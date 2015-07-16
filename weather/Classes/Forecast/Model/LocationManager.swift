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

class LocationManager: NSObject, CLLocationManagerDelegate, UIAlertViewDelegate
{
	let locationManager: CLLocationManager
	var lastLocation: CLLocation?

	class var sharedManager: LocationManager
	{
		struct Singleton { static let shared = LocationManager() }
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
		if (status == .Denied || status == .Restricted) {
			UIAlertView(title: "Location authorization needed",
				message: "Please open Settings to allow access.",
					delegate: self, cancelButtonTitle: "Close", otherButtonTitles: "Settings")
						.show()
			return false
		}

		// Ask for authorisation when needed
		if (status != .AuthorizedWhenInUse &&
			status != .AuthorizedAlways) {
			locationManager.requestWhenInUseAuthorization()
			return false
		}

		return true
	}


	// MARK: - Location manager delegate

	func locationManager(manager: CLLocationManager!,
		didUpdateToLocation newLocation: CLLocation!,
		fromLocation oldLocation: CLLocation!) {

		// Update handled location
		lastLocation = newLocation

		// Send notification
		NSNotificationCenter.defaultCenter().postNotificationName(kNotificationLocationDidUpdate, object: nil)
	}

	func locationManager(manager: CLLocationManager!,
		didChangeAuthorizationStatus status: CLAuthorizationStatus)
	{
		locationManager.startUpdatingLocation()
	}


	// MARK: Alert view delegate

	func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
	{
		if buttonIndex != alertView.cancelButtonIndex
		{ UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!) }
	}

}
