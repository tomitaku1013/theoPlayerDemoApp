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
    var duration: Int!
    init(title:String, path:String, duration:String){
        self.title = title
        self.path = path
        self.duration = Int(duration) ?? 0
    }
}
