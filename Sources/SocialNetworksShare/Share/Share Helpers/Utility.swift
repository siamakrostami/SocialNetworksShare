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
    static let watermarkObject = WatermarkHelper()
    static func watermarkProcess(shareObject : ShareObject,shareTarget : ShareTargets,imageDownloadProgress : @escaping DownloadProgressCompletion, videoDownloadProgress:@escaping DownloadProgressCompletion , watermarkProgress:@escaping WatermakrProgressCompletion , exportCompletion:@escaping ExportSessionCompletion , cachedWatermark:@escaping WatermarkExistCompletion , downloadError : @escaping DownloadErrorCompletion , shareErrorCompletion:@escaping ShareErrorCompletion , watermarkImageCompletion : @escaping WatermarkExistCompletion){
        guard let watermark = shareObject.watermarkURL else {return}
        switch shareObject.type{
        case .video:
            guard let mediaURL = shareObject.mediaURL else {return}
            watermarkObject.createWatermarkForVideoFrom(videoUrl: mediaURL, imageUrl: watermark) { downloadImage in
                imageDownloadProgress(downloadImage)
            } videoDownloadProgress: { downloadVideo in
                videoDownloadProgress(downloadVideo)
            } watermarkProgress: { exportProgress in
                watermarkProgress(exportProgress)
            } exportCompletion: { exportSession in
                exportCompletion(exportSession)
                guard let export = exportSession else {return}
                guard let videoOutput = export.outputURL else {return}
                switch export.status{
                case .completed:
                    Utility.createInstancesPerTarget(target: shareTarget, shareObject: shareObject, watermarkMediaUrl: videoOutput) { shareError in
                        shareErrorCompletion(shareError)
                    }
                default:
                    break
                }
            } cachedWatermark: { cached in
                cachedWatermark(cached)
                guard let cached = cached else {return}
                Utility.createInstancesPerTarget(target: shareTarget, shareObject: shareObject, watermarkMediaUrl: cached) { shareError in
                    shareErrorCompletion(shareError)
                }
                
            } downloadError: { downloadingError in
                downloadError(downloadingError)
            }
        default:
            guard let mediaURL = shareObject.mediaURL else {return}
            watermarkObject.addWatermarkToImage(mainImage: mediaURL) { imageDownload in
                imageDownloadProgress(imageDownload)
            } downloadError: { error in
                downloadError(error)
            } cachedWatermark: { cached in
                watermarkImageCompletion(cached)
                guard let url = cached else {return}
                Utility.createInstancesPerTarget(target: shareTarget, shareObject: shareObject, watermarkMediaUrl: url) { shareError in
                    shareErrorCompletion(shareError)
            }
        }
        }

        
    }
    
    static func createInstancesPerTarget(target : ShareTargets,shareObject : ShareObject , watermarkMediaUrl : URL , shareErrorCompletion:@escaping ShareErrorCompletion){
        guard let type = shareObject.type else {return}
        switch target{
        case .instagramPost,.instagramStory:
            Instagram().shareVideoToInstagram(url: watermarkMediaUrl, type: target, mediaType: type) { error in
                guard error == nil else {
                    shareErrorCompletion(error)
                    return
                }
                shareErrorCompletion(nil)
            }
        case .tiktok:
#if !targetEnvironment(simulator)
            TikTok().sendVideoToTikTok(url: watermarkMediaUrl, type: type) {  error in
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
            Snapchat().shareVideoToSnapchat(url: watermarkMediaUrl, type: type, view: shareObject.rootViewController.view) {  error in
                guard error == nil else {
                    shareErrorCompletion(error)
                    return
                }
                shareErrorCompletion(nil)
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

