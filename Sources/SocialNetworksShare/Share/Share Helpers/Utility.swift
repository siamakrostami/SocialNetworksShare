//
//  Utility.swift
//  SRShareModule
//
//  Created by siamak rostami on 10/24/1400 AP.
//

import Foundation
import UIKit
import Watermark

class Utility{
    
    static func watermarkProcess(shareObject : ShareObject,shareTarget : ShareTargets,imageDownloadProgress : @escaping DownloadProgressCompletion, videoDownloadProgress:@escaping DownloadProgressCompletion , watermarkProgress:@escaping WatermakrProgressCompletion , exportCompletion:@escaping ExportSessionCompletion , cachedWatermark:@escaping WatermarkExistCompletion , downloadError : @escaping DownloadErrorCompletion , shareErrorCompletion:@escaping ShareErrorCompletion){
        guard let watermark = shareObject.watermarkURL else {return}
        WatermarkHelper().createWatermarkForVideoFrom(videoUrl: shareObject.videoURL, imageUrl: watermark) { downloadImage in
            imageDownloadProgress(downloadImage)
        } videoDownloadProgress: { downloadVideo in
            videoDownloadProgress(downloadVideo)
        } watermarkProgress: { exportProgress in
            watermarkProgress(exportProgress)
        } exportCompletion: { exportSession in
            exportCompletion(exportSession)
        } cachedWatermark: { cached in
            cachedWatermark(cached)
            guard let cached = cached else {return}
            Utility.createInstancesPerTarget(target: shareTarget, shareObject: shareObject, watermarkVideoUrl: cached) { shareError in
                shareErrorCompletion(shareError)
            }
            
        } downloadError: { downloadingError in
            downloadError(downloadingError)
        }
        
    }
    
    static func createInstancesPerTarget(target : ShareTargets,shareObject : ShareObject , watermarkVideoUrl : URL , shareErrorCompletion:@escaping ShareErrorCompletion){
        
        switch target{
        case .instagramPost,.instagramStory:
            Instagram().shareVideoToInstagram(url: watermarkVideoUrl, type: target) { error in
                guard error == nil else {
                    shareErrorCompletion(error)
                    return
                }
                shareErrorCompletion(nil)
            }
        case .tiktok:
#if !targetEnvironment(simulator)
            TikTok().sendVideoToTikTok(url: watermarkVideoUrl) {  error in
                guard error == nil else {
                    shareErrorCompletion(error)
                    return
                }
                shareErrorCompletion(nil)
            }
#else
            shareErrorCompletion(ShareError.appNotFound)
#endif
        case .snapchat:
            Snapchat().shareVideoToSnapchat(url: watermarkVideoUrl, view: shareObject.rootViewController.view) {  error in
                guard error == nil else {
                    shareErrorCompletion(error)
                    return
                }
                shareErrorCompletion(nil)
            }
        case .cameraRoll:
            CameraRollHandler().saveVideoToCameraRoll(watermarkVideoUrl) { identifier, error in
                if error != nil{
                    shareErrorCompletion(ShareError.accessToLibraryFailed)
                }else{
                    shareErrorCompletion(nil)
                }
            }
        default:
            break
        }
        
        
    }
    
    static func createVideoOutputPath(from url : URL , data : Data) -> URL{
        let videoData = data
        let fileMgr = FileManager.default
        let dirPaths = fileMgr.urls(for: .documentDirectory, in: .userDomainMask)
        let filePath = dirPaths[0].appendingPathComponent("\(url.lastPathComponent)")
        do{
            try videoData.write(to: filePath, options: .atomic)
        }catch{
            debugPrint("error")
        }
        return filePath
    }
    
    
    static func OpenUrlScheme(scheme : String){
        guard let url = URL(string: scheme) else {return}
        DispatchQueue.main.async {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    static func isAppInstalledOnDevice(app : URL?) -> Bool{
        guard let url = app else {
            return false
        }
        if UIApplication.shared.canOpenURL(url){
            return true
        }
        return false
    }
    
    static var isSimulator: Bool {
#if targetEnvironment(simulator)
        // We're on the simulator
        return true
#else
        // We're on a device
        return false
#endif
    }
    
}

