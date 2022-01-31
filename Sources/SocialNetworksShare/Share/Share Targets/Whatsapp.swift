//
//  Whatsapp.swift
//  SRShareModule
//
//  Created by siamak rostami on 10/23/1400 AP.
//

import Foundation
import UIKit

protocol WhatsappProtocols{
    func sendPostToWhatsapp(url : URL , completion:@escaping ShareErrorCompletion)
}

class Whatsapp {
    
    private let whatsappScheme = "whatsapp"
    private let whatsappSendScheme = "whatsapp://send?text="
    init() {
    }
    
    
}

extension Whatsapp : WhatsappProtocols{
    
    func sendPostToWhatsapp(url: URL, completion: @escaping ShareErrorCompletion) {
        
        if PlistHelper.applicationQuerySchemeContains(scheme: whatsappScheme){
            guard let urlEncodedURL = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
            let finalScheme = whatsappSendScheme + urlEncodedURL
            Utility.OpenUrlScheme(scheme: finalScheme)
        }else{
            completion(ShareError.schemeNotfound)
        }
        
    }
    
    
}


