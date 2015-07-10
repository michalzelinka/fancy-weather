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

	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
	{
		return 64
	}

	override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
	{
		var v = view as! UITableViewHeaderFooterView
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
			switch (UserSettings.sharedSettings.temperatureUnit) {

			case .Kelvin:     cell.detailTextLabel?.text = "Kelvin"
			case .Celsius:    cell.detailTextLabel?.text = "Celsius"
			case .Fahrenheit: cell.detailTextLabel?.text = "Fahrenheit"

			}
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
			var newValue = UserSettings.sharedSettings.temperatureUnit.rawValue+1
			if newValue > TemperatureUnit.Fahrenheit.rawValue { newValue = TemperatureUnit.Kelvin.rawValue }
			UserSettings.sharedSettings.temperatureUnit = TemperatureUnit(rawValue: newValue)!
		}

		tableView.reloadRowsAtIndexPaths([ indexPath ], withRowAnimation: .None)

	}

}
