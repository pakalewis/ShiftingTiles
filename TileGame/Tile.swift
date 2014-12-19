//
//  Tile.swift
//  TileGame
//
//  Created by Parker Lewis on 12/18/14.
//  Copyright (c) 2014 Parker Lewis. All rights reserved.
//

import UIKit

class Tile {

    var imageSection = UIImage()
    var imageView = UIImageView()
    var doubleIndex : DoubleIndex!
    
    init(doubleIndex: DoubleIndex) {
        self.doubleIndex = doubleIndex
    }


    func getDoubleIndex() -> DoubleIndex {
        return self.doubleIndex
    }
}
