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

	@IBOutlet weak var topSeparator : UIView!
	@IBOutlet weak var bottomSeparator : UIView!
	@IBOutlet weak var shareButton : UIButton!

	var displayedDestination : Destination?
	var displayedRecord : WeatherRecord?


	// MARK: - View lifecycle

	override func viewDidLoad()
	{
		super.viewDidLoad()
		self.refresh()

		// Hook on notifications

		NotificationCenter.default.addObserver(self,
			selector: #selector(locationDidUpdate(_:)),
			name: NSNotification.Name(kNotificationLocationDidUpdate), object: nil)
		NotificationCenter.default.addObserver(self,
			selector: #selector(userSettingsDidUpdate(_:)),
			name: NSNotification.Name(kNotificationUserSettingsDidUpdate), object: nil)
		NotificationCenter.default.addObserver(self,
			selector: #selector(selectedDestinationChanged(_:)),
			name: NSNotification.Name(kNotificationSelectedDestinationChanged), object: nil)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if (segue.identifier == "Destinations")
		{
			let nc = segue.destination as! UINavigationController
			let vc = nc.viewControllers.first as! DestinationsViewController
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

		locationLabel.text = displayedDestination?.name ??
			displayedDestination?.country ?? "Unknown"
		navigationFlag.isHidden = displayedDestination?.identifier !=
			WeatherManager.sharedManager.locatedDestination?.identifier

		// Update brief summary

		let entries = NSMutableArray()

		if let t = displayedRecord?.temperature {
			let unit = UserSettings.sharedSettings.temperatureUnit
			entries.add(NumberFormatter.double(t, toTemperatureStringWithUnit: unit, unitDisplayed: true)!)
		}

		if let t = displayedRecord?.conditionText
		{ entries.add(t) }

		summaryLabel.text = entries.componentsJoined(by: " | ")

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
			let degree = Int(displayedRecord!.windDegree!)

			switch (degree) {

			case   0...22:  windDirection =  "N"
			case  23...67:  windDirection = "NE"
			case  68...112: windDirection =  "E"
			case 113...157: windDirection = "SE"
			case 158...202: windDirection =  "S"
			case 203...247: windDirection = "SW"
			case 248...292: windDirection =  "W"
			case 293...337: windDirection = "NW"
			case 338...360: windDirection =  "N"
			default: break

			}
		}

		windDirectionLabel.text = windDirection
		shareButton.isEnabled = (displayedDestination != nil && displayedRecord != nil)

	}

	func update(destination: Destination?, record: WeatherRecord?)
	{
		// Assign new objects
		displayedDestination = destination
		displayedRecord = record

		// Refresh on main thread
		DispatchQueue.main.async {() -> Void in
			self.reloadData()
		}

	}


	// MARK: - Actions

	@IBAction func refreshButtonTapped(_ sender: UIControl)
	{
		self.refresh()
	}

	@IBAction func shareButtonTapped(_ sender: UIControl)
	{
		let view = conditionIcon.superview

		// Take screenshot from the Today pane

		// Set image size
		var imageSize = view!.bounds.size
		imageSize.height -= shareButton.bounds.height

		// Create elements hiding view
		let hider = UIView(frame: CGRect(x: 0, y: 0, width: imageSize.width, height: 100))
		hider.backgroundColor = UIColor.white

		// Begin drawing
		UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.main.scale)
		view!.drawHierarchy(in: view!.bounds, afterScreenUpdates: false)
		hider.drawHierarchy(in: CGRect(x: 0, y: bottomSeparator.frame.minY,
			width: hider.frame.width, height: hider.frame.height), afterScreenUpdates: true)

		// Get image data
		let screenshot = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		//

		// Group shared items
		let message = "Look how the weather is today!"
		let items = [ message, screenshot! ] as [Any]

		// Present sharing flow
		let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
		self.tabBarController?.present(vc, animated: true, completion: nil)
	}


	// MARK: - Notifications

	func locationDidUpdate(_ notification: Notification)
	{
		// Refresh data & displayed content
		if (WeatherManager.sharedManager.selectedDestination == nil) {
			OperationQueue.main.addOperation({
				self.refresh()
			})
		}
	}

	func selectedDestinationChanged(_ notification: Notification)
	{
		// Refresh data & displayed content
		OperationQueue.main.addOperation({
			self.refresh()
		})
	}

	func userSettingsDidUpdate(_ notification: Notification)
	{
		// Refresh displayed content
		OperationQueue.main.addOperation({
			self.reloadData()
		})
	}


	// MARK: - Destinations screen delegate

	func destinationsViewControllerDidFinish()
	{
		self.dismiss(animated: true, completion: nil)
	}

	func destinationsViewControllerDidSelectDestination(_ destination: Destination?)
	{
		self.dismiss(animated: true, completion: nil)
	}

}
