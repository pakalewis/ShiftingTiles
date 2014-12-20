//
//  TileAreaView2.swift
//  TileGame
//
//  Created by Parker Lewis on 12/18/14.
//  Copyright (c) 2014 Parker Lewis. All rights reserved.
//


import UIKit

class TileAreaView2: UIView {
    
    var delegate : PuzzleSolvedProtocol?
    
    var imageToSolve = UIImage()
    var tilesPerRow = 3
    var firstTileSelectedBool = true
    var firstTile : Tile?
    var secondTile : Tile?
    var tileArray = [[Tile]]()
    var isPuzzleInitialized = false;
    var solved = false
    
    func initialize() {
        self.createTileArray()
        self.shuffleImages()
        
//        var margin = (self.frame.width / CGFloat(self.tilesPerRow)) * 0.0005
//        self.layoutTilesWithMargin((margin < 2) ? 2 : margin)
        self.layoutTilesWithMargin(2)
    }
    
    
    
    // Each Tile object holds a doubleIndex property which helps monitor the arrangement of the tiles
    // The tag property on the Tile's imageView is a way to determine the row/column for the tapped tile
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
//                println("tile xPOS = \(tileAreaPositionX) and tile yPOS = \(tileAreaPositionY)")
                
                // set the boundaries of the tile
                var tileFrame = CGRectMake(tileAreaPositionX, tileAreaPositionY, tileWidth, tileWidth)
                
                UIView.animateWithDuration(1.0, delay: 0.0, options: nil, animations: { () -> Void in

                    self.tileArray[index1][index2].imageView.frame = tileFrame

                    }, completion: nil)
            }
        }
    }
    
    
 
    func shuffleImages() {

        // Swap tiles a bunch of times
        for index in 0...self.tilesPerRow*8 {
            var randomInt1 = Int(arc4random_uniform(UInt32(self.tilesPerRow)))
            var randomInt2 = Int(arc4random_uniform(UInt32(self.tilesPerRow)))
            var randomInt3 = Int(arc4random_uniform(UInt32(self.tilesPerRow)))
            var randomInt4 = Int(arc4random_uniform(UInt32(self.tilesPerRow)))

            var tile1 = self.tileArray[randomInt1][randomInt2]
            var tile2 = self.tileArray[randomInt3][randomInt4]
            

            self.swapTiles(tile1, tile2: tile2, completionClosure: { () -> () in
            })
        }
    }
   
    
    func tileTapped(sender: UIGestureRecognizer) {
        // Grab the tag of the tile that was tapped
        var tag = sender.view!.tag
        
        println("You tapped the tile at ROW \(tag / 10) and COLUMN \(tag % 10)")
        println("The tag is \(tag)")
        
        // Check if it is the first or second tile tapped
        // Swap images and tags when
        if self.firstTileSelectedBool {
            println("FIRST TILE")
            var tile1 = self.tileArray[tag / 10][tag % 10]
            self.firstTile = tile1
            self.firstTileSelectedBool = false
        } else {
            println("SECOND TILE")
            var tile2 = self.tileArray[tag / 10][tag % 10]
            self.secondTile = tile2
            self.firstTileSelectedBool = true

            self.swapTiles(self.firstTile!, tile2: self.secondTile!, completionClosure: { () -> () in
                println("swap is done so now check")
                self.checkIfSolved()
            })
        
        }
    }
    
    
    
//    // Swap the images and tags when the second tile is tapped
    func swapTiles(tile1: Tile, tile2: Tile, completionClosure: () ->()) {
        
        if solved {
            return
        } else {
            // Animate the fade out
            UIView.animateWithDuration(0.15, delay: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                
                tile1.imageView.alpha = 0.5
                tile2.imageView.alpha = 0.5
                
                }) { (finished) -> Void in
                    
                    // Swap doubleindex
                    var tempDoubleIndex = tile1.doubleIndex
                    tile1.doubleIndex = tile2.doubleIndex
                    tile2.doubleIndex = tempDoubleIndex
                    
                    // Now animate the fade in
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        // TEST frame
                        var firstFrame = tile1.imageView.frame
                        tile1.imageView.frame = tile2.imageView.frame
                        tile2.imageView.frame = firstFrame
                        
                        tile1.imageView.alpha = 1
                        tile2.imageView.alpha = 1
                        
                        }) { (finished) -> Void in
                            completionClosure()
                    }
            }
        }
    }
    
    
    func swapLines(line1: Int, line2: Int) {
        println("line1 is \(line1) and line 2 is \(line2)")
        
        self.displayTagsFromTileArray()
        
        if line1 == line2 {
            // do nothing
            println("do nothing")
            return
        }

        var tileLine1 = [Tile]()
        var tileLine2 = [Tile]()

        if (line1 - 100) < 0 { // line 1 is a column
            println("line 1 is a column")

            for index in 0..<self.tilesPerRow {
                var coordinate = DoubleIndex(index1: index, index2: line1)
                var tile = self.findTileAtCoordinate(coordinate)
                tile.imageView.alpha = 0.5
                tileLine1.append(tile)
            }
        } else { // line1 is a row
            println("line 1 is a row")
            for index in 0..<self.tilesPerRow {
                var coordinate = DoubleIndex(index1: line1 - 100, index2: index)
                var tile = self.findTileAtCoordinate(coordinate)
                tile.imageView.alpha = 0.5
                tileLine1.append(tile)
            }
        }
        
        
        
        // Check line 2
        if (line2 - 100) < 0 { // line2 is a column
            println("line 2 is a column")
            for index in 0..<self.tilesPerRow {
                var coordinate = DoubleIndex(index1: index, index2: line2)
                var tile = self.findTileAtCoordinate(coordinate)
                tile.imageView.alpha = 0.5
                tileLine2.append(tile)
            }
            
        } else { // line2 is a row
            println("line 2 is a row")
            for index in 0..<self.tilesPerRow {
                var coordinate = DoubleIndex(index1: line2 - 100, index2: index)
                var tile = self.findTileAtCoordinate(coordinate)
                tile.imageView.alpha = 0.5
                tileLine2.append(tile)
            }
        }
        
        

        
        // swap the tiles in the lines
        for counter in 0..<tileLine1.count {
            self.swapTiles(tileLine1[counter], tile2: tileLine2[counter], completionClosure: { () -> () in

//                if counter == tileLine1.count - 1 {
//                    println("CHECKING SOLVE")
//                    self.checkIfSolved()
//                }
            })
        }
//        for tile in tileLine2 {
//            println("tile in line2 at \(tile.doubleIndex.concatenateToString())")
//        }

        
    }
    
    
    
    
//    // checks to see if the image pieces are in the correct order
    func checkIfSolved() {

        for index1 in 0..<self.tilesPerRow {
            for index2 in 0..<self.tilesPerRow {
                var doubleIndex = self.tileArray[index1][index2].doubleIndex

                print("Does doubleIndex \(doubleIndex.concatenateToString()) = \(index1)\(index2) ??")

                if (doubleIndex.rowIndex) == index1 && (doubleIndex.columnIndex) == index2 {
                    println("  YES")

                } else {
                    println("  NO")
                    return
                }
                
                
            }
        }
        
        // If it makes it through this loop then the puzzle is solved
        self.layoutTilesWithMargin(0.0)
        self.solved = true

        // Notify GameScreen
        self.delegate!.puzzleIsSolved()
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
    
    func displayTagsFromTileArray() {
        for index1 in 0..<self.tilesPerRow {
            for index2 in 0..<self.tilesPerRow {
                var doubleIndex = self.tileArray[index1][index2].doubleIndex
                
                println("doubleIndex for tile at \(index1)\(index2) is \(doubleIndex.concatenateToString())")
            }
        }
    }

}

