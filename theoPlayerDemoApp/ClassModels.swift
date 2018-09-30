//
//  ClassModels.swift
//  theoPlayerDemoApp
//
//  Created by Med on 9/27/18.
//  Copyright © 2018 Med Abida. All rights reserved.
//

import Foundation


// Class Model for Video Item in tableview 
class videoListItem {
    var title: String!
    var path: String!
    var mimeType: String!
    var posterURL: URL?
    init(title:String, path:String, posterURL: String = String()){
        self.title = title
        self.path = path
        self.mimeType = mimeTypeFromPath(path: self.path)
        if let url = URL(string: posterURL){
            self.posterURL = url
        }
    }
    // detect mime type from path extension
    // mimes are extracted from : https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/StreamingMediaGuide/DeployingHTTPLiveStreaming/DeployingHTTPLiveStreaming.html
    fileprivate func mimeTypeFromPath(path: String)->String{
        if let path = URL(string: path){
            switch path.pathExtension.uppercased() {
            case "TS":
                return "video/MP2T"
            default:
                return "application/x-mpegURL"
            }
        }
        return "application/x-mpegURL"
    }
}


class featureListItem {
    var videoItem: videoListItem!
    var config = [playerFeaturesType]()
    init(videoListItem: videoListItem, configs: [String]) {
        self.videoItem = videoListItem
        for cfg in configs {
            self.config.append(playerFeaturesType.init(fromRawValue: cfg))
        }
    }
}



enum playerFeaturesType: String {
    case PIP = "PIP"
    case POSTER_IMAGE = "POSTER_IMAGE"
    case PRE_ROL_AD = "PRE_ROL_AD"
    case SKIPPABLE_AD = "SKIPPABLE_AD"
    case NONE = "NONE" // default value
    init(fromRawValue: String){
        self = playerFeaturesType(rawValue: fromRawValue) ?? .NONE
    }
}
