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

        self.tileArea.delegate = self
        
        self.tileArea.imageToSolve = self.imageToSolve
        self.tileArea.tilesPerRow = self.tilesPerRow
        
        // Initialize tileArea
        self.tileArea.initialize()
        

        
        // Initialize row/column gestures
        self.initializeGestures()
        
        congratsMessage.text = "Keep going..."
        congratsMessage.layer.cornerRadius = 50
    }
    
    
    func initializeGestures() {
        
        for index in 0..<self.tilesPerRow {
            
            // Measuerments to make the frames
            var topBankGestureWidth = self.topBank.frame.width / CGFloat(self.tilesPerRow)
            var topBankGestureHeight = self.topBank.frame.height
            var topBankGesturePositionX = topBankGestureWidth * CGFloat(index)

            var leftBankGestureWidth = self.leftBank.frame.width
            var leftBankGestureHeight = self.leftBank.frame.height / CGFloat(self.tilesPerRow)
            var leftBankGesturePositionY = leftBankGestureHeight * CGFloat(index)
            
            var topBankGestureFrame = CGRectMake(topBankGesturePositionX, 0, topBankGestureWidth, topBankGestureHeight)
//            println("topBankGestureFrame is \(topBankGestureFrame)")
            var topGestureArea = UIView(frame: topBankGestureFrame)
            var topGesture = UITapGestureRecognizer(target: self, action: "bankTapped:")
            topGestureArea.tag = index
            topGestureArea.addGestureRecognizer(topGesture)
            self.topBank.addSubview(topGestureArea)
            
            
            var leftBankGestureFrame = CGRectMake(0, leftBankGesturePositionY, leftBankGestureWidth, leftBankGestureHeight)
//            println("leftBankGestureFrame is \(leftBankGestureFrame)")
            var leftGestureArea = UIView(frame: leftBankGestureFrame)
            var leftGesture = UITapGestureRecognizer(target: self, action: "bankTapped:")
            leftGestureArea.tag = index + 100
            leftGestureArea.addGestureRecognizer(leftGesture)
            self.leftBank.addSubview(leftGestureArea)

            
        }
        
    }
 

    
    func bankTapped(sender: UIGestureRecognizer) {

        
        if (sender.view!.tag - 100) < 0 {
            println("top bank tapped at column \(sender.view!.tag)")
        } else {
            println("left bank tapped at row \(sender.view!.tag % 100)")
        }
        
        
    }

    
    
    func puzzleIsSolved() {
        println("Puzzle is solved!")
        congratsMessage.text = "CONGRATULATIONS"
        self.congratsMessage.backgroundColor = UIColor.blueColor()
        self.solved = true
    }

    
   
    
    @IBAction func backToMainScreen(sender: AnyObject) {
        self.tileArea.checkIfSolved()
//        self.tileArea.displayTagsFromTileArray()
//        self.tileArea.shuffleImages()

        
        
        //        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}