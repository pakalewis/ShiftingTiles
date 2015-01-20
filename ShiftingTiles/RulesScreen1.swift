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
    @IBOutlet weak var label3: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.label1.text = "Solve the puzzle by rearranging the tiles to form the complete image."
        self.label2.text = "Tap a tile to select it.\nTap a second tile to swap their positions."
        self.label3.text = "Double tap a tile to rotate it 90°."
        
        self.label1.textColor = self.colorPalette.fetchDarkColor()
        self.label2.textColor = self.colorPalette.fetchDarkColor()
        self.label3.textColor = self.colorPalette.fetchDarkColor()

    }


}
