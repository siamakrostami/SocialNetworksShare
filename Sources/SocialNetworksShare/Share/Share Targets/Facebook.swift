//
//  Facebook.swift
//  SRShareModule
//
//  Created by siamak rostami on 10/23/1400 AP.
//

import Foundation
import UIKit
import FacebookShare
import FacebookCore

protocol FacebookProtocols{
    func shareVideoToFacebook(url : URL , controller : UIViewController? ,type : ShareTargets , completion:@escaping ShareErrorCompletion)
}


class Facebook : FacebookProtocols{
    
    private var videoData : Data!
    init(){}
    
    func shareVideoToFacebook(url: URL, controller : UIViewController? ,type: ShareTargets, completion: @escaping ShareErrorCompletion) {
        
        switch type{
        case .facebook:
            do{
                self.videoData = try Data(contentsOf: url)
            }catch{
                debugPrint(error)
            }
            let videoObject = ShareVideo(data: self.videoData)
            let videoContent = ShareVideoContent()
            videoContent.video = videoObject
            let shareDialog = ShareDialog.init(viewController: controller, content: videoContent, delegate: controller as? SharingDelegate)
            do{
                try shareDialog.validate()
            }catch{
                completion(ShareError.cantOpenUrl)
            }
            if shareDialog.canShow{
                shareDialog.show()
                completion(nil)
            }else{
                completion(ShareError.cantOpenUrl)
            }
        case .facebookMessenger:
            
            let content = ShareLinkContent()
            content.contentURL = url
            let dialog = MessageDialog(content: content, delegate: controller as? SharingDelegate)
            do{
                try dialog.validate()
            }catch{
                completion(ShareError.cantOpenUrl)
            }
            if dialog.canShow{
                dialog.show()
                completion(nil)
            }else{
                completion(ShareError.cantOpenUrl)
            }
        default:
            completion(ShareError.appNotFound)
        }
        
        
        
    }
    
    
}




