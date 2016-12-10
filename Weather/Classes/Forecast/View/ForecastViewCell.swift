//
//  ForecastViewCell.swift
//  
//
//  Created by Michal on 08/07/2015.
//
//

import UIKit

class ForecastViewCell: UITableViewCell {

	@IBOutlet weak var conditionImage: UIImageView?
	@IBOutlet weak var dayLabel: UILabel?
	@IBOutlet weak var conditionLabel: UILabel?
	@IBOutlet weak var temperatureLabel: UILabel?

    override func awakeFromNib()
	{
        super.awakeFromNib()
		self.selectionStyle = .none
    }

	func update(_ record: WeatherRecord?) -> Void
	{
		if let record = record
		{
			let unit = UserSettings.sharedSettings.temperatureUnit
			conditionImage?.image = UIImage(named: String("condition-"+record.conditionImagePattern()))
			dayLabel?.text = DateFormatter.sharedDayNameFormatter().string(from: record.date!)
			conditionLabel?.text = record.conditionText
			temperatureLabel?.text = NumberFormatter.double(record.temperature, toTemperatureStringWithUnit: unit, unitDisplayed: false)
		}
	}

}
