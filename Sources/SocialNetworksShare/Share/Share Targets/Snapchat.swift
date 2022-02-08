//
//  Snapchat.swift
//  SRShareModule
//
//  Created by siamak rostami on 10/23/1400 AP.
//

import Foundation
import UIKit
import SCSDKCoreKit
import SCSDKCreativeKit

protocol SnapchatProtocols{
    func shareVideoToSnapchat(url : URL,type : ShareObjectType ,view : UIView?,completion:@escaping ShareErrorCompletion)
}


class Snapchat : SnapchatProtocols{
    private let snapchatScheme = "snapchat"
    init(){
    }
    
    func shareVideoToSnapchat(url: URL,type : ShareObjectType,view : UIView?,completion: @escaping ShareErrorCompletion) {
        if PlistHelper.applicationQuerySchemeContains(scheme: snapchatScheme){
            switch type{
            case .video:
                let video = SCSDKSnapVideo(videoUrl: url)
                let videoContent = SCSDKVideoSnapContent(snapVideo: video)
                SocialSDK.snapApi.startSending(videoContent) { error in
                    DispatchQueue.main.async {
                        if error == nil{
                            completion(nil)
                            return
                        }
                        completion(ShareError.cantOpenUrl)
                    }
                }
            default:
                let image = SCSDKSnapPhoto(imageUrl: url)
                let imageContent = SCSDKPhotoSnapContent(snapPhoto: image)
                SocialSDK.snapApi.startSending(imageContent) { error in
                    DispatchQueue.main.async {
                        if error == nil{
                            completion(nil)
                            return
                        }
                        completion(ShareError.cantOpenUrl)
                    }
                }
                
            }

        }else{
            completion(ShareError.schemeNotfound)
        }
    }
}

