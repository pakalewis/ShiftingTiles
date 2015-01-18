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
    var firstRowOrColumnTapped = -1
    var secondRowOrColumnTapped = -1
    var firstButton = UIImageView()
    var secondButton = UIImageView()
    var isFirstRowOrColumnTapped = false
    
    
    // VIEWS
    var originalImageView: UIImageView!
    @IBOutlet weak var tileArea: TileAreaView!
    @IBOutlet weak var congratsMessage: UILabel!
    @IBOutlet weak var topBank: UIView!
    @IBOutlet weak var leftBank: UIView!
    @IBOutlet weak var separatorView: UIView!

    // CONSTRAINTS
    @IBOutlet weak var leftBankTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var topBankLeftConstraint: NSLayoutConstraint!
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
        
        self.updateColors()
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
        
        
        self.originalImageView = UIImageView(frame: self.tileArea.frame)
        self.originalImageView.image = self.imageToSolve
        self.originalImageView.alpha = 0
        self.view.addSubview(originalImageView)
        
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
            topGestureArea.image = UIImage(named: "upTriangle")?.imageWithColor(self.colorPalette.fetchDarkColor())
            topGestureArea.userInteractionEnabled = true;
            var topGesture = UITapGestureRecognizer(target: self, action: "bankTapped:")
            topGestureArea.tag = index
            topGestureArea.addGestureRecognizer(topGesture)
            self.topBank.addSubview(topGestureArea)
            
            
            var leftBankGestureFrame = CGRectMake(0, leftBankGesturePositionY, leftBankGestureWidth, leftBankGestureWidth)
            var leftGestureArea = UIImageView(frame: leftBankGestureFrame)
            leftGestureArea.image = UIImage(named: "leftTriangle")?.imageWithColor(self.colorPalette.fetchDarkColor())
            leftGestureArea.userInteractionEnabled = true;
            var leftGesture = UITapGestureRecognizer(target: self, action: "bankTapped:")
            leftGestureArea.tag = index + 100
            leftGestureArea.addGestureRecognizer(leftGesture)
            self.leftBank.addSubview(leftGestureArea)
        }
    }
 

    
    func bankTapped(sender: UIGestureRecognizer) {

        var tappedButton = sender.view as UIImageView
        
        if (!isFirstRowOrColumnTapped) {
            // Flip the bool
            self.isFirstRowOrColumnTapped = true

            // Store tag of the first line button
            self.firstRowOrColumnTapped = tappedButton.tag
            self.firstButton = tappedButton
            
            // Flip the image on the button
            if (tappedButton.tag - 100) < 0 { // line 1 is a column
                self.firstButton.image = UIImage(named: "downTriangle")?.imageWithColor(self.colorPalette.fetchDarkColor())
            } else { // line1 is a row
                self.firstButton.image = UIImage(named: "rightTriangle")?.imageWithColor(self.colorPalette.fetchDarkColor())
            }
            
        } else {
            // Flip the bool
            self.isFirstRowOrColumnTapped = false

            // set the second tag
            self.secondRowOrColumnTapped = sender.view!.tag
            
            // Flip the image on the button back to normal
            if (self.firstButton.tag - 100) < 0 { // line 1 is a column
                self.firstButton.image = UIImage(named: "upTriangle")?.imageWithColor(self.colorPalette.fetchDarkColor())
            } else { // line1 is a row
                self.firstButton.image = UIImage(named: "leftTriangle")?.imageWithColor(self.colorPalette.fetchDarkColor())
            }
            
            // If two distinct lines were tapped, then swap
            if self.firstRowOrColumnTapped != self.secondRowOrColumnTapped {
                self.tileArea.swapLines(self.firstRowOrColumnTapped, line2: self.secondRowOrColumnTapped)
            }
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
        if userDefaults.integerForKey("totalSolves") < 3 {
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
    
    
    @IBAction func solveButtonPressed(sender: AnyObject) {

        var solveAlert = UIAlertController(title: "This will auto-solve the puzzle", message: "Are you sure you want to do this?", preferredStyle: UIAlertControllerStyle.Alert)
        let noAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.Cancel, handler: nil)
        let yesAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.Default) { (finished) -> Void in
            
            // TODO: Better way to handle these buttons?
            self.hintButton.userInteractionEnabled = false
            self.hintButton.alpha = 0.0
            self.solveButton.userInteractionEnabled = false
            self.solveButton.alpha = 0.0
            self.showOriginalButton.userInteractionEnabled = false
            self.showOriginalButton.alpha = 0

            self.tileArea.layoutTilesWithMargin(0.0)
            self.tileArea.orientAllTiles()
            self.tileArea.isPuzzleSolved = true
            self.puzzleIsSolved()
        }

        solveAlert.addAction(yesAction)
        solveAlert.addAction(noAction)
        self.presentViewController(solveAlert, animated: true, completion: nil)
    }
    
 
    func updateColors() {
        // Apply color scheme
        self.view.backgroundColor = self.colorPalette.fetchLightColor()
        self.congratsMessage.textColor = self.colorPalette.fetchDarkColor()
        self.separatorView.backgroundColor = self.colorPalette.fetchDarkColor()
        self.backButton.setImage(UIImage(named: "backIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), forState: UIControlState.Normal)
        self.showOriginalButton.setImage(UIImage(named: "originalImageIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), forState: UIControlState.Normal)
        self.solveButton.setImage(UIImage(named: "solveIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), forState: UIControlState.Normal)
        self.hintButton.setImage(UIImage(named: "hintIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), forState: UIControlState.Normal)


    }
    
}