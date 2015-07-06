//
//  SettingsViewController.swift
//  Weather
//
//  Created by Michi on 5/7/15.
//  Copyright (c) 2015 Michi. All rights reserved.
//

import UIKit

enum SettingsViewRow: Int { case Distance, Temperature }

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
		var selection = SettingsViewRow(rawValue: indexPath.row)

		// Distance units cell
		if (selection == .Distance)
		{
			cell.detailTextLabel?.text =
				(UserSettings.sharedSettings.distanceUnit == DistanceUnit.Metric) ?
					"Meters" : "Miles"
		}

		// Temperature units cell
		else if (selection == .Temperature)
		{
			cell.detailTextLabel?.text =
				(UserSettings.sharedSettings.temperatureUnit == TemperatureUnit.Celsius) ?
					"Celsius" : "Fahrenheit"
		}
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
	{
		tableView.deselectRowAtIndexPath(indexPath, animated: true)

		var selection = SettingsViewRow(rawValue: indexPath.row)

		// Distance units cell

		if (selection == .Distance)
		{
			UserSettings.sharedSettings.distanceUnit =
				(UserSettings.sharedSettings.distanceUnit == .Metric) ?
					.Imperial : .Metric;
		}

		// Temperature units cell

		else if (selection == .Temperature)
		{
			UserSettings.sharedSettings.temperatureUnit =
				(UserSettings.sharedSettings.temperatureUnit == .Celsius) ?
					.Fahrenheit : .Celsius;
		}

		tableView.reloadRowsAtIndexPaths([ indexPath ], withRowAnimation: .None)
	}

}
