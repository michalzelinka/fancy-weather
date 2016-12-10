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

	var identifier: Int
	var name: String?
	var country: String?
	var location: CLLocation?

	init?(json: JSON?)
	{
		identifier = json?["id"].int ?? 0

		name = json?["name"].string
		if (name?.length() == 0) { name = nil }

		country = json?["sys"]["country"].string
		if (country?.length() == 0) { country = nil }

		let latitude = json?["coord"]["lat"].double
		let longitude = json?["coord"]["lon"].double

		if (latitude != nil && longitude != nil)
		{ location = CLLocation(latitude: latitude!, longitude: longitude!) }

		if (identifier == 0 ||
			(name == nil && country == nil) ||
			location == nil)
		{ return nil }

	}

	init?(dictionary: [String: AnyObject])
	{
		identifier = dictionary["identifier"] as? Int ?? 0

		name = dictionary["name"] as? String
		country = dictionary["country"] as? String

		let latitude = dictionary["latitude"] as? CLLocationDegrees
		let longitude = dictionary["longitude"] as? CLLocationDegrees

		if (latitude != nil && longitude != nil)
		{ location = CLLocation(latitude: latitude!, longitude: longitude!) }

		if (identifier == 0 ||
			(name == nil && country == nil) ||
			location == nil)
		{ return nil }
	}

	func toDictionary() -> [String: AnyObject]
	{
		var dict: [String: AnyObject] = [ "identifier": identifier as AnyObject ]

		if (name != nil) { dict["name"] = name as AnyObject? }
		if (country != nil) { dict["country"] = country as AnyObject? }
		if (location != nil) {
			dict["latitude"] = location!.coordinate.latitude as AnyObject?
			dict["longitude"] = location!.coordinate.longitude as AnyObject?
		}

		return dict
	}

}

func ==(lhs: Destination, rhs: Destination) -> Bool
{
	return lhs.identifier == rhs.identifier
}
