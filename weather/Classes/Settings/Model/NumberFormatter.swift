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
		// Thanks, wiki! - https://en.wikipedia.org/wiki/Conversion_of_units_of_temperature

		if var val = val {

			var unitStr = "K"

			if      unit == .Celsius    { val -= 273.15; unitStr = "°C" }
			else if unit == .Fahrenheit { val = (val-273.15) * 1.8 + 32.0; unitStr = "°F" }
			else if unit == .Delisle    { val = (373.15-val) * (3.0/2.0); unitStr = "°De" }
			else if unit == .Newton     { val = (val-273.15) * 0.33; unitStr = "°N" }
			else if unit == .Reaumur    { val = (val-273.15) * 0.8; unitStr = "°Ré" }
			else if unit == .Rankine    { val = val * (9.0/5.0); unitStr = "°Ra" }
			else if unit == .Romer      { val = (val-273.15) * (21.0/40.0) + 7.5; unitStr = "°Rø" }

			unitStr = (unitDisplayed) ? "  "+unitStr : (unit != .Kelvin) ? "°" : ""

			return String(format: "%.0f%@", val, unitStr)
		}

		return nil
	}

}
