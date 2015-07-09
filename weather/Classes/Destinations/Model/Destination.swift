//
//  Destination.swift
//  
//
//  Created by Michal on 07/07/2015.
//
//

import UIKit
import CoreLocation

class Destination {

	var identifier: Int?
	var name: String?
	var country: String?
	var location: CLLocation?

	convenience init(json: JSON?)
	{
		self.init()

		self.identifier = json?["id"].int
		self.name = json?["name"].string
		self.country = json?["sys"]["country"].string
		let latitude = json?["coord"]["lat"].double
		let longitude = json?["coord"]["lon"].double

		if (latitude != nil && longitude != nil)
		{
			self.location = CLLocation(latitude: latitude!, longitude: longitude!)
		}
	}

}
