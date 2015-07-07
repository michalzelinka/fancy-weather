//
//  UIFont+Swift.m
//  
//
//  Created by Michal on 08/07/2015.
//
//

#import "UIFont+Swift.h"

@implementation UIFont (Swift)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

+ (UIFont *)systemFontOfSize:(CGFloat)size
{
	return [UIFont fontWithName:@"ProximaNova-Regular" size:size];
}

+ (UIFont *)lightSystemFontOfSize:(CGFloat)size
{
	return [UIFont fontWithName:@"ProximaNova-Light" size:size];
}

+ (UIFont *)boldSystemFontOfSize:(CGFloat)size
{
	return [UIFont fontWithName:@"ProximaNova-Semibold" size:size];
}

+ (UIFont *)preferredFontForTextStyle:(NSString *)style
{
	if ([style isEqualToString:UIFontTextStyleBody])
		return [UIFont systemFontOfSize:17];
	if ([style isEqualToString:UIFontTextStyleHeadline])
		return [UIFont boldSystemFontOfSize:17];
	if ([style isEqualToString:UIFontTextStyleSubheadline])
		return [UIFont systemFontOfSize:15];
	if ([style isEqualToString:UIFontTextStyleFootnote])
		return [UIFont systemFontOfSize:13];
	if ([style isEqualToString:UIFontTextStyleCaption1])
		return [UIFont systemFontOfSize:12];
	if ([style isEqualToString:UIFontTextStyleCaption2])
		return [UIFont systemFontOfSize:11];
	return [UIFont systemFontOfSize:17];
}

- (UIFont *)fontAdjustedByPoints:(CGFloat)points
{
	return [self fontWithSize:self.pointSize+points];
}

#pragma clang diagnostic pop

@end
