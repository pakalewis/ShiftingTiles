//
//  RulesScreen2.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 1/16/15.
//  Copyright (c) 2015 Parker Lewis. All rights reserved.
//

import UIKit

class RulesScreen2: UIViewController {
    
    let colorPalette = ColorPalette()

    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            self.label1.font = UIFont(name: self.label1.font.fontName, size: 15)
            self.label2.font = UIFont(name: self.label2.font.fontName, size: 15)
            self.label3.font = UIFont(name: self.label3.font.fontName, size: 15)
            self.label4.font = UIFont(name: self.label4.font.fontName, size: 15)
            self.label5.font = UIFont(name: self.label5.font.fontName, size: 15)
        }
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            self.label1.font = UIFont(name: self.label1.font.fontName, size: 30)
            self.label2.font = UIFont(name: self.label2.font.fontName, size: 30)
            self.label3.font = UIFont(name: self.label3.font.fontName, size: 30)
            self.label4.font = UIFont(name: self.label4.font.fontName, size: 30)
            self.label5.font = UIFont(name: self.label5.font.fontName, size: 30)
        }
        
        self.image1.image = self.image1.image?.imageWithColor(self.colorPalette.fetchDarkColor())
        self.image2.image = self.image2.image?.imageWithColor(self.colorPalette.fetchDarkColor())
        self.image3.image = self.image3.image?.imageWithColor(self.colorPalette.fetchDarkColor())
        self.image4.image = self.image4.image?.imageWithColor(self.colorPalette.fetchDarkColor())
        self.image5.layer.borderColor = self.colorPalette.fetchDarkColor().CGColor
        self.image5.layer.borderWidth = 2
        self.image5.layer.cornerRadius = self.image4.frame.width * 0.25
        self.image5.image = self.image5.image?.imageWithColor(self.colorPalette.fetchDarkColor())
        
        self.label1.textColor = self.colorPalette.fetchDarkColor()
        self.label2.textColor = self.colorPalette.fetchDarkColor()
        self.label3.textColor = self.colorPalette.fetchDarkColor()
        self.label4.textColor = self.colorPalette.fetchDarkColor()
        self.label5.textColor = self.colorPalette.fetchDarkColor()
        
        
        self.label1.text = "Take a photo or select one\nfrom your photos library."
        self.label2.text = "Choose the grid size."
        self.label3.text = "Toggle the preview grid."
        self.label4.text = "View statistics."
        self.label5.text = "Start the puzzle!"

    }
}
