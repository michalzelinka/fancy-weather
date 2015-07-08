//
//  ForecastViewController.swift
//  Weather
//
//  Created by Michi on 5/7/15.
//  Copyright (c) 2015 Michi. All rights reserved.
//

import UIKit

class ForecastViewController: UITableViewController {

	var displayedDestination : Destination?
	var displayedRecords : [WeatherRecord]?


	// MARK: - View lifecycle

	override func loadView()
	{
		super.loadView()

		// Left navigation item

		self.navigationItem.leftBarButtonItem =
			UIBarButtonItem(barButtonSystemItem:
				UIBarButtonSystemItem.Refresh, target: self,
					action: "refreshButtonTapped:")

		// Right navigation item

		self.navigationItem.rightBarButtonItem =
			UIBarButtonItem(image: UIImage(named: "navicon-locations"),
				style: .Plain, target: self, action: "locationsButtonTapped:")
	}

	override func viewDidLoad()
	{
		super.viewDidLoad()
		self.refresh()
	}

	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(animated)
		self.reloadData()
	}


	// MARK: - Screen updating

	func refresh() -> Void
	{
		// TODO: Session-based picking of location

		WeatherManager.sharedManager.weatherForCurrentLocation { (destination, records) -> Void in

			// Update with new data
			self.update(destination: destination, records: records)

		}
	}

	func reloadData() -> Void
	{
		self.tableView.reloadData()
	}

	func update(#destination: Destination?, records: [WeatherRecord]?)
	{
		// Assign new objects
		displayedDestination = destination
		displayedRecords = records

		// Refresh on main thread
		dispatch_async(dispatch_get_main_queue()) {() -> Void in
			self.reloadData()
		}

	}


	// MARK: - Table view delegate

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return displayedRecords?.count ?? 0
	}

	override func tableView(tableView: UITableView,
		cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		return ForecastViewCell()
	}


	// MARK: - Actions

	@IBAction func refreshButtonTapped(sender: UIControl)
	{
		self.refresh()
	}

	@IBAction func locationsButtonTapped(sender: UIControl)
	{
		// TODO: Implement
	}

}
