//
//  NSDateExtension.swift
//  
//
//  Created by Michal on 08/07/2015.
//
//

import UIKit

extension DateFormatter {

	class func sharedDateTimeFormatter() -> DateFormatter
	{
		struct Singleton { static var shared = DateFormatter() }
		if (Singleton.shared.dateFormat == "")
		{
			Singleton.shared.locale = Locale(identifier: "en_US_POSIX");
			Singleton.shared.dateFormat = "yyyy-MM-dd HH:mm:ss";
		}
		return Singleton.shared
	}

	class func sharedDayNameFormatter() -> DateFormatter
	{
		struct Singleton { static var shared = DateFormatter() }
		if (Singleton.shared.dateFormat == "")
		{
			Singleton.shared.locale = Locale.current
			Singleton.shared.dateFormat = "EEEE";
		}
		return Singleton.shared
	}

}
