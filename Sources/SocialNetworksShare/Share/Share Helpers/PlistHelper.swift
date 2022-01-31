//
//  PlistHelper.swift
//  SRShareModule
//
//  Created by siamak rostami on 10/23/1400 AP.
//

import Foundation

public struct PlistHelper{
    
    static var infoDictionary: [String : Any] {
        Bundle.main.infoDictionary ?? [:]
    }
    
    static var applicationQueriesSchemes: [String] {
        infoDictionary["LSApplicationQueriesSchemes"] as? [String] ?? []
    }
    
    static var facebookAppId: String? {
        infoDictionary["FacebookAppID"] as? String
    }
    static var tiktokAppId: String?{
        infoDictionary["TikTokAppID"] as? String
    }
    static var snapchatAppId: String?{
        infoDictionary["SCSDKClientId"] as? String
    }
    
    static func applicationQuerySchemeContains(scheme : String) -> Bool{
        if PlistHelper.applicationQueriesSchemes.contains(scheme){
            return true
        }
        return false
    }

}
