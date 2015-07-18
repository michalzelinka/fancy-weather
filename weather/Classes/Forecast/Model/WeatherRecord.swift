//
//  WeatherRecord.swift
//  Weather
//
//  Created by Michi on 7/7/15.
//  Copyright (c) 2015 Michi. All rights reserved.
//

import Foundation

class WeatherRecord {

	var date: NSDate?
	var conditionID: Int?
	var conditionText: String?
	var temperature: Double?
	var windSpeed: Double?
	var windDegree: Double?
	var pressure: Double?
	var humidity: Double?
	var rainDrops: Double?

	convenience init(json: JSON?)
	{
		self.init()

		if let dt = json?["dt"].double { date = NSDate(timeIntervalSince1970: dt) }
		conditionID = json?["weather"][0]["id"].int
		conditionText = json?["weather"][0]["main"].string
		temperature = json?["temp"]["day"].double
		windSpeed = json?["speed"].double
		windDegree = json?["deg"].double
		pressure = json?["pressure"].double
		humidity = json?["humidity"].double
		rainDrops = json?["rain"].double
	}

	func conditionImagePattern() -> String
	{
		// Note: many condition images are missing, thus we try to
		//       display what we can and live on. :)

		if let conditionID = conditionID
		{
			let category = conditionID / 100
			let remainder = conditionID % 100

			if (category == 8)
			{
				if (remainder <= 1) { return "sun" }
				return "cloudy"
			}

			if (category == 5) { return "lightning" } // rain
			if (category == 2) { return "lightning" }
			if (category == 3) { return "lightning" } // rain
//			if (category == 7) { return "unknown" }
//			if (category == 6) { return "unknown" } // snow
		}

		return "unknown"
	}

}
