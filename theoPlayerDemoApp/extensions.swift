//
//  extensions.swift
//  theoPlayerDemoApp
//
//  Created by Med on 9/27/18.
//  Copyright © 2018 Med Abida. All rights reserved.
//

import Foundation
import UIKit
import THEOplayerSDK


//MARK - UIColor
extension UIColor {
    struct flatColor {
        struct navyBlue {
            static let accent1 =  UIColor(red: 52/255, green: 73/255, blue: 94/255, alpha: 1)
            static let accent2 =  UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1)
        }
        struct yellow {
            static let accent1 =  UIColor(red: 255/255, green: 205/255, blue: 1/255, alpha: 1)
            static let accent2 =  UIColor(red: 255/255, green: 168/255, blue: 0/255, alpha: 1)
        }
    }
}





//MARK - THEOplayer
extension THEOplayer {
    
    // Get video Width + Height
    fileprivate func requestVideoSize(completionHandler: @escaping (_ width:CGFloat,_ height:CGFloat) -> Void){
        self.requestVideoHeight { (height, err_h) in
            if height != nil && height != 0 {
                // request width
                self.requestVideoWidth(completionHandler: { (width, err_w) in
                    if width != nil && width != 0 {
                        completionHandler(CGFloat(width!),CGFloat(height!))
                    }else{
                        completionHandler(0,0)
                    }
                })
            }else{
                completionHandler(0,0)
            }
        }
    }
    
    // Get Video Aspect Ratio
    fileprivate func requestVideoAspectRatio(completionHandler: @escaping (CGFloat) -> Void){
        self.requestVideoSize { (width, height) in
            completionHandler(width/height)
        }
    }
    
    // Get Optimized Height For the video
    func requestOptimisedHeightForWidth(width:CGFloat, completionHandler: @escaping (CGFloat) -> Void){
        // get video Aspect ratio and calculate the new height..
        self.requestVideoAspectRatio { (aspectratio) in
            let newHeight = min(max((width / aspectratio),250), 300) // set height to be min 250 and max 300
            completionHandler(newHeight)
        }
    }
    
    
}
