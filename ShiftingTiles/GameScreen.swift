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
    
    // MARK: VARS
    let colorPalette = ColorPalette()
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var currentImagePackage : ImagePackage!
    var tilesPerRow = 3
    var congratsMessages : [String]!
    var originalImageShown = false
    
    var topGrips = [UIImageView]()
    var leftGrips = [UIImageView]()
    var rowColumnGrip : UIImageView?
    var firstGripOriginalFrame : CGRect?
    var firstLineOfTiles: [Tile]?
    
    // MARK: VIEWS
    @IBOutlet weak var originalImageView: UIImageView!
    @IBOutlet weak var tileArea: TileAreaView!
    @IBOutlet weak var congratsMessage: UILabel!
    @IBOutlet weak var topBank: UIView!
    @IBOutlet weak var leftBank: UIView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var imageCaptionLabel: UILabel!

    // MARK: CONSTRAINTS
    @IBOutlet weak var leftBankMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var topBankHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftBankWidthConstraint: NSLayoutConstraint!
    
    // MARK: BUTTONS
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var solveButton: UIButton!
    @IBOutlet weak var showOriginalButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    // MARK: Lifecycle funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        self.congratsMessages = [ // Populated from Localizable.strings
            NSLocalizedString("Message01", comment: ""),
            NSLocalizedString("Message02", comment: ""),
            NSLocalizedString("Message03", comment: ""),
            NSLocalizedString("Message04", comment: ""),
            NSLocalizedString("Message05", comment: ""),
            NSLocalizedString("Message06", comment: ""),
            NSLocalizedString("Message07", comment: ""),
            NSLocalizedString("Message08", comment: ""),
            NSLocalizedString("Message09", comment: ""),
            NSLocalizedString("Message10", comment: ""),
            NSLocalizedString("Message11", comment: ""),
            NSLocalizedString("Message12", comment: ""),
            NSLocalizedString("Message13", comment: ""),
            NSLocalizedString("Message14", comment: ""),
            NSLocalizedString("Message15", comment: ""),
            NSLocalizedString("Message16", comment: ""),
            NSLocalizedString("Message17", comment: "")
        ]
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            self.leftBankWidthConstraint.constant = 30
            self.topBankHeightConstraint.constant = 30
        }
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            self.leftBankWidthConstraint.constant = 50
            self.topBankHeightConstraint.constant = 50
        }

        
        self.originalImageView.image = self.currentImagePackage.image!
        self.originalImageView.layer.borderWidth = 2
        self.originalImageView.alpha = 0
        self.view.sendSubviewToBack(originalImageView)

        self.updateColorsAndFonts()
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Initialize tileArea
        self.tileArea.delegate = self
        self.tileArea.imageToSolve = self.currentImagePackage.image!
        self.tileArea.tilesPerRow = self.tilesPerRow
        self.view.bringSubviewToFront(self.tileArea)
        self.tileArea.initialize()
        self.tileArea.layer.borderWidth = 2
        
        // Add row/column gesture
        let rowColumnGripPanGesture = UIPanGestureRecognizer(target: self, action: "handleRowColumnGripPan:")
        self.view.addGestureRecognizer(rowColumnGripPanGesture)
        self.initializeRowColumnGrips()
        
        // Set text fields
        congratsMessage.text = ""
        if self.currentImagePackage.caption == "" {
            self.imageCaptionLabel.text = ""
        } else {
            if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
                self.imageCaptionLabel.text = "\"\(self.currentImagePackage.caption)\"" + "\nby " + self.currentImagePackage.photographer
            }
            if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                self.imageCaptionLabel.text = self.currentImagePackage.caption + " — " + self.currentImagePackage.photographer
            }
        }
    }
    
    
    
    
    // MARK: Grips that allow movement of an entire row or column
    func initializeRowColumnGrips() {
        
        // Measurements to make the frames
        var topWidth = self.topBank.frame.width / CGFloat(self.tilesPerRow)
        var topHeight = self.topBank.frame.height
        var leftWidth = self.leftBank.frame.width
        var leftHeight = self.leftBank.frame.height / CGFloat(self.tilesPerRow)
        
        for index in 0..<self.tilesPerRow {
            var topPositionX = self.topBank.frame.origin.x + (topWidth * CGFloat(index))
            var leftPositionY = self.leftBank.frame.origin.y + (leftHeight * CGFloat(index))
            
            // Top Grip Area
            var topFrame = CGRectMake(topPositionX, self.topBank.frame.origin.y, topWidth, topHeight * 0.9)
            var topArea = UIImageView(frame: topFrame)
            topArea.image = UIImage(named: "roundedSquareIcon")?.imageWithColor(self.colorPalette.fetchDarkColor())
            topArea.contentMode = UIViewContentMode.ScaleAspectFit
            topArea.tag = index // This is used later to determine row vs column
            self.view.addSubview(topArea)
            self.topGrips.append(topArea)
            
            // Left Grip Area
            var leftFrame = CGRectMake(self.leftBank.frame.origin.x, leftPositionY, leftWidth * 0.9, leftHeight)
            var leftArea = UIImageView(frame: leftFrame)
            leftArea.image = UIImage(named: "roundedSquareIcon")?.imageWithColor(self.colorPalette.fetchDarkColor())
            leftArea.contentMode = UIViewContentMode.ScaleAspectFit
            leftArea.tag = index + 100 // This is used later to determine row vs column
            self.view.addSubview(leftArea)
            self.leftGrips.append(leftArea)
        }
    }

    
    func handleRowColumnGripPan(gesture:UIPanGestureRecognizer) {
        if  !self.originalImageShown { // Gesture should be allowed
            switch gesture.state {
            case .Began:
                var startingPoint:CGPoint = gesture.locationInView(self.view)
                self.rowColumnGrip = self.findRowColumnGripWithPoint(startingPoint, first: true)
                if self.rowColumnGrip != nil { // The first handle was detected and stored for later
                    self.firstLineOfTiles = self.tileArea.makeLineOfTiles(self.rowColumnGrip!.tag)
                    for tile in self.firstLineOfTiles! {
                        self.tileArea.bringSubviewToFront(tile.imageView)
                        tile.originalFrame = tile.imageView.frame
                    }
                    self.view.bringSubviewToFront(self.rowColumnGrip!)
                    self.firstGripOriginalFrame = self.rowColumnGrip!.frame
                }
            case .Changed:
                if self.rowColumnGrip != nil { // There is a grip selected. Determine translation
                    let translation = gesture.translationInView(self.view)
                    if (self.rowColumnGrip!.tag - 100) < 0 { // line 1 is a column
                        if CGRectGetMinX(self.rowColumnGrip!.frame) + translation.x > CGRectGetMinX(self.tileArea.frame) && CGRectGetMaxX(self.rowColumnGrip!.frame) + translation.x < CGRectGetMaxX(self.tileArea.frame) {
                            // Translation is valid - translate the line of tiles and grip
                            for tile in self.firstLineOfTiles! {
                                tile.imageView.center.x = tile.imageView.center.x + translation.x
                            }
                            self.rowColumnGrip!.center.x = self.rowColumnGrip!.center.x + translation.x
                        }
                    } else { // line 1 is a Row
                        if CGRectGetMinY(self.rowColumnGrip!.frame) + translation.y > CGRectGetMinY(self.tileArea.frame) && CGRectGetMaxY(self.rowColumnGrip!.frame) + translation.y < CGRectGetMaxY(self.tileArea.frame) {
                            // Translation is valid - translate the line of tiles and grip
                            for tile in self.firstLineOfTiles! {
                                tile.imageView.center.y = tile.imageView.center.y + translation.y
                            }
                            self.rowColumnGrip!.center.y = self.rowColumnGrip!.center.y + translation.y
                        }
                    }
                    gesture.setTranslation(CGPointZero, inView: self.view)
                }
            case .Ended:
                if self.rowColumnGrip != nil {
                    var endingPoint :CGPoint = gesture.locationInView(self.view)
                    var secondRowColumnGrip = self.findRowColumnGripWithPoint(endingPoint, first: false)
                    if secondRowColumnGrip != nil { // A valid second grip was found at the endingPoint
                        // Swap the lines of tiles
                        var secondLineOfTiles = self.tileArea.makeLineOfTiles(secondRowColumnGrip!.tag)
                        self.tileArea.swapLines(self.firstLineOfTiles!, line2: secondLineOfTiles)
                        
                        // Swap the grips
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            self.rowColumnGrip!.frame = secondRowColumnGrip!.frame
                            secondRowColumnGrip!.frame = self.firstGripOriginalFrame!
                        })
                        
                        // Swap the tags of the buttons
                        var tempTag = self.rowColumnGrip!.tag
                        self.rowColumnGrip!.tag = secondRowColumnGrip!.tag
                        secondRowColumnGrip!.tag = tempTag
                        self.firstGripOriginalFrame = nil
                        self.rowColumnGrip = nil

                    } else { // Send the button and line of tiles back to where they started
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            for tile in self.firstLineOfTiles! {
                                tile.imageView.frame = tile.originalFrame!
                            }
                            self.rowColumnGrip!.frame = self.firstGripOriginalFrame!
                            self.firstGripOriginalFrame = nil
                            self.rowColumnGrip = nil
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
    }
    
    
    // This returns a grip that contains a CGPoint. Used to find the initial grip when first is true. Else, use a larger target space to find a grip when the pan gesture ends
    func findRowColumnGripWithPoint(point: CGPoint, first: Bool) -> UIImageView? {
        for index in 0..<self.tilesPerRow {
            var topArea : CGRect
            var leftArea : CGRect
            var topGrip = self.topGrips[index]
            var leftGrip = self.leftGrips[index]
            if first { // Find the initial grip
                topArea = topGrip.frame
                leftArea = leftGrip.frame
                if CGRectContainsPoint(topArea, point) {
                    return topGrip
                }
                if CGRectContainsPoint(leftArea, point) {
                    return leftGrip
                }
            } else {
                // The target areas are larger to make it easier to find the second grip / column to swap
                // Ensure that it is not the same as the first grip
                // Check if it is of similar type (row vs column)
                topArea = CGRectMake(topGrip.frame.origin.x, topGrip.frame.origin.y - 200, topGrip.frame.size.width, topGrip.frame.size.height + 400)
                leftArea = CGRectMake(leftGrip.frame.origin.x - 200, leftGrip.frame.origin.y, leftGrip.frame.size.width + 400, leftGrip.frame.size.height)
                if CGRectContainsPoint(topArea, point) && topGrip != self.rowColumnGrip && abs(self.rowColumnGrip!.tag - topGrip.tag) < 11 {
                    return topGrip
                }
                if CGRectContainsPoint(leftArea, point) && leftGrip != self.rowColumnGrip && abs(self.rowColumnGrip!.tag - leftGrip.tag) < 11  {
                    return leftGrip
                }
            }
        }
        return nil
    }

    

    
    // MARK: BUTTONS
    // These two funcs toggle the original image on and off
    @IBAction func showOriginalPressed(sender: AnyObject) {
        
        if !self.originalImageShown {
            self.originalImageShown = true
            self.tileArea.allowTileShifting = false
            self.view.bringSubviewToFront(self.originalImageView)
            self.originalImageView.alpha = 1

            // Turn off and hide buttons
            self.backButton.imageView?.alpha = 0
            self.solveButton.imageView?.alpha = 0
            self.hintButton.imageView?.alpha = 0
            self.backButton.userInteractionEnabled = false
            self.solveButton.userInteractionEnabled = false
            self.hintButton.userInteractionEnabled = false
            for index in 0..<self.tilesPerRow {
                self.topGrips[index].alpha = 0
                self.leftGrips[index].alpha = 0
            }
        } else {
            self.originalImageShown = false
            self.originalImageView.alpha = 0
            self.view.sendSubviewToBack(self.originalImageView)

            // Turn on and show buttons
            self.backButton.imageView?.alpha = 1
            self.solveButton.imageView?.alpha = 1
            self.hintButton.imageView?.alpha = 1
            self.backButton.userInteractionEnabled = true
            self.solveButton.userInteractionEnabled = true
            self.hintButton.userInteractionEnabled = true
            for index in 0..<self.tilesPerRow {
                self.topGrips[index].alpha = 1
                self.leftGrips[index].alpha = 1
            }
            self.tileArea.allowTileShifting = true
        }
    }

    
    // Hint button to wiggle two tiles
    @IBAction func hintButtonPressed(sender: AnyObject) {
        self.tileArea.wiggleTiles()
    }
   

    
    @IBAction func backToMainScreen(sender: AnyObject) {
        if self.tileArea.isPuzzleSolved {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            var numTimesBackButtonPressed = self.userDefaults.integerForKey("backButtonPressed")
            numTimesBackButtonPressed++
            self.userDefaults.setInteger(numTimesBackButtonPressed, forKey: "backButtonPressed")
            if userDefaults.integerForKey("backButtonPressed") < 3 {
                // Only show this alert for the first 3 times the user presses the back button
                var lossOfProgressAlert = UIAlertController(title: NSLocalizedString("LossOfProgressAlert_Part1", comment: ""), message: NSLocalizedString("LossOfProgressAlert_Part2", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
                let noAction = UIAlertAction(title: NSLocalizedString("NO", comment: ""), style: UIAlertActionStyle.Cancel, handler: nil)
                let yesAction = UIAlertAction(title: NSLocalizedString("YES", comment: ""), style: UIAlertActionStyle.Default, handler: { (ok) -> Void in
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
        var solveAlert = UIAlertController(title: NSLocalizedString("SolveAlert_Part1", comment: ""), message: NSLocalizedString("SolveAlert_Part2", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
        let noAction = UIAlertAction(title: NSLocalizedString("NO", comment: ""), style: UIAlertActionStyle.Cancel, handler: nil)
        let yesAction = UIAlertAction(title: NSLocalizedString("YES", comment: ""), style: UIAlertActionStyle.Default) { (finished) -> Void in
            
            self.puzzleIsSolved()
            self.tileArea.layoutTiles()
            self.tileArea.orientAllTiles()
            self.tileArea.isPuzzleSolved = true
        }

        solveAlert.addAction(yesAction)
        solveAlert.addAction(noAction)
        self.presentViewController(solveAlert, animated: true, completion: nil)
    }
    
 
    
    // MARK: Other class methods
    func puzzleIsSolved() {
        
        // Display congrats message
        if userDefaults.boolForKey("congratsOn") {
            var randomInt = Int(arc4random_uniform(UInt32(self.congratsMessages.count)))
            self.congratsMessage.text = self.congratsMessages[randomInt]
        }

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
            for grip in self.topGrips {
                grip.center.x = grip.center.x + 2000
            }
            for grip in self.leftGrips {
                grip.center.y = grip.center.y + 2000
            }
            
            }) { (finished) -> Void in
                // Grow the tile area by sliding the left bank off screen to the left
                self.leftBankMarginConstraint.constant =  -self.leftBank.frame.width + 10
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                    
                    }) { (finished) -> Void in
                        // Calling this again to resize all the tiles to take up the full TileArea
                        self.tileArea.layoutTiles()
                }
        }
    }

    
    func updateColorsAndFonts() {
        // Colors
        self.view.backgroundColor = self.colorPalette.fetchLightColor()
        self.congratsMessage.textColor = self.colorPalette.fetchDarkColor()
        self.imageCaptionLabel.textColor = self.colorPalette.fetchDarkColor()
        self.tileArea.layer.borderColor = self.colorPalette.fetchDarkColor().CGColor
        self.originalImageView.layer.borderColor = self.colorPalette.fetchDarkColor().CGColor
        self.separatorView.backgroundColor = self.colorPalette.fetchDarkColor()
        self.backButton.setImage(UIImage(named: "backIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), forState: UIControlState.Normal)
        self.showOriginalButton.setImage(UIImage(named: "originalImageIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), forState: UIControlState.Normal)
        self.solveButton.setImage(UIImage(named: "solveIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), forState: UIControlState.Normal)
        self.hintButton.setImage(UIImage(named: "hintIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), forState: UIControlState.Normal)

        // Fonts
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            self.congratsMessage.font = UIFont(name: "OpenSans-Bold", size: 35)
            self.imageCaptionLabel.font = UIFont(name: "OpenSans", size: 15)
        }
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            self.congratsMessage.font = UIFont(name: "OpenSans-Bold", size: 60)
            self.imageCaptionLabel.font = UIFont(name: "OpenSans", size: 23)
        }

    }
    
}