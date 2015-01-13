//
//  InfoScreen.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 1/13/15.
//  Copyright (c) 2015 Parker Lewis. All rights reserved.
//

import UIKit

class InfoScreen: UIViewController {

    let userDefaults = NSUserDefaults.standardUserDefaults()

    var light1: Int = 0xE8CF76
    var dark1: Int = 0x383F70
    var light2: Int = 0x84A174
    var dark2: Int = 0x1A3C3D

    
    
    @IBOutlet weak var shuffleImage: UIImageView!
    @IBOutlet weak var rotationImage: UIImageView!
    
    @IBOutlet weak var shuffle: UIView!
    @IBOutlet weak var rotations: UIView!

    
    @IBOutlet weak var colorPalette1: UIView!
    @IBOutlet weak var lightColor1: UIView!
    @IBOutlet weak var darkColor1: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        // Add tap gesturess
        var shuffleTap = UITapGestureRecognizer(target: self, action: "shuffleTapped:")
        self.shuffle.addGestureRecognizer(shuffleTap)
        
        var rotationTap = UITapGestureRecognizer(target: self, action: "rotationTapped:")
        self.rotations.addGestureRecognizer(rotationTap)
        
        var colorPalette1Tap = UITapGestureRecognizer(target: self, action: "colorPalette1Selected:")
        self.colorPalette1.addGestureRecognizer(colorPalette1Tap)

        // Set up the check images based on previous defaults
        if userDefaults.boolForKey("shufflesOn") {
            self.shuffleImage.image = UIImage(named: "checkedBox")
        } else {
            self.shuffleImage.image = UIImage(named: "uncheckedBox")
        }
        
        if userDefaults.boolForKey("rotationsOn") {
            self.rotationImage.image = UIImage(named: "checkedBox")
        } else {
            self.rotationImage.image = UIImage(named: "uncheckedBox")
        }
        
        
        self.lightColor1.backgroundColor = UIColor(hex: light1, alpha: 1)
        self.darkColor1.backgroundColor = UIColor(hex: dark1, alpha: 1)
    }

    func shuffleTapped(sender: UIGestureRecognizer) {
        var shufflesOn = userDefaults.boolForKey("shufflesOn")
        if shufflesOn {
            self.userDefaults.setBool(false, forKey: "shufflesOn")
            self.shuffleImage.image = UIImage(named: "uncheckedBox")
        } else {
            self.userDefaults.setBool(true, forKey: "shufflesOn")
            self.shuffleImage.image = UIImage(named: "checkedBox")
        }
    }
    
    
    func rotationTapped(sender: UIGestureRecognizer) {
        var rotationsOn = userDefaults.boolForKey("rotationsOn")
        if rotationsOn {
            self.userDefaults.setBool(false, forKey: "rotationsOn")
            self.rotationImage.image = UIImage(named: "uncheckedBox")
        } else {
            self.userDefaults.setBool(true, forKey: "rotationsOn")
            self.rotationImage.image = UIImage(named: "checkedBox")
        }
    }
    

    func colorPalette1Selected(sender: UIGestureRecognizer) {
        self.view.backgroundColor = UIColor(hex: light1, alpha: 1)
//        self.lightColor1.backgroundColor = UIColor(hex: light1, alpha: 1)
//        self.darkColor1.backgroundColor = UIColor(hex: dark1, alpha: 1)
    }
    
    
    @IBAction func dismissInfo(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func dismissTap(sender: UIGestureRecognizer) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    

    
    
    //        let scrollTapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("scrollTapped:"))
    //        scrollTapGestureRecognizer.numberOfTapsRequired = 1
    //        scrollTapGestureRecognizer.enabled = true
    //        self.infoText.addGestureRecognizer(scrollTapGestureRecognizer)
    ////        self.infoText.userInteractionEnabled = false
    //
    //        self.infoText.text = "The objective of the game is to form the original image by shifting the tiles around until they are in the proper order. Tap one tile and then another to swap their positions. The black arrows on the top and left of the tiles allow entire rows and columns to swap postions.\n\nThe HINT button shows the first incorrect tile and the correct tile which it should be swapped with.\n\nThe SOLVE button will auto-solve the puzzle by swapping tiles until complete.\n\nUse the Show Original button to remind yourself what the original image looks like.\n\nImages were culled from unsplash.com and from Dale Arveson: phalconphotography.smugmug.com\n\nFeedback, questions, comments are welcome: pakalewis@gmail.com\n\nThe source code can be viewed here: github.com/pakalewis/shiftingtiles\n\ntest\n\ntest\n\ntest\n\ntest\n\ntest\n\ntest\n\ntest\n\ntest\n\ntest"
    //

}
