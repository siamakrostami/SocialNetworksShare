//
//  ShareObject.swift
//  SRShareModule
//
//  Created by siamak rostami on 10/29/1400 AP.
//

import Foundation
import UIKit

public struct ShareObject{
    public var postUrlToShare : URL
    public var watermarkedVideoToShare : URL
    public var rootViewController : UIViewController
    
    public init (postUrlToShare : URL ,watermarkedVideoToShare : URL ,rootViewController : UIViewController){
        
        self.postUrlToShare = postUrlToShare
        self.watermarkedVideoToShare = watermarkedVideoToShare
        self.rootViewController = rootViewController
        
    }
}
