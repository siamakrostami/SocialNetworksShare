//
//  ShareTargets.swift
//  SRShareModule
//
//  Created by siamak rostami on 10/23/1400 AP.
//

import Foundation

public enum ShareTargets : CaseIterable{
    case
    instagramPost,
    instagramStory,
    tiktok,
    imessage,
    whatsapp,
    twitterPost,
    facebook,
    facebookMessenger,
    snapchat,
    telegram,
    sendMail,
    copyLink,
    activityController,
    report,
    bookmarkVideo,
    cameraRoll,
    editCaption,
    deleteVideo
    

}

extension ShareTargets{
    
    public var appSchemes : URL?{
        switch self{
        case .instagramPost:
            return URL(string: "instagram://")
        case .instagramStory:
            return URL(string: "instagram://")
        case .tiktok:
            return URL(string: "tiktok://")
        case .snapchat:
            return URL(string: "snapchat://")
        case .facebook:
            return URL(string: "fb://")
        case .facebookMessenger:
            return URL(string: "fb-messenger://")
        case .twitterPost:
            return URL(string: "twitter://")
        case .telegram:
            return URL(string: "tg://")
        case .whatsapp:
            return URL(string: "whatsapp://")
        default:
            return nil
        }
    }
    
    public var shareAppName : String{
        switch self{
        case .instagramPost:
            return "Instagram"
        case .instagramStory:
            return "Story"
        case .tiktok:
            return "TikTok"
        case .snapchat:
            return "Snapchat"
        case .facebook:
            return "Facebook"
        case .whatsapp:
            return "Whatsapp"
        case .facebookMessenger:
            return "Messenger"
        case .sendMail:
            return "Mail"
        case .copyLink:
            return "Copy Link"
        case .report:
            return "Report"
        case .bookmarkVideo:
            return "Bookmark"
        case .editCaption:
            return "Edit Caption"
        case .deleteVideo:
            return "Delete"
        case .imessage:
            return "SMS"
        case .twitterPost:
            return "Twitter"
        case .telegram:
            return "Telegram"
        case .cameraRoll:
            return "Save Video"
        case .activityController:
            return "More"
        }
    }
    
    public var shareAppIcon : String{
        switch self{
        case .instagramPost:
            return "InstagramIcon"
        case .instagramStory:
            return "InstagramStoryIcon"
        case .tiktok:
            return "TikTokIcon"
        case .facebookMessenger:
            return "MessengerIcon"
        case .sendMail:
            return "EmailIcon"
        case .copyLink:
            return "CopyLinkIcon"
        case .report:
            return "ReportIcon"
        case .bookmarkVideo:
            return "BookmarkIcon"
        case .editCaption:
            return "EditCaptionIcon"
        case .deleteVideo:
            return "DeleteVideoIcon"
        case .snapchat:
            return "SnapchatIcon"
        case .facebook:
            return "FacebookIcon"
        case .whatsapp:
            return "WhatsappIcon"
        case .imessage:
            return "MessagesIcon"
        case .twitterPost:
            return "TwitterIcon"
        case .telegram:
            return "TelegramIcon"
        case .cameraRoll:
            return "SaveToLibraryIcon"
        case .activityController:
            return "ShowMoreIcon"
        }
    }
}
