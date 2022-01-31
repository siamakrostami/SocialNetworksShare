//
//  File.swift
//  
//
//  Created by siamak rostami on 11/8/1400 AP.
//

import Foundation
import MessageUI
import UIKit

protocol MailProtocols{
    func sendMail(url : URL , viewController : UIViewController? , completion:@escaping ShareErrorCompletion)
}

class Mail : NSObject{
    private var controller : MFMailComposeViewController?
    
}

extension Mail : MailProtocols{
    func sendMail(url: URL, viewController: UIViewController?, completion: @escaping ShareErrorCompletion) {
        guard let viewController = viewController else {
            completion(ShareError.schemeNotfound)
            return
        }

        if MFMailComposeViewController.canSendMail(){
            self.controller = MFMailComposeViewController()
            self.controller?.mailComposeDelegate = viewController as? MFMailComposeViewControllerDelegate
            self.controller?.setMessageBody(url.absoluteString, isHTML: false)
            if self.controller != nil{
                viewController.present(self.controller!, animated: true, completion: nil)
            }
            
            completion(nil)
        }else{
            completion(ShareError.appNotFound)
        }
    }
    
    
}
