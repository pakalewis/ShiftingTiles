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
    var singleArrayOfTiles = [Tile]()

    var shuffleCount: Int {
        return tilesPerRow * 10
    }

    var selectedTile: Tile?

    weak var delegate: GameBoardDelegate?

    init(imagePackage: ImagePackage, tilesPerRow: Int) {
        self.imagePackage = imagePackage
        self.tilesPerRow = tilesPerRow
    }

    func createTilesInSingleArray(in view: UIView) {
        self.singleArrayOfTiles.removeAll()

        guard let cgimage = self.imagePackage.image().cgImage else { return }

        for index1 in 0..<self.tilesPerRow { // go down the rows
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
                self.singleArrayOfTiles.append(tile)
            }
        }
    }

    func setTiles(enabled: Bool) {
        for tile in self.singleArrayOfTiles {
            tile.isUserInteractionEnabled = enabled
        }
    }


    func twoRandomTiles() -> (tile1: Tile, tile2: Tile) {
//        func randomIndex() -> Int {
//            return Int.random(in: 0 ..< self.tilesPerRow)
//        }
        func randomIndex() -> Int {
            return Int.random(in: 0 ..< self.singleArrayOfTiles.count)
        }

        let tile1 = self.singleArrayOfTiles[randomIndex()]
        let tile2 = self.singleArrayOfTiles[randomIndex()]

//        let tile1 = self.tiles[randomIndex()][randomIndex()]
//        let tile2 = self.tiles[randomIndex()][randomIndex()]
        return (tile1: tile1, tile2: tile2)
    }

    func tile(at coordinate: Coordinate) -> Tile? {
        guard coordinate.row < self.tilesPerRow else { return nil }
        guard coordinate.column < self.tilesPerRow else { return nil }

        return self.tiles[coordinate.row][coordinate.column]
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
        if let row = row {
            let tiles = self.singleArrayOfTiles.filter({ $0.currentCoordinate.row == row } )
            return tiles.sorted(by: { $0.currentCoordinate.column < $1.currentCoordinate.column })
//            for index in 0..<self.tilesPerRow {
//                let coordinate = Coordinate(row, index)
//                if let tile =
//                tiles.append(self.findTile(at: coordinate))
//            }
        } else if let column = column {
            let tiles = self.singleArrayOfTiles.filter({ $0.currentCoordinate.column == column } )
            return tiles.sorted(by: { $0.currentCoordinate.row < $1.currentCoordinate.row })
//
//            return self.singleArrayOfTiles.filter({ $0.currentCoordinate.column == column } )

//            return self.singleArrayOfTiles.compactMap({ $0.currentCoordinate.row == row } )
//            return self.singleArrayOfTiles.map(where: { $0.currentCoordinate.column == column } )

//            for index in 0..<self.tilesPerRow {
//                let coordinate = Coordinate(index, column)
//                tiles.append(self.findTile(at: coordinate))
//            }
        }
        return []
    }

    func findTile(at coordinate: Coordinate) -> Tile? {
        return self.singleArrayOfTiles.first(where: { $0.currentCoordinate == coordinate } )
    }

    func findFirstUnorientedTile() -> Tile? {
        return self.singleArrayOfTiles.first(where: { $0.orientationCount != 1 } )
    }

    func swapCoordinates(_ tile1: Tile, _ tile2: Tile) {
        let tempCoordinate = tile1.currentCoordinate
        tile1.currentCoordinate = tile2.currentCoordinate
        tile2.currentCoordinate = tempCoordinate
    }


    // MARK: TILE EXAMINATION
    // Checks to see if the image pieces are in the correct order and if the orientations are correct
    func isSolved() -> Bool {
        for tile in self.singleArrayOfTiles {
            if tile.currentCoordinate != tile.targetCoordinate { return false }
            if tile.orientationCount != 1 { return false }
        }


//        for row in 0..<self.tilesPerRow {
//            for column in 0..<self.tilesPerRow {
//                let coordinate = Coordinate(row, column)
//                let tileToCheck = self.tiles[row][column]
//
//                print("coordinate = \(coordinate)")
//                print("tileToCheck.currentCoordinate = \(tileToCheck.currentCoordinate)")
//
//                if tileToCheck.currentCoordinate != coordinate  { return false }
//                if tileToCheck.orientationCount != 1 { return false }
//            }
//        }
        return true
    }
}

extension GameBoard: TileDelegate {
    func selected(tile: Tile) {
        if let firstTile = self.selectedTile {
            // firstTile was already selected, now a second tile is being selected

            // reset it and then swap the two selected tiles
            firstTile.state = .normal
            self.swapCoordinates(firstTile, tile)
            self.delegate?.swapTiles(firstTile, tile)
            self.selectedTile = nil
        } else {
            // this is a first tile being selected
            tile.state = .selected
            self.selectedTile = tile
        }
    }

    func deselected() {
        self.selectedTile = nil
    }
}

