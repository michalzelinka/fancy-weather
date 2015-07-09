//
//  DestinationsViewController.swift
//  
//
//  Created by Michal on 09/07/2015.
//
//

import UIKit


// MARK: - Controller delegate -

protocol DestinationsViewControllerDelegate: NSObjectProtocol
{
	func destinationsViewControllerDidSelectDestination(destination: Destination)
	func destinationsViewControllerDidFinish()
}


// MARK: - Controller -

class DestinationsViewController: UIViewController,
                                  UITableViewDelegate,
                                  UITableViewDataSource,
                                  DestinationsSearchViewControllerDelegate
{

	var delegate: DestinationsViewControllerDelegate?
	var pickedDestinations: Array<Destination>?


	// MARK: View lifecycle

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
	{
		if (segue.identifier == "Destinations Search")
		{
			let nc = segue.destinationViewController as UINavigationController
			let vc = nc.viewControllers.first as DestinationsSearchViewController
			vc.delegate = self
		}
	}


    // MARK: - Table view data source

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
        return 1 + (pickedDestinations?.count ?? 0)
    }

    func tableView(tableView: UITableView,
		cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
        let cell = tableView.dequeueReusableCellWithIdentifier("DestinationsViewCell",
			forIndexPath: indexPath) as DestinationsViewCell

		let destination = (indexPath.row == 0) ?
			WeatherManager.sharedManager.locatedDestination :
			WeatherManager.sharedManager.followedDestinations[indexPath.row-1]

		let records = WeatherManager.sharedManager.weatherForDestination(destination)
		cell.update(destination, record: records?.first)

		return cell
    }


	// MARK: - Actions

	@IBAction func doneButtonTapped(sender: UIControl)
	{
		delegate?.destinationsViewControllerDidFinish()
	}


	// MARK: - Desetinations Search screen delegate

	func destinationsSearchViewControllerDidSelectDestination(destination: Destination)
	{
		// TODO: Refresh with new selected destination

		self.dismissViewControllerAnimated(true, completion: nil)
	}

	func destinationsSearchViewControllerDidFinish()
	{
		self.dismissViewControllerAnimated(true, completion: nil)
	}

}
