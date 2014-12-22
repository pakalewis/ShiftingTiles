//
//  GameScreen.swift
//  TileGame
//
//  Created by Parker Lewis on 9/3/14.
//  Copyright (c) 2014 Parker Lewis. All rights reserved.
//

import Foundation
import UIKit


class GameScreen: UIViewController, PuzzleSolvedProtocol {
    

    
    var imageToSolve = UIImage()
    var solved = false
    var tilesPerRow = 3
    var firstRowOrColumnTapped = -1
    var secondRowOrColumnTapped = -1
    var firstButton = UIImageView()
    var secondButton = UIImageView()
    var isFirstRowOrColumnTapped = false
    
    @IBOutlet weak var tileArea: TileAreaView2!
    @IBOutlet weak var congratsMessage: UILabel!
    
    @IBOutlet weak var topBank: UIView!
    @IBOutlet weak var leftBank: UIView!

    override func viewDidLoad() {
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func viewDidAppear(animated: Bool) {

        // Initialize tileArea
        self.tileArea.delegate = self
        self.tileArea.imageToSolve = self.imageToSolve
        self.tileArea.tilesPerRow = self.tilesPerRow
        self.view.bringSubviewToFront(self.tileArea)
        self.tileArea.initialize()
        
        // Initialize row/column gestures
        self.initializeButtons()
        
        congratsMessage.text = "Keep going..."
        congratsMessage.layer.cornerRadius = 50
    }
    
    
    func initializeButtons() {
        
        for index in 0..<self.tilesPerRow {
            
            // Measuerments to make the frames
            var topBankGestureWidth = self.topBank.frame.width / CGFloat(self.tilesPerRow)
            var topBankGestureHeight = self.topBank.frame.height
            var topBankGesturePositionX = (topBankGestureWidth * CGFloat(index)) + (topBankGestureWidth / 2) - (topBankGestureHeight / 2)
            

            var leftBankGestureWidth = self.leftBank.frame.width
            var leftBankGestureHeight = self.leftBank.frame.height / CGFloat(self.tilesPerRow)
            var leftBankGesturePositionY = (leftBankGestureHeight * CGFloat(index)) + (leftBankGestureHeight / 2) - (leftBankGestureWidth / 2)
            
            
            var topBankGestureFrame = CGRectMake(topBankGesturePositionX, 0, topBankGestureHeight, topBankGestureHeight)
            var topGestureArea = UIImageView(frame: topBankGestureFrame)
            topGestureArea.image = UIImage(named: "upTriangle")
            topGestureArea.userInteractionEnabled = true;
            var topGesture = UITapGestureRecognizer(target: self, action: "bankTapped:")
            topGestureArea.tag = index
            topGestureArea.addGestureRecognizer(topGesture)
            self.topBank.addSubview(topGestureArea)
            
            
            var leftBankGestureFrame = CGRectMake(0, leftBankGesturePositionY, leftBankGestureWidth, leftBankGestureWidth)
            var leftGestureArea = UIImageView(frame: leftBankGestureFrame)
            leftGestureArea.image = UIImage(named: "leftTriangle")
            leftGestureArea.userInteractionEnabled = true;
            var leftGesture = UITapGestureRecognizer(target: self, action: "bankTapped:")
            leftGestureArea.tag = index + 100
            leftGestureArea.addGestureRecognizer(leftGesture)
            self.leftBank.addSubview(leftGestureArea)
        }
    }
 

    
    func bankTapped(sender: UIGestureRecognizer) {

        if solved {
            return
        } else {
            var tappedButton = sender.view as UIImageView
            
            if (!isFirstRowOrColumnTapped) {
                // Flip the bool
                self.isFirstRowOrColumnTapped = true

                // Store tag of the first line button
                self.firstRowOrColumnTapped = tappedButton.tag
                self.firstButton = tappedButton
                
                // Flip the image on the button
                if (tappedButton.tag - 100) < 0 { // line 1 is a column
                    self.firstButton.image = UIImage(named: "downTriangle")
                } else { // line1 is a row
                    self.firstButton.image = UIImage(named: "rightTriangle")
                }
                
                // TODO: Is comparing images like this ok??
//                if tappedButton.image == UIImage(named: "upTriangle") {
//                    self.firstButton.image = UIImage(named: "downTriangle")
//                } else {
//                    self.firstButton.image = UIImage(named: "rightTriangle")
//                }
            } else {
                // Flip the bool
                self.isFirstRowOrColumnTapped = false

                // set the second tag
                self.secondRowOrColumnTapped = sender.view!.tag
                
                // Flip the image on the button
                if (self.firstButton.tag - 100) < 0 { // line 1 is a column
                    self.firstButton.image = UIImage(named: "upTriangle")
                } else { // line1 is a row
                    self.firstButton.image = UIImage(named: "leftTriangle")
                }
                
                // If two distinct lines were tapped, then swap
                if self.firstRowOrColumnTapped != self.secondRowOrColumnTapped {
                    self.tileArea.swapLines(self.firstRowOrColumnTapped, line2: self.secondRowOrColumnTapped)
                }
            }
        }
    }

    
    
    func puzzleIsSolved() {
        println("Puzzle is solved!")
        congratsMessage.text = "CONGRATULATIONS"
        self.congratsMessage.backgroundColor = UIColor.blueColor()
        self.solved = true
    }

    
    @IBAction func hintButtonPressed(sender: AnyObject) {
        self.tileArea.showFirstIncorrectTile()
    }
   
    
    @IBAction func backToMainScreen(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}