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

    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Apply color scheme
        self.view.backgroundColor = self.colorPalette.fetchLightColor()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureDismiss = UITapGestureRecognizer(target: self, action: "dismissInfoScreen:")
        self.view.addGestureRecognizer(tapGestureDismiss)

        
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        let startingViewController = UIViewController(nibName: "RulesScreen", bundle: NSBundle.mainBundle())
        startingViewController.view.backgroundColor = UIColor.clearColor()
        let viewControllers: NSArray = [startingViewController]

        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
//        self.pageViewController!.view.frame = self.view.frame
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)

        
        
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = self.colorPalette.fetchDarkColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.clearColor()

    }
    
    
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        return UIViewController()
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        
//        let rulesScreen = viewController as RulesScreen
//        
//        if rulesScreen.index < 4 {
//            return rulesScreen
//        } 
//        

        let nextViewController = UIViewController(nibName: "RulesScreen", bundle: NSBundle.mainBundle())

        return nextViewController
        
        
    }
    
    
    
    
    // MARK: - Page Indicator
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 4
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

    
    //        self.infoText.text = "The objective of the game is to form the original image by shifting the tiles around until they are in the proper order. Tap one tile and then another to swap their positions. The black arrows on the top and left of the tiles allow entire rows and columns to swap postions.\n\nThe HINT button shows the first incorrect tile and the correct tile which it should be swapped with.\n\nThe SOLVE button will auto-solve the puzzle by swapping tiles until complete.\n\nUse the Show Original button to remind yourself what the original image looks like.\n\nImages were culled from unsplash.com and from Dale Arveson: phalconphotography.smugmug.com\n\nFeedback, questions, comments are welcome: pakalewis@gmail.com\n\nThe source code can be viewed here: github.com/pakalewis/shiftingtiles\n\ntest\n\ntest\n\ntest\n\ntest\n\ntest\n\ntest\n\ntest\n\ntest\n\ntest"
    //
    
    
    func dismissInfoScreen(sender: UIGestureRecognizer) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
