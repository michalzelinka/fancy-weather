//
//  DestinationsSearchViewController.swift
//  Weather
//
//  Created by Michi on 9/7/15.
//  Copyright (c) 2015 Michi. All rights reserved.
//

import UIKit


// MARK: - Controller delegate -

protocol DestinationsSearchViewControllerDelegate: NSObjectProtocol
{
	func destinationsSearchViewControllerDidSelectDestination(_ destination: Destination)
	func destinationsSearchViewControllerDidFinish()
}


// MARK: - Controller -

class DestinationsSearchViewController: UITableViewController,
                                        UITextFieldDelegate,
                                        UISearchBarDelegate
{

	@IBOutlet weak var searchBar : UISearchBar!

	var delegate: DestinationsSearchViewControllerDelegate?
	var foundDestinations: [Destination]?


	// MARK: - View lifecycle
	
	override func viewDidLoad()
	{
		super.viewDidLoad()

		// Search bar appearance changes

		searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
		searchBar.delegate = self

		let searchField = searchBar.forClass(UITextField.self) as? UITextField
		let searchFieldBackground = searchField?.subviews.first
		searchFieldBackground?.isHidden = true
		searchField?.layer.borderWidth = (UIScreen.main.scale > 1) ? 0.8 : 1
		searchField?.layer.cornerRadius = 5.0
		searchField?.layer.borderColor = Colors.defaultBlue().cgColor
		searchField?.keyboardType = .webSearch
		searchField?.returnKeyType = .search
	}

	override func viewDidAppear(_ animated: Bool)
	{
		// Set as first responder on appearing
		super.viewDidAppear(animated)
		searchBar.becomeFirstResponder()
	}

	override func viewWillDisappear(_ animated: Bool)
	{
		// Resign as first responder on dismissing
		super.viewWillDisappear(animated)
		searchBar.resignFirstResponder()
	}


	// MARK: - Actions

	@IBAction func closeButtonTapped(_ sender: UIControl)
	{
		self.resignFirstResponder()
		delegate?.destinationsSearchViewControllerDidFinish()
	}


	// MARK: - Table view delegate

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return foundDestinations?.count ?? 0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationsSearchViewCell") as UITableViewCell!

		// Construct Destination title to display in cell

		if let destination = foundDestinations?[indexPath.row]
		{
			var titleComponents = [String]()

			if (destination.name?.length() ?? 0 > 0) { titleComponents.append(destination.name!) }
			if (destination.country?.length() ?? 0 > 0) { titleComponents.append(destination.country!) }

			let title = ((titleComponents.count > 0) ? titleComponents.joined(separator: ", ") : "Unknown") as NSString

			let ms = NSMutableAttributedString(string: title as String, attributes: [
				NSForegroundColorAttributeName: Colors.fromRGB(0x333333, alphaValue: 1.0),
				NSFontAttributeName: UIFont.lightSystemFont(ofSize: cell!.textLabel!.font.pointSize)
			])

			let range = title.range(of: ",",
				options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, title.length), locale: nil)

			if (range.location != NSNotFound)
			{
				ms.addAttribute(NSFontAttributeName, value: cell!.textLabel!.font, range: range)
			}

			cell!.textLabel?.attributedText = ms
		}

		return cell!
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		tableView.deselectRow(at: indexPath, animated: true)

		if let destination = foundDestinations?[indexPath.row] {

			// Check following state of Destination, notify or add if possible

			if (WeatherManager.sharedManager.followedDestinations.contains(destination)) {
				SVProgressHUD.showInfo(withStatus: "Destination is already followed")
			} else {
				delegate?.destinationsSearchViewControllerDidSelectDestination(destination)
			}
		}
	}
	
	override func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
	{
		// Resign as first responder when scrolling through the list
		searchBar.resignFirstResponder()
	}


	// MARK: - Screen refreshing

	func reloadData() -> Void
	{
		tableView.reloadData()
	}


	// MARK: - Search Bar delegate

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
	{
		searchBar.resignFirstResponder()

		SVProgressHUD.show(withStatus: "Searching locations…")

		WeatherManager.sharedManager.searchForWeatherLocations(searchBar.text, completion: { (destinations) -> Void in

			self.foundDestinations = destinations

			// Refresh on main thread
			DispatchQueue.main.async {() -> Void in

				// Notify or dismiss HUD
				if (self.foundDestinations?.count == 0)
				{ SVProgressHUD.showError(withStatus: "No destinations found") }
				else { SVProgressHUD.dismiss() }

				// Reload table data
				self.reloadData()
			}

		})
	}

	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
	{
		// Reset table contents when search bar text changes
		self.foundDestinations = [ ]
		self.reloadData()
	}
}
