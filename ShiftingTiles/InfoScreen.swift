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
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Apply color scheme
        self.view.backgroundColor = self.colorPalette.fetchLightColor()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureDismiss = UITapGestureRecognizer(target: self, action: #selector(InfoScreen.dismissInfoScreen(_:)))
        self.view.addGestureRecognizer(tapGestureDismiss)

        
        // Setup pageViewController
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        
        // Set the initial ViewController
        self.firstVC = RulesScreen1(nibName: "RulesScreen1", bundle: Bundle.main)
        let viewControllers: [UIViewController] = [self.firstVC]
        pageViewController.setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
        self.viewControllers.append(self.firstVC)
        
        // Set up the rest of the VCs
        self.setupVCArray()
        
        // Add PageViewController to the InfoScreen VC
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)

        
        // Appearance of the page control dots
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = self.colorPalette.fetchDarkColor()
        appearance.currentPageIndicatorTintColor = UIColor.white
        appearance.backgroundColor = UIColor.clear

    }
    
    
    func setupVCArray() {
        let page2 = RulesScreen1a(nibName: "RulesScreen1a", bundle: Bundle.main)
        let page3 = RulesScreen2(nibName: "RulesScreen2", bundle: Bundle.main)
        let page4 = RulesScreen3(nibName: "RulesScreen3", bundle: Bundle.main)
        let page5 = Acknowledgements(nibName: "Acknowledgements", bundle: Bundle.main)
    
        self.viewControllers.append(page2)
        self.viewControllers.append(page3)
        self.viewControllers.append(page4)
        self.viewControllers.append(page5)
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: RulesScreen1a.self) {
            return self.viewControllers[0]
        }
        if viewController.isKind(of: RulesScreen2.self) {
            return self.viewControllers[1]
        }
        if viewController.isKind(of: RulesScreen3.self) {
            return self.viewControllers[2]
        }
        if viewController.isKind(of: Acknowledgements.self) {
            return self.viewControllers[3]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        

        if viewController.isKind(of: RulesScreen1.self) {
            return self.viewControllers[1]
        }
        if viewController.isKind(of: RulesScreen1a.self) {
            return self.viewControllers[2]
        }
        if viewController.isKind(of: RulesScreen2.self) {
            return self.viewControllers[3]
        }
        if viewController.isKind(of: RulesScreen3.self) {
            return self.viewControllers[4]
        }
        return nil
    }
    
    
    
    
    // MARK: - Page Indicator
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 5
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }

    
    func dismissInfoScreen(_ sender: UIGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
