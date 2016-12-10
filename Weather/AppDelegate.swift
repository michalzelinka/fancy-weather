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

	func application(_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
	{
		// Proress HUD appearance
		SVProgressHUD.setBackgroundColor(UIColor.white)
		SVProgressHUD.setForegroundColor(Colors.fromRGB(0x333333, alphaValue: 1.0))
		SVProgressHUD.setFont(UIFont.systemFont(ofSize: 19))
		SVProgressHUD.setDefaultMaskType(.black)

		// Default Navigation bar appearance changes
		UINavigationBar.appearance().isTranslucent = false
		UINavigationBar.appearance().shadowImage = UIImage(named: "navbar-shadow")
		UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		UINavigationBar.appearance().setTitleTextAttributesSwift([
			NSForegroundColorAttributeName: Colors.fromRGB(0x333333, alphaValue: 1),
			NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18)
		])

		// Default Tab bar appearance changes
		UITabBar.appearance().tintColor = Colors.defaultBlue()
//		UIView.appearanceWhenContainedWithin([ UITabBar.self ]).tintColor = UIColor.blackColor()
//		UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState: UIControlState.Normal)

		// Load some data from last session
		WeatherManager.sharedManager.loadFollowedDestinationsFromDefaults()

		// Ask for location permissions
		let _ = CLocationManager.sharedManager.checkAuthorisation()

		return true
	}

	func applicationWillResignActive(_ application: UIApplication) { }

	func applicationDidEnterBackground(_ application: UIApplication)
	{
		// Save some data for the next session
		WeatherManager.sharedManager.saveFollowedDestinationsToDefaults()
	}

	func applicationWillEnterForeground(_ application: UIApplication) { }

	func applicationDidBecomeActive(_ application: UIApplication) { }

	func applicationWillTerminate(_ application: UIApplication) { }

}
