//
//  TileAreaView.swift
//  TileGame
//
//  Created by Parker Lewis on 12/17/14.
//  Copyright (c) 2014 Parker Lewis. All rights reserved.
//

import UIKit

class TileAreaView: UIView {

    var delegate : PuzzleSolvedProtocol?

    var imageToSolve = UIImage()
    var tilesPerRow = 3
    var firstTileSelectedBool = true
    var firstTileNumber = 0
    var secondTileNumber = 0
    var imagePiecesArray = [UIImage]()
    var tileArray = [UIImageView]()

    
    func initialize() {
        self.createTileArray()
        self.createImagePieces()
//        self.shuffleImages()
        self.loadImagesIntoTiles()
        
        var margin = (self.frame.width / CGFloat(self.tilesPerRow)) * 0.05
        self.layoutTilesWithMargin(margin)
    }
    
    
    func createTileArray() {
        var count = 0
        
        for index1 in 0..<self.tilesPerRow { // go down the rows
            for index2 in 0..<self.tilesPerRow { // get the tiles in each row
                
                var tile = UIImageView()
                tile.userInteractionEnabled = true;
                tile.tag = count
                // Add tile to the array
                self.tileArray.append(tile)
                
                //Add gesture recognizer 
                let tapGesture = UITapGestureRecognizer(target: self, action: "tileTapped:")
                tile.addGestureRecognizer(tapGesture)
                
                // Add the imageview to the tile area
                self.addSubview(tile)
                
                count++
            }
        }
    }

    

    
    func layoutTilesWithMargin(margin:CGFloat) {
        var count = 0
        
        // Tile measuerments
        var totalWidth = self.frame.width
        var totalMargin = CGFloat(margin * CGFloat(self.tilesPerRow - 1))
        var tileWidth:CGFloat  = (totalWidth - totalMargin) / CGFloat(self.tilesPerRow)
        
        for index1 in 0..<self.tilesPerRow { // go down the rows
            var tileAreaPositionY:CGFloat = CGFloat(index1) * (tileWidth + margin)
            
            for index2 in 0..<self.tilesPerRow { // get the tiles in each row
                var tileAreaPositionX:CGFloat = CGFloat(index2) * (tileWidth + margin)
                println("tile xPOS = \(tileAreaPositionX) and tile yPOS = \(tileAreaPositionY)")
                
                // set the boundaries of the tile
                var tileFrame = CGRectMake(tileAreaPositionX, tileAreaPositionY, tileWidth, tileWidth)
                
                UIView.animateWithDuration(1.0, delay: 0.0, options: nil, animations: { () -> Void in
                    self.tileArray[count].frame = tileFrame
                }, completion: nil)
                
                count++;
            }
        }
    }
    
    
    func createImagePieces() {
        
        // Image measurements
        var tileImageWidth:CGFloat = CGFloat(self.imageToSolve.size.width / CGFloat(self.tilesPerRow))
        
        for index1 in 0..<self.tilesPerRow { // go down the rows
            var imagePositionY:CGFloat = CGFloat(index1) * (tileImageWidth)
            
            for index2 in 0..<self.tilesPerRow { // get the tiles in each row
                var imagePositionX:CGFloat = CGFloat(index2) * (tileImageWidth)

                // Set the frame of the small image
                var imageFrame = CGRectMake(imagePositionX, imagePositionY, tileImageWidth, tileImageWidth)
                // Make the small image
                var tileCGImage = CGImageCreateWithImageInRect(self.imageToSolve.CGImage, imageFrame)
                var tileUIImage = UIImage(CGImage: tileCGImage)
                // Add the small image to the array
                self.imagePiecesArray.append(tileUIImage!)
            }
        }
    }
    
    
    func shuffleImages() {

        // Get a Random int from 0 to index-1 and swap the tags and images
        for var index = self.tileArray.count - 1; index > 0; index-- {
            var j = Int(arc4random_uniform(UInt32(index-1)))
            
            var tempTag = self.tileArray[j].tag
            self.tileArray[j].tag = self.tileArray[index].tag
            self.tileArray[index].tag = tempTag
            
            var tempImage = imagePiecesArray[j]
            imagePiecesArray[j] = imagePiecesArray[index]
            imagePiecesArray[index] = tempImage
            
        }
    }
    


    // Iterate through the images array and loads to the appropriate tile
    func loadImagesIntoTiles() {
        for var index = 0; index < imagePiecesArray.count; index++ {
            self.tileArray[index].image = imagePiecesArray[index]
        }
    }
    
    
    func tileTapped(sender: UIGestureRecognizer) {
        // This is a funky way to get the correct index of the tile that was tapped
        var tag = sender.view?.tag
        var tileIndex = 0
        for var index = 0; index < self.tileArray.count; index++ {
            if tag == self.tileArray[index].tag {
                tileIndex = index;
            }
        }
        
        // Check if it is the first or second tile tapped
        // Swap images and tags when
        if self.firstTileSelectedBool {
            println("\n\nFIRST TILE TAPPED at index \(tileIndex)")
            self.firstTileNumber = tileIndex
            self.firstTileSelectedBool = false
        } else {
            println("SECOND TILE TAPPED at index \(tileIndex)")
            self.secondTileNumber = tileIndex
            self.firstTileSelectedBool = true
            self.swapTiles(firstTileNumber, index2: secondTileNumber)
        }
    }
    
    
    
    // Swap the images and tags when the second tile is tapped
    func swapTiles(index1: Int, index2: Int) {
        
        // Swap images and reload images into tiles
        var tempImage = imagePiecesArray[index1]
        imagePiecesArray[index1] = imagePiecesArray[index2]
        imagePiecesArray[index2] = tempImage
        
        UIView.animateWithDuration(0.15, delay: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            
            self.tileArray[index1].alpha = 0
            self.tileArray[index2].alpha = 0
            }) { (finished) -> Void in
                
                self.tileArray[index1].image = self.imagePiecesArray[index1]
                self.tileArray[index2].image = self.imagePiecesArray[index2]
                
                UIView.animateWithDuration(0.15, animations: { () -> Void in
                    self.tileArray[index1].alpha = 1
                    self.tileArray[index2].alpha = 1
                }) { (finished) -> Void in
                    // Swap tags
                    var temptag = self.tileArray[index1].tag
                    self.tileArray[index1].tag = self.tileArray[index2].tag
                    self.tileArray[index2].tag = temptag
                    
                    // After swapping, check if the puzzle is solved
                    self.checkIfSolved()
                }
        }
    }

    
    // checks to see if the image pieces are in the correct order
    func checkIfSolved() {
        
        for index in 0..<self.tileArray.count {
            println("Does tag \(self.tileArray[index].tag) = \(index)??")
            if self.tileArray[index].tag != index {
                println("Test fails at at \(index)")
                return
            }
        }
        
        // Making it through the for loop means that the puzzle is solved
        // Animate the tiles to fill up the entire view
        self.layoutTilesWithMargin(0.0)
        
        // Lock puzzle
        self.lockPuzzle()
        
        // Notify GameScreen
        self.delegate!.puzzleIsSolved()
    }
    
    func lockPuzzle() {
        for tile in self.tileArray {
            tile.userInteractionEnabled = false
        }
    }
  }


