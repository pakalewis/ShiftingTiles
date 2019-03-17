//
//  TileAreaView.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 12/18/14.
//  Copyright (c) 2014 Parker Lewis. All rights reserved.
//


import UIKit

class TileAreaView: UIView {
    
    weak var delegate: PuzzleSolvedProtocol?
    
    // Set to true when puzzle is solved
    var isPuzzleSolved = false
    
    // Indicates whether tiles should be movable
    var allowTileShifting = true;

    let gameBoard: GameBoard

    // 2D array of Tiles
    var tileArray = [[Tile]]()
    var newTileArray = [Tile]()

    // Number of rows and columns in the puzzle
    var tilesPerRow = 3
    
    // This is a temporary view that appears as a black border around the selected tile
    var highlightedView = UIView()
    
    // Vars for the tiles to be swapped
    var foundTileWithPoint : Tile?
    var firstTile : Tile?
    var secondTile : Tile?

    var firstUnorientedTile: Tile?
    
    // MARK: SETUP
    init(gameBoard: GameBoard, frame: CGRect) {
        print("initialize game board")

        self.gameBoard = gameBoard
        super.init(frame: frame)

        self.gameBoard.delegate = self

        self.layer.borderWidth = 2
        self.clipsToBounds = true


        self.tileArray = gameBoard.createTiles(in: self)

//        let moveTilePanGesture = UIPanGestureRecognizer(target: self, action: #selector(TileAreaView.handleMoveTilePan(_:)))
//        self.addGestureRecognizer(moveTilePanGesture)


        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.shuffle(index: 0)
        }

        if UserSettings.boolValue(for: .rotations) {
            self.rotateTiles()
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

        self.animateSwap(randomTiles.tile1, tile2: randomTiles.tile2, duration: 0.02) {
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


    func animateSwap(_ tile1: Tile, tile2: Tile, duration: TimeInterval = 0.2, complete: (() -> Void)? = nil) {
        print("swapping \(tile1.targetCoordinate) with \(tile2.targetCoordinate) ")

        let t1originalFrame = tile1.frame
        let t2originalFrame = tile2.frame

        // Swap coordinate
        let tempCoordinate = tile1.currentCoordinate
        tile1.currentCoordinate = tile2.currentCoordinate
        tile2.currentCoordinate = tempCoordinate

        self.insertSubview(tile2, belowSubview: tile1)

        UIView.animate(withDuration: duration, animations: { () -> Void in
            tile1.frame = t2originalFrame
            tile2.frame = t1originalFrame

        }, completion: { (finished) -> Void in
            complete?()
        })
    }
    
    
    func makeLineOfTiles(_ identifier: Int) -> [Tile] {
        var tileLine = [Tile]()
        
        // Create array of Tiles
        if (identifier - 100) < 0 { // Is a column
            for index in 0..<self.tilesPerRow {
                let coordinate = DoubleIndex(index1: index, index2: identifier)
                let tile = self.findTileAtCoordinate(coordinate)
                tile.originalFrame = tile.frame
                tileLine.append(tile)
            }
        } else { // Is a row
            for index in 0..<self.tilesPerRow {
                let coordinate = DoubleIndex(index1: identifier - 100, index2: index)
                let tile = self.findTileAtCoordinate(coordinate)
                tile.originalFrame = tile.frame
                tileLine.append(tile)
            }
        }
        return tileLine
    }

    
    func swapLines(_ line1: [Tile], line2: [Tile]) {
        // swap the tiles in the lines
        for counter in 0..<line1.count {
            self.animateSwap(line1[counter], tile2: line2[counter]) {
                if counter == line1.count - 1 {
                    if self.gameBoard.isSolved() {
                        self.isPuzzleSolved = true
                        self.delegate?.puzzleIsSolved()
                    }
                }
            }
        }
    }
    
    
    

    // MARK: ROTATIONS
    func rotateTiles() {
        // Rotate random tiles a bunch of times
        for _ in 0...self.tilesPerRow * 10 {
            let randomInt1 = Int(arc4random_uniform(UInt32(self.tilesPerRow)))
            let randomInt2 = Int(arc4random_uniform(UInt32(self.tilesPerRow)))
            
            let tileToRotate = self.tileArray[randomInt1][randomInt2]
            
            self.rotateTile(tileToRotate, duration: 0.6, completionClosure: { () -> () in
            })
        }
    }
    
    
    func rotateTile(_ tile: Tile, duration: TimeInterval, completionClosure: @escaping () ->()) {
        // Animation calculations
        let rotation = CGFloat(M_PI) * (tile.orientationCount / 2)
        UIView.animate(withDuration: duration, animations: { () -> Void in
            
            tile.transform = CGAffineTransform(rotationAngle: rotation)
            tile.orientationCount += 1
            if tile.orientationCount == 5 {
                tile.orientationCount = 1
            }
            
            }, completion: { (finished) -> Void in
                completionClosure()
        })
    }
    
    
    func orientAllTiles() {
        for index1 in 0..<self.tilesPerRow {
            for index2 in 0..<self.tilesPerRow {
                
                // Iterate through the array to find the first spot with an unoriented tile
                let doubleIndex = DoubleIndex(index1: index1, index2: index2)
                let currentTile = self.findTileAtCoordinate(doubleIndex)
                
                while currentTile.orientationCount != 1 {
                    self.rotateTile(currentTile, duration: 1.0, completionClosure: { () -> () in
                    })
                }
            }
        }
    }
    
    
    func wiggleTiles() {
        self.findTilesToSwap()
        if self.firstTile != nil && self.secondTile != nil {
            // Tiles are not in correct order
            self.wiggleTile(self.firstTile!)
            self.wiggleTile(self.secondTile!)
        } else {
            self.findFirstUnorientedTile()
            self.wiggleTile(self.firstUnorientedTile!)
        }
    }
    
    
    func wiggleTile(_ tileToWiggle : Tile) {
        // Animation calculations
        let fullRotation = CGFloat(M_PI * 2) / 30
        let duration = 0.7
        let relativeDuration = duration / 6
        let options = UIView.KeyframeAnimationOptions()
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: options, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: relativeDuration, animations: {
                tileToWiggle.transform = tileToWiggle.transform.rotated(by: fullRotation)
            })
            UIView.addKeyframe(withRelativeStartTime: 1/6, relativeDuration: relativeDuration, animations: {
                tileToWiggle.transform = tileToWiggle.transform.rotated(by: -2 * fullRotation)
            })
            UIView.addKeyframe(withRelativeStartTime: 2/6, relativeDuration: relativeDuration, animations: {
                tileToWiggle.transform = tileToWiggle.transform.rotated(by: 2 * fullRotation)
            })
            UIView.addKeyframe(withRelativeStartTime: 3/6, relativeDuration: relativeDuration, animations: {
                tileToWiggle.transform = tileToWiggle.transform.rotated(by: -2 * fullRotation)
            })
            UIView.addKeyframe(withRelativeStartTime: 4/6, relativeDuration: relativeDuration, animations: {
                tileToWiggle.transform = tileToWiggle.transform.rotated(by: 2 * fullRotation)
            })
            UIView.addKeyframe(withRelativeStartTime: 5/6, relativeDuration: relativeDuration, animations: {
                tileToWiggle.transform = tileToWiggle.transform.rotated(by: -fullRotation)
            })

        }) { (done) in
                print("done")
            
        }
    }
        
    
    
    
    // MARK: INTERACTIONS
    @objc func handleMoveTilePan(_ gesture:UIPanGestureRecognizer) {
        // Determine whether any tile movement should occur
        if !self.isPuzzleSolved && self.allowTileShifting {
            switch gesture.state {
            case .began:
                let startingPoint :CGPoint = gesture.location(in: self)
                if self.findTileWithPoint(startingPoint, searchingForFirst: true) {
                    self.firstTile = self.foundTileWithPoint!
                    self.bringSubviewToFront(self.firstTile!)
                    self.firstTile!.originalFrame = self.firstTile!.frame
                }
            case .changed:
                if self.firstTile != nil {
                    let translation = gesture.translation(in: self)
                    self.firstTile!.center.x = self.firstTile!.center.x + translation.x
                    self.firstTile!.center.y = self.firstTile!.center.y + translation.y
                    gesture.setTranslation(CGPoint.zero, in: self)
                }
            case .ended:
                if self.firstTile != nil {
                    let endingPoint :CGPoint = gesture.location(in: self)
                    if self.findTileWithPoint(endingPoint, searchingForFirst: false) {
                        self.secondTile = self.foundTileWithPoint!
                        self.secondTile!.originalFrame = self.secondTile!.frame
                        self.animateSwap(self.firstTile!, tile2: self.secondTile!) {
                            // Swap the tiles and then check if the puzzle is solved
                            if self.gameBoard.isSolved() {
                                // Notify GameScreen
                                self.isPuzzleSolved = true
                                self.delegate?.puzzleIsSolved()
                            }
                        }
                    } else {
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            self.firstTile!.frame = self.firstTile!.originalFrame!
                        })
                    }
                }
            case .possible:
                print("possible")
            case .cancelled:
                print("cancelled")
            case .failed:
                print("failed")
            }
        }
    }

    
    @objc func tileDoubleTapped(_ sender: UIGestureRecognizer) {
        // Determine whether any tile movement should occur
        if !self.isPuzzleSolved && self.allowTileShifting {
            if UserSettings.boolValue(for: .rotations) {
                 //   Grab the tag of the tile that was tapped and use it to find the correct tile
                let tag = sender.view!.tag
                let pressedTile = self.tileArray[tag / 10][tag % 10]
                self.rotateTile(pressedTile, duration: 0.3, completionClosure: { () -> () in
                    // Rotate the tile and then check if the puzzle is solved
                    if self.gameBoard.isSolved() {
                        // Notify GameScreen
                        self.isPuzzleSolved = true
                        self.delegate?.puzzleIsSolved()
                    }
                })
            }
        }
    }


    func findTilesToSwap() {
        self.firstTile = nil
        self.secondTile = nil
        for index1 in 0..<self.tilesPerRow {
            for index2 in 0..<self.tilesPerRow {
                
                // Iterate through the array to find the first spot with the wrong tile
                // Then find the tile that should go there
                let doubleIndex = DoubleIndex(index1: index1, index2: index2)
                let currentTile = self.findTileAtCoordinate(doubleIndex)
                let currentTag = currentTile.tag
                
                if (currentTag / 10) != index1 || (currentTag % 10) != index2 {
                    self.firstTile = currentTile
                    self.secondTile = self.findTileWithTag(currentTile.doubleIndex.concatenateToInt())
                    return
                }
            }
        }
    }
    

    func findFirstUnorientedTile() {
        self.firstUnorientedTile = nil
        for index1 in 0..<self.tilesPerRow {
            for index2 in 0..<self.tilesPerRow {
                
                // Iterate through the array to find the first spot with an unoriented tile
                let doubleIndex = DoubleIndex(index1: index1, index2: index2)
                let currentTile = self.findTileAtCoordinate(doubleIndex)
                
                if currentTile.orientationCount != 1 {
                    self.firstUnorientedTile = currentTile
                    return
                }
            }
        }
    }

    func tile(at coordinate: Coordinate) -> Tile? {
        return self.newTileArray.first(where: { $0.targetCoordinate == coordinate } )
    }

    func findTileAtCoordinate(_ coordinate: DoubleIndex) -> Tile {
        var tile = self.tileArray[0][0]
        for index1 in 0..<self.tilesPerRow {
            for index2 in 0..<self.tilesPerRow {
                tile = self.tileArray[index1][index2]
                if (tile.doubleIndex.rowIndex == coordinate.rowIndex && tile.doubleIndex.columnIndex == coordinate.columnIndex) {
                    return tile
                }
            }
        }
        return tile
    }
    
    
    func findTileWithTag(_ tag: Int) -> Tile {

        var tile = self.tileArray[0][0]
        for index1 in 0..<self.tilesPerRow {
            for index2 in 0..<self.tilesPerRow {
                tile = self.tileArray[index1][index2]
                if (tile.tag == tag) {
                    return tile
                }
            }
        }
        return tile
    }


    func findTileWithPoint(_ point: CGPoint, searchingForFirst : Bool) -> Bool {
        for index1 in 0..<self.tilesPerRow {
            for index2 in 0..<self.tilesPerRow {
                self.foundTileWithPoint = self.tileArray[index1][index2]
                if self.foundTileWithPoint!.frame.contains(point) {
                    if searchingForFirst {
                        return true
                    } else { // searching for second tile
                        if self.foundTileWithPoint?.tag != self.firstTile?.tag {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
}

extension TileAreaView: GameBoardDelegate {
    func swapTiles(_ tile1: Tile, _ tile2: Tile) {
        self.animateSwap(tile1, tile2: tile2) {
            if self.gameBoard.isSolved() {
                self.isPuzzleSolved = true
                self.delegate?.puzzleIsSolved()
            }
        }
    }
}
