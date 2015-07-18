//
//  Colors.swift
//  Weather
//
//  Created by Michi on 5/7/15.
//  Copyright (c) 2015 Michi. All rights reserved.
//

import UIKit

class Colors: NSObject {

	class func fromRGB(rgbValue: Int, alphaValue: CGFloat) -> UIColor
	{
		let r = CGFloat (( rgbValue & 0xFF0000 ) >> 16) / 255.0
		let g = CGFloat (( rgbValue & 0x00FF00 ) >> 8)  / 255.0
		let b = CGFloat (( rgbValue & 0x0000FF ) >> 0)  / 255.0

		return UIColor(red: r, green: g, blue: b, alpha: alphaValue)
	}

	class func defaultBlue() -> UIColor
	{
		return self.fromRGB(0x2F91FF, alphaValue: 1)
	}
}
