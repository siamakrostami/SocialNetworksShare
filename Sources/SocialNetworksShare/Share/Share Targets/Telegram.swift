//
//  Telegram.swift
//  SRShareModule
//
//  Created by siamak rostami on 10/29/1400 AP.
//

import Foundation

protocol TelegramProtocols{
    func shareLinkToTelegram(url : URL , completion: @escaping ShareErrorCompletion)
}

class Telegram : TelegramProtocols{

    private let telegramScheme = "tg"
    private let telegramShareScheme = "tg://msg_url?url="
    init(){}
    
    func shareLinkToTelegram(url: URL , completion: @escaping ShareErrorCompletion) {
        if PlistHelper.applicationQuerySchemeContains(scheme: telegramScheme){
            guard let urlEncodedURL = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
            let finalScheme = telegramShareScheme + urlEncodedURL
            Utility.OpenUrlScheme(scheme: finalScheme)
        }else{
            completion(ShareError.schemeNotfound)
        }
    }
    
    
    
}
