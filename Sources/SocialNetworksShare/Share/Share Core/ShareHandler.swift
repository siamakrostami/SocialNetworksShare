//
//  ShareHandler.swift
//  SRShareModule
//
//  Created by siamak rostami on 10/23/1400 AP.
//

import Foundation
import UIKit
import Combine
import Watermark

public typealias ShareErrorCompletion = ((ShareError?) -> Void)

public protocol ShareHandlerProtocols{
    func shareMedia(to target : ShareTargets ,imageDownloadProgress : @escaping DownloadProgressCompletion, videoDownloadProgress:@escaping DownloadProgressCompletion , watermarkProgress:@escaping WatermakrProgressCompletion , exportCompletion:@escaping ExportSessionCompletion , cachedWatermark:@escaping WatermarkExistCompletion , downloadError : @escaping DownloadErrorCompletion ,shareErrorCompletion: @escaping ShareErrorCompletion , watermarkImageCompletion : @escaping WatermarkExistCompletion)
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
    
    open var appSectionDataSource = CurrentValueSubject<[ShareTargets]?,Never>(nil)
    open var ownerSubSectionDataSource = CurrentValueSubject<[ShareTargets]?,Never>(nil)
    open var normalSubSectionDataSource = CurrentValueSubject<[ShareTargets]?,Never>(nil)
    open var cancellableSet : Set<AnyCancellable> = []
    open weak var subActionsDelegate : ShareSubActionProtocols?
    
    
    public init(ShareObject : ShareObject){
        self.shareObject = ShareObject
        self.bindWatermarkURL()
    }
}

extension ShareHandler : ShareHandlerProtocols{
    
    public func shareMedia(to target: ShareTargets,imageDownloadProgress : @escaping DownloadProgressCompletion, videoDownloadProgress:@escaping DownloadProgressCompletion , watermarkProgress:@escaping WatermakrProgressCompletion , exportCompletion:@escaping ExportSessionCompletion , cachedWatermark:@escaping WatermarkExistCompletion , downloadError : @escaping DownloadErrorCompletion ,shareErrorCompletion: @escaping ShareErrorCompletion , watermarkImageCompletion : @escaping WatermarkExistCompletion) {
        guard let share = shareObject else {return}
        switch target{
        case .cameraRoll:
            Utility.watermarkProcess(shareObject: share, shareTarget: target) { image in
                imageDownloadProgress(image)
            } videoDownloadProgress: { video in
                videoDownloadProgress(video)
            } watermarkProgress: { watermark in
                watermarkProgress(watermark)
            } exportCompletion: { export in
                exportCompletion(export)
                if export?.status == .completed{
                    guard let url = export?.outputURL else {return}
                    self.saveToCamera(url: url, completion: shareErrorCompletion)
                }
            } cachedWatermark: { cached in
                cachedWatermark(cached)
                guard let cached = cached else {return}
                self.saveToCamera(url: cached, completion: shareErrorCompletion)
            } downloadError: { downloaderror in
                downloadError(downloaderror)
            } shareErrorCompletion: { shareerror in
                shareErrorCompletion(shareerror)
            } watermarkImageCompletion: { url  in
                watermarkImageCompletion(url)
                guard let url = url else {return}
                self.saveToCamera(url: url, completion: shareErrorCompletion)
                
            }
        case .instagramPost , .instagramStory , .snapchat:
            Utility.watermarkProcess(shareObject: share, shareTarget: target, imageDownloadProgress: imageDownloadProgress, videoDownloadProgress: videoDownloadProgress, watermarkProgress: watermarkProgress, exportCompletion: exportCompletion, cachedWatermark: cachedWatermark, downloadError: downloadError, shareErrorCompletion: shareErrorCompletion, watermarkImageCompletion: watermarkImageCompletion)
        case .whatsapp:
            Whatsapp().sendPostToWhatsapp(url: share.postUrlToShare) { [weak self] error in
                guard let _ = self else {return}
                guard error == nil else {
                    shareErrorCompletion(error)
                    return
                }
                shareErrorCompletion(nil)
            }
        case .imessage:
            iMessage().sendURLToiMessage(shareObject: share) { [weak self] error in
                guard let _ = self else {return}
                guard error == nil else {
                    shareErrorCompletion(error)
                    return
                }
                shareErrorCompletion(nil)
            }
        case .facebook , .facebookMessenger:
            Facebook().shareURLToFacebook(shareObject: share, type: target) {  [weak self] error in
                guard let _ = self else {return}
                guard error == nil else {
                    shareErrorCompletion(error)
                    return
                }
                shareErrorCompletion(nil)
            }
            
        case .twitterPost:
            Twitter().sendPostToTwitter(url: share.postUrlToShare) { [weak self] error in
                guard let _ = self else {return}
                guard error == nil else {
                    shareErrorCompletion(error)
                    return
                }
                shareErrorCompletion(nil)
            }
        case .tiktok:
#if !targetEnvironment(simulator)
            Utility.watermarkProcess(shareObject: share, shareTarget: target, imageDownloadProgress: imageDownloadProgress, videoDownloadProgress: videoDownloadProgress, watermarkProgress: watermarkProgress, exportCompletion: exportCompletion, cachedWatermark: cachedWatermark, downloadError: downloadError, shareErrorCompletion: shareErrorCompletion, watermarkImageCompletion: watermarkImageCompletion)
#else
            shareErrorCompletion(ShareError.appNotFound)
#endif
        case .telegram:
            Telegram().shareLinkToTelegram(url: share.postUrlToShare) { [weak self] error in
                guard let _ = self else {return}
                guard error == nil else {
                    shareErrorCompletion(error)
                    return
                }
                shareErrorCompletion(nil)
            }
            //TODO: - Create Logic
        case .copyLink:
            self.copyLink { [weak self] error in
                guard let _ = self else {return}
                guard error == nil else {
                    shareErrorCompletion(error)
                    return
                }
                shareErrorCompletion(nil)
            }
            break
        case .sendMail:
            Mail().sendMail(url: share.postUrlToShare, viewController: share.rootViewController) { [weak self] error in
                guard let _ = self else {return}
                guard error == nil else {
                    shareErrorCompletion(error)
                    return
                }
                shareErrorCompletion(nil)
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
        case .activityController:
            self.showMoreOptions()
            shareErrorCompletion(nil)
            
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
    
    fileprivate func saveToCamera(url : URL,completion:@escaping ShareErrorCompletion){
        guard let type = self.shareObject?.type else {return}
        switch type{
        case .video:
            CameraRollHandler().saveVideoToCameraRoll(url) { identifier, error in
                if error != nil{
                    completion(ShareError.accessToLibraryFailed)
                }else{
                    completion(nil)
                    self.subActionsDelegate?.saveToCamera()
                }
            }
        default:
            CameraRollHandler().saveImageToCameraRoll(url) { identifier, error in
                if error != nil{
                    completion(ShareError.accessToLibraryFailed)
                }else{
                    completion(nil)
                    self.subActionsDelegate?.saveToCamera()
                }
            }
        }

    }
    
    fileprivate func showMoreOptions(){
        self.showActivityController()
    }
    
    fileprivate func showActivityController(){
        guard let shareObject = self.shareObject else {return}
        DispatchQueue.main.async {
            let activityController = UIActivityViewController(activityItems: [shareObject.postTitle,shareObject.postUrlToShare], applicationActivities: nil)
            activityController.excludedActivityTypes = SocialSDK.activityExcludedTypes
            shareObject.rootViewController.present(activityController, animated: true, completion: nil)
        }
    }
}

extension ShareHandler{
    
    func bindWatermarkURL(){
        guard var shareObject = shareObject else {return}
        shareObject.hasWatermark
            .subscribe(on: RunLoop.main)
            .sink(receiveValue: { [weak self] hasWatermark in
                guard let `self` = self else {return}
                self.appSectionDataSource.send(self.setAppSectionDataSources())
                self.normalSubSectionDataSource.send(self.setNormalSubActions())
                self.ownerSubSectionDataSource.send(self.setOwnerSubActions())
            })
            .store(in: &shareObject.cancellableSet)
    }
    
    func setAppSectionDataSources() -> [ShareTargets]{
        var appList : [ShareTargets] = [.instagramPost,.instagramStory,.tiktok,.imessage,.whatsapp,.twitterPost,.facebook,.facebookMessenger,.snapchat,.telegram,.sendMail,.copyLink,.activityController]
        
        appList.forEach { target in
            if target.appSchemes != nil{
                if !Utility.isAppInstalledOnDevice(app: target.appSchemes){
                    let index = appList.firstIndex(of: target)
                    if index != nil{
                        appList.remove(at: index!)
                    }
                }
            }
        }
        if shareObject?.watermarkURL == nil{
            appList.forEach { target in
                switch target{
                case .instagramPost,.instagramStory,.tiktok,.snapchat:
                    let index = appList.firstIndex(of: target)
                    if index != nil{
                        appList.remove(at: index!)
                    }
                default:
                    break
                }
            }
        }
        return appList
    }
    
    func setNormalSubActions() -> [ShareTargets]{
        var list : [ShareTargets] = [.report,.bookmarkVideo,.cameraRoll]
        if shareObject?.watermarkURL == nil{
            list.forEach { target in
                switch target{
                case .cameraRoll:
                    let index = list.firstIndex(of: target)
                    if index != nil{
                        list.remove(at: index!)
                    }
                default:
                    break
                }
            }
        }
        return list
    }
    
    func setOwnerSubActions() -> [ShareTargets]{
        var list : [ShareTargets] = [.report,.bookmarkVideo,.cameraRoll,.editCaption,.deleteVideo]
        if shareObject?.watermarkURL == nil{
            list.forEach { target in
                switch target{
                case .cameraRoll,.deleteVideo:
                    let index = list.firstIndex(of: target)
                    if index != nil{
                        list.remove(at: index!)
                    }
                default:
                    break
                }
            }
        }
        return list
    }
}
