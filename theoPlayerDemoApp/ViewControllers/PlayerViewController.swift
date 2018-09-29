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
    
    
    // var to be used in the swipedown effect
    var originalPosition: CGPoint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup theoPlayer
        attachTheoPlayer(parentView: self.videoPlayerContainer)
        
        // attach a PanGesture to detect when user is swiping on the view
        let panGest = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        self.view.addGestureRecognizer(panGest)
    }
    
    
    //handle panGesture to accomplish "swipe down to close" effect (like youtube App)
    @objc func didPan(_ panGesture: UIPanGestureRecognizer){
        let translation = panGesture.translation(in: view)
        
        // detect if user is swiping up and do nothing
        if translation.y < 0 {
            return
        }
        
        // user is swiping down so animate the view origin
        if panGesture.state == .changed{
            view.frame.origin.y = translation.y // change view Y origin to match the ammount of panGesture translation
        }else if panGesture.state == .ended {
            // detect the velocity of the gesture to automatically close the view
            let velocity = panGesture.velocity(in: view)
            if velocity.y >= 1500 {
                self.animateViewDownAndClose()
            } else {
                if translation.y > view.frame.height * 0.5 {
                    // transitionY is more than half the screen so close it
                    self.animateViewDownAndClose()
                }else{
                    // animate back to the initial origin of the view
                    UIView.animate(withDuration: 0.2, animations: {
                        self.view.frame.origin.y = 0
                    })
                }
            }
            
        }
    }
    
    // animate the transition of the view to the bottom and the close it
    func animateViewDownAndClose(){
        UIView.animate(withDuration: 0.2 , animations: {
            self.view.frame.origin.y = self.view.frame.size.height
        }, completion: { (isCompleted) in
            if isCompleted {
                self.closeView(animated:false)
            }
        })
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
        let _ = videoPlayer.addEventListener(type: PlayerEventTypes.LOADED_DATA) { (eP) in
            self.LOADED_DATA()
        }
        
        
        //Video Player Config
        videoPlayer.autoplay = true
        videoPlayer.fullscreenOrientationCoupling = true
        
        
        videoPlayer.addAsSubview(of: parentView)
    }
    
    // close current view and destroy theoPlayer instance
    func closeView(animated:Bool){
        self.videoPlayer.destroy()
        self.dismiss(animated: animated, completion: nil)
    }
    
    
    
    //MARK - TheoPlayer Events
    func LOADED_DATA(){
        // Update videoPlayer and its container to the optimized Height
        videoPlayer.requestOptimisedHeightForWidth(width: self.view.frame.width) { (newHeight) in
            self.videoPlayerHeightConstraint.constant = newHeight
            self.videoPlayer.frame.size.height = newHeight
        }
    }
    
    
    
    
}


