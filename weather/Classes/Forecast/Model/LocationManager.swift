//
//  LocationManager.swift
//  Weather
//
//  Created by Michi on 7/7/15.
//  Copyright (c) 2015 Michi. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {

	let locationManager: CLLocationManager

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
		locationManager.startUpdatingLocation()
	}

	func lastLocation() -> CLLocation?
	{
		return locationManager.location
	}

	func authorizationStatus() -> CLAuthorizationStatus
	{
		return CLLocationManager.authorizationStatus()
	}

	func checkAuthorisation() -> Bool
	{
		let status = CLLocationManager.authorizationStatus()

		if (status != .AuthorizedWhenInUse &&
			status != .AuthorizedAlways) {
			locationManager.requestWhenInUseAuthorization()
			return false
		}

		return true
	}

}
