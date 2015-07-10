//
//  UserSettings.swift
//  Weather
//
//  Created by Michi on 5/7/15.
//  Copyright (c) 2015 Michi. All rights reserved.
//

import Foundation

enum TemperatureUnit: Int { case Kelvin, Celsius, Fahrenheit,
                                 Delisle, Newton, Reaumur,
	                             Rankine, Romer }
enum DistanceUnit: Int { case Metric, Imperial }

let kNotificationUserSettingsDidUpdate    = "UserSettingsDidUpdate"

let kSettingDistanceUnit    = "DistanceUnit"
let kSettingTemperatureUnit = "TemperatureUnit"

class UserSettings: NSObject {

	var distanceUnit: DistanceUnit = DistanceUnit.Metric {
		didSet {
			self.commit()
			NSNotificationCenter.defaultCenter().postNotificationName(
				kNotificationUserSettingsDidUpdate, object: nil)
		}
	}

	var temperatureUnit : TemperatureUnit = TemperatureUnit.Celsius {
		didSet {
			self.commit()
			NSNotificationCenter.defaultCenter().postNotificationName(
				kNotificationUserSettingsDidUpdate, object: nil)
		}
	}

	class var sharedSettings: UserSettings
	{
		struct Singleton { static let shared = UserSettings() }
		return Singleton.shared;
	}

	override init()
	{
		let defaults = NSUserDefaults.standardUserDefaults()
		let isMetric = NSLocale.currentLocale().objectForKey(NSLocaleUsesMetricSystem) as! Bool

		if let o = defaults.objectForKey(kSettingDistanceUnit) as? Int {
			distanceUnit = DistanceUnit(rawValue: defaults.integerForKey(kSettingDistanceUnit))!
		} else {
			distanceUnit = (isMetric) ? .Metric : .Imperial
		}

		if let o = defaults.objectForKey(kSettingTemperatureUnit) as? Int {
			temperatureUnit = TemperatureUnit(rawValue: defaults.integerForKey(kSettingTemperatureUnit))!
		} else {
			temperatureUnit = (isMetric) ? .Celsius : .Fahrenheit
		}
	}

	func commit() -> Void
	{
		var defaults = NSUserDefaults.standardUserDefaults()
		defaults.setInteger(distanceUnit.rawValue, forKey: kSettingDistanceUnit)
		defaults.setInteger(temperatureUnit.rawValue, forKey: kSettingTemperatureUnit)
	}

}
