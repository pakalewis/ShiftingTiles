//
//  GameScreen.swift
//  TileGame
//
//  Created by Parker Lewis on 9/3/14.
//  Copyright (c) 2014 Parker Lewis. All rights reserved.
//

import Foundation
import UIKit

class GameScreen: UIViewController {
    
    var imageToSolve = UIImage()
    var solved = false
    var tilesPerRow = 3
    var firstTileSelectedBool = true
    var firstTileNumber = 0
    var secondTileNumber = 0
    var imagePiecesArray = [UIImage]()
    var tileArray = [UIImageView]()
    var margin:CGFloat = 5.0

    
    
    @IBOutlet weak var tileArea: UIView!
    @IBOutlet weak var congratsMessage: UILabel!
    
    
    override func viewDidLoad() {
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.createImagePieces()
        self.createTileArray()
        
        self.margin = (self.tileArea.frame.width / CGFloat(self.tilesPerRow)) * 0.05
        println("self.tileArea.frame.width = \(self.tileArea.frame.width)")
        println("margin = \(self.margin)")
        self.layoutTilesWithMargin(self.margin)

        self.shuffleImages()
        self.loadImagesIntoTiles()

        congratsMessage.text = "Keep going..."
        congratsMessage.layer.cornerRadius = 50
    }
    
    
    
    // Cut up the main image into an array of imagePieces (uiimage)
    // At the same time, create an array of tiles (uiimageviews)
    func createImagePieces() {
        
        // Image measurements
        var imageSideLength:CGFloat = CGFloat(self.imageToSolve.size.width / CGFloat(self.tilesPerRow))
        
        for index1 in 0..<self.tilesPerRow { // go down the rows
            var imagePositionY:CGFloat = CGFloat(index1) * (imageSideLength)

            for index2 in 0..<self.tilesPerRow { // get the tiles in each row
                var imagePositionX:CGFloat = CGFloat(index2) * (imageSideLength)
                
                
                //  set the boundaries of the small image
                var imageFrame = CGRectMake(imagePositionX, imagePositionY, imageSideLength, imageSideLength)
                // make the small image
                var tileCGImage = CGImageCreateWithImageInRect(self.imageToSolve.CGImage, imageFrame)
                var tileUIImage = UIImage(CGImage: tileCGImage)
                // add the small image tile to the array
                self.imagePiecesArray.append(tileUIImage!)
            }
        }
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
                
                //Add gesture recognizer instead of button
                let tapGesture = UITapGestureRecognizer(target: self, action: "tileTapped:")
                tile.addGestureRecognizer(tapGesture)
                
                // Add the imageview to the tile area
                self.tileArea.addSubview(tile)
                
                
                count++
            }
        }
  
    }
    
    
    func layoutTilesWithMargin(margin:CGFloat) {
        var count = 0
        
        // Tile measuerments
        var totalWidth = self.tileArea.frame.width
        var totalMargin = CGFloat(margin * CGFloat(self.tilesPerRow - 1))
        var tileWidth:CGFloat  = (totalWidth - totalMargin) / CGFloat(self.tilesPerRow)
        println("\(margin)")

        for index1 in 0..<self.tilesPerRow { // go down the rows
            var tileAreaPositionY:CGFloat = CGFloat(index1) * (tileWidth + margin)
            
            for index2 in 0..<self.tilesPerRow { // get the tiles in each row
                var tileAreaPositionX:CGFloat = CGFloat(index2) * (tileWidth + margin)
                println("tile xPOS = \(tileAreaPositionX) and tile yPOS = \(tileAreaPositionY)")
                
                
                // set the boundaries of the tile
                var tileFrame = CGRectMake(tileAreaPositionX, tileAreaPositionY, tileWidth, tileWidth)
                
                
                UIView.animateWithDuration(0.2, delay: 0.1, options: nil, animations: {
                    self.tileArray[count].backgroundColor = UIColor.redColor()
                    self.tileArray[count].frame = tileFrame
                    }, completion: nil)

                
                count++;
            }
        }
    }


    
    func shuffleImages() {
    
        for var index = self.tileArray.count - 1; index > 0; index-- {
            // Random int from 0 to index-1
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
        // Only allow tap if the puzzle is still unsolved
        if !solved {

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
            })
            
        }
        
        // Swap tags
        var temptag = self.tileArray[index1].tag
        self.tileArray[index1].tag = self.tileArray[index2].tag
        self.tileArray[index2].tag = temptag
        
        // After swapping, check if the puzzle is solved
        self.checkIfSolved()
    }
   
    
    
   
    // checks to see if the image pieces are in the correct order
    func checkIfSolved() -> Bool {
        for index in 0..<self.tileArray.count {
            println("Does tag \(self.tileArray[index].tag) = \(index)??")
            if self.tileArray[index].tag != index {
                println("Test fails at at \(index)")
                return false
            }
        }

        println("Puzzle is solved!")
        //TODO: move congrats message stuff/animations to new func
        congratsMessage.text = "CONGRATULATIONS"
        self.congratsMessage.backgroundColor = UIColor.blueColor()
        
        self.solved = true
        self.layoutTilesWithMargin(0.0)
//        self.moveTilesToFormCompletePicture()
        return true
    }

    
    
    
    
    
    
    
    func moveTilesToFormCompletePicture() {

        var centerTile:Int = 0
        var whichColumn = 1
        var whichRow = 1
        
        if self.imagePiecesArray.count % 2 != 0 { // Puzzle had odd rows/columns
            centerTile = tilesPerRow / 2 + 1
            for tile in self.tileArray {

                var frame = tile.frame
                frame.origin.x += self.margin * CGFloat((centerTile - whichColumn))
                frame.origin.y += self.margin * CGFloat((centerTile - whichRow))
                UIView.animateWithDuration(1.0, delay: 0.0, options: nil, animations: {
                    tile.frame = frame
                    }, completion: nil)

                // increment the column and row
                whichColumn++
                if whichColumn > tilesPerRow {
                    whichColumn = 1
                    whichRow++
                }
            }
        }
        else { // Puzzle had even rows/columns
            centerTile = tilesPerRow / 2
            for tile in self.tileArray {

                var frame = tile.frame
                frame.origin.x += (self.margin * CGFloat((centerTile - whichColumn))) + self.margin / 2
                frame.origin.y += (self.margin * CGFloat((centerTile - whichRow))) + self.margin / 2
                UIView.animateWithDuration(1.0, delay: 0.0, options: nil, animations: {
                    tile.frame = frame
                    }, completion: nil)

                // increment the column and row

                whichColumn++
                if whichColumn > tilesPerRow {
                    whichColumn = 1
                    whichRow++
                }
            }
        }
    }

    
    func showListOfTags() {
        for var index = 0; index < self.tileArray.count; index++ {
            print("\(self.tileArray[index].tag), ")
        }
        println()
        
    }

    
    @IBAction func backToMainScreen(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}