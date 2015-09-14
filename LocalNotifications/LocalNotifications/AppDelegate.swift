//
//  AppDelegate.swift
//  LocalNotifications
//
//  Created by Jeff Kereakoglow on 9/13/15.
//  Copyright © 2015 Alexis Digital. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder {
  var window: UIWindow?
}

extension AppDelegate: UIApplicationDelegate {
  func application(application: UIApplication, didFinishLaunchingWithOptions
    launchOptions: [NSObject: AnyObject]?) -> Bool {
      // Define what notifications the app will be using once the app first launches. This will
      // present an alert view to the user asking him whether he wants to allow these notifications.
      let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
      UIApplication.sharedApplication().registerUserNotificationSettings(settings)
      return true
  }

  func applicationDidBecomeActive(application: UIApplication) {
    NSNotificationCenter.defaultCenter().postNotificationName(
      "applicationDidBecomeActive",
      object: nil
    )
  }

  // Whether the user allows or denies notifications, this method will be invoked. See
  // `ViewController.viewDidLoad()` for an example of how to inspect the values of
  // `notificationSettings`
  func application(application: UIApplication,
    didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {

      NSNotificationCenter.defaultCenter().postNotificationName(
        "notificationSettingsRegistered",
        object: notificationSettings
      )
  }

  // This method is invoked when the app receives a notification. In this app, it's only function is
  // to print a message to the console when the user presents a notification right away.
  func application(application: UIApplication, didReceiveLocalNotification
    notification: UILocalNotification) {

      // Broadcast the notification only if the application is active.
      guard application.applicationState == UIApplicationState.Active else { return }

      NSNotificationCenter.defaultCenter().postNotificationName(
        "applicationDidReceiveLocalNotification",
        object: notification
      )
  }
}
