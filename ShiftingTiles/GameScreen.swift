//
//  GameScreen.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 9/3/14.
//  Copyright (c) 2014 Parker Lewis. All rights reserved.
//

import Foundation
import UIKit


class GameScreen: UIViewController, PuzzleSolvedProtocol {
    
    let colorPalette = ColorPalette()
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var imageToSolve = UIImage()
    var tilesPerRow = 3
    
    var topButtons = [UIImageView]()
    var leftButtons = [UIImageView]()
    var firstButton : UIImageView?
    var secondButton : UIImageView?
    var firstButtonOriginalFrame : CGRect?
    var secondButtonOriginalFrame : CGRect?
    var firstLineOfTiles: [Tile]?
    var secondLineOfTiles: [Tile]?
    
    // VIEWS
    var originalImageView: UIImageView!
    @IBOutlet weak var tileArea: TileAreaView!
    @IBOutlet weak var congratsMessage: UILabel!
    @IBOutlet weak var topBank: UIView!
    @IBOutlet weak var leftBank: UIView!
    @IBOutlet weak var separatorView: UIView!

    // CONSTRAINTS
    @IBOutlet weak var leftBankMarginConstraint: NSLayoutConstraint!
    
    // BUTTONS
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var solveButton: UIButton!
    @IBOutlet weak var showOriginalButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateColorsAndFonts()
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Initialize tileArea
        self.tileArea.delegate = self
        self.tileArea.imageToSolve = self.imageToSolve
        self.tileArea.tilesPerRow = self.tilesPerRow
        self.view.bringSubviewToFront(self.tileArea)
        self.tileArea.initialize()
        
        // Add pan gesture which allows moving rows/columns
        let panGesture = UIPanGestureRecognizer(target: self, action: "handleLinePan:")
        self.view.addGestureRecognizer(panGesture)
        
        // Initialize row/column buttons
        self.initializeButtons()
        
        congratsMessage.text = "Keep going..."
        congratsMessage.layer.cornerRadius = 50
        
        
        self.originalImageView = UIImageView(frame: self.tileArea.frame)
        self.originalImageView.image = self.imageToSolve
        self.originalImageView.alpha = 0
        self.view.addSubview(originalImageView)
    }
    
    
    func findButtonWithPoint(point: CGPoint) -> Bool {
        var currentButton = self.topButtons[0]
        for index in 0..<self.tilesPerRow {
            currentButton = self.topButtons[index]
            if CGRectContainsPoint(currentButton.frame, point) {
                self.firstButton = currentButton
                return true
            }
            
        }
        
        for index in 0..<self.tilesPerRow {
            currentButton = self.leftButtons[index]
            if CGRectContainsPoint(currentButton.frame, point) {
                self.firstButton = currentButton
                return true
            }
            
        }
        
        return false
    }

    func findSecondButtonWithPoint(point: CGPoint) -> Bool {
        var currentButton = self.topButtons[0]
        for index in 0..<self.tilesPerRow {
            currentButton = self.topButtons[index]
            if CGRectContainsPoint(currentButton.frame, point) {
                if currentButton != self.firstButton {
                    self.secondButton = currentButton
                    return true
                }
            }
            
        }
        
        for index in 0..<self.tilesPerRow {
            currentButton = self.leftButtons[index]
            if CGRectContainsPoint(currentButton.frame, point) {
                if currentButton != self.firstButton {
                    self.secondButton = currentButton
                    return true
                }
            }
            
        }
        
        return false
    }

    
    
    
    func handleLinePan(gesture:UIPanGestureRecognizer) {
        var startingPoint :CGPoint = gesture.locationInView(self.view)
        
            switch gesture.state {
            case .Began:
                if self.findButtonWithPoint(startingPoint) {
                    self.firstLineOfTiles = self.tileArea.makeLineOfTiles(self.firstButton!.tag)
                    for tile in self.firstLineOfTiles! {
                        self.tileArea.bringSubviewToFront(tile.imageView)
                        tile.originalFrame = tile.imageView.frame
                    }
                    self.view.bringSubviewToFront(self.firstButton!)
                    self.firstButtonOriginalFrame = self.firstButton!.frame
                }
            case .Changed:
                if self.firstButton != nil {
                    
                    let translation = gesture.translationInView(self.view)

                        if (self.firstButton!.tag - 100) < 0 { // line 1 is a column
                            for tile in self.firstLineOfTiles! {
                                tile.imageView.center.x = tile.imageView.center.x + translation.x
                            }
                            self.firstButton!.center.x = self.firstButton!.center.x + translation.x
                        } else { // line 1 is a Row
                            for tile in self.firstLineOfTiles! {
                                tile.imageView.center.y = tile.imageView.center.y + translation.y
                            }
                            self.firstButton!.center.y = self.firstButton!.center.y + translation.y
                        }

                    gesture.setTranslation(CGPointZero, inView: self.view)
                    
                }
                
            case .Ended:
                if self.firstButton != nil {
                    var endingPoint :CGPoint = gesture.locationInView(self.view)
                    // Check if the release is on another button
                    if self.findSecondButtonWithPoint(endingPoint) {
                        // Check if they are both rows or both columns
                        if abs(self.firstButton!.tag - self.secondButton!.tag) < 11 {
                            
                            // Swap the lines of tiles
                            self.secondLineOfTiles = self.tileArea.makeLineOfTiles(self.secondButton!.tag)
                            self.tileArea.swapLines(self.firstLineOfTiles!, line2: self.secondLineOfTiles!)
                            
                            // Swap the buttons
                            UIView.animateWithDuration(0.3, animations: { () -> Void in
                                self.firstButton!.frame = self.secondButton!.frame
                                self.secondButton!.frame = self.firstButtonOriginalFrame!
                                
                            })
                            // Swap the tags of the buttons
                            var tempTag = self.firstButton!.tag
                            self.firstButton!.tag = self.secondButton!.tag
                            self.secondButton!.tag = tempTag
                            self.firstButtonOriginalFrame = nil
                            self.secondButtonOriginalFrame = nil
                            self.firstButton = nil
                            self.secondButton = nil

                        } else { // Send the button and line of tiles back to where they started
                            UIView.animateWithDuration(0.3, animations: { () -> Void in
                                
                                for tile in self.firstLineOfTiles! {
                                    tile.imageView.frame = tile.originalFrame!
                                }
                                
                                
                                self.firstButton!.frame = self.firstButtonOriginalFrame!
                                self.firstButtonOriginalFrame = nil
                                self.secondButtonOriginalFrame = nil
                                self.firstButton = nil
                                self.secondButton = nil
                            })
                        }
                    } else { // Send the button and line of tiles back to where they started
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            
                            for tile in self.firstLineOfTiles! {
                                tile.imageView.frame = tile.originalFrame!
                            }
                            
                            
                            self.firstButton!.frame = self.firstButtonOriginalFrame!
                            self.firstButtonOriginalFrame = nil
                            self.secondButtonOriginalFrame = nil
                            self.firstButton = nil
                            self.secondButton = nil
                        })
                    }
                }
                
            case .Possible:
                println("possible")
            case .Cancelled:
                println("cancelled")
            case .Failed:
                println("failed")
            }
            
    }

    
    
    
    
    
    
    
    
    
    
    func initializeButtons() {
        
        // Measuerments to make the frames
        var topBankGestureWidth = self.topBank.frame.width / CGFloat(self.tilesPerRow)
        var topBankGestureHeight = self.topBank.frame.height
        var leftBankGestureWidth = self.leftBank.frame.width
        var leftBankGestureHeight = self.leftBank.frame.height / CGFloat(self.tilesPerRow)

        for index in 0..<self.tilesPerRow {
            
            // USE THESE TO MAKE THE BUTTON IMAGEVIEW FRAME
            // Measuerments to make the frames
//            var topBankGesturePositionX = self.tileArea.frame.origin.x + (topBankGestureWidth * CGFloat(index)) + (topBankGestureWidth / 2) - (topBankGestureHeight / 2)
//            var leftBankGesturePositionY = (leftBankGestureHeight * CGFloat(index)) + (leftBankGestureHeight / 2) - (leftBankGestureWidth / 2) + self.tileArea.frame.origin.y

            var topBankGesturePositionX = self.tileArea.frame.origin.x + (topBankGestureWidth * CGFloat(index))
            var leftBankGesturePositionY = self.tileArea.frame.origin.y + (leftBankGestureHeight * CGFloat(index))
            
            
            var topBankGestureFrame = CGRectMake(topBankGesturePositionX, self.topBank.frame.origin.y, topBankGestureWidth, topBankGestureHeight)
            var topGestureArea = UIImageView(frame: topBankGestureFrame)
            topGestureArea.image = UIImage(named: "upTriangle")?.imageWithColor(self.colorPalette.fetchDarkColor())
            topGestureArea.tag = index
            self.view.addSubview(topGestureArea)
            self.topButtons.append(topGestureArea)

            
            var leftBankGestureFrame = CGRectMake(self.leftBank.frame.origin.x, leftBankGesturePositionY, leftBankGestureWidth, leftBankGestureHeight)
            var leftGestureArea = UIImageView(frame: leftBankGestureFrame)
            leftGestureArea.image = UIImage(named: "leftTriangle")?.imageWithColor(self.colorPalette.fetchDarkColor())
            leftGestureArea.tag = index + 100
            self.view.addSubview(leftGestureArea)
            self.leftButtons.append(leftGestureArea)

        }
    }
 


    
    
    func puzzleIsSolved() {
        
        // Display congrats message
        // TODO: what else can i do? fireworks?
        congratsMessage.text = "CONGRATULATIONS!"
        
        // Update stats
        let stats = Stats()
        stats.updateSolveStats(self.tilesPerRow)
        
        
        // Hide and disable buttons
        self.hintButton.userInteractionEnabled = false
        self.hintButton.alpha = 0
        self.solveButton.userInteractionEnabled = false
        self.solveButton.alpha = 0
        self.showOriginalButton.userInteractionEnabled = false
        self.showOriginalButton.alpha = 0
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            // Slide off the banks of buttons
            for button in self.topButtons {
                button.center.x = button.center.x + 2000
            }
            for button in self.leftButtons {
                button.center.y = button.center.y + 2000
            }
            
            
            }) { (finished) -> Void in
                
                // Grow the tile area by sliding the left bank off screen to the left
                self.leftBankMarginConstraint.constant =  -self.leftBank.frame.width + 10

                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.view.layoutIfNeeded()

                    }) { (finished) -> Void in
                        // Calling this again to resize all the tiles to take up the full TileArea
                        self.tileArea.layoutTilesWithMargin(0.0)
                }
        }
    }

    
    // MARK: BUTTONS
    // These two funcs toggle the image on and off
    @IBAction func showOriginal(sender: AnyObject) {
        self.originalImageView.alpha = 1
    }
    
    
    @IBAction func stopShowingOriginal(sender: AnyObject) {
        self.originalImageView.alpha = 0
    }


    // Hint button to wiggle two tiles
    @IBAction func hintButtonPressed(sender: AnyObject) {
        self.tileArea.findTilesToSwap()
        if self.tileArea.firstTile != nil && self.tileArea.secondTile != nil {
            // Tiles are in correct order
            self.tileArea.wiggleTile(self.tileArea.firstTile!)
            self.tileArea.wiggleTile(self.tileArea.secondTile!)
        } else {
            self.tileArea.findFirstUnorientedTile()
            self.tileArea.wiggleTile(self.tileArea.firstUnorientedTile!)
        }
        
    }
   
    // TODO: this if statement is using a wrong check. another counter for how many times this alert has been shown?
    @IBAction func backToMainScreen(sender: AnyObject) {
        var totalPlays = self.userDefaults.integerForKey("backButtonPressed")
        totalPlays++
        self.userDefaults.setInteger(totalPlays, forKey: "backButtonPressed")
        

        if self.tileArea.isPuzzleSolved {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            if userDefaults.integerForKey("backButtonPressed") < 4 {
                var lossOfProgressAlert = UIAlertController(title: "Any progress on this puzzle will not be saved", message: "Are you sure you want to go back?", preferredStyle: UIAlertControllerStyle.Alert)
                let noAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.Cancel, handler: nil)
                let yesAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.Default, handler: { (ok) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                lossOfProgressAlert.addAction(yesAction)
                lossOfProgressAlert.addAction(noAction)
                self.presentViewController(lossOfProgressAlert, animated: true, completion: nil)
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }        
    }
    
    
    @IBAction func solveButtonPressed(sender: AnyObject) {

        var solveAlert = UIAlertController(title: "This will auto-solve the puzzle", message: "Are you sure you want to do this?", preferredStyle: UIAlertControllerStyle.Alert)
        let noAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.Cancel, handler: nil)
        let yesAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.Default) { (finished) -> Void in
            
            self.puzzleIsSolved()
            self.tileArea.layoutTilesWithMargin(0.0)
            self.tileArea.orientAllTiles()
            self.tileArea.isPuzzleSolved = true
        }

        solveAlert.addAction(yesAction)
        solveAlert.addAction(noAction)
        self.presentViewController(solveAlert, animated: true, completion: nil)
    }
    
 
    func updateColorsAndFonts() {
        // Colors
        self.view.backgroundColor = self.colorPalette.fetchLightColor()
        self.congratsMessage.textColor = self.colorPalette.fetchDarkColor()
        self.separatorView.backgroundColor = self.colorPalette.fetchDarkColor()
        self.backButton.setImage(UIImage(named: "backIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), forState: UIControlState.Normal)
        self.showOriginalButton.setImage(UIImage(named: "originalImageIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), forState: UIControlState.Normal)
        self.solveButton.setImage(UIImage(named: "solveIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), forState: UIControlState.Normal)
        self.hintButton.setImage(UIImage(named: "hintIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), forState: UIControlState.Normal)

        // Fonts
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            self.congratsMessage.font = UIFont(name: self.congratsMessage.font.fontName, size: 30)
        }
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            self.congratsMessage.font = UIFont(name: self.congratsMessage.font.fontName, size: 60)
        }

    }
    
}