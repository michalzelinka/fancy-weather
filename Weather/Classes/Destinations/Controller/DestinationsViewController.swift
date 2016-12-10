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
	func destinationsViewControllerDidSelectDestination(_ destination: Destination?)
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
		addButton.transform = CGAffineTransform(translationX: 0, y: 400)
		UIView.animate(withDuration: 0.3, delay: 0.5, usingSpringWithDamping: 0.8,
		  initialSpringVelocity: 0.1, options: [], animations: { () -> Void in

			self.addButton.transform = CGAffineTransform.identity

		}, completion: nil)
	}

	override func viewDidLayoutSubviews()
	{
		super.viewDidLayoutSubviews()

		// Update gradient below the button

		let gradient = CAGradientLayer()
		gradient.frame = self.view.bounds
		gradient.colors = [
			UIColor(white:0, alpha:1).cgColor,
			UIColor(white:0, alpha:0).cgColor,
		]
		gradient.startPoint = CGPoint(x: 0, y: 1-(128.0/gradient.bounds.size.height))
		gradient.endPoint = CGPoint(x: 0, y: 1)

		tableView.superview?.layer.mask = gradient
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if (segue.identifier == "Destinations Search")
		{
			let nc = segue.destination as! UINavigationController
			let vc = nc.viewControllers.first as! DestinationsSearchViewController
			vc.delegate = self
		}
	}


    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
        return 1 + WeatherManager.sharedManager.followedDestinations.count
    }

    func tableView(_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let wm = WeatherManager.sharedManager

        let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationsViewCell",
			for: indexPath) as! DestinationsViewCell

		let destination = (indexPath.row == 0) ?
			wm.locatedDestination :
			wm.followedDestinations[indexPath.row-1]

		// Initial filling
		cell.update(destination, record: nil)
		cell.delegate = self

		// Filling from (hopefully cached) data
		wm.weatherForDestination(destination)
		{ (records) -> Void in
			DispatchQueue.main.async(execute: { () -> Void in
				cell.update(destination, record: records?.first)
			})
		}

		// Right action button
		cell.rightButtons = [ MGSwipeButton(title: "", icon: UIImage(named: "destinations-delete"),
			backgroundColor: Colors.fromRGB(0xff7f2c, alphaValue: 1), padding: 36) ]
		cell.rightSwipeSettings.transition = MGSwipeTransition.drag

		return cell
    }

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		tableView.deselectRow(at: indexPath, animated: true)

		var newSelected : Destination? = nil

		if (indexPath.row > 0)
		{
			newSelected = WeatherManager.sharedManager.followedDestinations[indexPath.row-1]
		}

		WeatherManager.sharedManager.selectedDestination = newSelected

		delegate?.destinationsViewControllerDidSelectDestination(newSelected)
	}


	// MARK: - Actions

	@IBAction func doneButtonTapped(_ sender: UIControl)
	{
		delegate?.destinationsViewControllerDidFinish()
	}


	// MARK: - Swipable Table cell delegate

	func swipeTableCell(_ cell: MGSwipeTableCell!, canSwipe direction: MGSwipeDirection) -> Bool
	{
		// Prevent deletion of first table row
		if let path = tableView.indexPath(for: cell)
		{ return path.row != 0 }

		return false

	}

	func swipeTableCell(_ cell: MGSwipeTableCell!, tappedButtonAt index: Int,
		direction: MGSwipeDirection, fromExpansion: Bool) -> Bool
	{
		if let path = tableView.indexPath(for: cell)
		{
			let wm = WeatherManager.sharedManager
			let destination = WeatherManager.sharedManager.followedDestinations[path.row-1]
			wm.removeFollowedDestination(destination)

			tableView.deleteRows(at: [ path ], with: .fade)
			tableView.reloadData()
		}

		return false
	}

	// MARK: - Desetinations Search screen delegate

	func destinationsSearchViewControllerDidSelectDestination(_ destination: Destination)
	{
		WeatherManager.sharedManager.addFollowedDestination(destination)
		tableView.reloadData()
		self.dismiss(animated: true, completion: nil)
	}

	func destinationsSearchViewControllerDidFinish()
	{
		self.dismiss(animated: true, completion: nil)
	}

}
