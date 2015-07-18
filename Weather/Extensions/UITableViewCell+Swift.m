//
//  UITableViewCell+Swift.m
//  
//
//  Created by Michal on 10/07/2015.
//
//

#import "UITableViewCell+Swift.h"

@implementation UITableViewCell (Swift)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	if (self.selectionStyle == UITableViewCellSelectionStyleNone)
		return;

	if (!highlighted && self.isSelected)
		return;

	CGFloat duration = (animated && !highlighted) ? 0.2 : 0;

	[UIView animateWithDuration:duration delay:0
		options:UIViewAnimationOptionBeginFromCurrentState animations:^{

		self.backgroundColor = (highlighted) ?
			[UIColor colorWithWhite:.96 alpha:1] : [UIColor clearColor];

	} completion:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	if (self.selectionStyle == UITableViewCellSelectionStyleNone)
		return;

	CGFloat duration = (animated && !selected) ? 0.2 : 0;

	[UIView animateWithDuration:duration delay:0
		options:UIViewAnimationOptionBeginFromCurrentState animations:^{

		self.backgroundColor = (selected) ?
			[UIColor colorWithWhite:.96 alpha:1] : [UIColor clearColor];

	} completion:nil];
}

#pragma clang diagnostic pop

@end
