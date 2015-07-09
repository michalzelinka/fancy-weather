//
//  WeatherManager.swift
//  
//
//  Created by Michal on 07/07/2015.
//
//

import UIKit

class WeatherManager: NSObject {

	var locatedDestination: Destination?
	var selectedDestination: Destination?
	var followedDestinations = [Destination]()

	var weatherRecordsCache = [Int: [WeatherRecord]]()

	class var sharedManager: WeatherManager
	{
		struct Singleton { static let shared = WeatherManager() }
		return Singleton.shared;
	}

	func weatherForDestination(destination: Destination?) -> [WeatherRecord]?
	{
		if (destination == nil) { return nil }

		return weatherRecordsCache[destination!.identifier!]
	}

	func weatherForCurrentLocation(#completion: ((destination: Destination?, records: [WeatherRecord]?) -> Void)?) -> Void
	{
		if (LocationManager.sharedManager.checkAuthorisation() != true)
		{ completion?(destination: nil, records: nil) }

		if let location = LocationManager.sharedManager.lastLocation
		{
			let urlString = String(format: "http://api.openweathermap.org/data/2.5/forecast/daily?lat=%.5f&lon=%.5f&cnt=14",
				location.coordinate.latitude, location.coordinate.longitude)

			let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
			request.timeoutInterval = 5.0

			NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue())
			{ (response, data, error) -> Void in

				if (error != nil) { NSLog("Request error"); return; }

				let json = JSON(data: data)

				let city = json["city"]
				let destination = Destination(json: city)

				let entries = json["list"].array ?? [ ]
				var records: [WeatherRecord] = [ ]

				for e in entries
				{
					var record = WeatherRecord(json: e)
					records.append(record)
				}

				self.locatedDestination = destination
				self.weatherRecordsCache[destination.identifier!] = records

				completion?(destination: destination, records: records)

			}
		}
	}

	func searchForWeatherLocations(query: String?, completion: ((destinations: [Destination]?) -> Void)?) -> Void
	{
		if (query?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) < 3)
		{ completion?(destinations: nil) }

		let urlString = String(format: "http://api.openweathermap.org/data/2.5/find?q=%@&type=like",
			query!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)

		let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
		request.timeoutInterval = 5.0

		NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue())
		{ (response, data, error) -> Void in

			if (error != nil) { NSLog("Request error"); return; }

			let json = JSON(data: data)

			let cities = json["list"].array ?? [ ]
			var destinations: [Destination] = [ ]

			for c in cities
			{
				var dest = Destination(json: c)
				destinations.append(dest)
			}

			completion?(destinations: destinations)

		}
	}

}
