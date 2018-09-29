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
    var duration: Int!
    init(title:String, path:String, duration:String){
        self.title = title
        self.path = path
        self.duration = Int(duration) ?? 0
        self.mimeType = mimeTypeFromPath(path: self.path)
        
        
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
