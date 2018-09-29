//
//  ViewController.swift
//  theoPlayerDemoApp
//
//  Created by Med on 9/27/18.
//  Copyright © 2018 Med Abida. All rights reserved.
//

import UIKit
class PageViewController: RotationLockedPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    // declaring viewController that will be used in the pageViewController
    lazy var subViewControllers: [UIViewController] = {
        return [
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "videosListVC") as! VideosListViewController,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "featuresListVC") as! FeaturesListViewController
        ]
    }()
    
    //define and keep track of active ViewController (VC) index
    var currentPageIndex: Int {
        get {
            return subViewControllers.lastIndex(of: (self.viewControllers?.first)!) ?? 0
        }
    }
    
    // UI elements
    var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup segmented control When view did load
        preparSegmentedControl()

        // assigning delegate and datasource to the viewController
        self.delegate = self
        self.dataSource = self
        setViewControllers([subViewControllers[0]], direction: .forward, animated: true, completion: nil)
        
        
    }
    
    
    required init?(coder: NSCoder) {
        // change the pageView transition Style
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    
    
    //MARK - UIPageViewControllerDataSource
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let VcIndex: Int = subViewControllers.lastIndex(of: viewController) ?? 0
        if VcIndex <= 0 {
            return nil
        }
        return subViewControllers[VcIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let VcIndex: Int = subViewControllers.lastIndex(of: viewController) ?? 0
        if VcIndex >= subViewControllers.count - 1 {
            return nil
        }
        return subViewControllers[VcIndex + 1]
    }
    
    
    
    //MARK - UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        let VcIndex: Int = subViewControllers.lastIndex(of: pendingViewControllers[0]) ?? 0
        segmentedControl.selectedSegmentIndex = VcIndex
    }
    
}


extension PageViewController {
    
    func preparSegmentedControl(){
        segmentedControl = UISegmentedControl(items: ["Videos", "Features"])
        segmentedControl.frame.size = CGSize(width: self.view.frame.width, height: segmentedControl.frame.size.height)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = UIColor.flatColor.yellow.accent1
        segmentedControl.addTarget(self, action: #selector(self.didChangeSegmentedControlValue(sender:)), for: .valueChanged)
        self.navigationItem.titleView = segmentedControl
    }
    
    @objc func didChangeSegmentedControlValue(sender: UISegmentedControl){
        // detecting the transition direction (forward/reverse) and then set active VC for PageViewController
        let segmentedValue = sender.selectedSegmentIndex
        var direction = UIPageViewController.NavigationDirection.forward
        if(segmentedValue < self.currentPageIndex){
            direction = UIPageViewController.NavigationDirection.reverse
        }
        setViewControllers([subViewControllers[segmentedValue]], direction: direction, animated: true, completion: nil)
    }
    
    
}
