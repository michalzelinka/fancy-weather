//
//  UserSettings.swift
//  Weather
//
//  Created by Michi on 5/7/15.
//  Copyright (c) 2015 Michi. All rights reserved.
//

import Foundation

enum TemperatureUnit: Int { case kelvin, celsius, fahrenheit,
                                 delisle, newton, reaumur,
	                             rankine, romer }
enum DistanceUnit: Int { case metric, imperial }

let kNotificationUserSettingsDidUpdate    = "UserSettingsDidUpdate"

let kSettingDistanceUnit    = "DistanceUnit"
let kSettingTemperatureUnit = "TemperatureUnit"

class UserSettings: NSObject {

	var distanceUnit: DistanceUnit = DistanceUnit.metric {
		didSet {
			self.commit()
			NotificationCenter.default.post(
				name: Notification.Name(rawValue: kNotificationUserSettingsDidUpdate), object: nil)
		}
	}

	var temperatureUnit : TemperatureUnit = TemperatureUnit.celsius {
		didSet {
			self.commit()
			NotificationCenter.default.post(
				name: Notification.Name(rawValue: kNotificationUserSettingsDidUpdate), object: nil)
		}
	}

	class var sharedSettings: UserSettings
	{
		struct Singleton { static let shared = UserSettings() }
		return Singleton.shared;
	}

	override init()
	{
		let defaults = UserDefaults.standard
		let isMetric = (Locale.current as NSLocale).object(forKey: NSLocale.Key.usesMetricSystem) as! Bool

		if (defaults.object(forKey: kSettingDistanceUnit) as? Int) != nil {
			distanceUnit = DistanceUnit(rawValue: defaults.integer(forKey: kSettingDistanceUnit))!
		} else {
			distanceUnit = (isMetric) ? .metric : .imperial
		}

		if (defaults.object(forKey: kSettingTemperatureUnit) as? Int) != nil {
			temperatureUnit = TemperatureUnit(rawValue: defaults.integer(forKey: kSettingTemperatureUnit))!
		} else {
			temperatureUnit = (isMetric) ? .celsius : .fahrenheit
		}
	}

	func commit() -> Void
	{
		let defaults = UserDefaults.standard
		defaults.set(distanceUnit.rawValue, forKey: kSettingDistanceUnit)
		defaults.set(temperatureUnit.rawValue, forKey: kSettingTemperatureUnit)
	}

}
