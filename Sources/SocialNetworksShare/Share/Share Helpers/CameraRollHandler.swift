//
//  AlbumHandler.swift
//  SRShareModule
//
//  Created by siamak rostami on 10/23/1400 AP.
//

import Foundation
import Photos
import UIKit

class CameraRollHandler{
    
    func saveVideoToCameraRoll(_ videoURL: URL, _ completion:@escaping ((String?,Error?) -> Void)) {
        var assetPlaceholder: PHObjectPlaceholder?
        
        requestAuthorization { error in
            guard error == nil else {
                completion(nil,error)
                return
            }
            
            PHPhotoLibrary.shared().performChanges {
                let assetRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
                assetPlaceholder = assetRequest?.placeholderForCreatedAsset
            } completionHandler: { success, error in
                guard error == nil, success else {
                    completion(nil,error)
                  return
                }
                completion(assetPlaceholder?.localIdentifier,nil)
            }
   
        }
    }
    
    func saveImageToCameraRoll(_ imageURL: URL, _ completion:@escaping ((String?,Error?) -> Void)){
        var assetPlaceholder: PHObjectPlaceholder?
        
        requestAuthorization { error in
            guard error == nil else {
                completion(nil,error)
                return
            }
            
            PHPhotoLibrary.shared().performChanges {
                let assetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: imageURL)
                assetPlaceholder = assetRequest?.placeholderForCreatedAsset
            } completionHandler: { success, error in
                guard error == nil, success else {
                    completion(nil,error)
                  return
                }
                completion(assetPlaceholder?.localIdentifier,nil)
            }
   
        }
        
    }
    
    
    func requestAuthorization(completion: @escaping (ShareError?)->Void) {
        guard PlistHelper.infoDictionary["NSPhotoLibraryUsageDescription"] != nil else {
            let error = ShareError.schemeNotfound
            completion(error)
            return
        }
        
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .authorized:
            completion(nil)
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                DispatchQueue.main.async {
                    if status != .authorized {
                        completion(ShareError.accessToLibraryFailed)
                    }
                }
            }
            
        default:
            let error = ShareError.accessToLibraryFailed
            completion(error)
            
        }
        
    }
    
    func assetWithLocalIdentifier(_ localIdentifier: String) -> PHAsset? {
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil)
        return fetchResult.firstObject
    }
    
}
