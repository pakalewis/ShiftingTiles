//
//  SettingsScreen.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 1/13/15.
//  Copyright (c) 2015 Parker Lewis. All rights reserved.
//

import UIKit

class SettingsScreen: UIViewController {

    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    let colorPalette = ColorPalette()
    
    
    // Labels and buttons
    @IBOutlet weak var settingLabel: UILabel!
    
    
    @IBOutlet weak var rotationContainer: UIView!
    @IBOutlet weak var rotationImage: UIImageView!
    @IBOutlet weak var rotationLabel: UILabel!

    @IBOutlet weak var congratsContainer: UIView!
    @IBOutlet weak var congratsImage: UIImageView!
    @IBOutlet weak var congratsLabel: UILabel!

    
    @IBOutlet weak var colorSchemeLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    
    // Palettes
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
    
    @IBOutlet weak var colorPalette5: UIView!
    @IBOutlet weak var lightColor5: UIView!
    @IBOutlet weak var darkColor5: UIView!
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateColorsAndFonts()
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add tap gesturess
        var rotationTap = UITapGestureRecognizer(target: self, action: "rotationTapped:")
        self.rotationContainer.addGestureRecognizer(rotationTap)
        
        var congratsTap = UITapGestureRecognizer(target: self, action: "congratsTapped:")
        self.congratsContainer.addGestureRecognizer(congratsTap)
        
        var colorPalette1Tap = UITapGestureRecognizer(target: self, action: "colorPalette1Selected:")
        self.colorPalette1.addGestureRecognizer(colorPalette1Tap)
        
        var colorPalette2Tap = UITapGestureRecognizer(target: self, action: "colorPalette2Selected:")
        self.colorPalette2.addGestureRecognizer(colorPalette2Tap)
        
        var colorPalette3Tap = UITapGestureRecognizer(target: self, action: "colorPalette3Selected:")
        self.colorPalette3.addGestureRecognizer(colorPalette3Tap)
        
        var colorPalette4Tap = UITapGestureRecognizer(target: self, action: "colorPalette4Selected:")
        self.colorPalette4.addGestureRecognizer(colorPalette4Tap)
        
        var colorPalette5Tap = UITapGestureRecognizer(target: self, action: "colorPalette5Selected:")
        self.colorPalette5.addGestureRecognizer(colorPalette5Tap)
        
        
        // Set up the check images based on previous defaults
        if userDefaults.boolForKey("rotationsOn") {
            self.rotationImage.image = UIImage(named: "checkedBox")
        } else {
            self.rotationImage.image = UIImage(named: "uncheckedBox")
        }
        if userDefaults.boolForKey("congratsOn") {
            self.congratsImage.image = UIImage(named: "checkedBox")
        } else {
            self.congratsImage.image = UIImage(named: "uncheckedBox")
        }
        
        
        // Set light and dark colors for the palette options
        self.lightColor1.backgroundColor = self.colorPalette.lightColor1
        self.darkColor1.backgroundColor = self.colorPalette.darkColor1
        self.lightColor2.backgroundColor = self.colorPalette.lightColor2
        self.darkColor2.backgroundColor = self.colorPalette.darkColor2
        self.lightColor3.backgroundColor = self.colorPalette.lightColor3
        self.darkColor3.backgroundColor = self.colorPalette.darkColor3
        self.lightColor4.backgroundColor = self.colorPalette.lightColor4
        self.darkColor4.backgroundColor = self.colorPalette.darkColor4
        self.lightColor5.backgroundColor = self.colorPalette.lightColor5
        self.darkColor5.backgroundColor = self.colorPalette.darkColor5
    }
    
    
    
    
    func rotationTapped(sender: UIGestureRecognizer) {
        var rotationsOn = userDefaults.boolForKey("rotationsOn")
        if rotationsOn {
            self.userDefaults.setBool(false, forKey: "rotationsOn")
            self.rotationImage.image = UIImage(named: "uncheckedBox")?.imageWithColor(self.colorPalette.fetchDarkColor())
        } else {
            self.userDefaults.setBool(true, forKey: "rotationsOn")
            self.rotationImage.image = UIImage(named: "checkedBox")?.imageWithColor(self.colorPalette.fetchDarkColor())
        }
        self.userDefaults.synchronize()
    }
    
    
    func congratsTapped(sender: UIGestureRecognizer) {
        var congratsOn = userDefaults.boolForKey("congratsOn")
        if congratsOn {
            self.userDefaults.setBool(false, forKey: "congratsOn")
            self.congratsImage.image = UIImage(named: "uncheckedBox")?.imageWithColor(self.colorPalette.fetchDarkColor())
        } else {
            self.userDefaults.setBool(true, forKey: "congratsOn")
            self.congratsImage.image = UIImage(named: "checkedBox")?.imageWithColor(self.colorPalette.fetchDarkColor())
        }
        self.userDefaults.synchronize()
    }
    
    
    func colorPalette1Selected(sender: UIGestureRecognizer) {
        self.userDefaults.setInteger(1, forKey: "colorPaletteInt")
        self.updateColorsAndFonts()
    }
    
    func colorPalette2Selected(sender: UIGestureRecognizer) {
        self.userDefaults.setInteger(2, forKey: "colorPaletteInt")
        self.updateColorsAndFonts()
    }
    
    func colorPalette3Selected(sender: UIGestureRecognizer) {
        self.userDefaults.setInteger(3, forKey: "colorPaletteInt")
        self.updateColorsAndFonts()
    }
    
    func colorPalette4Selected(sender: UIGestureRecognizer) {
        self.userDefaults.setInteger(4, forKey: "colorPaletteInt")
        self.updateColorsAndFonts()
    }
    
    func colorPalette5Selected(sender: UIGestureRecognizer) {
        self.userDefaults.setInteger(5, forKey: "colorPaletteInt")
        self.updateColorsAndFonts()
    }
    
    
    func updateColorsAndFonts() {
        // Colors
        self.view.backgroundColor = self.colorPalette.fetchLightColor()
        self.settingLabel.textColor = self.colorPalette.fetchDarkColor()
        self.rotationLabel.textColor = self.colorPalette.fetchDarkColor()
        self.congratsLabel.textColor = self.colorPalette.fetchDarkColor()
        self.rotationImage.image = self.rotationImage.image?.imageWithColor(self.colorPalette.fetchDarkColor())
        self.congratsImage.image = self.congratsImage.image?.imageWithColor(self.colorPalette.fetchDarkColor())
        self.colorSchemeLabel.textColor = self.colorPalette.fetchDarkColor()
        self.backButton.setImage(UIImage(named: "backIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), forState: UIControlState.Normal)
        
        // Fonts
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            self.settingLabel.font = UIFont(name: "OpenSans-Bold", size: 40)
            self.rotationLabel.font = UIFont(name: "OpenSans", size: 20)
            self.congratsLabel.font = UIFont(name: "OpenSans", size: 20)
            self.colorSchemeLabel.font = UIFont(name: "OpenSans", size: 20)
        }
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            self.settingLabel.font = UIFont(name: "OpenSans-Bold", size: 70)
            self.rotationLabel.font = UIFont(name: "OpenSans", size: 40)
            self.congratsLabel.font = UIFont(name: "OpenSans", size: 40)
            self.colorSchemeLabel.font = UIFont(name: "OpenSans", size: 40)
        }
    }
    
    @IBAction func dismissInfo(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func dismissTap(sender: UIGestureRecognizer) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    

}