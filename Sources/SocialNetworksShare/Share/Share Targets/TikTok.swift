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
    func sendVideoToTikTok(url : URL , completion:@escaping ShareErrorCompletion)
}

class TikTok : TikTokProtocols{
    init(){}
}

extension TikTok{
    func sendVideoToTikTok(url: URL , completion:@escaping ShareErrorCompletion) {
        debugPrint("tiktok selected")
        SocialSDK.request = TikTokOpenSDKShareRequest()
        SocialSDK.request.mediaType = .video
        CameraRollHandler().saveVideoToCameraRoll(url) { [weak self] identifier, error in
            guard let identifier = identifier else {return}
            SocialSDK.request.localIdentifiers = [identifier]
            debugPrint("tiktok locale identifier = \(identifier)")
            DispatchQueue.main.async {
                SocialSDK.request.send(completionBlock: { response in
                    debugPrint(response.shareState.rawValue)
                    debugPrint(response.state)
                    debugPrint(response.errCode)
                    debugPrint(response.errString)
                    debugPrint(response.isSucceed)
                    if response.isSucceed{
                        completion(nil)
                        return
                    }
                    completion(ShareError.cantOpenUrl)
                    debugPrint(response)
                })
            }
        }
    }
}

#endif

