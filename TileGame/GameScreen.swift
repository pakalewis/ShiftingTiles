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

    
    
    @IBOutlet weak var tileArea: TileAreaView!
    @IBOutlet weak var congratsMessage: UILabel!
    
    
    override func viewDidLoad() {
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func viewDidAppear(animated: Bool) {

        self.tileArea.imageToSolve = self.imageToSolve
        self.tileArea.tilesPerRow = self.tilesPerRow
        self.margin = (self.tileArea.frame.width / CGFloat(self.tilesPerRow)) * 0.05
        println("self.tileArea.frame.width = \(self.tileArea.frame.width)")
        println("margin = \(self.margin)")

        
        
        // Initialize tileArea
        self.tileArea.initialize()
        

        congratsMessage.text = "Keep going..."
        congratsMessage.layer.cornerRadius = 50
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
//        self.layoutTilesWithMargin(0.0)
//        self.moveTilesToFormCompletePicture()
        return true
    }
    
    @IBAction func backToMainScreen(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}