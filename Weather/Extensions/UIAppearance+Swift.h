//
//  UIAppearance+Swift.h
//  Weather
//
//  Created by Michi on 5/7/15.
//  Copyright (c) 2015 Michi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (UIAppearance_Swift)

+ (instancetype)appearanceWhenContainedWithin:(NSArray *)containers;

@end


@interface UINavigationBar (UIAppearance_Swift)

- (void)setTitleTextAttributesSwift:(NSDictionary *)titleTextAttributes;

@end
