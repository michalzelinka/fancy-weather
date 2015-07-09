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
	}

	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(animated)
		self.reloadData()
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
	{
		if (segue.identifier == "Destinations")
		{
			let nc = segue.destinationViewController as! UINavigationController
			let vc = nc.viewControllers.first as! DestinationsViewController
			vc.delegate = self
		}
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
		self.navigationItem.title = displayedDestination?.name ?? "Forecast"
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
		return tableView.dequeueReusableCellWithIdentifier("ForecastViewCell") as! UITableViewCell
	}

	override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
		forRowAtIndexPath indexPath: NSIndexPath)
	{
		let c = cell as! ForecastViewCell
		c.update(displayedRecords?[indexPath.row])
	}


	// MARK: - Actions

	@IBAction func refreshButtonTapped(sender: UIControl)
	{
		self.refresh()
	}


	// MARK: - Destinations screen delegate

	func destinationsViewControllerDidFinish()
	{
		self.dismissViewControllerAnimated(true, completion: nil)
	}

	func destinationsViewControllerDidSelectDestination(destination: Destination)
	{
		// TODO: Implement
		self.dismissViewControllerAnimated(true, completion: nil)
	}

}
