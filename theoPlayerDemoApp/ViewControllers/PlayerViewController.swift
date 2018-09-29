//
//  PlayerViewController.swift
//  theoPlayerDemoApp
//
//  Created by Med on 9/29/18.
//  Copyright © 2018 Med Abida. All rights reserved.
//

import UIKit
import THEOplayerSDK


class PlayerViewController: UIViewController{
    
    var videoItem: videoListItem!
    var videoPlayer: THEOplayer!
    
    // UI Elements
    @IBOutlet weak var videoPlayerContainer: UIView!
    @IBOutlet weak var videoPlayerHeightConstraint: NSLayoutConstraint! // used to update the player height when video height is ready
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup theoPlayer
        attachTheoPlayer(parentView: self.videoPlayerContainer)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // fix videoPlayer Size when view finished layout calculations
        videoPlayer.frame.size = videoPlayerContainer.frame.size
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}


extension PlayerViewController {
    
    func attachTheoPlayer(parentView: UIView){
        videoPlayer = THEOplayer()
        
        // add playerSource
        let src = TypedSource(src: videoItem.path, type: videoItem.mimeType)
        videoPlayer.source = SourceDescription(source: src)
        
        
        // attach event Listeners
        let _ = videoPlayer.addEventListener(type: PlayerEventTypes.PLAYING) { (eP) in
            self.PLAYING()
        }
        
        
        //Video Player Config
        videoPlayer.autoplay = true
        videoPlayer.fullscreenOrientationCoupling = true
        
        
        videoPlayer.addAsSubview(of: parentView)
    }
    
    
    
    //MARK - TheoPlayer Events
    func PLAYING(){
        
        // Update videoPlayer and its container to the optimized Height
        videoPlayer.requestOptimisedHeightForWidth(width: self.view.frame.width) { (newHeight) in
            self.videoPlayerHeightConstraint.constant = newHeight
            self.videoPlayer.frame.size.height = newHeight
        }
        
    }
    
    
}


extension THEOplayer {
    
    // Get video Width + Heigt
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
    fileprivate func requestOptimisedHeightForWidth(width:CGFloat, completionHandler: @escaping (CGFloat) -> Void){
        // get video Aspect ratio and calculate the new height..
        self.requestVideoAspectRatio { (aspectratio) in
            let newHeight = min(max((width / aspectratio),250), 300) // set height to be min 250 and max 300
            completionHandler(newHeight)
        }
    }
    
    
}
