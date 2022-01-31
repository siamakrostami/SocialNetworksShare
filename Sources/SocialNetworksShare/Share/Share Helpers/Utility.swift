//
//  Utility.swift
//  SRShareModule
//
//  Created by siamak rostami on 10/24/1400 AP.
//

import Foundation
import UIKit

class Utility{
    
    static var appListSection : [ShareTargets]{
        return [.instagramPost,.instagramStory,.tiktok,.imessage,.whatsapp,.twitterPost,.facebook,.facebookMessenger,.snapchat,.telegram,.sendMail,.copyLink,.activityController]
    }
    static var ownerSubActionsSection : [ShareTargets]{
        return [.report,.bookmarkVideo,.cameraRoll,.editCaption,.deleteVideo]
    }
    static var normalSubActionsSection : [ShareTargets]{
        return [.report,.bookmarkVideo,.cameraRoll]
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
