//
//  SettingsViewController.swift
//  Weather
//
//  Created by Michi on 5/7/15.
//  Copyright (c) 2015 Michi. All rights reserved.
//

import UIKit

enum SettingsViewRow: Int { case distance, temperature }

class SettingsViewController: UITableViewController {


	// MARK: - Table view delegates

	override func tableView(_ tableView: UITableView,
		heightForRowAt indexPath: IndexPath) -> CGFloat
	{
		return 64
	}

	override func tableView(_ tableView: UITableView,
		willDisplayHeaderView view: UIView, forSection section: Int)
	{
		let v = view as! UITableViewHeaderFooterView
		v.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		v.textLabel?.textColor = Colors.defaultBlue()
	}

	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
		forRowAt indexPath: IndexPath)
	{
		let selection = SettingsViewRow(rawValue: indexPath.row)

		// Distance units cell
		if (selection == .distance)
		{
			cell.detailTextLabel?.text =
				(UserSettings.sharedSettings.distanceUnit == DistanceUnit.metric) ?
					"Meters" : "Miles"
		}

		// Temperature units cell
		else if (selection == .temperature)
		{
			switch (UserSettings.sharedSettings.temperatureUnit) {

			case .kelvin:     cell.detailTextLabel?.text = "Kelvin"
			case .celsius:    cell.detailTextLabel?.text = "Celsius"
			case .fahrenheit: cell.detailTextLabel?.text = "Fahrenheit"
			case .delisle:    cell.detailTextLabel?.text = "Delisle"
			case .newton:     cell.detailTextLabel?.text = "Newton"
			case .reaumur:    cell.detailTextLabel?.text = "Réaumur"
			case .rankine:    cell.detailTextLabel?.text = "Rankine"
			case .romer:      cell.detailTextLabel?.text = "Rømer"

			}
		}
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		tableView.deselectRow(at: indexPath, animated: true)

		let selection = SettingsViewRow(rawValue: indexPath.row)

		// Distance units cell

		if (selection == .distance)
		{
			UserSettings.sharedSettings.distanceUnit =
				(UserSettings.sharedSettings.distanceUnit == .metric) ?
					.imperial : .metric;
		}

			// Temperature units cell

		else if (selection == .temperature)
		{
			var newValue = UserSettings.sharedSettings.temperatureUnit.rawValue+1
			if newValue > TemperatureUnit.fahrenheit.rawValue { newValue = TemperatureUnit.kelvin.rawValue }
			UserSettings.sharedSettings.temperatureUnit = TemperatureUnit(rawValue: newValue)!
		}

		tableView.reloadRows(at: [ indexPath ], with: .none)
	}

}
