//
//  MainScreen.swift
//  TileGame
//
//  Created by Parker Lewis on 9/3/14.
//  Copyright (c) 2014 Parker Lewis. All rights reserved.
//


// ideas for more features:
// allow user to choose picture from camera or photo library
// enable hint button that will highlight the first piece out of position
// fix how the picture gets cut into pieces (some of the edges are not quite right)


import Foundation
import UIKit

class MainScreen: UIViewController {
                            
    @IBOutlet weak var imageCycler: UIImageView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var tilesPerRowLabel: UILabel!
    let image0 = UIImage(named: "augs")
    let image1 = UIImage(named: "image1")
    let image2 = UIImage(named: "image2")
    let image3 = UIImage(named: "image3")
    let image4 = UIImage(named: "image4")
    let image5 = UIImage(named: "image5")
    let image6 = UIImage(named: "image6")
    let image7 = UIImage(named: "image7")
    let image8 = UIImage(named: "image8")
    let image9 = UIImage(named: "image9")
    let image10 = UIImage(named: "image10")
    var imageArray = [UIImage]()
    var imageToSolve = UIImage()
    var tilesPerRow = 3
    var currentIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageArray =  [image0, image1, image2, image3, image4, image5, image6, image7, image8, image9, image10]
        self.imageCycler.image = imageArray[currentIndex]
        self.tilesPerRowLabel.text = "3"
        stepper.wraps = true
        stepper.autorepeat = true
        stepper.maximumValue = 10
        stepper.minimumValue = 3
    }

    @IBAction func letsPlayButton(sender: AnyObject) {
        // Let's Play button pressed
    }

    
    @IBAction func stepperPressed(sender: UIStepper) {
        self.tilesPerRowLabel.text = Int(sender.value).description
        self.tilesPerRow = Int(sender.value)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        var gameScreen = segue.destinationViewController as GameScreen
        if (segue.identifier == "playGame") {
            self.imageToSolve = imageArray[currentIndex]
        }
        gameScreen.imageToSolve = self.imageToSolve
        gameScreen.tilesPerRow = self.tilesPerRow
        
    }
    
    
    
    @IBAction func nextButton(sender: AnyObject) {
        currentIndex += 1
        if currentIndex == imageArray.count {
            currentIndex = 0
        }
        self.imageCycler.image = imageArray[currentIndex]
    }

    @IBAction func previousButton(sender: AnyObject) {
        currentIndex -= 1
        if currentIndex < 0 {
            currentIndex = imageArray.count - 1
        }
        self.imageCycler.image = imageArray[currentIndex]
    }

}