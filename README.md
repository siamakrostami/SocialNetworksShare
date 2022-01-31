
# SRShare
Custom Share Library


## Installation

Install SRShare with SPM

    
## Info.Plist
Don't forget to add this url schemes to your Info.Plist:

```swift
	<key>NSPhotoLibraryUsageDescription</key>
	<string>You can select media to attach to reports.</string>
	<key>NSPhotoLibraryAddUsageDescription</key>
	<string>Please allow access to save media in your photo library</string>
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>$FacebookAppID</string>
			</array>
		</dict>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>$TikTokAppID</string>
			</array>
		</dict>
	</array>
	<key>FacebookAppID</key>
	<string>$FacebookAppID</string>
	<key>LSApplicationQueriesSchemes</key>
	<array>
		<string>fb-messenger-share-api</string>
		<string>twitterauth</string>
		<string>instagram-stories</string>
		<string>instagram</string>
		<string>facebook-stories</string>
		<string>instagram</string>
		<string>snapchat</string>
		<string>tg</string>
		<string>whatsapp</string>
		<string>twitter</string>
		<string>snssdk1233</string>
		<string>snssdk1180</string>
		<string>tiktoksharesdk</string>
		<string>tiktokopensdk</string>
		<string>fb</string>
		<string>fbauth2</string>
		<string>fbshareextension</string>
	</array>
	<key>SCSDKClientId</key>
	<string>$SnapchatClientId</string>
	<key>TikTokAppID</key>
	<string>$TikTokAppID</string>
```
## AppDelegate Methods
Add this methods to your AppDelegate:

```swift
import TikTokOpenSDK
...

 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       TikTokOpenSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
       return true
}

func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        guard let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
              let annotation = options[UIApplication.OpenURLOptionsKey.annotation] else {
            return false
        }
        
        let tiktok = TikTokOpenSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        return tiktok
}

 func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if TikTokOpenSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation) {
            return true
        }
        return false
}

func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        if TikTokOpenSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: nil, annotation: "") {
            return true
        }
        return false
}

```
## Frameworks

Add this frameworks to your project:

```swift

Webkit.frameworks
Security.framework

```
## Usage/Examples

```swift
import SRShare
import MessageUI
import FacebookShare

class YourViewController : UIViewController{
    
    var share : ShareHandler!
    
    func initShareModule(){
        
        guard let video = Bundle.main.url(forResource: "test", withExtension: "mp4") else {return}
        guard let link = URL(string: "https://google.com") else {return}
        let shareObject = ShareObject(postUrlToShare: link, watermarkedVideoToShare: video, rootViewController: self)
        share = ShareHandler(ShareObject: shareObject)
        share.subActionsDelegate = self
        
    }
    
    @IBAction func sharePost(_ sender: Any) {
        
        //Share video to your target
        share.shareVideo(to: .instagramPost) { error in
            // Show Alert For Error
        }
        
    }
    
}
//Custom Actions Delegate
extension YourViewController : ShareSubActionProtocols {
    
    func reportVideo() {
        
    }
    
    func editCaption() {
        
    }
    
    func deleteVideo() {
        
    }
    
    func bookmarkVideo() {
        
    }
    func copyLink() {

    }
    func saveToCamera() {

    }
}
//Share Delegates for iMessage,Mail, and Facebook
extension YourViewController : MFMailComposeViewControllerDelegate , MFMessageComposeViewControllerDelegate, SharingDelegate{
    
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        debugPrint(#function)
    }
    
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        debugPrint(#function)
    }
    
    func sharerDidCancel(_ sharer: Sharing) {
        debugPrint(#function)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

```


