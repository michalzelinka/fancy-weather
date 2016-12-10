//
//  LocationManager.swift
//  Weather
//
//  Created by Michi on 7/7/15.
//  Copyright (c) 2015 Michi. All rights reserved.
//

import Foundation
import CoreLocation

let kNotificationLocationDidUpdate    = "LocationDidUpdate"

class CLocationManager: NSObject, CLLocationManagerDelegate, UIAlertViewDelegate
{
	let locationManager: CLLocationManager
	var lastLocation: CLLocation?

	class var sharedManager: CLocationManager
	{
		struct Singleton { static let shared = CLocationManager() }
		return Singleton.shared;
	}

	override init()
	{
		locationManager = CLLocationManager()
		super.init()
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
		locationManager.distanceFilter = 1000
		locationManager.startUpdatingLocation()
		lastLocation = locationManager.location
	}


	// MARK: - Authorisation stuff

	func authorizationStatus() -> CLAuthorizationStatus
	{
		return CLLocationManager.authorizationStatus()
	}

	func checkAuthorisation() -> Bool
	{
		let status = CLLocationManager.authorizationStatus()

		// Notify about authorisation when needed
		if (status == .denied || status == .restricted) {
			UIAlertView(title: "Location authorization needed",
				message: "Please open Settings to allow access.",
					delegate: self, cancelButtonTitle: "Close", otherButtonTitles: "Settings")
						.show()
			return false
		}

		// Ask for authorisation when needed
		if (status != .authorizedWhenInUse &&
			status != .authorizedAlways) {
			locationManager.requestWhenInUseAuthorization()
			return false
		}

		return true
	}


	// MARK: - Location manager delegate

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
	{
		// Update handled location
		lastLocation = locations.first

		// Send notification
		NotificationCenter.default.post(name: Notification.Name(rawValue: kNotificationLocationDidUpdate), object: nil)
	}

	func locationManager(_ manager: CLLocationManager,
		didChangeAuthorization status: CLAuthorizationStatus)
	{
		locationManager.startUpdatingLocation()
	}


	// MARK: Alert view delegate

	func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int)
	{
		if buttonIndex != alertView.cancelButtonIndex
		{ UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!) }
	}

}
