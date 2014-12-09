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
    var correctArray = [UIImage]()
    var tileButtonArray = [UIButton]()
    var margin:CGFloat = 5.0
    var tileArea:UIView = UIView()

    
    @IBOutlet weak var congratsMessage: UILabel!
    
    
    override func viewDidLoad() {
        makeTileArea()
        createImagePieces(tilesPerRow)
        shuffleTiles()
        loadImagesIntoButtons()

        congratsMessage.text = "Keep going..."
        congratsMessage.layer.cornerRadius = 50
    }
    
    func makeTileArea() {
        var screenSize = UIScreen.mainScreen().applicationFrame
        var tileAreaWidth = screenSize.size.width - 20.0
        // need to set this with math. without using 40
        var tileAreaPosY = (screenSize.size.height / 2) - (tileAreaWidth / 2) + 40
        var tileAreaFrame = CGRectMake(10, tileAreaPosY, tileAreaWidth, tileAreaWidth)
        tileArea = UIView(frame: tileAreaFrame)
        self.view.addSubview(tileArea)
    }
    
    // cuts up the main image into pieces and stores them in an array
    // at the same time, create buttons with the same dimensions and also put in an array
    // load the pictures
    func createImagePieces(size:Int) {
        self.imageToSolve = resizeImage(self.imageToSolve, size: self.tileArea.frame.width)
        
        var totalWidth = self.tileArea.frame.width
        
        self.margin = 0.04 * (totalWidth / CGFloat(size))

        var tileSideLength:CGFloat  = (totalWidth - (margin * CGFloat(size-1))) / CGFloat(size)


        for index1 in 0..<size { // go down the rows
            var posY:CGFloat = CGFloat(index1) * (tileSideLength + margin)

            for index2 in 0..<size { // get the tiles in each row
                var posX:CGFloat = CGFloat(index2) * (tileSideLength + margin)
                
                // set the boundaries of the tile
                var tileFrame = CGRectMake(posX, posY, tileSideLength, tileSideLength)

                // get the partial image data from the main image??
                var dataToMakeUIImage = CGImageCreateWithImageInRect(self.imageToSolve.CGImage, tileFrame)
                
                // make the new small image
                var imagePiece = UIImage(CGImage: dataToMakeUIImage, scale: UIScreen.mainScreen().scale, orientation: self.imageToSolve.imageOrientation)

                // not sure why but the image pieces come out smaller than they should so I resize them here
                imagePiece = resizeImage(imagePiece, size: tileSideLength)

                // add the small image tile to the array
                self.imagePiecesArray.append(imagePiece)

                // make button and put in array
                var button = UIButton(frame: tileFrame)
                button.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
                self.tileButtonArray.append(button)
                
                // add button to tileArea view
                self.tileArea.addSubview(button)
            }
        }
        // save the initial order to check against later
        self.correctArray = self.imagePiecesArray
    }
    
    
    func resizeImage(image:UIImage, size:CGFloat) -> UIImage {
        var newSize:CGSize = CGSize(width: size, height: size)
        let rect = CGRectMake(0,0, newSize.width, newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    
    // one of the buttons was pressed
    // get the index from the button array and then set some properties depending if it was the first or second button pressed
    func buttonPressed(sender: UIButton) {
        var index = find(self.tileButtonArray, sender)
        if self.firstTileSelectedBool { // this is the first tile pressed
            self.firstTileNumber = index!
            self.firstTileSelectedBool = false
        }
        else { // this is the second tile pressed
            self.secondTileNumber = index!
            self.swapTiles(firstTileNumber, secondTileNumber: secondTileNumber)
            self.firstTileSelectedBool = true
        }
    }

    
    // swaps two images in the array when the second button is pressed
    func swapTiles(firstTileNumber: Int, secondTileNumber: Int) {
        if !solved {
            var tempImage = imagePiecesArray[firstTileNumber]
            imagePiecesArray[firstTileNumber] = imagePiecesArray[secondTileNumber]
            imagePiecesArray[secondTileNumber] = tempImage
            
            // reload images into buttons
            self.loadImagesIntoButtons()
            
            // if the order is now correct, the user wins!
            if checkTileOrder() {
                moveTilesToFormCompletePicture()
                congratsMessage.backgroundColor = UIColor.greenColor()
                congratsMessage.text = "Congratulations!"
            }            
        }
    }

    
    // shuffles the image pieces in the array
    func shuffleTiles() {
        for var index = imagePiecesArray.count - 1; index > 0; index-- {
            // Random int from 0 to index-1
            var j = Int(arc4random_uniform(UInt32(index-1)))
            
            var tempImage = imagePiecesArray[j]
            imagePiecesArray[j] = imagePiecesArray[index]
            imagePiecesArray[index] = tempImage
        }
    }

    
    // iterates through the images array and sets button images
    func loadImagesIntoButtons() {
        // set the tiles with the images from the pieces array
        for var index = 0; index < imagePiecesArray.count; index++ {
            var image = imagePiecesArray[index]
            self.tileButtonArray[index].setImage(image, forState: .Normal)
        }
    }

    
    // checks to see if the image pieces are in the correct order
    func checkTileOrder() -> Bool {
        for index in 0...8 {
//            println("image in imagePiecesArray \(index) = \(imagePiecesArray[index])")
//            println("image in correctArray \(index) = \(correctArray[index])")
            if imagePiecesArray[index] != correctArray[index] {
                return false
            }
        }
        self.solved = true
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
            for tileButton in tileButtonArray {
                println("row: \(whichRow) column: \(whichColumn)")
                if whichColumn < centerTile {
                    println("move tile right")
                    UIView.animateWithDuration(1.0, delay: 0.0, options: nil, animations: {
                        var frame = tileButton.frame
                        frame.origin.x += self.margin * CGFloat((centerTile - whichColumn))
                        tileButton.frame = frame
                        }, completion: nil)
                }
                if whichColumn > centerTile {
                    println("move tile left")
                    UIView.animateWithDuration(1.0, delay: 0.0, options: nil, animations: {
                        var frame = tileButton.frame
                        frame.origin.x += self.margin * CGFloat((centerTile - whichColumn))
                        tileButton.frame = frame
                        }, completion: nil)
                }
                if whichRow < centerTile {
                    println("move tile down")
                    UIView.animateWithDuration(1.0, delay: 0.0, options: nil, animations: {
                        var frame = tileButton.frame
                        frame.origin.y += self.margin * CGFloat((centerTile - whichRow))
                        tileButton.frame = frame
                        }, completion: nil)
                }
                if whichRow > centerTile {
                    println("move tile up")
                    UIView.animateWithDuration(1.0, delay: 0.0, options: nil, animations: {
                        var frame = tileButton.frame
                        frame.origin.y += self.margin * CGFloat((centerTile - whichRow))
                        tileButton.frame = frame
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
            for tileButton in tileButtonArray {
                println("row: \(whichRow) column: \(whichColumn)")
                if whichColumn <= centerTile {
                    println("move tile right")
                    UIView.animateWithDuration(1.0, delay: 0.0, options: nil, animations: {
                        var frame = tileButton.frame
                        frame.origin.x += (self.margin * CGFloat((centerTile - whichColumn))) + self.margin / 2
                        tileButton.frame = frame
                        }, completion: nil)
                }
                if whichColumn > centerTile {
                    println("move tile left")
                    UIView.animateWithDuration(1.0, delay: 0.0, options: nil, animations: {
                        var frame = tileButton.frame
                        frame.origin.x += (self.margin * CGFloat((centerTile - whichColumn))) + self.margin / 2
                        tileButton.frame = frame
                        }, completion: nil)
                }
                if whichRow <= centerTile {
                    println("move tile down")
                    UIView.animateWithDuration(1.0, delay: 0.0, options: nil, animations: {
                        var frame = tileButton.frame
                        frame.origin.y += (self.margin * CGFloat((centerTile - whichRow))) + self.margin / 2
                        tileButton.frame = frame
                        }, completion: nil)
                }
                if whichRow > centerTile {
                    println("move tile up")
                    UIView.animateWithDuration(1.0, delay: 0.0, options: nil, animations: {
                        var frame = tileButton.frame
                        frame.origin.y += (self.margin * CGFloat((centerTile - whichRow))) + self.margin / 2
                        tileButton.frame = frame
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

    @IBAction func backToMainScreen(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}