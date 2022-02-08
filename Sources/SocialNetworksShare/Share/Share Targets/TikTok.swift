//
//  TikTok.swift
//  SRShareModule
//
//  Created by siamak rostami on 10/23/1400 AP.
//

import Foundation
import UIKit
#if canImport(TikTokOpenSDK)
import TikTokOpenSDK
#endif

#if !targetEnvironment(simulator)
protocol TikTokProtocols{
    func sendVideoToTikTok(url : URL , type : ShareObjectType , completion:@escaping ShareErrorCompletion)
}

class TikTok : TikTokProtocols{
    init(){}
}

extension TikTok{

    func sendVideoToTikTok(url: URL , type : ShareObjectType ,completion:@escaping ShareErrorCompletion) {
        SocialSDK.request = TikTokOpenSDKShareRequest()
        switch type{
        case .video:
            SocialSDK.request.mediaType = .video
        default:
            SocialSDK.request.mediaType = .video
        }
        
        CameraRollHandler().saveVideoToCameraRoll(url) {  identifier, error in
            guard let identifier = identifier else {return}
            SocialSDK.request.localIdentifiers = [identifier]
                SocialSDK.request.send(completionBlock: { response in
                    DispatchQueue.main.async {
                        if response.isSucceed{
                            completion(nil)
                            return
                        }
                        completion(ShareError.cantOpenUrl)
                        debugPrint(response)
                    }
                })
        }
    }
}

#endif

