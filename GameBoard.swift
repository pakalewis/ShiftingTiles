//
//  GameBoard.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 2/18/19.
//  Copyright © 2019 Parker Lewis. All rights reserved.
//

import UIKit

protocol GameBoardDelegate: class {
    func swapTiles(_ tile1: Tile, _ tile2: Tile)
}

class GameBoard {
    deinit {
        print("DEINIT GameBoard")
    }

    let imagePackage: ImagePackage
    let tilesPerRow: Int
    var tiles = [[Tile]]()

    var shuffleCount: Int {
        return tilesPerRow * 10
    }

    var selectedTile: Tile?

    weak var delegate: GameBoardDelegate?

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
                    coordinate: Coordinate(index1, index2),
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

//    func makeLineOfTiles(_ identifier: Int) -> [Tile] {
//        var tileLine = [Tile]()
//
//        // Create array of Tiles
//        if (identifier - 100) < 0 { // Is a column
//            for index in 0..<self.tilesPerRow {
//                let coordinate = DoubleIndex(index1: index, index2: identifier)
//                let tile = self.findTileAtCoordinate(coordinate)
//                tile.originalFrame = tile.frame
//                tileLine.append(tile)
//            }
//        } else { // Is a row
//            for index in 0..<self.tilesPerRow {
//                let coordinate = DoubleIndex(index1: identifier - 100, index2: index)
//                let tile = self.findTileAtCoordinate(coordinate)
//                tile.originalFrame = tile.frame
//                tileLine.append(tile)
//            }
//        }
//        return tileLine
//    }
//

    func lineOfTiles(row: Int? = nil, column: Int? = nil) -> [Tile] {
        var tiles = [Tile]()
        if let row = row {
            for index in 0..<self.tilesPerRow {
                let coordinate = Coordinate(row, index)
                tiles.append(self.findTile(at: coordinate))
            }
        } else if let column = column {
            for index in 0..<self.tilesPerRow {
                let coordinate = Coordinate(index, column)
                tiles.append(self.findTile(at: coordinate))
            }
        }
        return tiles
    }

    func findTile(at coordinate: Coordinate) -> Tile {
        for index1 in 0..<self.tilesPerRow {
            for index2 in 0..<self.tilesPerRow {
                let t = self.tiles[index1][index2]
                if t.currentCoordinate == coordinate {
                    return t
                }
            }
        }
        return self.tiles[0][0]
    }

    // MARK: TILE EXAMINATION
    // Checks to see if the image pieces are in the correct order and if the orientations are correct
    func isSolved() -> Bool {
        for row in 0..<self.tilesPerRow {
            for column in 0..<self.tilesPerRow {
                let coordinate = Coordinate(row, column)
                let tileToCheck = self.tiles[row][column]

                print("coordinate = \(coordinate)")
                print("tileToCheck.currentCoordinate = \(tileToCheck.currentCoordinate)")

                if tileToCheck.currentCoordinate != coordinate  { return false }
                if tileToCheck.orientationCount != 1 { return false }
            }
        }
        return true
    }
}

extension GameBoard: TileDelegate {
    func selected(tile: Tile) {
        if tile.state == .selected {
            tile.state = .normal
            self.selectedTile = nil
            return
        }

        guard let first = self.selectedTile else {
            tile.state = .selected
            self.selectedTile = tile
            return
        }

        for row in self.tiles {
            for tile in row {
                tile.state = .normal
            }
        }
        self.delegate?.swapTiles(first, tile)
        self.selectedTile = nil
    }

    func deselected() {
        self.selectedTile = nil
    }
}

