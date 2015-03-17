//
//  TileAreaView.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 12/18/14.
//  Copyright (c) 2014 Parker Lewis. All rights reserved.
//


import UIKit

class TileAreaView: UIView {
    
    let userDefaults = NSUserDefaults.standardUserDefaults()

    // MARK: VARS
    // Enables this class to notify the GameScreen when the puzzle is solved
    var delegate : PuzzleSolvedProtocol?
    
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
        
        let moveTilePanGesture = UIPanGestureRecognizer(target: self, action: "handleMoveTilePan:")
        self.addGestureRecognizer(moveTilePanGesture)
        
        self.clipsToBounds = true
        
        self.createTileArray()
        self.layoutTiles()
        self.shuffleTiles()
        if userDefaults.boolForKey("rotationsOn") {
            self.rotateTiles()
        }
    }
    
    

    
    // The doubleIndex property helps monitor the tile's current coordinate. This gets swapped in swapTile()
    // The tag property on the Tile's imageView does not change. It is a way to determine where that tile should be positioned
    func createTileArray() {
        var arrayIndexConcatenation = 0
        
        // Image measurements
        var CGIWdith : CGFloat = CGFloat(CGImageGetWidth(self.imageToSolve.CGImage))
        var imageWidth : CGFloat = CGFloat(CGIWdith / CGFloat(self.tilesPerRow))
        
        for index1 in 0..<self.tilesPerRow { // go down the rows
            // Make the row array of Tiles
            var rowArray = [Tile]()
            
            for index2 in 0..<self.tilesPerRow { // get the tiles in each row
                
                // Store the 2D array index as a tag on the view
                // This will help with determining which tile was tapped
                var doubleIndex = DoubleIndex(index1: index1, index2: index2)
                
                // Make a new tile with that doubleIndex
                var tile = Tile(doubleIndex: doubleIndex)
                tile.imageView.userInteractionEnabled = true;
                tile.imageView.tag = tile.doubleIndex.concatenateToInt()
                
                // Set the tile's frame
                var totalWidth = self.frame.width
                var tileFrame = CGRectMake(totalWidth / 2, totalWidth / 2, 0, 0)
                tile.imageView.frame = tileFrame

                // Add gesture recognizer for rotations
                let doubleTapGesture = UITapGestureRecognizer(target: self, action: "tileDoubleTapped:")
                doubleTapGesture.numberOfTapsRequired = 2
                tile.imageView.addGestureRecognizer(doubleTapGesture)
                
                
                // Create the image for the Tile
                var imagePositionY:CGFloat = CGFloat(index1) * (imageWidth)
                var imagePositionX:CGFloat = CGFloat(index2) * (imageWidth)
                var imageFrame = CGRectMake(imagePositionX, imagePositionY, imageWidth, imageWidth)
                var tileCGImage = CGImageCreateWithImageInRect(self.imageToSolve.CGImage, imageFrame)
                var tileUIImage = UIImage(CGImage: tileCGImage)
                tile.imageSection = tileUIImage!
                
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
        var tileWidth:CGFloat  = (self.frame.width) / CGFloat(self.tilesPerRow)
        var tileHeight:CGFloat  = (self.frame.height) / CGFloat(self.tilesPerRow)
        
        for index1 in 0..<self.tilesPerRow { // go down the rows
            var tileAreaPositionY:CGFloat = CGFloat(index1) * (tileHeight)
            
            for index2 in 0..<self.tilesPerRow { // get the tiles in each row
                var tileAreaPositionX:CGFloat = CGFloat(index2) * (tileWidth)
                
                // set the boundaries of the tile
                var tileFrame = CGRectMake(tileAreaPositionX, tileAreaPositionY, tileWidth, tileHeight)
                
                // TODO: play around with this animation more
                // Update and animate the tile's frame
                UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({

                    self.tileArray[index1][index2].imageView.frame = tileFrame
                    
                }), completion: nil)
            }
        }
    }

    
    
    // MARK: SHUFFLING / SWAPPING
    func shuffleTiles() {

        // Swap random tiles a bunch of times
        for index in 0...self.tilesPerRow * 20 {
            var randomInt1 = Int(arc4random_uniform(UInt32(self.tilesPerRow)))
            var randomInt2 = Int(arc4random_uniform(UInt32(self.tilesPerRow)))
            var randomInt3 = Int(arc4random_uniform(UInt32(self.tilesPerRow)))
            var randomInt4 = Int(arc4random_uniform(UInt32(self.tilesPerRow)))

            var tile1 = self.tileArray[randomInt1][randomInt2]
            var tile2 = self.tileArray[randomInt3][randomInt4]
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
    func swapTiles(tile1: Tile, tile2: Tile, duration: NSTimeInterval, completionClosure: () ->()) {
        if tile1.imageView.tag == tile2.imageView.tag {
            // tiles are the same so do nothing
            return
        } else {
            
            // Swap doubleindex
            var tempDoubleIndex = tile1.doubleIndex
            tile1.doubleIndex = tile2.doubleIndex
            tile2.doubleIndex = tempDoubleIndex
            
            self.insertSubview(tile2.imageView, belowSubview: tile1.imageView)
            
            UIView.animateWithDuration(duration, animations: { () -> Void in
                
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
    
    
    func makeLineOfTiles(identifier: Int) -> [Tile] {
        var tileLine = [Tile]()
        
        // Create array of Tiles
        if (identifier - 100) < 0 { // Is a column
            for index in 0..<self.tilesPerRow {
                var coordinate = DoubleIndex(index1: index, index2: identifier)
                var tile = self.findTileAtCoordinate(coordinate)
                tile.originalFrame = tile.imageView.frame
                tileLine.append(tile)
            }
        } else { // Is a row
            for index in 0..<self.tilesPerRow {
                var coordinate = DoubleIndex(index1: identifier - 100, index2: index)
                var tile = self.findTileAtCoordinate(coordinate)
                tile.originalFrame = tile.imageView.frame
                tileLine.append(tile)
            }
        }
        return tileLine
    }

    
    func swapLines(line1: [Tile], line2: [Tile]) {
        // swap the tiles in the lines
        for counter in 0..<line1.count {
            self.swapTiles(line1[counter], tile2: line2[counter], duration: 0.3, completionClosure: { () -> () in
                
                if counter == line1.count - 1 {
                    if self.checkIfSolved() {
                        // Notify GameScreen
                        self.isPuzzleSolved = true
                        self.delegate!.puzzleIsSolved()
                    }
                }
            })
        }
    }
    
    
    

    // MARK: ROTATIONS
    func rotateTiles() {
        // Rotate random tiles a bunch of times
        for index in 0...self.tilesPerRow * 10 {
            var randomInt1 = Int(arc4random_uniform(UInt32(self.tilesPerRow)))
            var randomInt2 = Int(arc4random_uniform(UInt32(self.tilesPerRow)))
            
            var tileToRotate = self.tileArray[randomInt1][randomInt2]
            
            self.rotateTile(tileToRotate, duration: 0.6, completionClosure: { () -> () in
            })
        }
    }
    
    
    func rotateTile(tile: Tile, duration: NSTimeInterval, completionClosure: () ->()) {
        // Animation calculations
        let rotation = CGFloat(M_PI) * (tile.orientationCount / 2)
        UIView.animateWithDuration(duration, animations: { () -> Void in
            
            tile.imageView.transform = CGAffineTransformMakeRotation(rotation)
            tile.orientationCount++
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
                var doubleIndex = DoubleIndex(index1: index1, index2: index2)
                var currentTile = self.findTileAtCoordinate(doubleIndex)
                
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
    
    
    func wiggleTile(tileToWiggle : Tile) {
        // Animation calculations
        let fullRotation = CGFloat(M_PI * 2) / 30
        let duration = 0.7
        let relativeDuration = duration / 6
        let options = UIViewKeyframeAnimationOptions.CalculationModeLinear
        UIView.animateKeyframesWithDuration(duration, delay: 0.0, options: nil, animations: {
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: relativeDuration, animations: {
                tileToWiggle.imageView.transform = CGAffineTransformRotate(tileToWiggle.imageView.transform, fullRotation)
            })
            UIView.addKeyframeWithRelativeStartTime(1/6, relativeDuration: relativeDuration, animations: {
                tileToWiggle.imageView.transform = CGAffineTransformRotate(tileToWiggle.imageView.transform, -2 * fullRotation)
            })
            UIView.addKeyframeWithRelativeStartTime(2/6, relativeDuration: relativeDuration, animations: {
                tileToWiggle.imageView.transform = CGAffineTransformRotate(tileToWiggle.imageView.transform, 2 * fullRotation)
            })
            UIView.addKeyframeWithRelativeStartTime(3/6, relativeDuration: relativeDuration, animations: {
                tileToWiggle.imageView.transform = CGAffineTransformRotate(tileToWiggle.imageView.transform, -2 * fullRotation)
            })
            UIView.addKeyframeWithRelativeStartTime(4/6, relativeDuration: relativeDuration, animations: {
                tileToWiggle.imageView.transform = CGAffineTransformRotate(tileToWiggle.imageView.transform, 2 * fullRotation)
            })
            UIView.addKeyframeWithRelativeStartTime(5/6, relativeDuration: relativeDuration, animations: {
                tileToWiggle.imageView.transform = CGAffineTransformRotate(tileToWiggle.imageView.transform, -fullRotation)
            })
            
        }, completion: nil)
    }
        
    
    
    
    // MARK: INTERACTIONS
    func handleMoveTilePan(gesture:UIPanGestureRecognizer) {
        // Determine whether any tile movement should occur
        if !self.isPuzzleSolved && self.allowTileShifting {
            switch gesture.state {
            case .Began:
                var startingPoint :CGPoint = gesture.locationInView(self)
                if self.findTileWithPoint(startingPoint, searchingForFirst: true) {
                    self.firstTile = self.foundTileWithPoint!
                    self.bringSubviewToFront(self.firstTile!.imageView)
                    self.firstTile!.originalFrame = self.firstTile!.imageView.frame
                }
            case .Changed:
                if self.firstTile != nil {
                    let translation = gesture.translationInView(self)
                    self.firstTile!.imageView.center.x = self.firstTile!.imageView.center.x + translation.x
                    self.firstTile!.imageView.center.y = self.firstTile!.imageView.center.y + translation.y
                    gesture.setTranslation(CGPointZero, inView: self)
                }
            case .Ended:
                if self.firstTile != nil {
                    var endingPoint :CGPoint = gesture.locationInView(self)
                    if self.findTileWithPoint(endingPoint, searchingForFirst: false) {
                        self.secondTile = self.foundTileWithPoint!
                        self.secondTile!.originalFrame = self.secondTile!.imageView.frame
                        self.swapTiles(self.firstTile!, tile2: self.secondTile!, duration: 0.3, completionClosure: { () -> () in
                            // Swap the tiles and then check if the puzzle is solved
                            if self.checkIfSolved() {
                                // Notify GameScreen
                                self.isPuzzleSolved = true
                                self.delegate!.puzzleIsSolved()
                            }
                        })
                    } else {
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            self.firstTile!.imageView.frame = self.firstTile!.originalFrame!
                        })
                    }
                }
            case .Possible:
                println("possible")
            case .Cancelled:
                println("cancelled")
            case .Failed:
                println("failed")
            }
        }
    }

    
    func tileDoubleTapped(sender: UIGestureRecognizer) {
        // Determine whether any tile movement should occur
        if !self.isPuzzleSolved && self.allowTileShifting {
            if userDefaults.boolForKey("rotationsOn") {
                // Grab the tag of the tile that was tapped and use it to find the correct tile
                var tag = sender.view!.tag
                var pressedTile = self.tileArray[tag / 10][tag % 10]
                self.rotateTile(pressedTile, duration: 0.3, completionClosure: { () -> () in
                    // Rotate the tile and then check if the puzzle is solved
                    if self.checkIfSolved() {
                        // Notify GameScreen
                        self.isPuzzleSolved = true
                        self.delegate!.puzzleIsSolved()
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
                var tileToCheck = self.tileArray[index1][index2]
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
                var doubleIndex = DoubleIndex(index1: index1, index2: index2)
                var currentTile = self.findTileAtCoordinate(doubleIndex)
                var currentTag = currentTile.imageView.tag
                
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
                var doubleIndex = DoubleIndex(index1: index1, index2: index2)
                var currentTile = self.findTileAtCoordinate(doubleIndex)
                
                if currentTile.orientationCount != 1 {
                    self.firstUnorientedTile = currentTile
                    return
                }
            }
        }
    }

    
    func findTileAtCoordinate(coordinate: DoubleIndex) -> Tile {
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
    
    
    func findTileWithTag(tag: Int) -> Tile {

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


    func findTileWithPoint(point: CGPoint, searchingForFirst : Bool) -> Bool {
        for index1 in 0..<self.tilesPerRow {
            for index2 in 0..<self.tilesPerRow {
                self.foundTileWithPoint = self.tileArray[index1][index2]
                if CGRectContainsPoint(self.foundTileWithPoint!.imageView.frame, point) {
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

