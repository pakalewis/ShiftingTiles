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
    var tiles = [[Tile]]()

    weak var delegate: PuzzleSolvedProtocol?

    init(imagePackage: ImagePackage, tilesPerRow: Int) {
        self.imagePackage = imagePackage
        self.tilesPerRow = tilesPerRow
    }


    func createTiles(in view: UIView) -> [[Tile]] {
        tiles.removeAll()
        guard let cgimage = self.imagePackage.image().cgImage else { return tiles }

        for index1 in 0..<self.tilesPerRow { // go down the rows
            // Make the row array of Tiles
            var rowArray = [Tile]()

            for index2 in 0..<self.tilesPerRow { // make the tiles in each row
                // Create the image for the Tile
                let imageWidth: CGFloat = CGFloat(CGFloat(cgimage.width) / CGFloat(self.tilesPerRow))
                let imageFrame = CGRect(
                    x: CGFloat(index2) * (imageWidth),
                    y: CGFloat(index1) * (imageWidth),
                    width: imageWidth,
                    height: imageWidth
                )
                let tileCGImage = cgimage.cropping(to: imageFrame)
                let tileUIImage = UIImage(cgImage: tileCGImage!)

                // set the boundaries of the tile
                let tileWidth: CGFloat = (view.frame.width) / CGFloat(self.tilesPerRow)
                let tileFrame = CGRect(
                    x: CGFloat(index2) * (tileWidth),
                    y: CGFloat(index1) * (tileWidth),
                    width: tileWidth,
                    height: tileWidth
                )

                // Make a new tile
                let tile = Tile(
                    image: tileUIImage,
                    doubleIndex: DoubleIndex(index1: index1, index2: index2),
                    coordinate: Coordinate(index1,index2),
                    delegate: self,
                    frame: tileFrame
                )

                view.addSubview(tile)

                // Add to row array
                rowArray.append(tile)
            }

            // Add the row array to the tile area
            tiles.append(rowArray)
        }
        return tiles
    }

    private func randomIndex() -> Int {
        return Int.random(in: 0 ..< self.tilesPerRow)
    }

    func twoRandomTiles() -> (tile1: Tile, tile2: Tile) {
        let tile1 = self.tiles[self.randomIndex()][self.randomIndex()]
        let tile2 = self.tiles[self.randomIndex()][self.randomIndex()]
        return (tile1: tile1, tile2: tile2)
    }
}

extension GameBoard: TileDelegate {
    func selected(at coordinate: Coordinate) {

    }

    func deselected() {
        
    }


}

