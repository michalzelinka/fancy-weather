//
//  ForecastViewController.swift
//  Weather
//
//  Created by Michi on 5/7/15.
//  Copyright (c) 2015 Michi. All rights reserved.
//

import UIKit

class ForecastViewController: UITableViewController, DestinationsViewControllerDelegate {

	var displayedDestination : Destination?
	var displayedRecords : [WeatherRecord]?


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

	override func viewDidAppear(_ animated: Bool)
	{
		tableView.showsVerticalScrollIndicator = false
		super.viewDidAppear(animated)
		tableView.showsVerticalScrollIndicator = true
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
				self.update(destination: selected, records: records)
			})

		} else {

			wm.weatherForCurrentLocation { (destination, records) -> Void in
				// Update with new data
				self.update(destination: destination, records: records)
			}
			
		}
	}

	func reloadData() -> Void
	{
		self.navigationItem.title = displayedDestination?.name ??
			displayedDestination?.country ?? "Forecast"
		self.tableView.reloadData()
	}

	func update(destination: Destination?, records: [WeatherRecord]?)
	{
		// Assign new objects
		displayedDestination = destination
		displayedRecords = records

		// Refresh on main thread
		DispatchQueue.main.async {() -> Void in
			self.reloadData()
		}

	}


	// MARK: - Table view delegate

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return displayedRecords?.count ?? 0
	}

	override func tableView(_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		return tableView.dequeueReusableCell(withIdentifier: "ForecastViewCell") as UITableViewCell!
	}

	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
		forRowAt indexPath: IndexPath)
	{
		let c = cell as! ForecastViewCell
		c.update(displayedRecords?[indexPath.row])
	}


	// MARK: - Actions

	@IBAction func refreshButtonTapped(_ sender: UIControl)
	{
		self.refresh()
	}


	// MARK: - Notifications

	func locationDidUpdate(_ notification: Notification)
	{
		if (WeatherManager.sharedManager.selectedDestination == nil) {
			self.refresh()
		}
	}

	func selectedDestinationChanged(_ notification: Notification)
	{
		self.refresh()
	}

	func userSettingsDidUpdate(_ notification: Notification)
	{
		DispatchQueue.main.async {() -> Void in
			self.reloadData()
		}
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
