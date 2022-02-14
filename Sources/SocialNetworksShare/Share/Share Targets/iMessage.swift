//
//  iMessage.swift
//  SRShareModule
//
//  Created by siamak rostami on 10/27/1400 AP.
//

import Foundation
import MessageUI
import UIKit

protocol iMessageProtocols{
    func sendURLToiMessage(shareObject : ShareObject , completion:@escaping ShareErrorCompletion)
}

class iMessage : NSObject{
    private var controller : MFMessageComposeViewController?
}

extension iMessage : iMessageProtocols{
    
    func sendURLToiMessage(shareObject : ShareObject , completion: @escaping ShareErrorCompletion) {
        self.controller = MFMessageComposeViewController()
        let shareText = "\(shareObject.postTitle) \(shareObject.postUrlToShare)"
        self.controller?.body = shareText
        self.controller?.messageComposeDelegate = shareObject.rootViewController as? MFMessageComposeViewControllerDelegate
        if self.controller != nil{
            shareObject.rootViewController?.present(self.controller!, animated: true, completion: nil)
        }
    }
    
    
}


