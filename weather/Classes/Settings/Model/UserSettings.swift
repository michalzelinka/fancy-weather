//
//  UserSettings.swift
//  Weather
//
//  Created by Michi on 5/7/15.
//  Copyright (c) 2015 Michi. All rights reserved.
//

import Foundation

enum TemperatureUnit: Int { case Celsius, Fahrenheit }
enum DistanceUnit: Int { case Metric, Imperial }

let kNotificationDistanceUnitDidUpdate    = "DistanceUnitDidUpdate"
let kNotificationTemperatureUnitDidUpdate = "TemperatureUnitDidUpdate"

let kSettingDistanceUnit    = "DistanceUnit"
let kSettingTemperatureUnit = "TemperatureUnit"

class UserSettings: NSObject {

	var distanceUnit: DistanceUnit = DistanceUnit.Metric {
		didSet {
			NSNotificationCenter.defaultCenter().postNotificationName(kNotificationDistanceUnitDidUpdate, object: nil)
		}
	}

	var temperatureUnit : TemperatureUnit = TemperatureUnit.Celsius {
		didSet {
			NSNotificationCenter.defaultCenter().postNotificationName(kNotificationTemperatureUnitDidUpdate, object: nil)
		}
	}

	class var sharedSettings: UserSettings
	{
		struct Singleton { static let shared = UserSettings() }
		return Singleton.shared;
	}

	override init()
	{
		var defaults = NSUserDefaults.standardUserDefaults()
		distanceUnit = DistanceUnit(rawValue: defaults.integerForKey(kSettingDistanceUnit))!
		temperatureUnit = TemperatureUnit(rawValue: defaults.integerForKey(kSettingTemperatureUnit))!
	}

	func commit() -> Void
	{
		var defaults = NSUserDefaults.standardUserDefaults()
		defaults.setInteger(distanceUnit.rawValue, forKey: kSettingDistanceUnit)
		defaults.setInteger(temperatureUnit.rawValue, forKey: kSettingTemperatureUnit)
	}

}
