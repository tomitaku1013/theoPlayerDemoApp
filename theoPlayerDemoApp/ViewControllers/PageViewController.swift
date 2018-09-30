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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
}


extension PageViewController {
    
    //MARK - signal from ParentVC that the segmentedControl Changed
    func didChangeSegmentedControlValue(segmentedValue: Int){
        var direction = UIPageViewController.NavigationDirection.forward
        if(segmentedValue < self.currentPageIndex){
            direction = UIPageViewController.NavigationDirection.reverse
        }
        setViewControllers([subViewControllers[segmentedValue]], direction: direction, animated: true, completion: nil)
    }
    
}
