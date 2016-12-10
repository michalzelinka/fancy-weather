//
//  UIView+Swift.m
//  Weather
//
//  Created by Michi on 9/7/15.
//  Copyright (c) 2015 Michi. All rights reserved.
//

#import "UIView+Swift.h"

@implementation UIView (Swift)

- (UIView *)viewForClass:(Class)className;
{
	for (UIView *v in self.subviews)
	{
		if ([v isKindOfClass:className])
			return v;

		UIView *w = [v viewForClass:className];
		if (w) return w;
	}

	return nil;
}

@end
