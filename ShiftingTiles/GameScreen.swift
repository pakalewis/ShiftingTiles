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
    let userDefaults = UserDefaults.standard
    
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            self.leftBankWidthConstraint.constant = 30
            self.topBankHeightConstraint.constant = 30
        }
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            self.leftBankWidthConstraint.constant = 50
            self.topBankHeightConstraint.constant = 50
        }

        
        self.originalImageView.image = self.currentImagePackage.image!
        self.originalImageView.layer.borderWidth = 2
        self.originalImageView.alpha = 0
        self.view.sendSubview(toBack: originalImageView)

        self.updateColorsAndFonts()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Initialize tileArea
        self.tileArea.delegate = self
        self.tileArea.imageToSolve = self.currentImagePackage.image!
        self.tileArea.tilesPerRow = self.tilesPerRow
        self.view.bringSubview(toFront: self.tileArea)
        self.tileArea.initialize()
        self.tileArea.layer.borderWidth = 2
        
        // Add row/column gesture
        let rowColumnGripPanGesture = UIPanGestureRecognizer(target: self, action: #selector(GameScreen.handleRowColumnGripPan(_:)))
        self.view.addGestureRecognizer(rowColumnGripPanGesture)
        self.initializeRowColumnGrips()
        
        // Set text fields
        congratsMessage.text = ""
        if self.currentImagePackage.caption == "" {
            self.imageCaptionLabel.text = ""
        } else {
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
                self.imageCaptionLabel.text = "\"\(self.currentImagePackage.caption)\"" + "\nby " + self.currentImagePackage.photographer
            }
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                self.imageCaptionLabel.text = self.currentImagePackage.caption + " — " + self.currentImagePackage.photographer
            }
        }
    }
    
    
    
    
    // MARK: Grips that allow movement of an entire row or column
    func initializeRowColumnGrips() {
        
        // Measurements to make the frames
        let topWidth = self.topBank.frame.width / CGFloat(self.tilesPerRow)
        let topHeight = self.topBank.frame.height
        let leftWidth = self.leftBank.frame.width
        let leftHeight = self.leftBank.frame.height / CGFloat(self.tilesPerRow)
        
        for index in 0..<self.tilesPerRow {
            let topPositionX = self.topBank.frame.origin.x + (topWidth * CGFloat(index))
            let leftPositionY = self.leftBank.frame.origin.y + (leftHeight * CGFloat(index))
            
            // Top Grip Area
            let topFrame = CGRect(x: topPositionX, y: self.topBank.frame.origin.y, width: topWidth, height: topHeight * 0.9)
            let topArea = UIImageView(frame: topFrame)
            topArea.image = UIImage(named: "roundedSquareIcon")?.imageWithColor(self.colorPalette.fetchDarkColor())
            topArea.contentMode = UIViewContentMode.scaleAspectFit
            topArea.tag = index // This is used later to determine row vs column
            self.view.addSubview(topArea)
            self.topGrips.append(topArea)
            
            // Left Grip Area
            let leftFrame = CGRect(x: self.leftBank.frame.origin.x, y: leftPositionY, width: leftWidth * 0.9, height: leftHeight)
            let leftArea = UIImageView(frame: leftFrame)
            leftArea.image = UIImage(named: "roundedSquareIcon")?.imageWithColor(self.colorPalette.fetchDarkColor())
            leftArea.contentMode = UIViewContentMode.scaleAspectFit
            leftArea.tag = index + 100 // This is used later to determine row vs column
            self.view.addSubview(leftArea)
            self.leftGrips.append(leftArea)
        }
    }

    
    func handleRowColumnGripPan(_ gesture:UIPanGestureRecognizer) {
        if  !self.originalImageShown { // Gesture should be allowed
            switch gesture.state {
            case .began:
                let startingPoint:CGPoint = gesture.location(in: self.view)
                self.rowColumnGrip = self.findRowColumnGripWithPoint(startingPoint, first: true)
                if self.rowColumnGrip != nil { // The first handle was detected and stored for later
                    self.firstLineOfTiles = self.tileArea.makeLineOfTiles(self.rowColumnGrip!.tag)
                    for tile in self.firstLineOfTiles! {
                        self.tileArea.bringSubview(toFront: tile.imageView)
                        tile.originalFrame = tile.imageView.frame
                    }
                    self.view.bringSubview(toFront: self.rowColumnGrip!)
                    self.firstGripOriginalFrame = self.rowColumnGrip!.frame
                }
            case .changed:
                if self.rowColumnGrip != nil { // There is a grip selected. Determine translation
                    let translation = gesture.translation(in: self.view)
                    if (self.rowColumnGrip!.tag - 100) < 0 { // line 1 is a column
                        if self.rowColumnGrip!.frame.minX + translation.x > self.tileArea.frame.minX && self.rowColumnGrip!.frame.maxX + translation.x < self.tileArea.frame.maxX {
                            // Translation is valid - translate the line of tiles and grip
                            for tile in self.firstLineOfTiles! {
                                tile.imageView.center.x = tile.imageView.center.x + translation.x
                            }
                            self.rowColumnGrip!.center.x = self.rowColumnGrip!.center.x + translation.x
                        }
                    } else { // line 1 is a Row
                        if self.rowColumnGrip!.frame.minY + translation.y > self.tileArea.frame.minY && self.rowColumnGrip!.frame.maxY + translation.y < self.tileArea.frame.maxY {
                            // Translation is valid - translate the line of tiles and grip
                            for tile in self.firstLineOfTiles! {
                                tile.imageView.center.y = tile.imageView.center.y + translation.y
                            }
                            self.rowColumnGrip!.center.y = self.rowColumnGrip!.center.y + translation.y
                        }
                    }
                    gesture.setTranslation(CGPoint.zero, in: self.view)
                }
            case .ended:
                if self.rowColumnGrip != nil {
                    let endingPoint :CGPoint = gesture.location(in: self.view)
                    let secondRowColumnGrip = self.findRowColumnGripWithPoint(endingPoint, first: false)
                    if secondRowColumnGrip != nil { // A valid second grip was found at the endingPoint
                        // Swap the lines of tiles
                        let secondLineOfTiles = self.tileArea.makeLineOfTiles(secondRowColumnGrip!.tag)
                        self.tileArea.swapLines(self.firstLineOfTiles!, line2: secondLineOfTiles)
                        
                        // Swap the grips
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            self.rowColumnGrip!.frame = secondRowColumnGrip!.frame
                            secondRowColumnGrip!.frame = self.firstGripOriginalFrame!
                        })
                        
                        // Swap the tags of the buttons
                        let tempTag = self.rowColumnGrip!.tag
                        self.rowColumnGrip!.tag = secondRowColumnGrip!.tag
                        secondRowColumnGrip!.tag = tempTag
                        self.firstGripOriginalFrame = nil
                        self.rowColumnGrip = nil

                    } else { // Send the button and line of tiles back to where they started
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            for tile in self.firstLineOfTiles! {
                                tile.imageView.frame = tile.originalFrame!
                            }
                            self.rowColumnGrip!.frame = self.firstGripOriginalFrame!
                            self.firstGripOriginalFrame = nil
                            self.rowColumnGrip = nil
                        })
                    }
                }
            case .possible:
                print("possible")
            case .cancelled:
                print("cancelled")
            case .failed:
                print("failed")
            }
        }
    }
    
    
    // This returns a grip that contains a CGPoint. Used to find the initial grip when first is true. Else, use a larger target space to find a grip when the pan gesture ends
    func findRowColumnGripWithPoint(_ point: CGPoint, first: Bool) -> UIImageView? {
        for index in 0..<self.tilesPerRow {
            var topArea : CGRect
            var leftArea : CGRect
            let topGrip = self.topGrips[index]
            let leftGrip = self.leftGrips[index]
            if first { // Find the initial grip
                topArea = topGrip.frame
                leftArea = leftGrip.frame
                if topArea.contains(point) {
                    return topGrip
                }
                if leftArea.contains(point) {
                    return leftGrip
                }
            } else {
                // The target areas are larger to make it easier to find the second grip / column to swap
                // Ensure that it is not the same as the first grip
                // Check if it is of similar type (row vs column)
                topArea = CGRect(x: topGrip.frame.origin.x, y: topGrip.frame.origin.y - 200, width: topGrip.frame.size.width, height: topGrip.frame.size.height + 400)
                leftArea = CGRect(x: leftGrip.frame.origin.x - 200, y: leftGrip.frame.origin.y, width: leftGrip.frame.size.width + 400, height: leftGrip.frame.size.height)
                if topArea.contains(point) && topGrip != self.rowColumnGrip && abs(self.rowColumnGrip!.tag - topGrip.tag) < 11 {
                    return topGrip
                }
                if leftArea.contains(point) && leftGrip != self.rowColumnGrip && abs(self.rowColumnGrip!.tag - leftGrip.tag) < 11  {
                    return leftGrip
                }
            }
        }
        return nil
    }

    

    
    // MARK: BUTTONS
    // These two funcs toggle the original image on and off
    @IBAction func showOriginalPressed(_ sender: AnyObject) {
        
        if !self.originalImageShown {
            self.originalImageShown = true
            self.tileArea.allowTileShifting = false
            self.view.bringSubview(toFront: self.originalImageView)
            self.originalImageView.alpha = 1

            // Turn off and hide buttons
            self.backButton.imageView?.alpha = 0
            self.solveButton.imageView?.alpha = 0
            self.hintButton.imageView?.alpha = 0
            self.backButton.isUserInteractionEnabled = false
            self.solveButton.isUserInteractionEnabled = false
            self.hintButton.isUserInteractionEnabled = false
            for index in 0..<self.tilesPerRow {
                self.topGrips[index].alpha = 0
                self.leftGrips[index].alpha = 0
            }
        } else {
            self.originalImageShown = false
            self.originalImageView.alpha = 0
            self.view.sendSubview(toBack: self.originalImageView)

            // Turn on and show buttons
            self.backButton.imageView?.alpha = 1
            self.solveButton.imageView?.alpha = 1
            self.hintButton.imageView?.alpha = 1
            self.backButton.isUserInteractionEnabled = true
            self.solveButton.isUserInteractionEnabled = true
            self.hintButton.isUserInteractionEnabled = true
            for index in 0..<self.tilesPerRow {
                self.topGrips[index].alpha = 1
                self.leftGrips[index].alpha = 1
            }
            self.tileArea.allowTileShifting = true
        }
    }

    
    // Hint button to wiggle two tiles
    @IBAction func hintButtonPressed(_ sender: AnyObject) {
        self.tileArea.wiggleTiles()
    }
   

    
    @IBAction func backToMainScreen(_ sender: AnyObject) {
        if self.tileArea.isPuzzleSolved {
            self.dismiss(animated: true, completion: nil)
        } else {
            var numTimesBackButtonPressed = self.userDefaults.integer(forKey: "backButtonPressed")
            numTimesBackButtonPressed += 1
            self.userDefaults.set(numTimesBackButtonPressed, forKey: "backButtonPressed")
            if userDefaults.integer(forKey: "backButtonPressed") < 3 {
                // Only show this alert for the first 3 times the user presses the back button
                let lossOfProgressAlert = UIAlertController(title: NSLocalizedString("LossOfProgressAlert_Part1", comment: ""), message: NSLocalizedString("LossOfProgressAlert_Part2", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
                let noAction = UIAlertAction(title: NSLocalizedString("NO", comment: ""), style: UIAlertActionStyle.cancel, handler: nil)
                let yesAction = UIAlertAction(title: NSLocalizedString("YES", comment: ""), style: UIAlertActionStyle.default, handler: { (ok) -> Void in
                    self.dismiss(animated: true, completion: nil)
                })
                lossOfProgressAlert.addAction(yesAction)
                lossOfProgressAlert.addAction(noAction)
                self.present(lossOfProgressAlert, animated: true, completion: nil)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }        
    }

    
    @IBAction func solveButtonPressed(_ sender: AnyObject) {
        let solveAlert = UIAlertController(title: NSLocalizedString("SolveAlert_Part1", comment: ""), message: NSLocalizedString("SolveAlert_Part2", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        let noAction = UIAlertAction(title: NSLocalizedString("NO", comment: ""), style: UIAlertActionStyle.cancel, handler: nil)
        let yesAction = UIAlertAction(title: NSLocalizedString("YES", comment: ""), style: UIAlertActionStyle.default) { (finished) -> Void in
            
            self.puzzleIsSolved()
            self.tileArea.layoutTiles()
            self.tileArea.orientAllTiles()
            self.tileArea.isPuzzleSolved = true
        }

        solveAlert.addAction(yesAction)
        solveAlert.addAction(noAction)
        self.present(solveAlert, animated: true, completion: nil)
    }
    
 
    
    // MARK: Other class methods
    func puzzleIsSolved() {
        
        // Display congrats message
        if userDefaults.bool(forKey: "congratsOn") {
            let randomInt = Int(arc4random_uniform(UInt32(self.congratsMessages.count)))
            self.congratsMessage.text = self.congratsMessages[randomInt]
        }

        // Update stats
        let stats = Stats()
        stats.updateSolveStats(self.tilesPerRow)
        
        // Hide and disable buttons
        self.hintButton.isUserInteractionEnabled = false
        self.hintButton.alpha = 0
        self.solveButton.isUserInteractionEnabled = false
        self.solveButton.alpha = 0
        self.showOriginalButton.isUserInteractionEnabled = false
        self.showOriginalButton.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            // Slide off the banks of buttons
            for grip in self.topGrips {
                grip.center.x = grip.center.x + 2000
            }
            for grip in self.leftGrips {
                grip.center.y = grip.center.y + 2000
            }
            
            }, completion: { (finished) -> Void in
                // Grow the tile area by sliding the left bank off screen to the left
                self.leftBankMarginConstraint.constant =  -self.leftBank.frame.width + 10
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                    
                    }, completion: { (finished) -> Void in
                        // Calling this again to resize all the tiles to take up the full TileArea
                        self.tileArea.layoutTiles()
                }) 
        }) 
    }

    
    func updateColorsAndFonts() {
        // Colors
        self.view.backgroundColor = self.colorPalette.fetchLightColor()
        self.congratsMessage.textColor = self.colorPalette.fetchDarkColor()
        self.imageCaptionLabel.textColor = self.colorPalette.fetchDarkColor()
        self.tileArea.layer.borderColor = self.colorPalette.fetchDarkColor().cgColor
        self.originalImageView.layer.borderColor = self.colorPalette.fetchDarkColor().cgColor
        self.separatorView.backgroundColor = self.colorPalette.fetchDarkColor()
        self.backButton.setImage(UIImage(named: "backIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControlState())
        self.showOriginalButton.setImage(UIImage(named: "originalImageIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControlState())
        self.solveButton.setImage(UIImage(named: "solveIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControlState())
        self.hintButton.setImage(UIImage(named: "hintIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControlState())

        // Fonts
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            self.congratsMessage.font = UIFont(name: "OpenSans-Bold", size: 35)
            self.imageCaptionLabel.font = UIFont(name: "OpenSans", size: 15)
        }
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            self.congratsMessage.font = UIFont(name: "OpenSans-Bold", size: 60)
            self.imageCaptionLabel.font = UIFont(name: "OpenSans", size: 23)
        }

    }
    
}
