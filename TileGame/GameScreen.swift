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
    var isSolved = false
    var tilesPerRow = 3
    var firstRowOrColumnTapped = -1
    var secondRowOrColumnTapped = -1
    var firstButton = UIImageView()
    var secondButton = UIImageView()
    var isFirstRowOrColumnTapped = false
    
    
    // VIEWS
    @IBOutlet weak var tileArea: TileAreaView2!
    @IBOutlet weak var congratsMessage: UILabel!
    @IBOutlet weak var topBank: UIView!
    @IBOutlet weak var leftBank: UIView!
    
    // CONSTRAINTS
    @IBOutlet weak var leftBankTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var topBankLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftBankMarginConstraint: NSLayoutConstraint!
    
    // BUTTONS
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var solveButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

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

        if self.isSolved {
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
        self.isSolved = true
        
        congratsMessage.text = "CONGRATULATIONS!"
        
        // TODO: How to handle these buttons?
        self.hintButton.userInteractionEnabled = false
        self.hintButton.alpha = 0.0
        self.solveButton.userInteractionEnabled = false
        self.solveButton.alpha = 0.0

        // Slide off the banks of buttons
        self.leftBankTopConstraint.constant = 1000
        self.topBankLeftConstraint.constant = 1000
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
            
            }) { (finished) -> Void in
                
                // Bring tiles together
                self.tileArea.layoutTilesWithMargin(0.0)

                // Grow the tile area by sliding the left bank off screen to the left
                self.leftBankMarginConstraint.constant = self.leftBankMarginConstraint.constant - self.leftBank.frame.width + 10

                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                    
                    }) { (finished) -> Void in
                        // Calling this again to resize all the tiles to take up the full TileArea
                        self.tileArea.layoutTilesWithMargin(0.0)

                }
        }
    }

    
    @IBAction func hintButtonPressed(sender: AnyObject) {
        self.tileArea.findTilesToSwap()
        self.tileArea.wiggleTile(self.tileArea.firstTile!)
        self.tileArea.wiggleTile(self.tileArea.secondTile!)
    }
   
    
    @IBAction func backToMainScreen(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func solveButtonPressed(sender: AnyObject) {

        var solveAlert = UIAlertController(title: "", message: "Are you sure you want to solve the puzzle?", preferredStyle: UIAlertControllerStyle.Alert)
        let noAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.Cancel, handler: nil)
        let yesAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.Default) { (finished) -> Void in
            
            // TODO: How to handle these buttons?
            self.hintButton.userInteractionEnabled = false
            self.hintButton.alpha = 0.0
            self.solveButton.userInteractionEnabled = false
            self.solveButton.alpha = 0.0
            self.solvePuzzle() }

        solveAlert.addAction(yesAction)
        solveAlert.addAction(noAction)
        self.presentViewController(solveAlert, animated: true, completion: nil)
    }
    
    func solvePuzzle() {
        self.tileArea.findTilesToSwap()
        self.tileArea.swapTiles(self.tileArea.firstTile!, tile2: self.tileArea.secondTile!, completionClosure: { () -> () in
            println()
            if !self.tileArea.checkIfSolved() {
                println("TESTTEST")
                self.solvePuzzle()
            }
        })
    }
    
}