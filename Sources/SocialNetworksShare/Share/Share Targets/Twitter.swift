//
//  Twitter.swift
//  SRShareModule
//
//  Created by siamak rostami on 10/23/1400 AP.
//

import Foundation
import UIKit

protocol TwitterProtocols{
    func sendPostToTwitter(url : URL ,completion:@escaping ShareErrorCompletion)
}

class Twitter : TwitterProtocols {
    
    private let twitterScheme = "twitter"
    private let twitterPostScheme = "twitter://post?message="
    init(){}
    
    func sendPostToTwitter(url: URL,completion: @escaping ShareErrorCompletion) {
        if PlistHelper.applicationQuerySchemeContains(scheme: self.twitterScheme){
            guard let urlEncodedURL = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
            let finalScheme = twitterPostScheme + urlEncodedURL
            Utility.OpenUrlScheme(scheme: finalScheme)
        }else{
            completion(ShareError.schemeNotfound)
        }
    }
    
    
}


