//
//  RulesScreen1a.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 3/3/15.
//  Copyright (c) 2015 Parker Lewis. All rights reserved.
//

import UIKit

class RulesScreen1a: UIViewController {

    let colorPalette = ColorPalette()
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var scrambledImage: UIImageView!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var solvedImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            self.label1.font = UIFont(name: "OpenSans", size: 15)
            self.label2.font = UIFont(name: "OpenSans", size: 15)
        }
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            self.label1.font = UIFont(name: "OpenSans", size: 30)
            self.label2.font = UIFont(name: "OpenSans", size: 30)
        }
        
        
        self.label1.text = NSLocalizedString("Rules1_Part4", comment: "")
        self.label2.text = NSLocalizedString("Rules1_Part5", comment: "")
        
        
        self.label1.textColor = self.colorPalette.fetchDarkColor()
        self.label2.textColor = self.colorPalette.fetchDarkColor()
        
        
        self.scrambledImage.layer.borderColor = self.colorPalette.fetchDarkColor().CGColor
        self.scrambledImage.layer.borderWidth = 2
        self.solvedImage.layer.borderColor = self.colorPalette.fetchDarkColor().CGColor
        self.solvedImage.layer.borderWidth = 2
        
        self.arrowImage.image = self.arrowImage.image?.imageWithColor(self.colorPalette.fetchDarkColor())
        
        
    }
    
}
