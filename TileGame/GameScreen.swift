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
        self.createImagePieces(tilesPerRow)
        self.shuffleImages()
        self.loadImagesIntoTiles()

        congratsMessage.text = "Keep going..."
        congratsMessage.layer.cornerRadius = 50
    }
    
    
    
    // Cut up the main image into an array of imagePieces (uiimage)
    // At the same time, create an array of tiles (uiimageviews)
    func createImagePieces(size:Int) {
        
        var count = 0
        
        // Tile measuerments
        var totalWidth = self.tileArea.frame.width
        var margin:CGFloat = 4
        var totalMargin = CGFloat(margin * CGFloat(size-1))
        var tileSideLength:CGFloat  = (totalWidth - totalMargin) / CGFloat(size)

        // Image measurements
        var imageSideLength:CGFloat = CGFloat(self.imageToSolve.size.width / CGFloat(size))

        
        
        for index1 in 0..<size { // go down the rows
            var tileAreaPositionY:CGFloat = CGFloat(index1) * (tileSideLength + margin)
            var imagePositionY:CGFloat = CGFloat(index1) * (imageSideLength)

            for index2 in 0..<size { // get the tiles in each row
                var tileAreaPositionX:CGFloat = CGFloat(index2) * (tileSideLength + margin)
                var imagePositionX:CGFloat = CGFloat(index2) * (imageSideLength)
                
                
                //  set the boundaries of the small image
                var imageFrame = CGRectMake(imagePositionX, imagePositionY, imageSideLength, imageSideLength)
                // make the small image
                var tileCGImage = CGImageCreateWithImageInRect(self.imageToSolve.CGImage, imageFrame)
                var tileUIImage = UIImage(CGImage: tileCGImage)
                // add the small image tile to the array
                self.imagePiecesArray.append(tileUIImage!)
                
                
                
                // set the boundaries of the tile
                var tileFrame = CGRectMake(tileAreaPositionX, tileAreaPositionY, tileSideLength, tileSideLength)
                var tile = UIImageView(frame: tileFrame)
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
        self.loadImagesIntoTiles()
        
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
        self.moveTilesToFormCompletePicture()
        return true
    }

    
    
    
    
    
    
    
    func moveTilesToFormCompletePicture() {
        // testing animation
        // OMG my logic is so convoluted right here!!!
        // i need a much simpler way of figuring out if a tile moves up vs down and left vs right
        // I should really have the button in a 2d array so I can just pull the row and column
        
        var numTiles = self.imagePiecesArray.count
        var centerTile:Int = 0
        var whichColumn = 1
        var whichRow = 1
        
        if numTiles % 2 != 0 {
            centerTile = tilesPerRow / 2 + 1
            println("odd \(centerTile)")
            for tile in self.tileArray {
                println("row: \(whichRow) column: \(whichColumn)")
                if whichColumn < centerTile {
                    println("move tile right")
                    UIView.animateWithDuration(1.0, delay: 0.0, options: nil, animations: {
                        var frame = tile.frame
                        frame.origin.x += self.margin * CGFloat((centerTile - whichColumn))
                        tile.frame = frame
                        }, completion: nil)
                }
                if whichColumn > centerTile {
                    println("move tile left")
                    UIView.animateWithDuration(1.0, delay: 0.0, options: nil, animations: {
                        var frame = tile.frame
                        frame.origin.x += self.margin * CGFloat((centerTile - whichColumn))
                        tile.frame = frame
                        }, completion: nil)
                }
                if whichRow < centerTile {
                    println("move tile down")
                    UIView.animateWithDuration(1.0, delay: 0.0, options: nil, animations: {
                        var frame = tile.frame
                        frame.origin.y += self.margin * CGFloat((centerTile - whichRow))
                        tile.frame = frame
                        }, completion: nil)
                }
                if whichRow > centerTile {
                    println("move tile up")
                    UIView.animateWithDuration(1.0, delay: 0.0, options: nil, animations: {
                        var frame = tile.frame
                        frame.origin.y += self.margin * CGFloat((centerTile - whichRow))
                        tile.frame = frame
                        }, completion: nil)
                }
                whichColumn++
                if whichColumn > tilesPerRow {
                    whichColumn = 1
                    whichRow++
                }
            }
        }
        else {
            centerTile = tilesPerRow / 2
            println("even \(centerTile)")
            for tile in self.tileArray {
                println("row: \(whichRow) column: \(whichColumn)")
                if whichColumn <= centerTile {
                    println("move tile right")
                    UIView.animateWithDuration(1.0, delay: 0.0, options: nil, animations: {
                        var frame = tile.frame
                        frame.origin.x += (self.margin * CGFloat((centerTile - whichColumn))) + self.margin / 2
                        tile.frame = frame
                        }, completion: nil)
                }
                if whichColumn > centerTile {
                    println("move tile left")
                    UIView.animateWithDuration(1.0, delay: 0.0, options: nil, animations: {
                        var frame = tile.frame
                        frame.origin.x += (self.margin * CGFloat((centerTile - whichColumn))) + self.margin / 2
                        tile.frame = frame
                        }, completion: nil)
                }
                if whichRow <= centerTile {
                    println("move tile down")
                    UIView.animateWithDuration(1.0, delay: 0.0, options: nil, animations: {
                        var frame = tile.frame
                        frame.origin.y += (self.margin * CGFloat((centerTile - whichRow))) + self.margin / 2
                        tile.frame = frame
                        }, completion: nil)
                }
                if whichRow > centerTile {
                    println("move tile up")
                    UIView.animateWithDuration(1.0, delay: 0.0, options: nil, animations: {
                        var frame = tile.frame
                        frame.origin.y += (self.margin * CGFloat((centerTile - whichRow))) + self.margin / 2
                        tile.frame = frame
                        }, completion: nil)
                }
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