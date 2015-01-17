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

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.topLabel.text = "How To Play"
        self.label1.text = "Choose from over 50 available images. Alternatively, tap the camera icon to take a photo or select one from your photos library."
        self.label2.text = "Choose the difficulty level from 2 to 10."
        self.label3.text = "Toggle the grid on and off to see a preview of the size of the tiles. This does not have any affect on the puzzle."
        self.label4.text = "Start the puzzle!"
        self.label5.text = "View statistics "

    }
}
