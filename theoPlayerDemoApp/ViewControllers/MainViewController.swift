//
//  MainViewController.swift
//  theoPlayerDemoApp
//
//  Created by Med on 9/30/18.
//  Copyright © 2018 Med Abida. All rights reserved.
//

import UIKit

class MainViewController: RotationLockedViewController {

    // UI elements
    var segmentedControl: UISegmentedControl!
    @IBOutlet weak var segmentedControlContainer: UIView!
    
    //refrence to the container view controller (PageViewController)
    var containerViewController: PageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup segmented control When view did load
        preparSegmentedControl()
        
        // setup logo in navigationBar
        prepareTheoPlayerLogo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    //MARK - Setup TheoPlayer Logo
    func prepareTheoPlayerLogo(){
        let imageView = UIImageView(image: UIImage(named: "theoplayer_logo"))
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
    }

    //MARK - Setup segmentedControl
    func preparSegmentedControl(){
        segmentedControl = UISegmentedControl(items: ["Videos", "Features"])
        segmentedControl.frame.size = CGSize(width: self.view.frame.width, height: segmentedControl.frame.size.height)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = UIColor.flatColor.yellow.accent1
        segmentedControl.frame.size = CGSize(width: self.view.frame.width + 10, height: self.view.frame.height * 0.05) // added + 10 to the width as a workarround to hide borders
        segmentedControl.center = segmentedControlContainer.center
        segmentedControl.addTarget(self, action: #selector(self.didChangeSegmentedControlValue(sender:)), for: .valueChanged)
        self.segmentedControlContainer.addSubview(segmentedControl)
    }
    
    
    @objc func didChangeSegmentedControlValue(sender: UISegmentedControl){
        // inform pageviewcontroller in Container about the change
        containerViewController!.didChangeSegmentedControlValue(segmentedValue: sender.selectedSegmentIndex)
    }
    
    //get refrence of the pageViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PageViewContainerSegue"{
            containerViewController = segue.destination as? PageViewController
        }
    }
    
}
