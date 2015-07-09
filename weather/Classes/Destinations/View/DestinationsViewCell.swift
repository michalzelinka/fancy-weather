//
//  ForecastViewCell.swift
//  
//
//  Created by Michal on 09/07/2015.
//
//

import UIKit

class DestinationsViewCell: UITableViewCell {

	@IBOutlet weak var conditionImage: UIImageView?
	@IBOutlet weak var destinationLabel: UILabel?
	@IBOutlet weak var conditionLabel: UILabel?
	@IBOutlet weak var temperatureLabel: UILabel?

    override func awakeFromNib()
	{
        super.awakeFromNib()
		self.selectionStyle = .Default
    }

	func update(destination: Destination?, record: WeatherRecord?) -> Void
	{
		if var record = record
		{
			let unit = UserSettings.sharedSettings.temperatureUnit
			conditionImage?.image = UIImage(named: String("condition-"+record.conditionImagePattern()))
			destinationLabel?.text = destination?.name
			conditionLabel?.text = record.conditionText
			temperatureLabel?.text = NumberFormatter.double(record.temperature, toTemperatureStringWithUnit: unit, unitDisplayed: false)
		}
	}

}
