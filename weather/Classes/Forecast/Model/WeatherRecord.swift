//
//  WeatherRecord.swift
//  Weather
//
//  Created by Michi on 7/7/15.
//  Copyright (c) 2015 Michi. All rights reserved.
//

import Foundation

class WeatherRecord {

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

		conditionID = json?["weather"][0]["id"].int
		conditionText = json?["weather"][0]["main"].string
		temperature = json?["main"]["temp"].double
		windSpeed = json?["wind"]["speed"].double
		windDegree = json?["wind"]["deg"].double
		pressure = json?["main"]["pressure"].double
		humidity = json?["main"]["humidity"].double
		rainDrops = json?["rain"]["3h"].double
	}

	func conditionImagePattern() -> String
	{
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

			return "unknown"
		}

		return "unknown"
	}

}
