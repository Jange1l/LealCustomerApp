//
//  AppDelegate.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 1/31/21.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
	
	let accountDetails = AccountDetails()

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		FirebaseApp.configure()
		
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
			print("granted: (\(granted)")
		}
		Messaging.messaging().delegate = self
		if #available(iOS 10.0, *) {
		  // For iOS 10 display notification (sent via APNS)
		  UNUserNotificationCenter.current().delegate = self

		  let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
		  UNUserNotificationCenter.current().requestAuthorization(
			options: authOptions,
			completionHandler: {_, _ in })
		} else {
		  let settings: UIUserNotificationSettings =
		  UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
		  application.registerUserNotificationSettings(settings)
		}

		application.registerForRemoteNotifications()

		if accountDetails.hasUserLoggedinBefore() {
			let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
			storyBoard.instantiateViewController(withIdentifier: "logIn") as! InitialViewController
			
		}
		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}

	func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
		
//	  print("Firebase registration token: \(fcmToken!)")
//
//
//	  let dataDict:[String: String] = ["token": fcmToken!]
//		print("TOKEN?", dataDict["token"]!)
//	
//	  NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
	  
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
		NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadEventsTable"), object: nil)

	}
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		
		let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
		  let token = tokenParts.joined()
		  print("Device Token: \(token)")
	}
}

