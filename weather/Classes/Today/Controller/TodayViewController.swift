//
//  TodayViewController.swift
//  Weather
//
//  Created by Michi on 5/7/15.
//  Copyright (c) 2015 Michi. All rights reserved.
//
//  FILE TODO:
//  - periodic updating
//

import UIKit

class TodayViewController: UIViewController, DestinationsViewControllerDelegate {

	@IBOutlet weak var conditionIcon : UIImageView!
	@IBOutlet weak var navigationFlag : UIImageView!
	@IBOutlet weak var locationLabel : UILabel!
	@IBOutlet weak var summaryLabel : UILabel!

	@IBOutlet weak var humidityLabel : UILabel!
	@IBOutlet weak var rainDropsLabel : UILabel!
	@IBOutlet weak var pressureLabel : UILabel!
	@IBOutlet weak var windSpeedLabel : UILabel!
	@IBOutlet weak var windDirectionLabel : UILabel!

	var displayedDestination : Destination?
	var displayedRecord : WeatherRecord?


	// MARK: - View lifecycle

	override func viewDidLoad()
	{
		super.viewDidLoad()
		self.refresh()
	}

	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(animated)
		self.reloadData() // TODO: Remove, refresh cells via method on notification
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
	{
		if (segue.identifier == "Destinations")
		{
			let nc = segue.destinationViewController as UINavigationController
			let vc = nc.viewControllers.first as DestinationsViewController
			vc.delegate = self
		}
	}


	// MARK: - Screen updating

	func refresh() -> Void
	{
		let wm = WeatherManager.sharedManager

		if let selected = wm.selectedDestination {

			wm.weatherForDestination(selected, completion: { (records) -> Void in
				// Update with new data
				self.update(destination: selected, record: records?.first)
			})

		} else {

			wm.weatherForCurrentLocation { (destination, records) -> Void in
				// Update with new data
				self.update(destination: destination, record: records?.first)
			}

		}
	}

	func reloadData() -> Void
	{
		// Update condition icon

		if (displayedRecord != nil) {
			conditionIcon.image = UIImage(named: String("condition-"+displayedRecord!.conditionImagePattern()))
		} else {
			conditionIcon.image = UIImage(named: "condition-unknown")
		}

		// Update location name

		locationLabel.text = displayedDestination?.name
		navigationFlag.hidden = displayedDestination?.identifier != WeatherManager.sharedManager.locatedDestination?.identifier

		// Update brief summary

		var entries = NSMutableArray()

		if let t = displayedRecord?.temperature {
			let unit = UserSettings.sharedSettings.temperatureUnit
			entries.addObject(NumberFormatter.double(t, toTemperatureStringWithUnit: unit, unitDisplayed: true)!)
		}

		if let t = displayedRecord?.conditionText
		{ entries.addObject(t) }

		summaryLabel.text = entries.componentsJoinedByString(" | ")

		// Update rain drops value

		rainDropsLabel.text = (displayedRecord?.rainDrops != nil) ?
			String(format: "%.1f  mm", displayedRecord!.rainDrops!) : "–"

		// Update humidity value

		humidityLabel.text = (displayedRecord?.humidity != nil) ?
			String(format: "%.0f  %%", displayedRecord!.humidity!) : "–"

		// Update pressure value

		pressureLabel.text = (displayedRecord?.pressure != nil) ?
			String(format: "%.0f  hPa", displayedRecord!.pressure!) : "–"

		// Update wind speed value

		if var windSpeed = displayedRecord?.windSpeed {
			windSpeed *= 3.6
			let unit = UserSettings.sharedSettings.distanceUnit
			windSpeedLabel.text = NumberFormatter.double(windSpeed, toDistanceStringWithUnit: unit)
		} else { windSpeedLabel.text = "–" }


		// Update wind direction

		var windDirection = "–"

		if (displayedRecord?.windDegree != nil)
		{
			var degree = Int(displayedRecord!.windDegree!)

			switch (degree) {

			case   0...22:  windDirection = "N"
			case  23...67:  windDirection = "NE"
			case  68...112: windDirection = "E"
			case 113...157: windDirection = "SE"
			case 158...202: windDirection = "S"
			case 203...247: windDirection = "SW"
			case 248...292: windDirection = "W"
			case 293...337: windDirection = "NW"
			case 338...360: windDirection = "N"
			default: break

			}
		}

		windDirectionLabel.text = windDirection

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


	// MARK: - Actions

	@IBAction func refreshButtonTapped(sender: UIControl)
	{
		self.refresh()
	}

	@IBAction func shareButtonTapped(sender: UIControl)
	{
		let view = conditionIcon.superview

		sender.hidden = true
		
		UIGraphicsBeginImageContextWithOptions(view!.bounds.size, false, UIScreen.mainScreen().scale)
		view!.drawViewHierarchyInRect(view!.bounds, afterScreenUpdates: true)
		let screenshot = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		sender.hidden = false

		let message = "Look how the weather is today!"
		let items = [ message, screenshot ]

		let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
		self.tabBarController?.presentViewController(vc, animated: true, completion: nil)
	}


	// MARK: - Destinations screen delegate

	func destinationsViewControllerDidFinish()
	{
		self.dismissViewControllerAnimated(true, completion: nil)
	}

	func destinationsViewControllerDidSelectDestination(destination: Destination?)
	{
		self.refresh()
		self.dismissViewControllerAnimated(true, completion: nil)
	}

}
