//
//  ShareObject.swift
//  SRShareModule
//
//  Created by siamak rostami on 10/29/1400 AP.
//

import Foundation
import UIKit
import Combine

public struct ShareObject{
    public var postUrlToShare : URL
    public var postTitle : String
    public var videoURL : URL
    public var watermarkURL : URL?
    var hasWatermark = CurrentValueSubject<Bool,Never>(false)
    var cancellableSet : Set<AnyCancellable> = []
    public var rootViewController : UIViewController
    
    public init (postUrlToShare : URL ,postTitle : String,video : URL ,watermark : URL,rootViewController : UIViewController){
        self.postUrlToShare = postUrlToShare
        self.postTitle = postTitle
        self.videoURL = video
        self.watermarkURL = watermark
        self.rootViewController = rootViewController
        self.checkWatermark()
    }
}

extension ShareObject{
   public func checkWatermark(){
        guard self.watermarkURL != nil else {
            self.hasWatermark.send(false)
            return
        }
        self.hasWatermark.send(true)
    }
}
