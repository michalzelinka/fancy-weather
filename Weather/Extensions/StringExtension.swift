//
//  StringExtension.swift
//  Weather
//
//  Created by Michi on 17/7/15.
//  Copyright (c) 2015 Michi. All rights reserved.
//

import Foundation

extension String {

	func length() -> Int
	{
		return self.lengthOfBytes(using: String.Encoding.utf8)
	}

}
