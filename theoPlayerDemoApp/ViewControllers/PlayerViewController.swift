//
//  PlayerViewController.swift
//  theoPlayerDemoApp
//
//  Created by Med on 9/29/18.
//  Copyright © 2018 Med Abida. All rights reserved.
//

import UIKit
import THEOplayerSDK


class PlayerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var videoItem: videoListItem!
    var videoPlayer: THEOplayer!
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    //MARK - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tCell")! as UITableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.5))
        view.backgroundColor = .black
        attachTheoPlayer(parentView: view)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.view.frame.height * 0.5
    }
    
    
    
    //MARK - UITableViewDelegate
    
    
}


extension PlayerViewController {
    
    func attachTheoPlayer(parentView: UIView){
        videoPlayer = THEOplayer()
        videoPlayer.frame = parentView.frame
        
        // add playerSource
        let src = TypedSource(src: videoItem.path, type: "application/x-mpegurl")
        videoPlayer.source = SourceDescription(source: src)
        videoPlayer.fullscreenOrientationCoupling = true
        //other configs
        //videoPlayer.autoplay = true
        
        videoPlayer.addAsSubview(of: parentView)
    }
    
    
}
