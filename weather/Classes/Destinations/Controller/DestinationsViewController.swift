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
	func destinationsViewControllerDidSelectDestination(destination: Destination?)
	func destinationsViewControllerDidFinish()
}


// MARK: - Controller -

class DestinationsViewController: UIViewController,
                                  UITableViewDelegate,
                                  UITableViewDataSource,
                                  MGSwipeTableCellDelegate,
                                  DestinationsSearchViewControllerDelegate
{

	@IBOutlet weak var tableView : UITableView!
	@IBOutlet weak var addButton : UIButton!

	var delegate: DestinationsViewControllerDelegate?


	// MARK: - View lifecycle

	override func viewDidLoad()
	{
		super.viewDidLoad()

		// Minor UI tweaks
		tableView.contentInset = UIEdgeInsetsMake(0, 0, 96, 0)
		addButton.transform = CGAffineTransformMakeTranslation(0, 400)
		UIView.animateWithDuration(0.3, delay: 0.5, usingSpringWithDamping: 0.8,
			initialSpringVelocity: 0.1, options: .allZeros, animations: { () -> Void in

			self.addButton.transform = CGAffineTransformIdentity

		}, completion: nil)
	}

	override func viewDidLayoutSubviews()
	{
		super.viewDidLayoutSubviews()

		// Update gradient below the button

		let gradient = CAGradientLayer()
		gradient.frame = self.view.bounds
		gradient.colors = [
			UIColor(white:0, alpha:1).CGColor,
			UIColor(white:0, alpha:0).CGColor,
		]
		gradient.startPoint = CGPointMake(0, 1-(128.0/gradient.bounds.size.height))
		gradient.endPoint = CGPointMake(0, 1)

		tableView.superview?.layer.mask = gradient
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
	{
		if (segue.identifier == "Destinations Search")
		{
			let nc = segue.destinationViewController as! UINavigationController
			let vc = nc.viewControllers.first as! DestinationsSearchViewController
			vc.delegate = self
		}
	}


    // MARK: - Table view data source

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
        return 1 + WeatherManager.sharedManager.followedDestinations.count
    }

    func tableView(tableView: UITableView,
		cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		let wm = WeatherManager.sharedManager

        let cell = tableView.dequeueReusableCellWithIdentifier("DestinationsViewCell",
			forIndexPath: indexPath) as! DestinationsViewCell

		let destination = (indexPath.row == 0) ?
			wm.locatedDestination :
			wm.followedDestinations[indexPath.row-1]

		// Initial filling
		cell.update(destination, record: nil)
		cell.delegate = self

		// Filling from (hopefully cached) data
		wm.weatherForDestination(destination)
		{ (records) -> Void in
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				cell.update(destination, record: records?.first)
			})
		}

		// Right action button
		cell.rightButtons = [ MGSwipeButton(title: "", icon: UIImage(named: "destinations-delete"),
			backgroundColor: Colors.fromRGB(0xff7f2c, alphaValue: 1), padding: 36) ]
		cell.rightSwipeSettings.transition = MGSwipeTransition.Drag

		return cell
    }

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
	{
		tableView.deselectRowAtIndexPath(indexPath, animated: true)

		let newSelected = (indexPath.row > 0) ?
			WeatherManager.sharedManager.followedDestinations[indexPath.row-1] ?? nil : nil

		WeatherManager.sharedManager.selectedDestination = newSelected

		delegate?.destinationsViewControllerDidSelectDestination(newSelected)
	}


	// MARK: - Actions

	@IBAction func doneButtonTapped(sender: UIControl)
	{
		delegate?.destinationsViewControllerDidFinish()
	}


	// MARK: - Swipable Table cell delegate

	func swipeTableCell(cell: MGSwipeTableCell!, canSwipe direction: MGSwipeDirection) -> Bool
	{
		// Prevent deletion of first table row
		if let path = tableView.indexPathForCell(cell)
		{ return path.row != 0 }

		return false

	}

	func swipeTableCell(cell: MGSwipeTableCell!, tappedButtonAtIndex index: Int,
		direction: MGSwipeDirection, fromExpansion: Bool) -> Bool
	{
		if let path = tableView.indexPathForCell(cell)
		{
			let wm = WeatherManager.sharedManager
			let destination = WeatherManager.sharedManager.followedDestinations[path.row-1]
			wm.removeFollowedDestination(destination)

			tableView.deleteRowsAtIndexPaths([ path ], withRowAnimation: .Fade)
			tableView.reloadData()
		}

		return false
	}

	// MARK: - Desetinations Search screen delegate

	func destinationsSearchViewControllerDidSelectDestination(destination: Destination)
	{
		WeatherManager.sharedManager.addFollowedDestination(destination)
		tableView.reloadData()
		self.dismissViewControllerAnimated(true, completion: nil)
	}

	func destinationsSearchViewControllerDidFinish()
	{
		self.dismissViewControllerAnimated(true, completion: nil)
	}

}
