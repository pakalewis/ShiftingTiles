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
    
    var topButtons = [UIImageView]()
    var leftButtons = [UIImageView]()
    var rowColumnHandle : UIImageView?
    var firstButtonOriginalFrame : CGRect?
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
        self.congratsMessages = [
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
            NSLocalizedString("Message17", comment: "")]
        
        
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
        
        // Add row/column gestures
        let rowColumnGesture = UIPanGestureRecognizer(target: self, action: "handleRowColumnPan:")
        self.view.addGestureRecognizer(rowColumnGesture)
        self.initializeRowColumnGestures()
        
        // Set text fields
        congratsMessage.text = ""
        if self.currentImagePackage.caption == "" {
            self.imageCaptionLabel.text = ""
        } else {
            if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
                self.imageCaptionLabel.text = self.currentImagePackage.caption + "\n" + self.currentImagePackage.photographer
            }
            if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                self.imageCaptionLabel.text = self.currentImagePackage.caption + " — " + self.currentImagePackage.photographer
            }
        }
    }
    
    
    
    
    // MARK: Gestures to move rows and columns
    func initializeRowColumnGestures() {
        
        // Measuerments to make the frames
        var topGestureWidth = self.topBank.frame.width / CGFloat(self.tilesPerRow)
        var topGestureHeight = self.topBank.frame.height
        var leftGestureWidth = self.leftBank.frame.width
        var leftGestureHeight = self.leftBank.frame.height / CGFloat(self.tilesPerRow)
        
        for index in 0..<self.tilesPerRow {
            var topGesturePositionX = self.topBank.frame.origin.x + (topGestureWidth * CGFloat(index))
            var leftGesturePositionY = self.leftBank.frame.origin.y + (leftGestureHeight * CGFloat(index))
            
            // TopGestureArea
            var topGestureFrame = CGRectMake(topGesturePositionX, self.topBank.frame.origin.y, topGestureWidth, topGestureHeight * 0.9)
            var topGestureArea = UIImageView(frame: topGestureFrame)
            
            topGestureArea.image = UIImage(named: "roundedSquareIcon")?.imageWithColor(self.colorPalette.fetchDarkColor())
            topGestureArea.contentMode = UIViewContentMode.ScaleAspectFit
            topGestureArea.tag = index
            self.view.addSubview(topGestureArea)
            self.topButtons.append(topGestureArea)
            
            // LeftGestureArea
            var leftGestureFrame = CGRectMake(self.leftBank.frame.origin.x, leftGesturePositionY, leftGestureWidth * 0.9, leftGestureHeight)
            var leftGestureArea = UIImageView(frame: leftGestureFrame)
            leftGestureArea.image = UIImage(named: "roundedSquareIcon")?.imageWithColor(self.colorPalette.fetchDarkColor())
            leftGestureArea.contentMode = UIViewContentMode.ScaleAspectFit
            leftGestureArea.tag = index + 100
            self.view.addSubview(leftGestureArea)
            self.leftButtons.append(leftGestureArea)
        }
    }

    
    func handleRowColumnPan(gesture:UIPanGestureRecognizer) {
        var selectedRowColumnHandle : UIImageView?
        // Determine if any movement should occur
        if  !self.originalImageShown {
            switch gesture.state {
            case .Began:
                var startingPoint:CGPoint = gesture.locationInView(self.view)
                selectedRowColumnHandle = self.findButtonWithPoint(startingPoint, first: true)
                if selectedRowColumnHandle != nil { // The first handle was detected
                    self.rowColumnHandle = selectedRowColumnHandle
                    self.firstLineOfTiles = self.tileArea.makeLineOfTiles(selectedRowColumnHandle!.tag)
                    for tile in self.firstLineOfTiles! {
                        self.tileArea.bringSubviewToFront(tile.imageView)
                        tile.originalFrame = tile.imageView.frame
                    }
                    self.view.bringSubviewToFront(selectedRowColumnHandle!)
                    self.firstButtonOriginalFrame = selectedRowColumnHandle!.frame
                }
            case .Changed:
                if self.rowColumnHandle != nil {
                    let translation = gesture.translationInView(self.view)
                    if (self.rowColumnHandle!.tag - 100) < 0 { // line 1 is a column
                        if CGRectGetMinX(self.rowColumnHandle!.frame) + translation.x > CGRectGetMinX(self.tileArea.frame) && CGRectGetMaxX(self.rowColumnHandle!.frame) + translation.x < CGRectGetMaxX(self.tileArea.frame) {
                            for tile in self.firstLineOfTiles! {
                                tile.imageView.center.x = tile.imageView.center.x + translation.x
                            }
                            self.rowColumnHandle!.center.x = self.rowColumnHandle!.center.x + translation.x
                        }
                    } else { // line 1 is a Row
                        if CGRectGetMinY(self.rowColumnHandle!.frame) + translation.y > CGRectGetMinY(self.tileArea.frame) && CGRectGetMaxY(self.rowColumnHandle!.frame) + translation.y < CGRectGetMaxY(self.tileArea.frame) {
                            for tile in self.firstLineOfTiles! {
                                tile.imageView.center.y = tile.imageView.center.y + translation.y
                            }
                            self.rowColumnHandle!.center.y = self.rowColumnHandle!.center.y + translation.y
                        }
                    }
                    gesture.setTranslation(CGPointZero, inView: self.view)
                }
                
            case .Ended:
                if self.rowColumnHandle != nil {
                    var endingPoint :CGPoint = gesture.locationInView(self.view)
                    var secondRowColumnHandle = self.findButtonWithPoint(endingPoint, first: false)
                    if secondRowColumnHandle != nil {
                        // Check if they are both rows or both columns
                        if abs(self.rowColumnHandle!.tag - secondRowColumnHandle!.tag) < 11 {
                            
                            // Swap the lines of tiles
                            var secondLineOfTiles = self.tileArea.makeLineOfTiles(secondRowColumnHandle!.tag)
                            self.tileArea.swapLines(self.firstLineOfTiles!, line2: secondLineOfTiles)
                            
                            // Swap the buttons
                            UIView.animateWithDuration(0.3, animations: { () -> Void in
                                self.rowColumnHandle!.frame = secondRowColumnHandle!.frame
                                secondRowColumnHandle!.frame = self.firstButtonOriginalFrame!
                            })
                            
                            // Swap the tags of the buttons
                            var tempTag = self.rowColumnHandle!.tag
                            self.rowColumnHandle!.tag = secondRowColumnHandle!.tag
                            secondRowColumnHandle!.tag = tempTag
                            self.firstButtonOriginalFrame = nil
                            self.rowColumnHandle = nil
                            
                        } else { // Send the button and line of tiles back to where they started
                            UIView.animateWithDuration(0.3, animations: { () -> Void in
                                
                                for tile in self.firstLineOfTiles! {
                                    tile.imageView.frame = tile.originalFrame!
                                }
                                
                                self.rowColumnHandle!.frame = self.firstButtonOriginalFrame!
                                self.firstButtonOriginalFrame = nil
                                self.rowColumnHandle = nil
                            })
                        }
                    } else { // Send the button and line of tiles back to where they started
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            
                            for tile in self.firstLineOfTiles! {
                                tile.imageView.frame = tile.originalFrame!
                            }
                            
                            
                            self.rowColumnHandle!.frame = self.firstButtonOriginalFrame!
                            self.firstButtonOriginalFrame = nil
                            self.rowColumnHandle = nil
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
    
    
    func findButtonWithPoint(point: CGPoint, first: Bool) -> UIImageView? {
        for index in 0..<self.tilesPerRow {
            var area : CGRect
            var currentButton = self.topButtons[index]
            if first {
                area = currentButton.frame
            } else {
                area = CGRectMake(currentButton.frame.origin.x, currentButton.frame.origin.y - 200, currentButton.frame.size.width, currentButton.frame.size.height + 400)
            }
            if CGRectContainsPoint(area, point) && currentButton != self.rowColumnHandle {
                return currentButton
            }
        }
        for index in 0..<self.tilesPerRow {
            var area : CGRect
            var currentButton = self.leftButtons[index]
            if first {
                area = currentButton.frame
            } else {
                area = CGRectMake(currentButton.frame.origin.x - 200, currentButton.frame.origin.y, currentButton.frame.size.width + 400, currentButton.frame.size.height)
            }
            if CGRectContainsPoint(area, point) && currentButton != self.rowColumnHandle {
                return currentButton
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
                self.topButtons[index].alpha = 0
                self.leftButtons[index].alpha = 0
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
                self.topButtons[index].alpha = 1
                self.leftButtons[index].alpha = 1
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
    
 
    
    // MARK: Other funcs
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