//
//  ShareHandler.swift
//  SRShareModule
//
//  Created by siamak rostami on 10/23/1400 AP.
//

import Foundation
import UIKit

public typealias ShareErrorCompletion = ((ShareError?) -> Void)

public protocol ShareHandlerProtocols{
    func shareVideo(to target : ShareTargets , completion:@escaping ShareErrorCompletion)
}

public protocol ShareSubActionProtocols : AnyObject{
    func reportVideo()
    func editCaption()
    func deleteVideo()
    func bookmarkVideo()
    func copyLink()
    func saveToCamera()
}

open class ShareHandler{
    
    private var shareObject : ShareObject?
    
    open var appSectionDataSource = Utility.appListSection
    open var ownerSubSectionDataSource = Utility.ownerSubActionsSection
    open var normalSubSectionDataSource = Utility.normalSubActionsSection
    
    open weak var subActionsDelegate : ShareSubActionProtocols?
    
    
    public init(ShareObject : ShareObject){
        self.shareObject = ShareObject
    }
}

extension ShareHandler : ShareHandlerProtocols{
    
    public func shareVideo(to target: ShareTargets, completion: @escaping ShareErrorCompletion) {
        guard let share = shareObject else {return}
        switch target{
        case .instagramPost , .instagramStory:
            Instagram().shareVideoToInstagram(url: share.watermarkedVideoToShare, type: target) { [weak self] error in
                guard let _ = self else {return}
                guard error == nil else {
                    completion(error)
                    return
                }
                completion(nil)
            }
        case .whatsapp:
            Whatsapp().sendPostToWhatsapp(url: share.postUrlToShare) { [weak self] error in
                guard let _ = self else {return}
                guard error == nil else {
                    completion(error)
                    return
                }
                completion(nil)
            }
        case .imessage:
            iMessage().sendVideoToiMessage(url: share.watermarkedVideoToShare, viewController: share.rootViewController) { [weak self] error in
                guard let _ = self else {return}
                guard error == nil else {
                    completion(error)
                    return
                }
                completion(nil)
            }
        case .facebook:
            Facebook().shareVideoToFacebook(url: share.watermarkedVideoToShare, controller: share.rootViewController, type: target) { [weak self] error in
                guard let _ = self else {return}
                guard error == nil else {
                    completion(error)
                    return
                }
                completion(nil)
            }
            
        case .twitterPost:
            Twitter().sendPostToTwitter(url: share.postUrlToShare) { [weak self] error in
                guard let _ = self else {return}
                guard error == nil else {
                    completion(error)
                    return
                }
                completion(nil)
            }
        case .tiktok:
#if !targetEnvironment(simulator)
            TikTok().sendVideoToTikTok(url: share.watermarkedVideoToShare) { [weak self] error in
                guard let _ = self else {return}
                guard error == nil else {
                    completion(error)
                    return
                }
                completion(nil)
            }
#else
            completion(ShareError.appNotFound)
#endif
        case .snapchat:
            Snapchat().shareVideoToSnapchat(url: share.watermarkedVideoToShare, view: share.rootViewController.view) { [weak self] error in
                guard let _ = self else {return}
                guard error == nil else {
                    completion(error)
                    return
                }
                completion(nil)
            }
        case .telegram:
            Telegram().shareLinkToTelegram(url: share.postUrlToShare) { [weak self] error in
                guard let _ = self else {return}
                guard error == nil else {
                    completion(error)
                    return
                }
                completion(nil)
            }
        case .cameraRoll:
            self.saveVideoToCameraRoll { [weak self] error in
                guard let _ = self else {return}
                guard error == nil else {
                    completion(error)
                    return
                }
                completion(nil)
            }
            //TODO: - Create Logic
        case .copyLink:
            self.copyLink { [weak self] error in
                guard let _ = self else {return}
                guard error == nil else {
                    completion(error)
                    return
                }
                completion(nil)
            }
            break
        case .sendMail:
            Mail().sendMail(url: share.postUrlToShare, viewController: share.rootViewController) { [weak self] error in
                guard let _ = self else {return}
                guard error == nil else {
                    completion(error)
                    return
                }
                completion(nil)
            }
            break
        case .report:
            self.subActionsDelegate?.reportVideo()
            break
        case .bookmarkVideo:
            self.subActionsDelegate?.bookmarkVideo()
            break
        case .editCaption:
            self.subActionsDelegate?.editCaption()
            break
        case .deleteVideo:
            self.subActionsDelegate?.deleteVideo()
            break
        case .facebookMessenger:
            Facebook().shareVideoToFacebook(url: share.postUrlToShare, controller: share.rootViewController, type: .facebookMessenger) { [weak self] error in
                guard let _ = self else {return}
                guard error == nil else {
                    completion(error)
                    return
                }
                completion(nil)
            }
            break
        case .activityController:
            self.showMoreOptions()
            completion(nil)
            
        }
    }
    
    
}

extension ShareHandler{
    
    fileprivate func copyLink(completion: @escaping ShareErrorCompletion){
        guard let shareObject = self.shareObject else {
            completion(ShareError.cantConvertData)
            return
        }
        UIPasteboard.general.url = shareObject.postUrlToShare
        self.subActionsDelegate?.copyLink()
        completion(nil)
    }
    
    fileprivate func saveVideoToCameraRoll(completion: @escaping ShareErrorCompletion){
        guard let shareObject = self.shareObject else {
            completion(ShareError.cantConvertData)
            return
        }
        CameraRollHandler().saveVideoToCameraRoll(shareObject.watermarkedVideoToShare) { [weak self] identifier, error in
            guard let _ = self else {return}
            guard error == nil else {
                completion(ShareError.accessToLibraryFailed)
                return
            }
            self?.subActionsDelegate?.saveToCamera()
            completion(nil)
        }
    }
    
    fileprivate func showMoreOptions(){
        self.showActivityController()
    }
    
    fileprivate func showActivityController(){
        guard let shareObject = self.shareObject else {return}
        DispatchQueue.main.async {
            let activityController = UIActivityViewController(activityItems: [shareObject.postUrlToShare], applicationActivities: nil)
            activityController.excludedActivityTypes = SocialSDK.activityExcludedTypes
            shareObject.rootViewController.present(activityController, animated: true, completion: nil)
        }
    }
}
