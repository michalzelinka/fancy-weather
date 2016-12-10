//
//  WeatherManager.swift
//  
//
//  Created by Michal on 07/07/2015.
//
//
//  FILE TODO:
//  - Group URL - http://api.openweathermap.org/data/2.5/group?id=524901,703448,2643743
//  - Refresh results when given data are older than X - inject into cache getter
//    - flow: return so it can be displayed, but continue with hooked refresh?
//

import UIKit

let kSettingsFollowedDestinations = "FollowedDestinations"

let kNotificationSelectedDestinationChanged = "SelectedDestinationChanged"

class WeatherManager: NSObject {

	var locatedDestination: Destination?
	var selectedDestination: Destination?
	{
		didSet {
			// Send notification on change
			NotificationCenter.default.post(
				name: Notification.Name(rawValue: kNotificationSelectedDestinationChanged), object: nil)
		}
	}

	var followedDestinations = [Destination]()
	var requestsQueue: OperationQueue

	var weatherRecordsCache = [Int: [WeatherRecord]]()

	class var sharedManager: WeatherManager
	{
		struct Singleton { static let shared = WeatherManager() }
		return Singleton.shared;
	}

	override init()
	{
		requestsQueue = OperationQueue()
		requestsQueue.name = "Weather queue"
		requestsQueue.maxConcurrentOperationCount = 4

		super.init()
	}


	// MARK: - Temporary cache workers

	func cachedRecords(_ destination: Destination?) -> [WeatherRecord]?
	{
		// Return cached results if available
		if let destination = destination {
			return weatherRecordsCache[destination.identifier]
		}

		return nil
	}

	func cacheRecords(_ records: [WeatherRecord]?, destination: Destination?) -> Void
	{
		// Cache results if possible
		if let d = destination {
			if let r = records {
				weatherRecordsCache[d.identifier] = r
			}
		}
	}


	// MARK: - Followed destinations workers

	func addFollowedDestination(_ destination: Destination) -> Void
	{
		// Add followed Destination
		self.followedDestinations.append(destination)
	}

	func removeFollowedDestination(_ destination: Destination) -> Void
	{
		// Remove followed Destination and unset as selected if so
		self.followedDestinations.removeObject(destination)

		if (destination.identifier == selectedDestination?.identifier)
		{ self.selectedDestination = nil }
	}

	func loadFollowedDestinationsFromDefaults() -> Void
	{
		// Fetch followed Destinations from User Defaults

		if let dicts = UserDefaults.standard
			.object(forKey: kSettingsFollowedDestinations) as? [Dictionary<String, AnyObject>]
		{
			var dests = [Destination]()

			for d in dicts
			{
				if let d = Destination(dictionary: d)
				{ dests.append(d) }
			}

			followedDestinations = dests
		}
	}

	func saveFollowedDestinationsToDefaults() -> Void
	{
		// Save followed Destinations to User Defaults

		var dicts = [Dictionary<String, AnyObject>]()

		for d in followedDestinations
		{
			dicts.append(d.toDictionary())
		}

		UserDefaults.standard.set(dicts, forKey: kSettingsFollowedDestinations)
	}


	// MARK: - Data fetching workers

	func weatherForDestination(_ destination: Destination?,
		completion: ((_ records: [WeatherRecord]?) -> Void)?) -> Void
	{
		// Return empty result when no Destination given

		if (destination == nil) { completion?(nil); return }

		// Return cached values if available

		if let cached = self.cachedRecords(destination)
		{
			completion?(cached)
			return
		}

		// Fetch online data for the given Destination

		let urlString = String(format: "http://api.openweathermap.org/data/2.5/forecast/daily?id=%d&cnt=14&APPID=f64fce69c7a2d556123a11d4e6d0f673",
			destination!.identifier)

		let request = NSMutableURLRequest(url: URL(string: urlString)!)
		request.timeoutInterval = 5.0

		NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: requestsQueue)
		{ (response, data, error) -> Void in

			if (error != nil) {
				NSLog("Request error")
				CNotificationCenter.default().fireNotification(withTitle: "Cannot get current weather data")
				completion?(nil)
				return
			}

			// Parse JSON
			let json = JSON(data: data!)

			// Parse Destination
			let city = json["city"]
			let destination = Destination(json: city)

			// Parse Weather records
			let entries = json["list"].array ?? [ ]
			var records: [WeatherRecord] = [ ]

			for e in entries
			{
				let record = WeatherRecord(json: e)
				records.append(record)
			}

			// Cache records
			self.cacheRecords(records, destination: destination)

			// Call back
			completion?(records)
				
		}
	}

	func weatherForCurrentLocation(_ completion: ((_ destination: Destination?, _ records: [WeatherRecord]?) -> Void)?) -> Void
	{
		// Return empty result when Location access not authorised

		if (CLocationManager.sharedManager.checkAuthorisation() != true)
		{
			completion?(nil, nil)
			return
		}

		// Return cached values if available

		if let cached = self.cachedRecords(locatedDestination)
		{
			completion?(locatedDestination!, cached)
			return
		}

		// Fetch online data if user's location is available

		if let location = CLocationManager.sharedManager.lastLocation
		{
			let urlString = String(format: "http://api.openweathermap.org/data/2.5/forecast/daily?lat=%.5f&lon=%.5f&cnt=14&APPID=f64fce69c7a2d556123a11d4e6d0f673",
				location.coordinate.latitude, location.coordinate.longitude)

			let request = NSMutableURLRequest(url: URL(string: urlString)!)
			request.timeoutInterval = 5.0

			NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: requestsQueue)
			{ (response, data, error) -> Void in

				if (error != nil) {
					NSLog("Request error")
					CNotificationCenter.default().fireNotification(withTitle: "Cannot get current weather data")
					completion?(nil, nil)
					return
				}

				// Parse JSON
				let json = JSON(data: data!)

				// Parse Destination
				let city = json["city"]
				let destination = Destination(json: city)

				// Parse Wether records
				let entries = json["list"].array ?? [ ]
				var records: [WeatherRecord] = [ ]

				for e in entries
				{
					let record = WeatherRecord(json: e)
					records.append(record)
				}

				// Assign and cache records
				self.locatedDestination = destination
				self.cacheRecords(records, destination: destination)

				// Call back
				completion?(destination, records)

			}
		}

		// Otherwise return empty result

		else
		{
			CNotificationCenter.default().fireNotification(withTitle: "Location cannot be determined")
			completion?(nil, nil)
		}
	}

	func searchForWeatherLocations(_ query: String?, completion: ((_ destinations: [Destination]?) -> Void)?) -> Void
	{
		// Return empty result when search term is too short

		if (query == nil || query!.lengthOfBytes(using: String.Encoding.utf8) < 3)
		{ completion?(nil) }

		// Call API for results with the given query

		let urlString = String(format: "http://api.openweathermap.org/data/2.5/find?q=%@&type=like&APPID=f64fce69c7a2d556123a11d4e6d0f673",
			query!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)

		let request = NSMutableURLRequest(url: URL(string: urlString)!)
		request.timeoutInterval = 5.0

		NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: requestsQueue)
		{ (response, data, error) -> Void in

			if (error != nil) {
				NSLog("Request error")
				CNotificationCenter.default().fireNotification(withTitle: "Cannot get destinations")
				completion?(nil)
				return
			}

			// Parse JSON
			let json = JSON(data: data!)

			// Parse Destinations
			let cities = json["list"].array ?? [ ]
			var destinations: [Destination] = [ ]

			for c in cities
			{
				if let dest = Destination(json: c)
				{ destinations.append(dest) }
			}

			// Call back
			completion?(destinations)

		}
	}

}
