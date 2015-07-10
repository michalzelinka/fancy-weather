//
//  Destination.swift
//  
//
//  Created by Michal on 07/07/2015.
//
//

import UIKit
import CoreLocation

class Destination: Equatable {

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

	convenience init(dictionary: [String: AnyObject])
	{
		self.init()

		self.identifier = dictionary["identifier"] as! Int?
		self.name = dictionary["name"] as! String?
		self.country = dictionary["country"] as! String?

		let latitude = dictionary["latitude"] as! CLLocationDegrees?
		let longitude = dictionary["longitude"] as! CLLocationDegrees?

		if (latitude != nil && longitude != nil)
		{
			self.location = CLLocation(latitude: latitude!, longitude: longitude!)
		}
	}

	func toDictionary() -> [String: AnyObject]
	{
		return [
			"identifier": self.identifier ?? 0,
			"name": self.name ?? "",
			"country": self.country ?? "",
			"latitude": self.location?.coordinate.latitude ?? 0,
			"longitude": self.location?.coordinate.longitude ?? 0
		]
	}

}

func ==(lhs: Destination, rhs: Destination) -> Bool
{
	return lhs.identifier == rhs.identifier
}
