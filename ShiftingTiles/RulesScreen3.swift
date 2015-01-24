//
//  RulesScreen3.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 1/19/15.
//  Copyright (c) 2015 Parker Lewis. All rights reserved.
//

import UIKit

class RulesScreen3: UIViewController {

    let colorPalette = ColorPalette()
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            self.label1.font = UIFont(name: self.label1.font.fontName, size: 15)
            self.label2.font = UIFont(name: self.label2.font.fontName, size: 15)
            self.label3.font = UIFont(name: self.label3.font.fontName, size: 15)
        }

        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            self.label1.font = UIFont(name: self.label1.font.fontName, size: 30)
            self.label2.font = UIFont(name: self.label2.font.fontName, size: 30)
            self.label3.font = UIFont(name: self.label3.font.fontName, size: 30)
        }
        

        self.image1.image = self.image1.image?.imageWithColor(self.colorPalette.fetchDarkColor())
        self.image2.image = self.image2.image?.imageWithColor(self.colorPalette.fetchDarkColor())
        self.image3.image = self.image3.image?.imageWithColor(self.colorPalette.fetchDarkColor())
        
        self.label1.textColor = self.colorPalette.fetchDarkColor()
        self.label2.textColor = self.colorPalette.fetchDarkColor()
        self.label3.textColor = self.colorPalette.fetchDarkColor()
        
        
        self.label1.text = "Tap and hold to view the original image."
        self.label2.text = "Get a hint and see which tiles should be swapped.\n\nIf all tiles are in the correct positions, see which tile should be rotated."
        self.label3.text = "Stuck?\nAuto-solve the puzzle."

    }
}
