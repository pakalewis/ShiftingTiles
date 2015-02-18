//
//  RulesScreen1.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 1/15/15.
//  Copyright (c) 2015 Parker Lewis. All rights reserved.
//

import UIKit

class RulesScreen1: UIViewController {

    let colorPalette = ColorPalette()
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label2a: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    
    @IBOutlet weak var scrambledImage: UIImageView!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var solvedImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            self.label1.font = UIFont(name: self.label1.font.fontName, size: 15)
            self.label2.font = UIFont(name: self.label2.font.fontName, size: 15)
            self.label2a.font = UIFont(name: self.label2a.font.fontName, size: 15)
            self.label3.font = UIFont(name: self.label3.font.fontName, size: 15)
            self.label4.font = UIFont(name: self.label4.font.fontName, size: 15)
        }
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            self.label1.font = UIFont(name: self.label1.font.fontName, size: 30)
            self.label2.font = UIFont(name: self.label2.font.fontName, size: 30)
            self.label2a.font = UIFont(name: self.label2a.font.fontName, size: 30)
            self.label3.font = UIFont(name: self.label3.font.fontName, size: 30)
            self.label4.font = UIFont(name: self.label4.font.fontName, size: 30)
        }
        

        self.label1.text = NSLocalizedString("Rules1_Part1", comment: "Rules1_Part1")
        self.label2.text = NSLocalizedString("Rules1_Part2", comment: "Rules1_Part2")
        self.label2a.text = NSLocalizedString("Rules1_Part3", comment: "Rules1_Part3")
        self.label3.text = NSLocalizedString("Rules1_Part4", comment: "Rules1_Part4")
        self.label4.text = NSLocalizedString("Rules1_Part5", comment: "Rules1_Part5")
        
//        "Rearrange the tiles to form the complete picture."
//        self.label2.text = "Drag a tile on top of another tile to swap their positions."
//        self.label2a.text = "Swap entire rows and columns by dragging the outer squares."
//        self.label3.text = "For an extra challenge, turn on Rotations in the settings menu."
//        self.label4.text = "Double tap a tile to rotate it 90°."
        
        self.label1.textColor = self.colorPalette.fetchDarkColor()
        self.label2.textColor = self.colorPalette.fetchDarkColor()
        self.label2a.textColor = self.colorPalette.fetchDarkColor()
        self.label3.textColor = self.colorPalette.fetchDarkColor()
        self.label4.textColor = self.colorPalette.fetchDarkColor()

        
        self.scrambledImage.layer.borderColor = self.colorPalette.fetchDarkColor().CGColor
        self.scrambledImage.layer.borderWidth = 2
        self.solvedImage.layer.borderColor = self.colorPalette.fetchDarkColor().CGColor
        self.solvedImage.layer.borderWidth = 2
        
        self.arrowImage.image = self.arrowImage.image?.imageWithColor(self.colorPalette.fetchDarkColor())

        
    }


}
