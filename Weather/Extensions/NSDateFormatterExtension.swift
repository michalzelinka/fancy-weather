//
//  NSDateExtension.swift
//  
//
//  Created by Michal on 08/07/2015.
//
//

import UIKit

extension NSDateFormatter {

	class func sharedDateTimeFormatter() -> NSDateFormatter
	{
		struct Singleton { static var shared = NSDateFormatter() }
		if (Singleton.shared.dateFormat == "")
		{
			Singleton.shared.locale = NSLocale(localeIdentifier: "en_US_POSIX");
			Singleton.shared.dateFormat = "yyyy-MM-dd HH:mm:ss";
		}
		return Singleton.shared
	}

	class func sharedDayNameFormatter() -> NSDateFormatter
	{
		struct Singleton { static var shared = NSDateFormatter() }
		if (Singleton.shared.dateFormat == "")
		{
			Singleton.shared.locale = NSLocale.currentLocale()
			Singleton.shared.dateFormat = "EEEE";
		}
		return Singleton.shared
	}

}
