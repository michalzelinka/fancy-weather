//
//  SettingsViewController.swift
//  Weather
//
//  Created by Michi on 5/7/15.
//  Copyright (c) 2015 Michi. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {


	// MARK: - Table view delegates

	override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
	{
		var v = view as UITableViewHeaderFooterView
		v.textLabel.font = UIFont.boldSystemFontOfSize(14)
		v.textLabel.textColor = Colors.defaultBlue()
	}

	override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
	{
		// TODO: Update detail text

		if (indexPath.row == 0)
		{
			cell.detailTextLabel?.text = "Meters"
		}

		else if (indexPath.row == 1)
		{
			cell.detailTextLabel?.text = "Celsius"
		}
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
	{
		tableView.deselectRowAtIndexPath(indexPath, animated: true)

		// TODO: Switch setting

		tableView.reloadRowsAtIndexPaths([ indexPath ], withRowAnimation: .None)
	}

}
