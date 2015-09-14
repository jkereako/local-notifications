//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Jeff Kereakoglow on 9/13/15.
//  Copyright © 2015 Alexis Digital. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  private var count = 0
  private var localNotificationsAllowed = true
  @IBOutlet weak var allowedTypes: UILabel?

  deinit {
    // Don't forget to stop observing!
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
}

// MARK: - View controller life cycle
extension ViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    // The settings may not be defined at the point. For example, it's the first time the user has
    // launched the app.
    if let settings = UIApplication.sharedApplication().currentUserNotificationSettings() {
      updateNotificationPrivilegesLabel(notificationSettings: settings)
    }
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    // When the user first selects whether to allow notifications or not
    NSNotificationCenter.defaultCenter().addObserver(
      self,
      selector: "notificationSettingsRegistered:",
      name:"notificationSettingsRegistered",
      object: nil
    )

    // When the application receives a local notification
    NSNotificationCenter.defaultCenter().addObserver(
      self,
      selector: "applicationDidReceiveLocalNotification:",
      name:"applicationDidReceiveLocalNotification",
      object: nil
    )

    // When the application is in the foreground
    NSNotificationCenter.defaultCenter().addObserver(
      self,
      selector: "applicationDidBecomeActive:",
      name:"applicationDidBecomeActive",
      object: nil
    )

  }
}

// MARK: - Observers
extension ViewController {
  // Respond to the user's notification settings. This will only happen 1 time.
  func notificationSettingsRegistered(note: NSNotification) {
    if let settings = note.object as? UIUserNotificationSettings {
      updateNotificationPrivilegesLabel(notificationSettings: settings)
    }
  }

  func applicationDidReceiveLocalNotification(note: NSNotification) {
    guard let notification = note.object as? UILocalNotification else {
      return
    }

    let controller = UIAlertController(title: notification.alertTitle,
      message: notification.alertBody,
      preferredStyle: .Alert)
    let action = UIAlertAction(title: notification.alertAction, style: .Cancel, handler: nil)
    controller.addAction(action)

    presentViewController(controller, animated: true, completion: nil)
  }

  //   We have to check the user's notification settings each time this app becomes active. The
  // possible scenario is when the user 1) sends this app into the background, 2) opens the Settings
  // app, 3) changes his notification settings for this app, and 4) re-opens this app.
  //   We can't rely on the delegate methods `viewDidLoad()` and `viewDidAppear()` to be invoked
  // each time the app is visible because although the app is in the background, it is still 
  // executing. Hence, we must respond to `applicationDidBecomeActive`.
  func applicationDidBecomeActive(note: NSNotification) {
    if let settings = UIApplication.sharedApplication().currentUserNotificationSettings() {
      updateNotificationPrivilegesLabel(notificationSettings: settings)
    }
  }
}

// MARK: - Actions
extension ViewController {
  @IBAction func postNotificationNowAction(_: UIButton) {
    // Before building the notification, make sure you have the rights to show local notifications.
    guard localNotificationsAllowed else {
      showError()
      return
    }

    // Post the local notification right away
    UIApplication.sharedApplication().presentLocalNotificationNow(notification())
  }

  @IBAction func postNotificationLaterAction(_: UIButton) {
    guard localNotificationsAllowed else {
      showError()
      return
    }

    let aNotification = notification()
    // Post the local notification 5 seconds from now. The point of this is 1) to prove that the
    // scheduling feature works and 2) to allow you to view the notification as a banner.
    aNotification.fireDate = NSDate().dateByAddingTimeInterval(5.0)
    UIApplication.sharedApplication().scheduleLocalNotification(aNotification)
  }
}

// MARK: -  Private helpers
extension ViewController {
  private func updateNotificationPrivilegesLabel(notificationSettings settings: UIUserNotificationSettings) {
    allowedTypes?.text = ""

    // The best way to inspect `notificationSettings.types` is to use the Boolean expression below.
    if settings.types == .None {
      allowedTypes?.text = "none"
      localNotificationsAllowed = false
    }

    else {
      allowedTypes?.text?.appendContentsOf("alert, badge, sound")
      localNotificationsAllowed = true
    }
  }

  // Generate a local notification
  private func notification() -> UILocalNotification {
    let notification = UILocalNotification()
    notification.applicationIconBadgeNumber = ++count
    notification.alertTitle = "Hello"
    notification.alertBody = "This is a test notification"
    notification.alertAction = "Okay"
    notification.soundName = UILocalNotificationDefaultSoundName

    return notification
  }

  private func showError() {
    let controller = UIAlertController(title: "Notifications prohibited",
      message: "Go to Settings > LocalNotifications to change your notification preferences.",
      preferredStyle: .Alert)
    let action = UIAlertAction(title: "Okay", style: .Cancel, handler: nil)
    controller.addAction(action)

    presentViewController(controller, animated: true, completion: nil)
  }
}

