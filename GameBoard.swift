//
//  GameBoard.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 2/18/19.
//  Copyright © 2019 Parker Lewis. All rights reserved.
//

import Foundation

protocol GameBoardDelegate {
    func isSolved()
}

class GameBoard {
    let imagePackage: ImagePackage
    let tilesPerRow: Int
    
    weak var delegate: PuzzleSolvedProtocol?

    init(imagePackage: ImagePackage, tilesPerRow: Int) {
        self.imagePackage = imagePackage
        self.tilesPerRow = tilesPerRow
    }
    
    
}

