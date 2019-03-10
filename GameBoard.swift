//
//  GameBoard.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 2/18/19.
//  Copyright © 2019 Parker Lewis. All rights reserved.
//

import UIKit

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



    func createTiles(in view: UIView) -> [[Tile]] {
        var tiles = [[Tile]]()
        // Image measurements
        guard let cgimage = self.imagePackage.image().cgImage else { return tiles }

        let totalImageWidth = CGFloat(cgimage.width)
        let imageWidth : CGFloat = CGFloat(totalImageWidth / CGFloat(self.tilesPerRow))

        let tileWidth: CGFloat = (view.frame.width) / CGFloat(self.tilesPerRow)

        for index1 in 0..<self.tilesPerRow { // go down the rows
            // Make the row array of Tiles
            var rowArray = [Tile]()

            let tileAreaPositionY:CGFloat = CGFloat(index1) * (tileWidth)

            for index2 in 0..<self.tilesPerRow { // get the tiles in each row

                let tileAreaPositionX:CGFloat = CGFloat(index2) * (tileWidth)

                let doubleIndex = DoubleIndex(index1: index1, index2: index2)
                let coordinate = Coordinate(index1,index2)
                // Create the image for the Tile
                let imagePositionY:CGFloat = CGFloat(index1) * (imageWidth)
                let imagePositionX:CGFloat = CGFloat(index2) * (imageWidth)
                let imageFrame = CGRect(x: imagePositionX, y: imagePositionY, width: imageWidth, height: imageWidth)
                let tileCGImage = cgimage.cropping(to: imageFrame)
                let tileUIImage = UIImage(cgImage: tileCGImage!)

                // Make a new tile with that doubleIndex
                let tile = Tile(image: tileUIImage, doubleIndex: doubleIndex, coordinate: coordinate, delegate: self)
                // set the boundaries of the tile
                let tileFrame = CGRect(x: tileAreaPositionX, y: tileAreaPositionY, width: tileWidth, height: tileWidth)
                tile.frame = tileFrame
                view.addSubview(tile)

                // Add to row array
                rowArray.append(tile)
            }

            // Add the row array to the tile area
            tiles.append(rowArray)
        }
        return tiles
    }

    
}
extension GameBoard: TileDelegate {
    func selected(at coordinate: Coordinate) {

    }

    func deselected() {
        
    }


}

