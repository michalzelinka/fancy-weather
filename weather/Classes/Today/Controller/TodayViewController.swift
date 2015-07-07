//
//  TodayViewController.swift
//  Weather
//
//  Created by Michi on 5/7/15.
//  Copyright (c) 2015 Michi. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {

	@IBOutlet weak var conditionIcon : UIImageView!
	@IBOutlet weak var locationLabel : UILabel!
	@IBOutlet weak var summaryLabel : UILabel!

	@IBOutlet weak var humidityLabel : UILabel!
	@IBOutlet weak var rainDropsLabel : UILabel!
	@IBOutlet weak var pressureLabel : UILabel!
	@IBOutlet weak var windSpeedLabel : UILabel!
	@IBOutlet weak var windDirectionLabel : UILabel!

	var displayedDestination : Destination?
	var displayedRecord : WeatherRecord?

	override func loadView()
	{
		super.loadView()

		self.navigationItem.rightBarButtonItem =
			UIBarButtonItem(image: UIImage(named: "navicon-locations"),
				style: .Plain, target: self, action: "destinationsButtonTapped:")
	}

	func reloadData() -> Void
	{
		// Update location name

		locationLabel.text = displayedDestination?.name

		// Update brief summary

		var entries = NSMutableArray()

		if let t = displayedRecord?.temperature
		{ entries.addObject(String(format: "%.0fK", t)) }

		if let t = displayedRecord?.conditionText
		{ entries.addObject(t) }

		summaryLabel.text = entries.componentsJoinedByString(" | ")

		// Update rain drops value

		if let drops = displayedRecord?.humidity {
			rainDropsLabel.text = String(format: "%.1f mm", drops)
		} else {
			rainDropsLabel.text = "–"
		}

		// Update humidity value

		if let humidity = displayedRecord?.humidity {
			humidityLabel.text = String(format: "%.0f%%", humidity)
		} else {
			humidityLabel.text = "–"
		}

		// Update pressure value

		if let pressure = displayedRecord?.pressure {
			pressureLabel.text = String(format: "%.0f hPa", pressure)
		} else {
			pressureLabel.text = "–"
		}

		// Update wind speed value

		if let windSpeed = displayedRecord?.windSpeed {
			windSpeedLabel.text = String(format: "%.0f km/h", windSpeed)
		} else {
			windSpeedLabel.text = "–"
		}

		// Update wind direction

		if let windDegree = displayedRecord?.windDegree {
			windDirectionLabel.text = String(format: "%.0f°", windDegree)
		} else {
			windDirectionLabel.text = "–"
		}


	}

	func update(#destination: Destination?, record: WeatherRecord?)
	{
		// Assign new objects
		displayedDestination = destination
		displayedRecord = record

		// Refresh on main thread
		dispatch_async(dispatch_get_main_queue()) {() -> Void in
			self.reloadData()
		}

	}

	@IBAction func destinationsButtonTapped(sender: UIControl)
	{
		WeatherManager.sharedManager.weatherForCurrentLocation { (destination, record) -> Void in

			// Update with new data
			self.update(destination: destination, record: record)

		}
	}

	@IBAction func shareButtonTapped(sender: UIControl)
	{
		// TODO: Implement
	}

	@IBAction func locationsButtonTapped(sender: UIControl)
	{
		// TODO: Implement
	}

}
