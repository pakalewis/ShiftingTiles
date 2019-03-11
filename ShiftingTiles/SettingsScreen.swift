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
    
    var rotationsOn: Bool = false {
        didSet {
            if rotationsOn {
                self.rotationImage.image = Icon.checkedBox.image()
            } else {
                self.rotationImage.image = Icon.uncheckedBox.image()
            }
        }
    }

    var showCongrats: Bool = false {
        didSet {
            if showCongrats {
                self.congratsImage.image = Icon.checkedBox.image()
            } else {
                self.congratsImage.image = Icon.uncheckedBox.image()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.rotationImage.tintColor = Colors.fetchDarkColor()
        self.congratsImage.tintColor = Colors.fetchDarkColor()

        self.rotationsOn = UserSettings.boolValue(for: .rotations)
        self.showCongrats = UserSettings.boolValue(for: .congratsMessages)

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
    
    
    
    
    @objc func rotationTapped(_ sender: UIGestureRecognizer) {
        UserSettings.toggle(key: .rotations)
        self.rotationsOn = UserSettings.boolValue(for: .rotations)
    }
    
    
    @objc func congratsTapped(_ sender: UIGestureRecognizer) {
        UserSettings.toggle(key: .congratsMessages)
        self.showCongrats = UserSettings.boolValue(for: .congratsMessages)
    }

    @objc func colorPaletteSelected(_ sender: UIGestureRecognizer) {
        // Determine which palette was selected and apply the color scheme
        let tappedPalette = sender.view
        let index = colorPalettes?.index(of: tappedPalette!)
        UserSettings.set(value: index!, for: .colorScheme)
        self.updateColorsAndFonts()
    }
    
    
    func updateColorsAndFonts() {
        // Colors
        self.view.backgroundColor = Colors.fetchLightColor()
        self.settingLabel.textColor = Colors.fetchDarkColor()
        self.rotationLabel.textColor = Colors.fetchDarkColor()
        self.congratsLabel.textColor = Colors.fetchDarkColor()
        self.colorSchemeLabel.textColor = Colors.fetchDarkColor()
        self.backButton.setImage(UIImage(named: "backIcon")?.imageWithColor(Colors.fetchDarkColor()), for: UIControl.State())

    }
    
    @IBAction func dismissInfo(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    func dismissTap(_ sender: UIGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}

