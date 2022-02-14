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
    func shareURLToFacebook(shareObject : ShareObject ,type : ShareTargets , completion:@escaping ShareErrorCompletion)
}


class Facebook : FacebookProtocols{
    
    var linkContent = ShareLinkContent()
    var shareDialog : ShareDialog!
    var messageDialoge : MessageDialog!
    init(){}
    
    func shareURLToFacebook(shareObject : ShareObject ,type : ShareTargets , completion:@escaping ShareErrorCompletion) {
        
        switch type{
        case .facebook:
            linkContent = ShareLinkContent()
            linkContent.contentURL = shareObject.postUrlToShare
            linkContent.quote = shareObject.postTitle
            shareDialog = ShareDialog(viewController: shareObject.rootViewController, content: linkContent, delegate: shareObject.rootViewController as? SharingDelegate)
            shareDialog.mode = .shareSheet
            if shareDialog.canShow{
                shareDialog.show()
            }else{
                completion(ShareError.cantOpenUrl)
            }
        case .facebookMessenger:
            
            linkContent = ShareLinkContent()
            linkContent.contentURL = shareObject.postUrlToShare
            linkContent.quote = shareObject.postTitle
            messageDialoge = MessageDialog(content: linkContent, delegate: shareObject.rootViewController as? SharingDelegate)
            if messageDialoge.canShow{
                messageDialoge.show()
            }else{
                completion(ShareError.cantOpenUrl)
            }
        default:
            completion(ShareError.appNotFound)
        }
        
        
        
    }
    
    
}




