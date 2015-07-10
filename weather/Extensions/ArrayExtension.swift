//
//  ArrayExtension.swift
//  weather
//
//  Created by Michal on 10/07/15.
//  Copyright (c) 2015 Michi. All rights reserved.
//

import UIKit

extension Array {

	mutating func removeObject<U: Equatable>(object: U)
	{
		var index: Int?

		for (idx, objectToCompare) in enumerate(self) {
			if let to = objectToCompare as? U {
				if object == to {
					index = idx
				}
			}
		}

		if (index != nil) { self.removeAtIndex(index!) }
	}
}
