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
    init(){}
    
    func shareURLToFacebook(shareObject : ShareObject ,type : ShareTargets , completion:@escaping ShareErrorCompletion) {
        
        switch type{
        case .facebook:
            linkContent = ShareLinkContent()
            linkContent.contentURL = shareObject.postUrlToShare
            shareDialog = ShareDialog(viewController: shareObject.rootViewController, content: linkContent, delegate: shareObject.rootViewController as? SharingDelegate)
            if shareDialog.canShow{
                shareDialog.show()
                completion(nil)
            }else{
                completion(ShareError.cantOpenUrl)
            }
        case .facebookMessenger:

            linkContent = ShareLinkContent()
            linkContent.contentURL = shareObject.postUrlToShare
            let dialog = MessageDialog(content: linkContent, delegate: shareObject.rootViewController as? SharingDelegate)
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




