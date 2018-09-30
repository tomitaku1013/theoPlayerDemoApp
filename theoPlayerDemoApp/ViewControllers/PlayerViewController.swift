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
    var videoPlayerFeatures: [playerFeaturesType] = []
    
    // UI Elements
    @IBOutlet weak var videoPlayerContainer: UIView!
    @IBOutlet weak var videoPlayerHeightConstraint: NSLayoutConstraint! // used to update the player height when video height is ready
    @IBOutlet weak var navBarOutlet: UINavigationBar!
    
    
    
    // var to be used in the swipedown effect
    var originalPosition: CGPoint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.flatColor.navyBlue.accent1
        self.navBarOutlet.topItem?.title = videoItem.title
        
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
    
    
    @IBAction func didPressClose(_ sender: Any) {
        self.closeView(animated:true)
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
        
        // init videoPlayer
        videoPlayer = theoPlayerWithConfigs(configs: [.SKIPPABLE_AD,.PIP])
        
        // attach event Listeners
        let _ = videoPlayer.addEventListener(type: PlayerEventTypes.PLAYING) { (eP) in
            self.PLAYING()
        }
        
        videoPlayer.addAsSubview(of: parentView)
    }
    
    // close current view and destroy theoPlayer instance
    func closeView(animated:Bool){
        self.videoPlayer.destroy()
        self.dismiss(animated: animated, completion: nil)
    }
    
    
    
    //MARK - TheoPlayer Events
    func PLAYING(){
        // Update videoPlayer and its container to the optimized Height
        videoPlayer.requestOptimisedHeightForWidth(width: self.view.frame.width) { (newHeight) in
            if newHeight.isFinite {
                self.videoPlayerHeightConstraint.constant = newHeight
                self.videoPlayer.frame.size.height = newHeight
            }
        }
    }
    
    
    
    //MARK - PLayer Features Activation
    func theoPlayerWithConfigs(configs:[playerFeaturesType])->THEOplayer{
        
        var adsDescription = [GoogleImaAdDescription]()
        var PIP = false
        var PRE_ROL_AD = false
        var SKIPPABLE_AD = false
        var posterSource: URL? = 
        // loop through the configs and active the required config
        for cfg in configs {
            switch cfg {
            case .PIP:
                // set picture-in-picture to be true
                PIP = true
                break
            case .PRE_ROL_AD:
                // activate pre-roll ad and set its IMA ad description
                PRE_ROL_AD = true
                adsDescription.append(GoogleImaAdDescription(src: GoogleImaAdDescription.googleSamples.PRE_ROL_AD))
                break
            case .SKIPPABLE_AD:
                // activate skippable ad and set its IMA ad description
                SKIPPABLE_AD = true
                adsDescription.append(GoogleImaAdDescription(src: GoogleImaAdDescription.googleSamples.SKIPPABLE_AD))
                break
            default:
                break
            }
        }
        
        // set the stream source and the parsed config
        let streamSource = TypedSource(src: videoItem.path, type: videoItem.mimeType)
        let sourceDescription =  SourceDescription(source: streamSource, ads: adsDescription)
        if let imgSrc = posterSource {
            sourceDescription.poster = imgSrc
            videoPlayer.autoplay = false // set autoplay to false to give the player time to load the poster
        }else{
            videoPlayer.autoplay = true
        }
        let config = THEOplayerConfiguration(googleIMA: (PRE_ROL_AD || SKIPPABLE_AD), pictureInPicture: PIP, ads: AdsConfiguration(showCountdown: true, preload: .MIDROLL_AND_POSTROLL))
        let player = THEOplayer(configuration: config)
        player.source = sourceDescription
        player.fullscreenOrientationCoupling = true
        return player
    }
}





extension GoogleImaAdDescription {
    struct googleSamples {
        static let PRE_ROL_AD = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpreonly&cmsid=496&vid=short_onecue&correlator="
        static let SKIPPABLE_AD = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dskippablelinear&correlator="
    }
}
