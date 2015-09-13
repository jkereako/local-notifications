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

  override func viewDidLoad() {
    super.viewDidLoad()

    // The user may change his notification preferences while the app is not running, so it is
    // important to always fetch the latest version of the user's settings
    let settings = UIApplication.sharedApplication().currentUserNotificationSettings()

    allowedTypes?.text = ""

    if let types = settings?.types {
      if types.contains(.Alert) {
        allowedTypes?.text?.appendContentsOf("alert,")
      }

      if types.contains(.Badge) {
        allowedTypes?.text?.appendContentsOf(" badge,")
      }

      if types.contains(.Sound) {
        allowedTypes?.text?.appendContentsOf(" sound")
      }

      else if types.contains(.None) {
        allowedTypes?.text = "none"
        localNotificationsAllowed = false
      }
    }
  }
}

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

