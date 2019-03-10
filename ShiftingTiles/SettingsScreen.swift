//
//  SettingsScreen.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 1/13/15.
//  Copyright (c) 2015 Parker Lewis. All rights reserved.
//

import UIKit

class SettingsScreen: UIViewController {
    class func generate() -> SettingsScreen {
        return UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController() as! SettingsScreen
    }

    
    let userDefaults = UserDefaults.standard
    
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
    @IBOutlet var colorPalettes: NSArray! // Array of five UIViews
    @IBOutlet var lightColors: NSArray! // Array of five UIViews
    @IBOutlet var darkColors: NSArray! // Array of five UIViews
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateColorsAndFonts()
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check/uncheck the Rotations/Congrats based on previous defaults
        if userDefaults.bool(forKey: "rotationsOn") {
            self.rotationImage.image = UIImage(named: "checkedBox")
        } else {
            self.rotationImage.image = UIImage(named: "uncheckedBox")
        }
        if userDefaults.bool(forKey: "congratsOn") {
            self.congratsImage.image = UIImage(named: "checkedBox")
        } else {
            self.congratsImage.image = UIImage(named: "uncheckedBox")
        }
        
        
        // Add tap gestures
        let rotationTap = UITapGestureRecognizer(target: self, action: #selector(SettingsScreen.rotationTapped(_:)))
        self.rotationContainer.addGestureRecognizer(rotationTap)
        
        let congratsTap = UITapGestureRecognizer(target: self, action: #selector(SettingsScreen.congratsTapped(_:)))
        self.congratsContainer.addGestureRecognizer(congratsTap)
        
        for palette in colorPalettes {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SettingsScreen.colorPaletteSelected(_:)))
            (palette as AnyObject).addGestureRecognizer(tapGesture)
        }

        
        // Set light and dark colors for the palette options
        for index in 0..<colorPalettes.count {
            let lightColorView = self.lightColors[index] as! UIView
            lightColorView.backgroundColor = Colors.lights()[index]
            let darkColorView = self.darkColors[index] as! UIView
            darkColorView.backgroundColor = Colors.darks()[index]
        }
    }
    
    
    
    
    @objc func rotationTapped(_ sender: UIGestureRecognizer) {
        let rotationsOn = userDefaults.bool(forKey: "rotationsOn")
        if rotationsOn {
            self.userDefaults.set(false, forKey: "rotationsOn")
            self.rotationImage.image = UIImage(named: "uncheckedBox")?.imageWithColor(Colors.fetchDarkColor())
        } else {
            self.userDefaults.set(true, forKey: "rotationsOn")
            self.rotationImage.image = UIImage(named: "checkedBox")?.imageWithColor(Colors.fetchDarkColor())
        }
        self.userDefaults.synchronize()
    }
    
    
    @objc func congratsTapped(_ sender: UIGestureRecognizer) {
        let congratsOn = userDefaults.bool(forKey: "congratsOn")
        if congratsOn {
            self.userDefaults.set(false, forKey: "congratsOn")
            self.congratsImage.image = UIImage(named: "uncheckedBox")?.imageWithColor(Colors.fetchDarkColor())
        } else {
            self.userDefaults.set(true, forKey: "congratsOn")
            self.congratsImage.image = UIImage(named: "checkedBox")?.imageWithColor(Colors.fetchDarkColor())
        }
        self.userDefaults.synchronize()
    }
    

    @objc func colorPaletteSelected(_ sender: UIGestureRecognizer) {
        // Determine which palette was selected and apply the color scheme
        let tappedPalette = sender.view
        let index = colorPalettes?.index(of: tappedPalette!)
        self.userDefaults.set(index!, forKey: "colorPaletteInt")
        self.updateColorsAndFonts()
    }
    
    
    func updateColorsAndFonts() {
        // Colors
        self.view.backgroundColor = Colors.fetchLightColor()
        self.settingLabel.textColor = Colors.fetchDarkColor()
        self.rotationLabel.textColor = Colors.fetchDarkColor()
        self.congratsLabel.textColor = Colors.fetchDarkColor()
        self.rotationImage.image = self.rotationImage.image?.imageWithColor(Colors.fetchDarkColor())
        self.congratsImage.image = self.congratsImage.image?.imageWithColor(Colors.fetchDarkColor())
        self.colorSchemeLabel.textColor = Colors.fetchDarkColor()
        self.backButton.setImage(UIImage(named: "backIcon")?.imageWithColor(Colors.fetchDarkColor()), for: UIControl.State())
        
        // Fonts
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            self.settingLabel.font = UIFont(name: "OpenSans-Bold", size: 40)
            self.rotationLabel.font = UIFont(name: "OpenSans", size: 20)
            self.congratsLabel.font = UIFont(name: "OpenSans", size: 20)
            self.colorSchemeLabel.font = UIFont(name: "OpenSans", size: 20)
        }
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            self.settingLabel.font = UIFont(name: "OpenSans-Bold", size: 70)
            self.rotationLabel.font = UIFont(name: "OpenSans", size: 40)
            self.congratsLabel.font = UIFont(name: "OpenSans", size: 40)
            self.colorSchemeLabel.font = UIFont(name: "OpenSans", size: 40)
        }
    }
    
    @IBAction func dismissInfo(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    func dismissTap(_ sender: UIGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
