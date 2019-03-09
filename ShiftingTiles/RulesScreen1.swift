//
//  RulesScreen1.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 1/15/15.
//  Copyright (c) 2015 Parker Lewis. All rights reserved.
//

import UIKit

class RulesScreen1: UIViewController {
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    @IBOutlet weak var sampleRoundedSquare: UIImageView!
    @IBOutlet weak var scrambledImage: UIImageView!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var solvedImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            self.label1.font = UIFont(name: "OpenSans", size: 15)
            self.label2.font = UIFont(name: "OpenSans", size: 15)
            self.label3.font = UIFont(name: "OpenSans", size: 15)
        }
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            self.label1.font = UIFont(name: "OpenSans", size: 30)
            self.label2.font = UIFont(name: "OpenSans", size: 30)
            self.label3.font = UIFont(name: "OpenSans", size: 30)
        }
        

        self.label1.text = NSLocalizedString("Rules1_Part1", comment: "")
        self.label2.text = NSLocalizedString("Rules1_Part2", comment: "")
        self.label3.text = NSLocalizedString("Rules1_Part3", comment: "")
        
        
        self.label1.textColor = ColorPalette.fetchDarkColor()
        self.label2.textColor = ColorPalette.fetchDarkColor()
        self.label3.textColor = ColorPalette.fetchDarkColor()

        
        self.scrambledImage.layer.borderColor = ColorPalette.fetchDarkColor().cgColor
        self.scrambledImage.layer.borderWidth = 2
        self.solvedImage.layer.borderColor = ColorPalette.fetchDarkColor().cgColor
        self.solvedImage.layer.borderWidth = 2
        
        self.arrowImage.image = self.arrowImage.image?.imageWithColor(ColorPalette.fetchDarkColor())
        self.sampleRoundedSquare.image = self.sampleRoundedSquare.image?.imageWithColor(ColorPalette.fetchDarkColor())

        
    }


}
