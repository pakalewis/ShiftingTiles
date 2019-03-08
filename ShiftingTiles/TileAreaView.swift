//
//  TileAreaView.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 12/18/14.
//  Copyright (c) 2014 Parker Lewis. All rights reserved.
//


import UIKit

class TileAreaView: UIView {
    
    let userDefaults = UserDefaults.standard

    weak var delegate: PuzzleSolvedProtocol?
    
    // Set to true when puzzle is solved
    var isPuzzleSolved = false
    
    // Indicates whether tiles should be movable
    var allowTileShifting = true;
    
    // Image that the user selected to solve
    var imageToSolve = UIImage()

    // 2D array of Tiles
    var tileArray = [[Tile]]()

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
    func initialize() {
        
        let moveTilePanGesture = UIPanGestureRecognizer(target: self, action: #selector(TileAreaView.handleMoveTilePan(_:)))
        self.addGestureRecognizer(moveTilePanGesture)
        
        self.clipsToBounds = true
        
        self.createTileArray()
        self.layoutTiles()
        self.shuffleTiles()
        if userDefaults.bool(forKey: "rotationsOn") {
            self.rotateTiles()
        }
    }
    
    

    
    // The doubleIndex property helps monitor the tile's current coordinate. This gets swapped in swapTile()
    // The tag property on the Tile's imageView does not change. It is a way to determine where that tile should be positioned
    func createTileArray() {        
        // Image measurements
        let CGIWdith : CGFloat = CGFloat(self.imageToSolve.cgImage!.width)
        let imageWidth : CGFloat = CGFloat(CGIWdith / CGFloat(self.tilesPerRow))
        
        for index1 in 0..<self.tilesPerRow { // go down the rows
            // Make the row array of Tiles
            var rowArray = [Tile]()
            
            for index2 in 0..<self.tilesPerRow { // get the tiles in each row
                
                // Store the 2D array index as a tag on the view
                // This will help with determining which tile was tapped
                let doubleIndex = DoubleIndex(index1: index1, index2: index2)
                
                // Make a new tile with that doubleIndex
                let tile = Tile(doubleIndex: doubleIndex)
                tile.imageView.isUserInteractionEnabled = true;
                tile.imageView.tag = tile.doubleIndex.concatenateToInt()
                
                // Set the tile's frame
                let totalWidth = self.frame.width
                let tileFrame = CGRect(x: totalWidth / 2, y: totalWidth / 2, width: 0, height: 0)
                tile.imageView.frame = tileFrame

                // Add gesture recognizer for rotations
                let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(TileAreaView.tileDoubleTapped(_:)))
                doubleTapGesture.numberOfTapsRequired = 2
                tile.imageView.addGestureRecognizer(doubleTapGesture)
                
                
                // Create the image for the Tile
                let imagePositionY:CGFloat = CGFloat(index1) * (imageWidth)
                let imagePositionX:CGFloat = CGFloat(index2) * (imageWidth)
                let imageFrame = CGRect(x: imagePositionX, y: imagePositionY, width: imageWidth, height: imageWidth)
                let tileCGImage = self.imageToSolve.cgImage?.cropping(to: imageFrame)
                let tileUIImage = UIImage(cgImage: tileCGImage!)
                tile.imageSection = tileUIImage
                
                // Add the imageview to the tile area
                tile.imageView.image = tile.imageSection
                self.addSubview(tile.imageView)
                
                // Add to row array
                rowArray.append(tile)
            }
            
            // Add the row array to the tile area
            self.tileArray.append(rowArray)
        }
    }
    
    
    
    func layoutTiles() {

        // Tile measuerments
        let tileWidth:CGFloat  = (self.frame.width) / CGFloat(self.tilesPerRow)
        let tileHeight:CGFloat  = (self.frame.height) / CGFloat(self.tilesPerRow)
        
        for index1 in 0..<self.tilesPerRow { // go down the rows
            let tileAreaPositionY:CGFloat = CGFloat(index1) * (tileHeight)
            
            for index2 in 0..<self.tilesPerRow { // get the tiles in each row
                let tileAreaPositionX:CGFloat = CGFloat(index2) * (tileWidth)
                
                // set the boundaries of the tile
                let tileFrame = CGRect(x: tileAreaPositionX, y: tileAreaPositionY, width: tileWidth, height: tileHeight)
                
                // TODO: play around with this animation more
                // Update and animate the tile's frame
                UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: UIView.AnimationOptions(), animations: ({

                    self.tileArray[index1][index2].imageView.frame = tileFrame
                    
                }), completion: nil)
            }
        }
    }

    
    
    // MARK: SHUFFLING / SWAPPING
    func shuffleTiles() {

        // Swap random tiles a bunch of times
        for _ in 0...self.tilesPerRow * 20 {
            let randomInt1 = Int(arc4random_uniform(UInt32(self.tilesPerRow)))
            let randomInt2 = Int(arc4random_uniform(UInt32(self.tilesPerRow)))
            let randomInt3 = Int(arc4random_uniform(UInt32(self.tilesPerRow)))
            let randomInt4 = Int(arc4random_uniform(UInt32(self.tilesPerRow)))

            let tile1 = self.tileArray[randomInt1][randomInt2]
            let tile2 = self.tileArray[randomInt3][randomInt4]
            tile1.originalFrame = tile1.imageView.frame
            tile2.originalFrame = tile2.imageView.frame

            self.swapTiles(tile1, tile2: tile2, duration: 0.2, completionClosure: { () -> () in
            })
        }
        
        // Ensure that the puzzle is shuffled
        if self.checkIfSolved() {
            self.shuffleTiles()
        }
    }
    
    
    // Swap the images and tags when the second tile is tapped
    func swapTiles(_ tile1: Tile, tile2: Tile, duration: TimeInterval, completionClosure: @escaping () ->()) {
        if tile1.imageView.tag == tile2.imageView.tag {
            // tiles are the same so do nothing
            return
        } else {
            
            // Swap doubleindex
            let tempDoubleIndex = tile1.doubleIndex
            tile1.doubleIndex = tile2.doubleIndex
            tile2.doubleIndex = tempDoubleIndex
            
            self.insertSubview(tile2.imageView, belowSubview: tile1.imageView)
            
            UIView.animate(withDuration: duration, animations: { () -> Void in
                
                // Swap frames
                tile1.imageView.frame = tile2.originalFrame!
                tile2.imageView.frame = tile1.originalFrame!
                tile1.originalFrame = tile1.imageView.frame
                tile2.originalFrame = tile2.imageView.frame
                
                
                }, completion: { (finished) -> Void in
                    completionClosure()
            })
        }
    }
    
    
    func makeLineOfTiles(_ identifier: Int) -> [Tile] {
        var tileLine = [Tile]()
        
        // Create array of Tiles
        if (identifier - 100) < 0 { // Is a column
            for index in 0..<self.tilesPerRow {
                let coordinate = DoubleIndex(index1: index, index2: identifier)
                let tile = self.findTileAtCoordinate(coordinate)
                tile.originalFrame = tile.imageView.frame
                tileLine.append(tile)
            }
        } else { // Is a row
            for index in 0..<self.tilesPerRow {
                let coordinate = DoubleIndex(index1: identifier - 100, index2: index)
                let tile = self.findTileAtCoordinate(coordinate)
                tile.originalFrame = tile.imageView.frame
                tileLine.append(tile)
            }
        }
        return tileLine
    }

    
    func swapLines(_ line1: [Tile], line2: [Tile]) {
        // swap the tiles in the lines
        for counter in 0..<line1.count {
            self.swapTiles(line1[counter], tile2: line2[counter], duration: 0.3, completionClosure: { () -> () in
                
                if counter == line1.count - 1 {
                    if self.checkIfSolved() {
                        self.isPuzzleSolved = true
                        self.delegate?.puzzleIsSolved()
                    }
                }
            })
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
            
            tile.imageView.transform = CGAffineTransform(rotationAngle: rotation)
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
                tileToWiggle.imageView.transform = tileToWiggle.imageView.transform.rotated(by: fullRotation)
            })
            UIView.addKeyframe(withRelativeStartTime: 1/6, relativeDuration: relativeDuration, animations: {
                tileToWiggle.imageView.transform = tileToWiggle.imageView.transform.rotated(by: -2 * fullRotation)
            })
            UIView.addKeyframe(withRelativeStartTime: 2/6, relativeDuration: relativeDuration, animations: {
                tileToWiggle.imageView.transform = tileToWiggle.imageView.transform.rotated(by: 2 * fullRotation)
            })
            UIView.addKeyframe(withRelativeStartTime: 3/6, relativeDuration: relativeDuration, animations: {
                tileToWiggle.imageView.transform = tileToWiggle.imageView.transform.rotated(by: -2 * fullRotation)
            })
            UIView.addKeyframe(withRelativeStartTime: 4/6, relativeDuration: relativeDuration, animations: {
                tileToWiggle.imageView.transform = tileToWiggle.imageView.transform.rotated(by: 2 * fullRotation)
            })
            UIView.addKeyframe(withRelativeStartTime: 5/6, relativeDuration: relativeDuration, animations: {
                tileToWiggle.imageView.transform = tileToWiggle.imageView.transform.rotated(by: -fullRotation)
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
                    self.bringSubviewToFront(self.firstTile!.imageView)
                    self.firstTile!.originalFrame = self.firstTile!.imageView.frame
                }
            case .changed:
                if self.firstTile != nil {
                    let translation = gesture.translation(in: self)
                    self.firstTile!.imageView.center.x = self.firstTile!.imageView.center.x + translation.x
                    self.firstTile!.imageView.center.y = self.firstTile!.imageView.center.y + translation.y
                    gesture.setTranslation(CGPoint.zero, in: self)
                }
            case .ended:
                if self.firstTile != nil {
                    let endingPoint :CGPoint = gesture.location(in: self)
                    if self.findTileWithPoint(endingPoint, searchingForFirst: false) {
                        self.secondTile = self.foundTileWithPoint!
                        self.secondTile!.originalFrame = self.secondTile!.imageView.frame
                        self.swapTiles(self.firstTile!, tile2: self.secondTile!, duration: 0.3, completionClosure: { () -> () in
                            // Swap the tiles and then check if the puzzle is solved
                            if self.checkIfSolved() {
                                // Notify GameScreen
                                self.isPuzzleSolved = true
                                self.delegate?.puzzleIsSolved()
                            }
                        })
                    } else {
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            self.firstTile!.imageView.frame = self.firstTile!.originalFrame!
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
            if userDefaults.bool(forKey: "rotationsOn") {
                // Grab the tag of the tile that was tapped and use it to find the correct tile
                let tag = sender.view!.tag
                let pressedTile = self.tileArray[tag / 10][tag % 10]
                self.rotateTile(pressedTile, duration: 0.3, completionClosure: { () -> () in
                    // Rotate the tile and then check if the puzzle is solved
                    if self.checkIfSolved() {
                        // Notify GameScreen
                        self.isPuzzleSolved = true
                        self.delegate?.puzzleIsSolved()
                    }
                })
            }
        }
    }


    
    
    // MARK: TILE EXAMINATION
    // Checks to see if the image pieces are in the correct order and if the orientations are correct
    func checkIfSolved() -> Bool {
        for index1 in 0..<self.tilesPerRow {
            for index2 in 0..<self.tilesPerRow {
                let tileToCheck = self.tileArray[index1][index2]
                if (tileToCheck.doubleIndex.rowIndex != index1
                    || tileToCheck.doubleIndex.columnIndex != index2
                    || tileToCheck.orientationCount != 1) {
                        return false
                }
            }
        }
        return true
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
                let currentTag = currentTile.imageView.tag
                
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
                if (tile.imageView.tag == tag) {
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
                if self.foundTileWithPoint!.imageView.frame.contains(point) {
                    if searchingForFirst {
                        return true
                    } else { // searching for second tile
                        if self.foundTileWithPoint?.imageView.tag != self.firstTile?.imageView.tag {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
}

