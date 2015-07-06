//
//  AppDelegate.swift
//  weather
//
//  Created by Michi on 5/7/15.
//  Copyright (c) 2015 Michi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
	{
		// Default Navigation bar appearance changes
		UINavigationBar.appearance().translucent = false
		UINavigationBar.appearance().shadowImage = UIImage(named: "navbar-shadow")
		UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
		UINavigationBar.appearance().setTitleTextAttributesSwift([
			NSForegroundColorAttributeName: Colors.fromRGB(0x333333, alphaValue: 1),
			NSFontAttributeName: UIFont.boldSystemFontOfSize(18)
		])

		// Default Tab bar appearance changes
		UITabBar.appearance().tintColor = Colors.defaultBlue()
//		UIView.appearanceWhenContainedWithin([ UITabBar.self ]).tintColor = UIColor.blackColor()
//		UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState: UIControlState.Normal)

		return true
	}

	func applicationWillResignActive(application: UIApplication) { }

	func applicationDidEnterBackground(application: UIApplication) { }

	func applicationWillEnterForeground(application: UIApplication) { }

	func applicationDidBecomeActive(application: UIApplication) { }

	func applicationWillTerminate(application: UIApplication) { }

}
