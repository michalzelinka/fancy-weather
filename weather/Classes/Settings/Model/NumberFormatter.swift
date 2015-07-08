//
//  NumberFormatter.swift
//  
//
//  Created by Michal on 08/07/2015.
//
//

import UIKit

class NumberFormatter: NSObject {

	class func double(val: Double?, toDistanceStringWithUnit unit: DistanceUnit) -> String?
	{
		// Base is metric

		if let val = val {

			if unit == .Metric   { return String(format: "%.0f  km/h", val) }
			if unit == .Imperial { return String(format: "%.0f  mi/h", val * 0.62137) }

		}

		return nil
	}

	class func double(val: Double?, toTemperatureStringWithUnit unit: TemperatureUnit, unitDisplayed: Bool) -> String?
	{
		// Base is Kelvin

		if var val = val {

			var unitStr = "K"

			if unit == .Celsius { val -= 273.15; unitStr = "°C" }
			else if unit == .Fahrenheit { val = (val-273.15) * 1.8 + 32.0; unitStr = "°F" }

			unitStr = (unitDisplayed) ? "  "+unitStr : (unit != .Kelvin) ? "°" : ""

			return String(format: "%.0f%@", val, unitStr)
		}

		return nil
	}

}
