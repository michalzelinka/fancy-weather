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

	class func double(val: Double?, toTemperatureStringWithUnit unit: TemperatureUnit) -> String?
	{
		// Base is Kelvin

		if let val = val {
			if unit == .Kelvin     { return String(format: "%.0f  K", val) }
			if unit == .Celsius    { return String(format: "%.0f  °C", val-273.15) }
			if unit == .Fahrenheit { return String(format: "%.0f  °F", (val-273.15) * 1.8 + 32.0) }
		}

		return nil
	}

}
