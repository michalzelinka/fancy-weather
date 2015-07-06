//
//  TodayViewController.swift
//  Weather
//
//  Created by Michi on 5/7/15.
//  Copyright (c) 2015 Michi. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {

	@IBOutlet weak var conditionIcon : UIImageView!
	@IBOutlet weak var locationLabel : UILabel!
	@IBOutlet weak var summaryLabel : UILabel!

	@IBOutlet weak var humidityLabel : UILabel!
	@IBOutlet weak var rainDropsLabel : UILabel!
	@IBOutlet weak var pressureLabel : UILabel!
	@IBOutlet weak var windSpeedLabel : UILabel!
	@IBOutlet weak var windDirectionLabel : UILabel!

	func reloadData() -> Void
	{
		// TODO: Fill UI elements with values
	}

	@IBAction func shareButtonTapped(sender: UIControl)
	{
		// TODO: Implement
	}

	@IBAction func locationsButtonTapped(sender: UIControl)
	{
		// TODO: Implement
	}

}
