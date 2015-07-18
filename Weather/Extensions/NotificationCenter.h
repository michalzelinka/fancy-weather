//
//  NotificationCenter.h
//  Tripomatic
//
//  Created by Michal Zelinka on 15/08/2014.
//  Copyright (c) 2014 Tripomatic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kNotificationBannerHeight  64.0
#define kNotificationDisplayTimeStandard  4.0
#define kNotificationDisplayTimeMinimal   2.0

// Notification identifiers

#define kNotificationAppDidFinishLaunching    UIApplicationDidFinishLaunchingNotification
#define kNotificationAppWillTerminate         UIApplicationWillTerminateNotification
#define kNotificationAppWillResignActive      UIApplicationWillResignActiveNotification
#define kNotificationAppDidEnterBackground    UIApplicationDidEnterBackgroundNotification
#define kNotificationAppWillEnterForeground   UIApplicationWillEnterForegroundNotification
#define kNotificationAppDidBecomeActive       UIApplicationDidBecomeActiveNotification



@interface NotificationCenter : NSObject

// Internal counter of displayed notifications
@property (nonatomic, assign) NSInteger displayedNotificationsCount;
// TODO: Move to UIApplication category as a new attribute --
//       like idle or network activity handling

// Initializer
+ (instancetype)defaultCenter;

// Wrapping methods
- (void)addObserver:(id)observer selector:(SEL)selector name:(NSString *)notificationName;
- (void)addObserver:(id)observer selector:(SEL)selector name:(NSString *)notificationName object:(id)object;
- (void)postNotificationName:(NSString *)notificationName;
- (void)postNotificationName:(NSString *)notificationName object:(id)object;
- (void)postNotificationName:(NSString *)notificationName userInfo:(NSDictionary *)userInfo;
- (void)postNotificationName:(NSString *)notificationName object:(id)object userInfo:(NSDictionary *)userInfo;
- (void)removeObserver:(id)observer;
- (void)removeObserver:(id)observer name:(NSString *)notificationName;

// Authorization
- (void)checkAuthorization;
- (void)checkAuthorizationForced;
- (UIUserNotificationType)allowedPermissionsForLocalNotifications;
- (BOOL)hasPermissionsForLocalNotifications;
- (void)askPermissionsForLocalNotifications;

// Extending methods
- (void)processReceivedLocalNotification:(UILocalNotification *)notification;

// Specific notifications
- (void)fireNotificationWithTitle:(NSString *)title;

@end
