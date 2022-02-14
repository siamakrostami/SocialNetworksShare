//
//  ShareObject.swift
//  SRShareModule
//
//  Created by siamak rostami on 10/29/1400 AP.
//

import Foundation
import UIKit
import Combine

public enum ShareObjectType {
    case
    video , image
}

public struct ShareObject{
    public var postUrlToShare : URL
    public var postTitle : String
    public var mediaURL : URL?
    public var watermarkURL : URL?
    public var type : ShareObjectType?
    var hasWatermark = CurrentValueSubject<Bool,Never>(false)
    var cancellableSet : Set<AnyCancellable> = []
    public var rootViewController : UIViewController?
    
    public init (postUrlToShare : URL ,postTitle : String,type : ShareObjectType ,media : URL? ,watermark : URL?,rootViewController : UIViewController?){
        self.postUrlToShare = postUrlToShare
        self.postTitle = postTitle
        self.mediaURL = media
        self.watermarkURL = watermark
        self.type = type
        self.rootViewController = rootViewController
        self.checkWatermark()
    }

}

extension ShareObject{
   public func checkWatermark(){
       guard self.type != nil else {return}
       switch type{
       case .video:
           guard self.watermarkURL != nil else {
               self.hasWatermark.send(false)
               return
           }
           self.hasWatermark.send(true)
       default:
           guard self.mediaURL != nil else {
               self.hasWatermark.send(false)
               return
           }
           self.hasWatermark.send(true)
       }

    }
}
