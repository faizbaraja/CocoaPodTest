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
let announceKit = AnnounceKit(widgetId: <#widget id#>)
```
make sure to replace the ```widget id``` with your ```widget id```

### Unread Count
1.  To get the unread count of the posts, use this method
```swift
announceKit.getUnreadCount(delegate: self)
```
Don't forget to set the delegate for receive the callback

2.  To get the unread count of the posts, use this method
```swift
extension <#Your ViewController Name#> : AnnounceKitProtocol {
    func updateUnreadCount(unreadCount: Int) {
        //
    }
}
```
```func updateUnreadCount(unreadCount: Int)``` is a callback method when succeded getting the unread count and it returns with a number of unread post count

### Widget Page
1.  To create a post page, tou can simply use this method
```swift
let postPageViewController = announceKit.createWidget()
```
```createWidget()``` will return a UIViewController, so you can use it as modal, push or even as subview.

### Widget Language
1.  To change the widget language, tou can simply use this method
```swift
announceKit.setLanguage(lang: <#language#>)
```
make sure to replace the ```language``` with your preferred language code. You can check your supported language in announcekit [dashboard language seeting](https://announcekit.app/dashboard/settings/languages)


## More
You can also check out our [documentation](https://announcekit.app/docs) for more detailed information about our SDK.
