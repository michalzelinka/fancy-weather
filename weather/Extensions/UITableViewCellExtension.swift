//
//  UITableViewCellExtension.swift
//  Weather
//
//  Created by Michi on 5/7/15.
//  Copyright (c) 2015 Michi. All rights reserved.
//

import UIKit

extension UITableViewCell {

	func setHighlighted(highlighted: Bool, animated: Bool)
	{
		if (self.selectionStyle == .None) { return }
		if (!highlighted && selected) { return }

		let duration = (animated && !highlighted) ? 0.2 : 0
		UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
			self.backgroundColor = (highlighted) ?
				UIColor(white: 0.96, alpha: 1) : UIColor.clearColor()
			}, completion: nil)
	}

	func setSelected(selected: Bool, animated: Bool)
	{
		if (self.selectionStyle == .None) { return }

		let duration = (animated && !selected) ? 0.2 : 0
		UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
			self.backgroundColor = (selected) ?
				UIColor(white: 0.96, alpha: 1) : UIColor.clearColor()
			}, completion: nil)
	}
	
}
