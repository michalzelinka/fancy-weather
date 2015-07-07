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
	}

}
