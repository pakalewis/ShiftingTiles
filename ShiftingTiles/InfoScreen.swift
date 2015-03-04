//
//  InfoScreen.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 1/13/15.
//  Copyright (c) 2015 Parker Lewis. All rights reserved.
//

import UIKit

class InfoScreen: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    let colorPalette = ColorPalette()

    var pageViewController : UIPageViewController!
    var firstVC : UIViewController!
    var viewControllers = [UIViewController]()
    
    var currentVCIndex = 0
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Apply color scheme
        self.view.backgroundColor = self.colorPalette.fetchLightColor()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureDismiss = UITapGestureRecognizer(target: self, action: "dismissInfoScreen:")
        self.view.addGestureRecognizer(tapGestureDismiss)

        
        // Setup pageViewController
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        
        // Set the initial ViewController
        self.firstVC = RulesScreen1(nibName: "RulesScreen1", bundle: NSBundle.mainBundle())
        let viewControllers: NSArray = [self.firstVC]
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
        self.viewControllers.append(self.firstVC)
        
        // Set up the rest of the VCs
        self.setupVCArray()
        
        // Add PageViewController to the InfoScreen VC
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)

        
        // Appearance of the page control dots
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = self.colorPalette.fetchDarkColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.clearColor()

    }
    
    
    func setupVCArray() {
        let page2 = RulesScreen1a(nibName: "RulesScreen1a", bundle: NSBundle.mainBundle())
        let page3 = RulesScreen2(nibName: "RulesScreen2", bundle: NSBundle.mainBundle())
        let page4 = RulesScreen3(nibName: "RulesScreen3", bundle: NSBundle.mainBundle())
        let page5 = Acknowledgements(nibName: "Acknowledgements", bundle: NSBundle.mainBundle())
    
        self.viewControllers.append(page2)
        self.viewControllers.append(page3)
        self.viewControllers.append(page4)
        self.viewControllers.append(page5)
    }
    
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKindOfClass(RulesScreen1a) {
            return self.viewControllers[0]
        }
        if viewController.isKindOfClass(RulesScreen2) {
            return self.viewControllers[1]
        }
        if viewController.isKindOfClass(RulesScreen3) {
            return self.viewControllers[2]
        }
        if viewController.isKindOfClass(Acknowledgements) {
            return self.viewControllers[3]
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        

        if viewController.isKindOfClass(RulesScreen1) {
            return self.viewControllers[1]
        }
        if viewController.isKindOfClass(RulesScreen1a) {
            return self.viewControllers[2]
        }
        if viewController.isKindOfClass(RulesScreen2) {
            return self.viewControllers[3]
        }
        if viewController.isKindOfClass(RulesScreen3) {
            return self.viewControllers[4]
        }
        return nil
    }
    
    
    
    
    // MARK: - Page Indicator
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 5
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

    
    func dismissInfoScreen(sender: UIGestureRecognizer) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
