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

    NSNotificationCenter.defaultCenter().addObserver(
      self,
      selector: "notificationSettingsRegistered:",
      name:"notificationSettingsRegistered",
      object: nil
    )

    NSNotificationCenter.defaultCenter().addObserver(
      self,
      selector: "applicationDidReceiveLocalNotification:",
      name:"applicationDidReceiveLocalNotification",
      object: nil
    )

  }

  override func viewWillDisappear(animated: Bool) {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
}

// MARK: - Observers
extension ViewController {
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
}

// MARK: - Actions
extension ViewController {
  @IBAction func postNotificationNowAction(_: UIButton) {
    // Before building the notification, make sure you have the rights to show local notifications.
    guard localNotificationsAllowed else {
      showError()
      return
    }

    UIApplication.sharedApplication().presentLocalNotificationNow(notification())
  }

  @IBAction func postNotificationLaterAction(_: UIButton) {
    guard localNotificationsAllowed else {
      showError()
      return
    }

    let aNotification = notification()
    // 5 seconds from now
    aNotification.fireDate = NSDate().dateByAddingTimeInterval(5.0)
    UIApplication.sharedApplication().scheduleLocalNotification(aNotification)
  }
}

// MARK: -  Private helpers
extension ViewController {
  private func updateNotificationPrivilegesLabel(notificationSettings settings: UIUserNotificationSettings) {
    allowedTypes?.text = ""

    // It took me an hour to come up with this.
    if settings.types == .None {
      allowedTypes?.text = "none"
      localNotificationsAllowed = false
    }

    else {
      allowedTypes?.text?.appendContentsOf("alert, badge, sound")
      localNotificationsAllowed = true
    }
  }
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
      message: "You have denied this app the privilege to annoy you with local notifications.",
      preferredStyle: .Alert)
    let action = UIAlertAction(title: "Okay", style: .Cancel, handler: nil)
    controller.addAction(action)

    presentViewController(controller, animated: true, completion: nil)
  }
}

