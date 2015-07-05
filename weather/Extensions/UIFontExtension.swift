//
//  UIFontExtension.swift
//  Weather
//
//  Created by Michi on 5/7/15.
//  Copyright (c) 2015 Michi. All rights reserved.
//

import UIKit

extension UIFont {

	class func systemFontOfSize(fontSize: CGFloat) -> UIFont
	{
		return UIFont(name: "ProximaNova-Regular", size: fontSize)!
	}

	class func boldSystemFontOfSize(fontSize: CGFloat) -> UIFont
	{
		return UIFont(name: "ProximaNova-Semibold", size: fontSize)!
	}

	class func lightSystemFontOfSize(fontSize: CGFloat) -> UIFont
	{
		return UIFont(name: "ProximaNova-Light", size: fontSize)!
	}

	class func preferredFontForTextStyle(style: String) -> UIFont
	{
		switch style {

		case UIFontTextStyleBody:
			return UIFont.systemFontOfSize(17)
		case UIFontTextStyleHeadline:
			return UIFont.boldSystemFontOfSize(17)
		case UIFontTextStyleSubheadline:
			return UIFont.systemFontOfSize(15)
		case UIFontTextStyleFootnote:
			return UIFont.systemFontOfSize(13)
		case UIFontTextStyleCaption1:
			return UIFont.systemFontOfSize(12)
		case UIFontTextStyleCaption2:
			return UIFont.systemFontOfSize(11)
		default:
			return UIFont.systemFontOfSize(17)

		}
	}

}
