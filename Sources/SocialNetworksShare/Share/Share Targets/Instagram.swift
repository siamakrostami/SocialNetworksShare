//
//  Instagram.swift
//  SRShareModule
//
//  Created by siamak rostami on 10/23/1400 AP.
//

import Foundation
import UIKit

protocol InstagramProtocols{
    func shareVideoToInstagram(url : URL , type : ShareTargets , mediaType : ShareObjectType , completion:@escaping ShareErrorCompletion)
}

class Instagram : InstagramProtocols {
    
    private let backgroundVideo = "com.instagram.sharedSticker.backgroundVideo"
    private let backgroundImage = "com.instagram.sharedSticker.backgroundImage"
    private var contentURL = "com.instagram.sharedSticker.contentURL"
    private let instagramStoryScheme = "instagram-stories://share"
    private let instagramFeedScheme = "instagram://library?LocalIdentifier="
    private var pasteboardItems = [[String:Any]]()
    private var videoData : Data!
    private var imageData : Data?
    init(){}
    
    func shareVideoToInstagram(url: URL, type: ShareTargets, mediaType : ShareObjectType ,completion: @escaping ShareErrorCompletion) {
        switch mediaType{
        case .video:
            do{
                self.videoData = try Data(contentsOf: url)
            }catch{
                debugPrint(error)
            }
        default:
            self.imageData = try? Data(contentsOf: url)
        }

        switch type{
        case .instagramStory:
            if PlistHelper.applicationQuerySchemeContains(scheme: "instagram-stories"){
                self.shareVideoToStory(url: url, type: mediaType) { [weak self] error in
                    guard let _ = self else {return}
                    guard error != nil else {
                        completion(error)
                        return
                    }
                }
                completion(nil)
                return
            }
            completion(ShareError.schemeNotfound)
        case .instagramPost:
            if PlistHelper.applicationQuerySchemeContains(scheme: "instagram"){
                self.shareVideoToFeed(url: url, type: mediaType) { [weak self] error in
                    guard let _ = self else {return}
                    guard error != nil else {
                        completion(error)
                        return
                    }
                }
                completion(nil)
                return
            }
            completion(ShareError.schemeNotfound)
        default:
            completion(nil)
            break
        }
    }
    
    fileprivate func shareVideoToFeed(url : URL , type : ShareObjectType ,completion:@escaping ShareErrorCompletion){
        switch type{
        case .video:
            CameraRollHandler().saveVideoToCameraRoll(url) { identifier, error in
                guard error == nil else {
                    completion(ShareError.accessToLibraryFailed)
                    return
                }
                guard let identifier = identifier else {return}
                let basePath = self.instagramFeedScheme
                let completePath = basePath + identifier
                Utility.OpenUrlScheme(scheme: completePath)
            }
        default:
            CameraRollHandler().saveImageToCameraRoll(url) { identifier, error in
                guard error == nil else {
                    completion(ShareError.accessToLibraryFailed)
                    return
                }
                guard let identifier = identifier else {return}
                let basePath = self.instagramFeedScheme
                let completePath = basePath + identifier
                Utility.OpenUrlScheme(scheme: completePath)
            }
        }

    }
    
    fileprivate func shareVideoToStory(url : URL ,type : ShareObjectType,completion:@escaping ShareErrorCompletion){
        switch type{
        case .video:
            guard let videoData = videoData else {
                completion(ShareError.cantConvertData)
                return
            }
            self.pasteboardItems = [[backgroundVideo:videoData]]
            let pasteboardOption = [UIPasteboard.OptionsKey.expirationDate : Date(timeInterval: 60, since: Date())]
            UIPasteboard.general.setItems(self.pasteboardItems, options: pasteboardOption)
            Utility.OpenUrlScheme(scheme: self.instagramStoryScheme)
        default:
            guard let imageData = imageData else {
                completion(ShareError.cantConvertData)
                return
            }
            self.pasteboardItems = [[backgroundImage:imageData]]
            let pasteboardOption = [UIPasteboard.OptionsKey.expirationDate : Date(timeInterval: 60, since: Date())]
            UIPasteboard.general.setItems(self.pasteboardItems, options: pasteboardOption)
            Utility.OpenUrlScheme(scheme: self.instagramStoryScheme)
        }

    }
    
    
}

