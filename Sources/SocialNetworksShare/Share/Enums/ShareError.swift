//
//  ShareError.swift
//  SRShareModule
//
//  Created by siamak rostami on 10/23/1400 AP.
//

import Foundation

public enum ShareError : Error , LocalizedError{
    case
    appNotFound,
    accessToLibraryFailed,
    schemeNotfound,
    cantConvertData,
    cantOpenUrl
    
    public var errorDescription: String?{
        switch self{
        case .appNotFound:
            return "Application not found on your device"
        case .accessToLibraryFailed:
            return "Please access to photo library"
        case .cantConvertData:
            return "Can't convert video file to Data"
        case .schemeNotfound:
            return "Scheme not found in your bundle"
        case .cantOpenUrl:
            return "Can't open the target application"
            
        }
    }
}
