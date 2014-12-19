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
    var firstTileNumber : DoubleIndex?
    var secondTileNumber : DoubleIndex?
    var imagePiecesArray = [[UIImage]]()
    var tileArray = [[Tile]]()
    
    
    func initialize() {
        self.createTileArray()
        self.createImagePieces()
        self.loadImagesIntoTiles()
        self.shuffleImages()
//        self.displayTagsFromTileArray()
        
        var margin = (self.frame.width / CGFloat(self.tilesPerRow)) * 0.05
        self.layoutTilesWithMargin(margin)

        
        //        self.tileArray[0][2].imageView.backgroundColor = UIColor.blueColor()

    }
    
    
    func createTileArray() {
        var arrayIndexConcatenation = 0
        
        for index1 in 0..<self.tilesPerRow { // go down the rows
            // Make the row array
            var rowArray = [Tile]()
            
            for index2 in 0..<self.tilesPerRow { // get the tiles in each row
                
                // Store the 2D array index as a tag on the view
                // This will help with determining the correct tap gesture
                var doubleIndex = DoubleIndex(index1: index1, index2: index2)
//                println("\(doubleIndex.rowIndex), \(doubleIndex.columnIndex)")

                
                // Make a new tile
                var tile = Tile(doubleIndex: doubleIndex)
                tile.imageView.userInteractionEnabled = true;
                tile.imageView.backgroundColor = UIColor.redColor()
                tile.imageView.tag = tile.doubleIndex.concatenateToInt()
                
                //Add gesture recognizer
                let tapGesture = UITapGestureRecognizer(target: self, action: "tileTapped:")
                tile.imageView.addGestureRecognizer(tapGesture)
                
                // Add the imageview to the tile area
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
    
    
    func createImagePieces() {
        
        // Image measurements
        var tileImageWidth:CGFloat = CGFloat(self.imageToSolve.size.width / CGFloat(self.tilesPerRow))
        
        for index1 in 0..<self.tilesPerRow { // go down the rows
            // Make the row array
            var rowArray = [UIImage]()
            
            for index2 in 0..<self.tilesPerRow { // get the tiles in each row
                // XY coordinate for each tile
                var imagePositionY:CGFloat = CGFloat(index1) * (tileImageWidth)
                var imagePositionX:CGFloat = CGFloat(index2) * (tileImageWidth)
                
                // Set the frame of the small image
                var imageFrame = CGRectMake(imagePositionX, imagePositionY, tileImageWidth, tileImageWidth)
                // Make the small image
                var tileCGImage = CGImageCreateWithImageInRect(self.imageToSolve.CGImage, imageFrame)
                var tileUIImage = UIImage(CGImage: tileCGImage)

                
                // Add the small image to the array
                rowArray.append(tileUIImage!)
            }
            
            // Add the row array to the tile area
            self.imagePiecesArray.append(rowArray)
        }
    }
    
    
    func shuffleImages() {

        // Swap tiles a bunch of times
        for index in 0...self.tilesPerRow*3 {
            var randomInt1 = Int(arc4random_uniform(UInt32(self.tilesPerRow)))
            var randomInt2 = Int(arc4random_uniform(UInt32(self.tilesPerRow)))
            var randomInt3 = Int(arc4random_uniform(UInt32(self.tilesPerRow)))
            var randomInt4 = Int(arc4random_uniform(UInt32(self.tilesPerRow)))
            
            var tile1index = DoubleIndex(index1: randomInt1, index2: randomInt2)
            var tile2index = DoubleIndex(index1: randomInt3, index2: randomInt4)
            
            self.swapTiles(tile1index, index2: tile2index)
        }
    
    
    }
    
    
    
    // Iterate through the images array and loads to the appropriate tile
    func loadImagesIntoTiles() {

        
        
        
        for index1 in 0..<self.tilesPerRow {
            for index2 in 0..<self.tilesPerRow {
                self.tileArray[index1][index2].imageView.image = imagePiecesArray[index1][index2]
            }
        }
    }
    
    
    func tileTapped(sender: UIGestureRecognizer) {
        // Grab the tag of the tile that was tapped
        var tag = sender.view!.tag
        var tagDouble =  DoubleIndex(index1: tag / 10, index2: tag % 10)
        
        println("You tapped the tile at ROW \(tag / 10) and COLUMN \(tag % 10)")
        println("The tag is \(tag)")
        
        // Check if it is the first or second tile tapped
        // Swap images and tags when
        if self.firstTileSelectedBool {
            println("FIRST TILE")
            self.firstTileNumber = tagDouble
            self.firstTileSelectedBool = false
        } else {
            println("SECOND TILE")
            self.secondTileNumber = tagDouble
            self.firstTileSelectedBool = true
            
            println("FirstTileNumber \(self.firstTileNumber?.concatenateToInt()) and SecondTileNumber \(self.secondTileNumber?.concatenateToInt())")
            
            
            self.swapTiles(self.firstTileNumber!, index2: self.secondTileNumber!)
        }
    }
    
    
    
//    // Swap the images and tags when the second tile is tapped
    func swapTiles(index1: DoubleIndex, index2: DoubleIndex) {
        
        println("SWAPPING TILES \(index1.concatenateToInt()) and \(index2.concatenateToInt())")

        // Animate the fade out
        UIView.animateWithDuration(0.15, delay: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            
            self.tileArray[index1.rowIndex][index1.columnIndex].imageView.alpha = 0
            self.tileArray[index2.rowIndex][index2.columnIndex].imageView.alpha = 0

            }) { (finished) -> Void in

                // Swap images in the images array
                var tempImage = self.imagePiecesArray[index1.rowIndex][index1.columnIndex]
                self.imagePiecesArray[index1.rowIndex][index1.columnIndex] = self.imagePiecesArray[index2.rowIndex][index2.columnIndex]
                self.imagePiecesArray[index2.rowIndex][index2.columnIndex] = tempImage
        
                // Load the two images onto the tiles since they were swapped in the imagePieces Array
                // I could instead call self.loadImagesIntoTiles()
                self.tileArray[index1.rowIndex][index1.columnIndex].imageView.image = self.imagePiecesArray[index1.rowIndex][index1.columnIndex]
                self.tileArray[index2.rowIndex][index2.columnIndex].imageView.image = self.imagePiecesArray[index2.rowIndex][index2.columnIndex]

                // Swap doubleindex
                var first = self.tileArray[index1.rowIndex][index1.columnIndex].doubleIndex
                self.tileArray[index1.rowIndex][index1.columnIndex].doubleIndex = self.tileArray[index2.rowIndex][index2.columnIndex].doubleIndex
                self.tileArray[index2.rowIndex][index2.columnIndex].doubleIndex = first

                // Now animate the fade in
                UIView.animateWithDuration(0.15, animations: { () -> Void in
                    self.tileArray[index1.rowIndex][index1.columnIndex].imageView.alpha = 1
                    self.tileArray[index2.rowIndex][index2.columnIndex].imageView.alpha = 1

                    }) { (finished) -> Void in
        

//                        self.displayTagsFromTileArray()
                        //                         After swapping, check if the puzzle is solved
//                        self.checkIfSolved()
                }
        }
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

        
        // Lock puzzle
        self.lockPuzzle()
    
            

        // Notify GameScreen
        self.delegate!.puzzleIsSolved()
    }

    
    func lockPuzzle() {
        for index1 in 0..<self.tilesPerRow {
            for index2 in 0..<self.tilesPerRow {
                self.tileArray[index1][index2].imageView.userInteractionEnabled = false
            }
        }
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

