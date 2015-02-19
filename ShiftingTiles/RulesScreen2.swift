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

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            self.label1.font = UIFont(name: "OpenSans", size: 15)
            self.label2.font = UIFont(name: "OpenSans", size: 15)
            self.label3.font = UIFont(name: "OpenSans", size: 15)
            self.label4.font = UIFont(name: "OpenSans", size: 15)
        }
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            self.label1.font = UIFont(name: "OpenSans", size: 30)
            self.label2.font = UIFont(name: "OpenSans", size: 30)
            self.label3.font = UIFont(name: "OpenSans", size: 30)
            self.label4.font = UIFont(name: "OpenSans", size: 30)
        }
        
        self.image1.image = self.image1.image?.imageWithColor(self.colorPalette.fetchDarkColor())
        self.image2.image = self.image2.image?.imageWithColor(self.colorPalette.fetchDarkColor())
        self.image3.image = self.image3.image?.imageWithColor(self.colorPalette.fetchDarkColor())
        self.image4.layer.borderColor = self.colorPalette.fetchDarkColor().CGColor
        self.image4.layer.borderWidth = 2
        self.image4.layer.cornerRadius = self.image4.frame.width * 0.25
        self.image4.image = self.image4.image?.imageWithColor(self.colorPalette.fetchDarkColor())
        
        self.label1.textColor = self.colorPalette.fetchDarkColor()
        self.label2.textColor = self.colorPalette.fetchDarkColor()
        self.label3.textColor = self.colorPalette.fetchDarkColor()
        self.label4.textColor = self.colorPalette.fetchDarkColor()
        
        
        self.label1.text = NSLocalizedString("Rules2_Part1", comment: "")
        self.label2.text = NSLocalizedString("Rules2_Part2", comment: "")
        self.label3.text = NSLocalizedString("Rules2_Part3", comment: "")
        self.label4.text = NSLocalizedString("Rules2_Part4", comment: "")


    }
}
