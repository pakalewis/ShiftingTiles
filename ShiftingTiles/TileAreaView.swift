//
//  TileAreaView.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 12/18/14.
//  Copyright (c) 2014 Parker Lewis. All rights reserved.
//


import UIKit

protocol TileAreaViewDelegate: class {
    func puzzleSolved()
    func doneShuffling()
}

class TileAreaView: UIView {
    
    weak var delegate: TileAreaViewDelegate?

    // Set to true when puzzle is solved
    var isPuzzleSolved = false

    let gameBoard: GameBoard

    // Number of rows and columns in the puzzle
    var tilesPerRow = 3
    
    // This is a temporary view that appears as a black border around the selected tile
    var highlightedView = UIView()

    // MARK: SETUP
    init(gameBoard: GameBoard, frame: CGRect) {
        print("initialize game board")

        self.gameBoard = gameBoard
        super.init(frame: frame)

        self.gameBoard.delegate = self

        self.layer.borderWidth = 2
        self.clipsToBounds = true


        gameBoard.createTilesInSingleArray(in: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.shuffle(index: 0, complete: {
//                if UserSettings.boolValue(for: .rotations) {
//                    self.rotateTiles()
//                }
                self.gameBoard.setTiles(enabled: true)
                self.delegate?.doneShuffling()
            })
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func shuffle(index: Int, complete: (() -> Void)? = nil) {
        print("starting shuffle \(index)")

        let randomTiles = self.gameBoard.twoRandomTiles()
        if randomTiles.tile1.targetCoordinate == randomTiles.tile2.targetCoordinate {
            // tiles are the same so do nothing
            print("skip this swap since the two random tiles are the same")
            self.shuffle(index: index, complete: complete)
            return
        }

        self.gameBoard.swapCoordinates(randomTiles.tile1, randomTiles.tile2)        
        self.animateSwap(randomTiles.tile1, randomTiles.tile2, duration: 0.02) {
            if index == self.gameBoard.shuffleCount  {
                if self.gameBoard.isSolved() {
                    // the shuffling resulted in a solved board - restart
                    print("the shuffling resulted in a solved board - restart")
                    self.shuffle(index: 0, complete: complete)
                } else {
                    print("shuffling complete!")
                    complete?()
                }
            } else {
                print("shuffled \(index) times so far. keep going")
                self.shuffle(index: index + 1, complete: complete)
            }
        }
    }

    func animateSwap(_ tile1: Tile, _ tile2: Tile, duration: TimeInterval = 0.2, complete: (() -> Void)? = nil) {
        print("swapping \(tile1.targetCoordinate) with \(tile2.targetCoordinate) ")

        let t1originalFrame = tile1.frame
        let t2originalFrame = tile2.frame

        self.bringSubviewToFront(tile1)
        self.insertSubview(tile2, belowSubview: tile1)

        UIView.animate(withDuration: duration, animations: { () -> Void in
            tile1.frame = t2originalFrame
            tile2.frame = t1originalFrame

        }, completion: { (finished) -> Void in
            complete?()
        })
    }

    func swapLines(_ index1: Int, _ index2: Int, type: GripType) {
        let line1: [Tile]
        let line2: [Tile]
        switch type {
        case .column:
            line1 = self.gameBoard.lineOfTiles(column: index1)
            line2 = self.gameBoard.lineOfTiles(column: index2)
        case .row:
            line1 = self.gameBoard.lineOfTiles(row: index1)
            line2 = self.gameBoard.lineOfTiles(row: index2)
        }
        for (index, tile) in line1.enumerated() {
            self.gameBoard.swapCoordinates(tile, line2[index])
            self.animateSwap(tile, line2[index])
        }
        if self.gameBoard.isSolved() {
            self.gameBoard.setTiles(enabled: false)
            self.isPuzzleSolved = true
            self.delegate?.puzzleSolved()
        }
    }


    // MARK: ROTATIONS
    func rotateTiles() {
        for tile in self.gameBoard.singleArrayOfTiles {
            let orientation = TileOrientation(rawValue: Int.random(in: 1...TileOrientation.allCases.count))
            self.rotateTile(tile, orientation: orientation, duration: 0.5)
        }
    }
    
    func rotateTile(_ tile: Tile, orientation: TileOrientation? = nil, duration: TimeInterval, complete: (() -> Void)? = nil) {
        guard let orientation = orientation else {
            complete?()
            return
        }
        let rotation = CGFloat(Double.pi / 2) * orientation.degree()
        UIView.animate(withDuration: duration, animations: { () -> Void in
            tile.transform = CGAffineTransform(rotationAngle: rotation)
//            tile.orientationCount += 1
//            if tile.orientationCount == 5 {
//                tile.orientationCount = 1
//            }

            }, completion: { (finished) -> Void in
                complete?()
                tile.orientation = orientation
        })
    }
    
    
    func orientAllTiles() {
        for tile in self.gameBoard.singleArrayOfTiles {
            while tile.orientation != .zero {
                self.rotateTile(tile, orientation: .zero, duration: 0.5)
            }
        }
    }
    
    
    func showHintByWigglingTiles() {
        if
            let misplaced = self.gameBoard.findFirstMisplacedTile(),
            let correctTile = self.gameBoard.findTile(at: misplaced.targetCoordinate)
        {
            self.wiggleTile(misplaced)
            self.wiggleTile(correctTile)
        } else if let unoriented = self.gameBoard.findFirstUnorientedTile() {
            self.wiggleTile(unoriented)
        }
    }
    
    
    func wiggleTile(_ tile : Tile) {
        let NUM_WIGGLES: Int = 6
        let ANGLE = CGFloat(Double.pi / 15)
        let TOTAL_DURATION: TimeInterval = 0.5
        let relativeDuration = TOTAL_DURATION / 6
        UIView.animateKeyframes(withDuration: TOTAL_DURATION, delay: 0.0, options: [], animations: {
            for i in 0..<NUM_WIGGLES {
                let partialAngle: CGFloat
                if i == 0 {
                    partialAngle = ANGLE
                } else if i == NUM_WIGGLES - 1 {
                    partialAngle = -ANGLE
                } else if i % 2 == 1 {
                    partialAngle = -2 * ANGLE
                } else {
                    partialAngle = 2 * ANGLE
                }
                UIView.addKeyframe(
                    withRelativeStartTime: Double(i) / Double(NUM_WIGGLES),
                    relativeDuration: relativeDuration,
                    animations: {
                        tile.transform = tile.transform.rotated(by: partialAngle)
                    }
                )
            }
        }) { (done) in
                print("done wiggling")
        }
    }
        
}

extension TileAreaView: GameBoardDelegate {
    func swapTiles(_ tile1: Tile, _ tile2: Tile) {
        self.animateSwap(tile1, tile2) {
            if self.gameBoard.isSolved() {
                self.gameBoard.setTiles(enabled: false)
                self.isPuzzleSolved = true
                self.delegate?.puzzleSolved()
            }
        }
    }
}



//    func findTilesToSwap() {
//        self.firstTile = nil
//        self.secondTile = nil
//        for index1 in 0..<self.tilesPerRow {
//            for index2 in 0..<self.tilesPerRow {
//
//                // Iterate through the array to find the first spot with the wrong tile
//                // Then find the tile that should go there
//                let doubleIndex = DoubleIndex(index1: index1, index2: index2)
//                let currentTile = self.findTileAtCoordinate(doubleIndex)
//                let currentTag = currentTile.tag
//
//                if (currentTag / 10) != index1 || (currentTag % 10) != index2 {
//                    self.firstTile = currentTile
//                    self.secondTile = self.findTileWithTag(currentTile.doubleIndex.concatenateToInt())
//                    return
//                }
//            }
//        }
//    }
