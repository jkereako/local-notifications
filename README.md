# Local Notifications
This is a small and simple app demonstrating the use of local notifications. I used it as research for figuring out the best way to handle local notifications.

# Usage
You can take snippets from this project. For example, the code below is pretty standard.
```swift
func application(application: UIApplication, 
  didReceiveLocalNotification notification: UILocalNotification) {
    guard application.applicationState == UIApplicationState.Active else { return }

    NSNotificationCenter.defaultCenter().postNotificationName(
      "applicationDidReceiveLocalNotification",
      object: notification
    )
}
```
This broadcasts to the app that a local notification has been received. The notification is only broadcasted if the app is active, otherwise its ignored.
