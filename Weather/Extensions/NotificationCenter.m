//
//  NotificationCenter.m
//  Tripomatic
//
//  Created by Michal Zelinka on 15/08/2014.
//  Copyright (c) 2014 Tripomatic. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "NotificationCenter.h"
#import "UIView+position.h"
#import "UIView+Swift.h"

#pragma mark -
#pragma mark Global-scope functions (semi-redacted)
#pragma mark -


void dispatch_after_b(NSTimeInterval after, dispatch_block_t block)
{
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(after * NSEC_PER_SEC)),
				   dispatch_get_main_queue(), block);
}

#pragma mark -
#pragma mark Notifications stuff definition
#pragma mark -

// Notice: These values are used in external/system component and may
//         unpredictably remain in system storage before notifications are
//         fired.

typedef NS_ENUM(NSUInteger, NotificationType) {
	NotificationTypeUnknown            = 0,
	NotificationTypeAppReminder        = 1,
	NotificationTypeOfflineMapDownload = 2,
	NotificationTypeOfflineMapDownloadInterruption = 3,
	NotificationTypeTripReminder       = 4,
	NotificationTypeSyncReminder       = 5,
	NotificationTypePhotoUpload        = 6,
}; // ABI-EXPORTED

#define NotificationPropertyType @"Type"
#define NotificationPropertyIdentifier @"Identifier"

@interface InAppNotification : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *alertBody;
@property (nonatomic, copy) NSString *soundName;
@property (nonatomic, strong) NSDate *fireDate;

@end


@interface NotificationsWindow : UIWindow

- (void)enqueueNotification:(InAppNotification *)notification;

@end

@interface NotificationBanner : UIView

@property (nonatomic, strong) InAppNotification *notification;

@end


@interface CNotificationCenter ()

@property (nonatomic, weak) NSNotificationCenter *defaultCenter;
@property (nonatomic, weak) UIApplication *sharedApplication;

@end


#pragma mark -
#pragma mark Notification center
#pragma mark -


@implementation CNotificationCenter


#pragma mark Instance handling


+ (instancetype)defaultCenter
{
	static CNotificationCenter *shared = nil;
	static dispatch_once_t once;
	dispatch_once(&once, ^{ shared = [[self alloc] init]; });
	return shared;
}

- (instancetype)init
{
	if (self = [super init])
	{
		_sharedApplication = [UIApplication sharedApplication];
		_defaultCenter = [NSNotificationCenter defaultCenter];
		[self addObserver:self selector:@selector(appDidFinishLaunching) name:kNotificationAppDidFinishLaunching];
		[self addObserver:self selector:@selector(appWillEnterForeground) name:kNotificationAppWillEnterForeground];
		[self addObserver:self selector:@selector(appDidEnterBackground) name:kNotificationAppDidEnterBackground];
	}

	return self;
}

- (void)dealloc
{
	[self removeObserver:self];
}


#pragma mark - Wrapping methods


- (void)addObserver:(id)observer selector:(SEL)selector name:(NSString *)notificationName
{
	[self addObserver:observer selector:selector name:notificationName object:nil];
}

- (void)addObserver:(id)observer selector:(SEL)selector name:(NSString *)notificationName object:(id)object
{
	[_defaultCenter addObserver:observer selector:selector name:notificationName object:object];
}

- (void)postNotificationName:(NSString *)notificationName
{
	[_defaultCenter postNotificationName:notificationName object:nil userInfo:nil];
}

- (void)postNotificationName:(NSString *)notificationName object:(id)object
{
	[_defaultCenter postNotificationName:notificationName object:object userInfo:nil];
}

- (void)postNotificationName:(NSString *)notificationName userInfo:(NSDictionary *)userInfo;
{
	[_defaultCenter postNotificationName:notificationName object:nil userInfo:userInfo];
}

- (void)postNotificationName:(NSString *)notificationName object:(id)object userInfo:(NSDictionary *)userInfo
{
	[_defaultCenter postNotificationName:notificationName object:object userInfo:userInfo];
}

- (void)removeObserver:(id)observer
{
	[_defaultCenter removeObserver:observer];
}

- (void)removeObserver:(id)observer name:(NSString *)notificationName
{
	[_defaultCenter removeObserver:observer name:notificationName object:nil];
}


#pragma mark - Extending methods


- (void)processReceivedLocalNotification:(UILocalNotification *)notification
{
	// Redacted
}

- (void)fireNotificationWithTitle:(NSString *)title
{
	// Rush, rush!
	InAppNotification *n = [[InAppNotification alloc] init];
	n.alertBody = title;
	n.image = [UIImage imageNamed:@"AppIcon29x29"];
	n.fireDate = [NSDate new];
	n.soundName = @"telegramwe.caf";
	[self tryDisplayInAppNotification:n];
}


#pragma mark - Authorization


- (void)checkAuthorization
{
	static dispatch_once_t once;
	dispatch_once(&once, ^{ [self checkAuthorizationForced]; });
}

- (void)checkAuthorizationForced
{
	// Redacted
}


#pragma mark - Batch scheduling & clean-up


- (void)cleanupScheduledNotifications
{
	// Cancel if there's probably nothing stored
	if (![self hasPermissionsForLocalNotifications])
		return;

	BOOL badgeAllowed = [self allowedPermissionsForLocalNotifications] & UIUserNotificationTypeBadge;

	// Clear application icon badge number
	if (badgeAllowed)
		_sharedApplication.applicationIconBadgeNumber = _displayedNotificationsCount = 0;

	// Cancel all remaining notifications
	[_sharedApplication cancelAllLocalNotifications];
}

- (void)scheduleNotifications
{
	// Break when no permission granted
	if (![self hasPermissionsForLocalNotifications])
		return;

	BOOL soundAllowed = [self allowedPermissionsForLocalNotifications] & UIUserNotificationTypeSound;
	BOOL badgeAllowed = [self allowedPermissionsForLocalNotifications] & UIUserNotificationTypeBadge;

	NSMutableArray *notifications = [NSMutableArray array];

	// Get App Reminder notification
	// Redacted

	// Get Sync Reminder notification
	// Redacted

	// Get notifications for future Trips
	// Redacted

	// Sort notifications by fire date
	[notifications sortUsingComparator:^NSComparisonResult(UILocalNotification *n1, UILocalNotification *n2) {
		return [n1.fireDate compare:n2.fireDate];
	}];

	// Set proper icon badge numbers and schedule notifications
	for (UILocalNotification *notification in notifications)
	{
		if (badgeAllowed) notification.applicationIconBadgeNumber = [notifications indexOfObject:notification]+1;
		if (!soundAllowed) notification.soundName = nil;
		[_sharedApplication scheduleLocalNotification:notification];
	}
}


#pragma mark - Settings


- (UIUserNotificationType)allowedPermissionsForLocalNotifications
{
	// Return current settings directly on supported devices
	if ([_sharedApplication respondsToSelector:@selector(currentUserNotificationSettings)])
		return [_sharedApplication currentUserNotificationSettings].types;

	// Return all permissions for devices with iOS 7 and older as these
	// versions do not block Local notifications
	return (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
}

- (BOOL)hasPermissionsForLocalNotifications
{
	// Check for Alert/Banner permitted type
	return ([self allowedPermissionsForLocalNotifications] & UIUserNotificationTypeAlert);
}

- (void)askPermissionsForLocalNotifications
{
	// On iOS 8+ perform a Local notifications registration call
	if ([_sharedApplication respondsToSelector:@selector(registerUserNotificationSettings:)])
	{
		NSUInteger wishedTypes = (UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound);

		// Direct call when using iOS 8 SDK
		[_sharedApplication registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:wishedTypes categories:nil]];
	}
}


#pragma mark - In-App Notifications


- (NotificationsWindow *)localNotificationsWidnow
{
	static NotificationsWindow *window = nil;

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		window = [[NotificationsWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
		window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		window.windowLevel = UIWindowLevelStatusBar + 1000;
		window.userInteractionEnabled = YES;
	});

	return window;
}

- (void)showInAppNotification:(InAppNotification *)notification
{
	if (![[NSThread currentThread] isMainThread])
	{
		[self performSelectorOnMainThread:@selector(showInAppNotification:) withObject:notification waitUntilDone:NO];
		return;
	}

	[[self localNotificationsWidnow] enqueueNotification:notification];
}

- (void)tryDisplayInAppNotification:(InAppNotification *)notification
{
	if (![[NSThread currentThread] isMainThread])
	{
		[self performSelectorOnMainThread:@selector(tryDisplayInAppNotification:) withObject:notification waitUntilDone:NO];
		return;
	}

	if (![[self localNotificationsWidnow] viewForClass:[NotificationBanner class]])
		[[self localNotificationsWidnow] enqueueNotification:notification];
}


#pragma mark - Notifications


- (void)appDidFinishLaunching
{
	[self cleanupScheduledNotifications];
}

- (void)appWillEnterForeground
{
	[self cleanupScheduledNotifications];
}

- (void)appDidEnterBackground
{
	[self scheduleNotifications];
}


@end


///////////////////////
#pragma mark -
#pragma mark Local Notifications stuff
#pragma mark -
///////////////////////


@implementation InAppNotification
@end

@interface NotificationBanner ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *drawer;
@property (atomic) BOOL lightContent;
@property (atomic) BOOL dismissBlocked;
@property (atomic) CGPoint touchPoint;

@end

@implementation NotificationBanner

- (instancetype)initWithFrame:(CGRect)frame
{
	return [self initWithFrame:frame lightContent:YES];
}

- (instancetype)initWithFrame:(CGRect)frame lightContent:(BOOL)lightContent;
{
	if (self = [super initWithFrame:frame])
	{
		_lightContent = lightContent;

		self.height = kNotificationBannerHeight;
		self.userInteractionEnabled = YES;

		BOOL blurred = [UIBlurEffect class] != nil; // && [[UIDevice currentDevice] isPowerfulDevice];

		if (blurred)
		{
			UIBlurEffectStyle style = (lightContent) ? UIBlurEffectStyleDark : UIBlurEffectStyleExtraLight;
			UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:style]];
			effectView.frame = self.bounds;
			effectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			effectView.userInteractionEnabled = NO;
			[self addSubview:effectView];
		}

		CGFloat backgroundAlpha = (blurred) ? .7:.94;
		self.backgroundColor = [UIColor colorWithRed:40/255.0 green:44/255.0 blue:52/255.0 alpha:backgroundAlpha];

		_drawer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 38, 6)];
		_drawer.layer.cornerRadius = 3;
		_drawer.backgroundColor = [(lightContent ? [UIColor whiteColor] : [UIColor blackColor]) colorWithAlphaComponent:.8];
		_drawer.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
		[self addCenteredSubview:_drawer];
		_drawer.fromBottomEdge = 4;

		_iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 18, 20, 20)];
		_iconView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
		_iconView.contentMode = UIViewContentModeScaleAspectFill;
		_iconView.layer.masksToBounds = YES;
		_iconView.layer.cornerRadius = 4.125;
		_iconView.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
		_iconView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
		[self addSubview:_iconView];

		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 6, self.width-50-14, 44)];
		_titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
		_titleLabel.font = [UIFont boldSystemFontOfSize:15];
		_titleLabel.numberOfLines = 2;
		_titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
		_titleLabel.textColor = (lightContent) ? [UIColor whiteColor] : [UIColor blackColor];
		[self addSubview:_titleLabel];

		_drawer.userInteractionEnabled = _iconView.userInteractionEnabled =
			_titleLabel.userInteractionEnabled = NO;
	}

	return self;
}

- (void)setNotification:(InAppNotification *)notification
{
	_notification = notification;

	if (notification.image)      _iconView.image = notification.image;
	if (notification.alertBody)
	{
		NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//		style.hyphenationFactor = 1.0f;
		style.lineSpacing = -2;
		style.alignment = NSTextAlignmentLeft;

		NSMutableAttributedString *str = [[NSMutableAttributedString alloc]
			initWithString:notification.alertBody attributes:@{
				NSParagraphStyleAttributeName: style,
				NSForegroundColorAttributeName: (_lightContent) ? [UIColor whiteColor] : [UIColor blackColor],
				NSFontAttributeName: _titleLabel.font,
		}];

		_titleLabel.attributedText = str;
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (_dismissBlocked) return;
	if (!self.isUserInteractionEnabled) return;

	CGPoint touchPoint = [event.allTouches.anyObject locationInView:self];
	if (touchPoint.y < 20+4) return;

	_dismissBlocked = YES;
	_touchPoint = touchPoint;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (!_dismissBlocked) return;
	if (!self.isUserInteractionEnabled) return;
	CGPoint currentPoint = [event.allTouches.anyObject locationInView:self];
	CGFloat heightDiff = (currentPoint.y - _touchPoint.y);
	if (heightDiff > 1) heightDiff = powf((float)heightDiff, 0.5);
	self.height = kNotificationBannerHeight + heightDiff;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self touchesEnded:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (!self.isUserInteractionEnabled) return;

	if (self.height < kNotificationBannerHeight-14) {
		_dismissBlocked = NO;
		[self dismiss];
	}
	else [UIView animateWithDuration:.1 animations:^{
		self.height = kNotificationBannerHeight;
	} completion:^(BOOL finished) {
		dispatch_after_b(.5, ^{ _dismissBlocked = NO; });
	}];
}

- (void)dismiss
{
	if (_dismissBlocked) return;
	_dismissBlocked = YES;
	self.userInteractionEnabled = NO;
	
	[UIView animateWithDuration:.2 animations:^{
		self.height = 0;
	} completion:^(BOOL finished) {
		[self removeFromSuperview];
	}];
}

@end

@interface NotificationsViewController : UIViewController
@end

@implementation NotificationsViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return [[UIApplication sharedApplication] statusBarStyle];
}

@end

@interface NotificationsWindow () <AVAudioPlayerDelegate>

@property (nonatomic, strong) NSMutableArray *notificationsQueue;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation NotificationsWindow

- (BOOL)notificationShown
{
	return YES;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		[self setRootViewController:[NotificationsViewController new]];
		_notificationsQueue = [NSMutableArray array];
	}

	return self;
}

- (void)enqueueNotification:(InAppNotification *)notification
{
	[_notificationsQueue addObject:notification];
	[self checkNotificationDisplay];
}

- (void)checkNotificationDisplay
{
	InAppNotification *toDisplay = _notificationsQueue.firstObject;
	NotificationBanner *displayed = (id)[self viewForClass:[NotificationBanner class]];

	if (displayed && [[NSDate new] timeIntervalSinceDate:displayed.notification.fireDate] < kNotificationDisplayTimeMinimal)
	{ dispatch_after_b(.5, ^{ [self checkNotificationDisplay]; }); return; }

	if (displayed && displayed.dismissBlocked)
	{ dispatch_after_b(1.0, ^{ [self checkNotificationDisplay]; }); return; }

	if (displayed)
	{ [displayed dismiss]; dispatch_after_b(.5, ^{ [self checkNotificationDisplay]; }); return; }

	if (!toDisplay && !displayed)
		self.hidden = YES;

	else if (toDisplay)
	{
		[_notificationsQueue removeObject:toDisplay];

		self.hidden = NO;

		NotificationBanner *banner = [[NotificationBanner alloc] initWithFrame:self.bounds lightContent:NO];
		toDisplay.fireDate = [NSDate new];
		banner.notification = toDisplay;

		[self addSubview:banner];
		banner.top = -banner.height;

		[UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:500 initialSpringVelocity:0 options:0 animations:^{
			banner.top = 0;
		} completion:nil];

		if (toDisplay.soundName != nil)
		{
			NSString *soundFilePath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], toDisplay.soundName];
			NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];

			[_audioPlayer stop];

			_audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
			_audioPlayer.delegate = self;
			_audioPlayer.numberOfLoops = 0;
			[_audioPlayer play];
		}

		dispatch_after_b(kNotificationDisplayTimeStandard, ^{ [self checkNotificationDisplay]; });
	}
}

#pragma mark AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	[_audioPlayer stop];
	_audioPlayer = nil;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	UIView *responding = [super hitTest:point withEvent:event];

	if ([responding isKindOfClass:[NotificationBanner class]])
		return responding;

	return nil;
}

@end
