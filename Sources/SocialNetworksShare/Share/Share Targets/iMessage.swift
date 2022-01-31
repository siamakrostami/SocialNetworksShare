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
    func sendVideoToiMessage(url : URL , viewController : UIViewController? , completion:@escaping ShareErrorCompletion)
}

class iMessage : NSObject{
    private var controller : MFMessageComposeViewController?
    private var videoData : Data?
}

extension iMessage : iMessageProtocols{
    
    func sendVideoToiMessage(url: URL, viewController: UIViewController?, completion: @escaping ShareErrorCompletion) {
        self.controller = MFMessageComposeViewController()
        do{
            self.videoData = try Data(contentsOf: url)
        }catch{
            completion(ShareError.cantConvertData)
        }
        let videoExtension = url.pathExtension
        guard let videoData = videoData else {return}
        self.controller?.addAttachmentData(videoData, typeIdentifier: videoExtension, filename: "video.\(videoExtension)")
        self.controller?.messageComposeDelegate = viewController as? MFMessageComposeViewControllerDelegate
        if self.controller != nil{
            viewController?.present(self.controller!, animated: true, completion: nil)
        }
    }
    
    
}


