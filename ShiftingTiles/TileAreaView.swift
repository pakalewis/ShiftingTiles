//
//  TileAreaView.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 12/18/14.
//  Copyright (c) 2014 Parker Lewis. All rights reserved.
//


import UIKit

class TileAreaView: UIView {
    
    var delegate : PuzzleSolvedProtocol?
    
    var imageToSolve = UIImage()
    var tileArray = [[Tile]]()
    var tilesPerRow = 3
    var isPuzzleInitialized = false;
    
    var highlightedView = UIView()
    
    // For swapping
    var firstTileSelectedBool = true
    var firstTile : Tile?
    var secondTile : Tile?

    
    
    func initialize() {
        self.createTileArray()
        self.layoutTilesWithMargin(2)
        self.shuffleImages()

    }
    
    
    
    // The doubleIndex property helps monitor the tile's current coordinate. This gets swapped in swapTile()
    // The tag property on the Tile's imageView does not change. It is a way to determine where that tile should be positioned
    func createTileArray() {
        var arrayIndexConcatenation = 0
        
        // Image measurements
        var imageWidth:CGFloat = CGFloat(self.imageToSolve.size.width / CGFloat(self.tilesPerRow))

        for index1 in 0..<self.tilesPerRow { // go down the rows
            // Make the row array of Tiles
            var rowArray = [Tile]()
            
            for index2 in 0..<self.tilesPerRow { // get the tiles in each row
                
                // Store the 2D array index as a tag on the view
                // This will help with determining the correct tap gesture
                var doubleIndex = DoubleIndex(index1: index1, index2: index2)
                
                // Make a new tile with that doubleIndex
                var tile = Tile(doubleIndex: doubleIndex)
                tile.imageView.userInteractionEnabled = true;
                tile.imageView.tag = tile.doubleIndex.concatenateToInt()

                var totalWidth = self.frame.width
                var tileFrame = CGRectMake(totalWidth / 2, totalWidth / 2, 0, 0)
                tile.imageView.frame = tileFrame

                //Add gesture recognizer
                let tapGesture = UITapGestureRecognizer(target: self, action: "tileTapped:")
                tile.imageView.addGestureRecognizer(tapGesture)
                
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
    
    
    
    
    func layoutTilesWithMargin(margin:CGFloat) {

        // Tile measuerments
        var totalWidth = self.frame.width
        var totalMargin = CGFloat(margin * CGFloat(self.tilesPerRow - 1))
        var tileWidth:CGFloat  = (totalWidth - totalMargin) / CGFloat(self.tilesPerRow)
        
        for index1 in 0..<self.tilesPerRow { // go down the rows
            var tileAreaPositionY:CGFloat = CGFloat(index1) * (tileWidth + margin)
            
            for index2 in 0..<self.tilesPerRow { // get the tiles in each row
                var tileAreaPositionX:CGFloat = CGFloat(index2) * (tileWidth + margin)
                
                // set the boundaries of the tile
                var tileFrame = CGRectMake(tileAreaPositionX, tileAreaPositionY, tileWidth, tileWidth)
                
                // TODO: play around with this animation more
                // Update and animate the tile's frame
                UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({

                    self.tileArray[index1][index2].imageView.frame = tileFrame
                    
                }), completion: nil)
            }
        }
    }
    
    
 
    func shuffleImages() {

        // Swap random tiles a bunch of times
        for index in 0...self.tilesPerRow * 10 {
            var randomInt1 = Int(arc4random_uniform(UInt32(self.tilesPerRow)))
            var randomInt2 = Int(arc4random_uniform(UInt32(self.tilesPerRow)))
            var randomInt3 = Int(arc4random_uniform(UInt32(self.tilesPerRow)))
            var randomInt4 = Int(arc4random_uniform(UInt32(self.tilesPerRow)))

            var tile1 = self.tileArray[randomInt1][randomInt2]
            var tile2 = self.tileArray[randomInt3][randomInt4]
            

            self.swapTiles(tile1, tile2: tile2, completionClosure: { () -> () in
            })
        }
        
        // Ensure that the puzzle is shuffled
        if self.checkIfSolved() {
            self.shuffleImages()
        }
    }
   
    
    func tileTapped(sender: UIGestureRecognizer) {
        // Grab the tag of the tile that was tapped and use it to find the correct tile
        var tag = sender.view!.tag
        var tappedTile = self.tileArray[tag / 10][tag % 10]
        
        // Check if it is the first or second tile tapped
        // Swap images and tags when
        if self.firstTileSelectedBool {

            // Add a subview behind the tapped tile to indicate that it was selected
            var tileFrame = tappedTile.imageView.frame
            var highlightedViewFrame = CGRectMake(tileFrame.origin.x - 2, tileFrame.origin.y - 2, tileFrame.width + 4, tileFrame.height + 4)
            self.highlightedView = UIView(frame: highlightedViewFrame)
            self.highlightedView.backgroundColor = UIColor.blackColor()
            self.addSubview(self.highlightedView)
            self.sendSubviewToBack(self.highlightedView)
            
//            
//            var oldtileFrame = tappedTile.imageView.frame
//            var centerpoint = tappedTile.imageView.center
//            var biggerTileFrame = CGRectMake(oldtileFrame.origin.x, oldtileFrame.origin.y, oldtileFrame.width * 1.1, oldtileFrame.height * 1.1)
//            tappedTile.imageView.frame = biggerTileFrame
//            tappedTile.imageView.center = centerpoint
//            self.bringSubviewToFront(tappedTile.imageView)
//            
//            UIView.animateWithDuration(0.2, animations: { () -> Void in
//                self.layoutIfNeeded()
//            })
//            

            
            
            
            // Store the first tapped tile for later use
            var tile1 = self.tileArray[tag / 10][tag % 10]
            self.firstTile = tile1
            self.firstTileSelectedBool = false
        } else {
            // Remove the temporary highlighting
            self.highlightedView.removeFromSuperview()
            
            // Store the second tapped tile for later use
            var tile2 = self.tileArray[tag / 10][tag % 10]
            self.secondTile = tile2
            self.firstTileSelectedBool = true

            self.swapTiles(self.firstTile!, tile2: self.secondTile!, completionClosure: { () -> () in
                // Swap the tiles and then check if the puzzle is solved
                if self.checkIfSolved() {
                    // Notify GameScreen
                    self.delegate!.puzzleIsSolved()
                }
            })
        
        }
    }
    
    
    
    // Swap the images and tags when the second tile is tapped
    func swapTiles(tile1: Tile, tile2: Tile, completionClosure: () ->()) {
        
        if tile1.imageView.tag == tile2.imageView.tag {
            // tiles are the same so do nothing
            return
        } else {
            
            // Swap doubleindex
            var tempDoubleIndex = tile1.doubleIndex
            tile1.doubleIndex = tile2.doubleIndex
            tile2.doubleIndex = tempDoubleIndex

            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                // Swap frames
                var firstFrame = tile1.imageView.frame
                tile1.imageView.frame = tile2.imageView.frame
                tile2.imageView.frame = firstFrame

                }, completion: { (finished) -> Void in
                completionClosure()
            })
        }
    }
    
    
    
    func swapLines(line1: Int, line2: Int) {

        var tileLine1 = [Tile]()
        var tileLine2 = [Tile]()

        // Create arrau of Tiles in line1
        if (line1 - 100) < 0 { // line 1 is a column
            for index in 0..<self.tilesPerRow {
                var coordinate = DoubleIndex(index1: index, index2: line1)
                var tile = self.findTileAtCoordinate(coordinate)
                tileLine1.append(tile)
            }
        } else { // line1 is a row
            for index in 0..<self.tilesPerRow {
                var coordinate = DoubleIndex(index1: line1 - 100, index2: index)
                var tile = self.findTileAtCoordinate(coordinate)
                tileLine1.append(tile)
            }
        }
        
        
        // Create arrau of Tiles in line2
        if (line2 - 100) < 0 { // line2 is a column
            for index in 0..<self.tilesPerRow {
                var coordinate = DoubleIndex(index1: index, index2: line2)
                var tile = self.findTileAtCoordinate(coordinate)
                tileLine2.append(tile)
            }
        } else { // line2 is a row
            for index in 0..<self.tilesPerRow {
                var coordinate = DoubleIndex(index1: line2 - 100, index2: index)
                var tile = self.findTileAtCoordinate(coordinate)
                tileLine2.append(tile)
            }
        }

        
        // swap the tiles in the lines
        for counter in 0..<tileLine1.count {
            self.swapTiles(tileLine1[counter], tile2: tileLine2[counter], completionClosure: { () -> () in

                if counter == tileLine1.count - 1 {
                    if self.checkIfSolved() {
                        // Notify GameScreen
                        self.delegate!.puzzleIsSolved()
                    }
                }
            })
        }
    }
    
    
    
    
//    // checks to see if the image pieces are in the correct order
    func checkIfSolved() -> Bool {

        for index1 in 0..<self.tilesPerRow {
            for index2 in 0..<self.tilesPerRow {
                var doubleIndex = self.tileArray[index1][index2].doubleIndex

                if (doubleIndex.rowIndex) != index1 || (doubleIndex.columnIndex) != index2 {
                    return false
                }
            }
        }
        
        // If it makes it through this loop then the puzzle is solved
        return true
    }

    
    func findTilesToSwap() {
        for index1 in 0..<self.tilesPerRow {
            for index2 in 0..<self.tilesPerRow {
                
                // Iterate through the array to find the first spot with the wrong tile
                // Then find the tile that should go there and wiggle both of them
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

    
    func wiggleTile(tileToWiggle : Tile) {
        // Animation calculations
        let fullRotation = CGFloat(M_PI * 2) / 72
        let duration = 0.7
        let relativeDuration = duration / 6
        let options = UIViewKeyframeAnimationOptions.CalculationModeLinear
        UIView.animateKeyframesWithDuration(duration, delay: 0.0, options: nil, animations: {
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: relativeDuration, animations: {
                tileToWiggle.imageView.transform = CGAffineTransformMakeRotation(fullRotation)
                
            })
            UIView.addKeyframeWithRelativeStartTime(1/6, relativeDuration: relativeDuration, animations: {
                tileToWiggle.imageView.transform = CGAffineTransformMakeRotation(-fullRotation)
            })
            UIView.addKeyframeWithRelativeStartTime(2/6, relativeDuration: relativeDuration, animations: {
                tileToWiggle.imageView.transform = CGAffineTransformMakeRotation(fullRotation)
            })
            UIView.addKeyframeWithRelativeStartTime(3/6, relativeDuration: relativeDuration, animations: {
                tileToWiggle.imageView.transform = CGAffineTransformMakeRotation(-fullRotation)
            })
            UIView.addKeyframeWithRelativeStartTime(4/6, relativeDuration: relativeDuration, animations: {
                tileToWiggle.imageView.transform = CGAffineTransformMakeRotation(fullRotation)
            })
            UIView.addKeyframeWithRelativeStartTime(5/6, relativeDuration: relativeDuration, animations: {
                tileToWiggle.imageView.transform = CGAffineTransformMakeRotation(0)
            })

            }, completion: {finished in
                
        })
        
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

}

