# CocoaPodTest
AnnounceKit iOS is an iOS sdk for get the unread post count and show the post page by using WKWebview.

## Installation
### CocoaPods
To integrate Instabug into your Xcode project using CocoaPods, add it to your Podfile:
```swift
pod 'BarajaFramework'
```
Then, run the following command:
```swift
pod 'Install'
```

## Usage
1.  Import BarajaFramework framework header in your class
```swift
import BarajaFramework
```
2.  Create instance of the framework main class
```swift
let announceKit = WhatsNewViewController()
```

### Unread Count
1.  To get the unread count of the posts, use this method
```swift
announceKit.getUnreadCount(userId: nil, widgetId: <#widget id#>, delegate: self)
```
make sure to replace the ```widget id``` with your ```widget id```
userId is optional data. <br/>It used to track the user data. 
<br/>Don't forget to set the delegate for receive the callback

2.  To get the unread count of the posts, use this method
```swift
extension <#Your ViewController Name#> : WhatsNewViewControllerProtocol {
    func updateUnreadCount(unreadCount: Int) {
        //
    }
}
```
```func updateUnreadCount(unreadCount: Int)``` is a callback method when succeded getting the unread count and it returns with a number of unread post count

### Post Page
1.  To create a post page, tou can simply use this method
```swift
let postPageViewController = announceKit.postPageViewController(userId: nil, widgetId: <#widget id#>)
```
```postPageViewController(userId: nil, widgetId: <#widget id#>)``` will return a UIViewController, so you can use it as modal, push or even as subview.
<br/>Don't forget to set the delegate for receive the callback
