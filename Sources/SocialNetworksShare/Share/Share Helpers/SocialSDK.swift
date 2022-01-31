//
//  SnapchatSDK.swift
//  SRShareModule
//
//  Created by siamak rostami on 10/28/1400 AP.
//

import Foundation
import SCSDKCoreKit
import SCSDKCreativeKit
import TikTokOpenSDK

open class SocialSDK{
    
     static let snapApi = SCSDKSnapAPI()
     static var request = TikTokOpenSDKShareRequest()
     static let activityExcludedTypes = [UIActivity.ActivityType.addToReadingList
                                       ,UIActivity.ActivityType.assignToContact
                                       ,UIActivity.ActivityType.markupAsPDF
                                       ,UIActivity.ActivityType.openInIBooks
                                       ,UIActivity.ActivityType.print]
    
}
