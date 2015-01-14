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
    
    let colorPalette = ColorPalette()


    
    @IBOutlet weak var settingLabel: UILabel!
    
    @IBOutlet weak var shuffleImage: UIImageView!
    @IBOutlet weak var rotationImage: UIImageView!
    
    @IBOutlet weak var shuffle: UIView!
    @IBOutlet weak var rotations: UIView!

    
    @IBOutlet weak var colorPalette1: UIView!
    @IBOutlet weak var lightColor1: UIView!
    @IBOutlet weak var darkColor1: UIView!

    @IBOutlet weak var colorPalette2: UIView!
    @IBOutlet weak var lightColor2: UIView!
    @IBOutlet weak var darkColor2: UIView!

    @IBOutlet weak var colorPalette3: UIView!
    @IBOutlet weak var lightColor3: UIView!
    @IBOutlet weak var darkColor3: UIView!

    @IBOutlet weak var colorPalette4: UIView!
    @IBOutlet weak var lightColor4: UIView!
    @IBOutlet weak var darkColor4: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        // Add tap gesturess
        var shuffleTap = UITapGestureRecognizer(target: self, action: "shuffleTapped:")
        self.shuffle.addGestureRecognizer(shuffleTap)
        
        var rotationTap = UITapGestureRecognizer(target: self, action: "rotationTapped:")
        self.rotations.addGestureRecognizer(rotationTap)
        
        var colorPalette1Tap = UITapGestureRecognizer(target: self, action: "colorPalette1Selected:")
        self.colorPalette1.addGestureRecognizer(colorPalette1Tap)
        
        var colorPalette2Tap = UITapGestureRecognizer(target: self, action: "colorPalette2Selected:")
        self.colorPalette2.addGestureRecognizer(colorPalette2Tap)
        
        var colorPalette3Tap = UITapGestureRecognizer(target: self, action: "colorPalette3Selected:")
        self.colorPalette3.addGestureRecognizer(colorPalette3Tap)
        
        var colorPalette4Tap = UITapGestureRecognizer(target: self, action: "colorPalette4Selected:")
        self.colorPalette4.addGestureRecognizer(colorPalette4Tap)
        
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
        
        // Set colors
        self.view.backgroundColor = ColorPalette().fetchLightColor()
        self.settingLabel.textColor = ColorPalette().fetchDarkColor()

        
        self.lightColor1.backgroundColor = self.colorPalette.lightColor1
        self.darkColor1.backgroundColor = self.colorPalette.darkColor1
        self.lightColor2.backgroundColor = self.colorPalette.lightColor2
        self.darkColor2.backgroundColor = self.colorPalette.darkColor2
        self.lightColor3.backgroundColor = self.colorPalette.lightColor3
        self.darkColor3.backgroundColor = self.colorPalette.darkColor3
        self.lightColor4.backgroundColor = self.colorPalette.lightColor4
        self.darkColor4.backgroundColor = self.colorPalette.darkColor4
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
        self.userDefaults.synchronize()

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
        self.userDefaults.synchronize()
    }
    

    func colorPalette1Selected(sender: UIGestureRecognizer) {
        self.userDefaults.setInteger(1, forKey: "colorPaletteInt")
        self.view.backgroundColor = ColorPalette().fetchLightColor()
        self.settingLabel.textColor = ColorPalette().fetchDarkColor()
    }
    
    func colorPalette2Selected(sender: UIGestureRecognizer) {
        self.userDefaults.setInteger(2, forKey: "colorPaletteInt")
        self.view.backgroundColor = ColorPalette().fetchLightColor()
        self.settingLabel.textColor = ColorPalette().fetchDarkColor()
    }
    
    func colorPalette3Selected(sender: UIGestureRecognizer) {
        self.userDefaults.setInteger(3, forKey: "colorPaletteInt")
        self.view.backgroundColor = ColorPalette().fetchLightColor()
        self.settingLabel.textColor = ColorPalette().fetchDarkColor()
    }
    
    func colorPalette4Selected(sender: UIGestureRecognizer) {
        self.userDefaults.setInteger(4, forKey: "colorPaletteInt")
        self.view.backgroundColor = ColorPalette().fetchLightColor()
        self.settingLabel.textColor = ColorPalette().fetchDarkColor()
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
