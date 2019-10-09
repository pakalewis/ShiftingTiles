//
//  GameBoardVC.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 9/3/14.
//  Copyright (c) 2014 Parker Lewis. All rights reserved.
//

import Foundation
import UIKit

class GameBoardVC: UIViewController {
    class func generate(board: GameBoard) -> GameBoardVC {
        let gbvc = UIStoryboard(name: "GameBoard", bundle: nil).instantiateInitialViewController() as! GameBoardVC
        gbvc.gameBoard = board
        return gbvc
    }
    
    var gameBoard: GameBoard!
    var tileArea: TileAreaView!
    var originalImageShown = false
    
    var columnGrips = [Grip]()
    var rowGrips = [Grip]()
    var selectedGrip: Grip?

    var highlightedRowColumnMask: UIView?
    
    // MARK: VIEWS
    @IBOutlet weak var originalImageView: UIImageView!
    @IBOutlet weak var tileAreaContainer: UIView!
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

        self.topBank.backgroundColor = .clear
        self.leftBank.backgroundColor = .clear

        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            self.leftBankWidthConstraint.constant = 30
            self.topBankHeightConstraint.constant = 30
        }
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            self.leftBankWidthConstraint.constant = 50
            self.topBankHeightConstraint.constant = 50
        }

        
        self.originalImageView.image = self.gameBoard.imagePackage.image()
        self.originalImageView.layer.borderWidth = 2
        self.setOriginalImage(hidden: false)

        // Colors
        self.view.backgroundColor = Colors.fetchLightColor()
        self.congratsMessage.textColor = Colors.fetchDarkColor()
        self.imageCaptionLabel.textColor = Colors.fetchDarkColor()
        self.tileAreaContainer.layer.borderColor = Colors.fetchDarkColor().cgColor
        self.originalImageView.layer.borderColor = Colors.fetchDarkColor().cgColor
        self.separatorView.backgroundColor = Colors.fetchDarkColor()

        self.backButton.setImage(Icon.back.image(), for: .normal)
        self.backButton.tintColor = Colors.fetchDarkColor()
        self.showOriginalButton.setImage(Icon.showOriginal.image(), for: .normal)
        self.showOriginalButton.tintColor = Colors.fetchDarkColor()
        self.solveButton.setImage(Icon.solve.image(), for: .normal)
        self.solveButton.tintColor = Colors.fetchDarkColor()
        self.hintButton.setImage(Icon.hint.image(), for: .normal)
        self.hintButton.tintColor = Colors.fetchDarkColor()

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

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.tileArea = TileAreaView(gameBoard: self.gameBoard, frame: self.tileAreaContainer.frame)
        self.tileArea.delegate = self
        self.view.addSubview(tileArea)
        setOriginalImage(hidden: true)
        self.view.bringSubviewToFront(tileArea)

        // Add row/column grips
        self.initializeRowColumnGrips()
        
        // Set text fields
        self.imageCaptionLabel.text = gameBoard.imagePackage.captionText()
    }

    // MARK: Grips that allow selection/movement of an entire row or column
    func initializeRowColumnGrips() {
        // Measurements to make the frames
        let topWidth = self.topBank.frame.width / CGFloat(self.gameBoard.tilesPerRow)
        let topHeight = self.topBank.frame.height
        let leftWidth = self.leftBank.frame.width
        let leftHeight = self.leftBank.frame.height / CGFloat(self.gameBoard.tilesPerRow)
        
        for index in 0..<self.gameBoard.tilesPerRow {
            let topPositionX = self.topBank.frame.origin.x + (topWidth * CGFloat(index))
            let leftPositionY = self.leftBank.frame.origin.y + (leftHeight * CGFloat(index))
            
            // Top Grip Area
            let topFrame = CGRect(x: topPositionX, y: self.topBank.frame.origin.y, width: topWidth, height: topHeight * 0.9)
            let topGrip = Grip(gripType: .column, index: index, frame: topFrame, delegate: self)
            self.view.addSubview(topGrip)
            self.columnGrips.append(topGrip)
            
            // Left Grip Area
            let leftFrame = CGRect(x: self.leftBank.frame.origin.x, y: leftPositionY, width: leftWidth * 0.9, height: leftHeight)
            let leftGrip = Grip(gripType: .row, index: index, frame: leftFrame, delegate: self)
            self.view.addSubview(leftGrip)
            self.rowGrips.append(leftGrip)
        }
    }

    func resetGrips() {
        for grip in self.columnGrips + self.rowGrips {
            grip.gripState = .normal
        }
        self.tileArea.gameBoard.tileSelectionAllowed = true
    }



    
    // MARK: BUTTONS
    // These two funcs toggle the original image on and off
    @IBAction func showOriginalPressed(_ sender: AnyObject) {
        if self.originalImageView.isHidden {
            self.setOriginalImage(hidden: false)
            self.backButton.imageView?.alpha = 0
            self.solveButton.imageView?.alpha = 0
            self.hintButton.imageView?.alpha = 0
            self.backButton.isUserInteractionEnabled = false
            self.solveButton.isUserInteractionEnabled = false
            self.hintButton.isUserInteractionEnabled = false
            for index in 0..<self.gameBoard.tilesPerRow {
                self.columnGrips[index].alpha = 0
                self.rowGrips[index].alpha = 0
            }
        } else {
            self.setOriginalImage(hidden: true)
            self.view.sendSubviewToBack(self.originalImageView)

            // Turn on and show buttons
            self.backButton.imageView?.alpha = 1
            self.solveButton.imageView?.alpha = 1
            self.hintButton.imageView?.alpha = 1
            self.backButton.isUserInteractionEnabled = true
            self.solveButton.isUserInteractionEnabled = true
            self.hintButton.isUserInteractionEnabled = true
            for index in 0..<self.gameBoard.tilesPerRow {
                self.columnGrips[index].alpha = 1
                self.rowGrips[index].alpha = 1
            }
        }
    }

    func setOriginalImage(hidden: Bool) {
        self.originalImageView.isHidden = hidden
        if hidden {
            self.view.sendSubviewToBack(originalImageView)
        } else {
            self.view.bringSubviewToFront(originalImageView)
        }
    }

    
    // Hint button to wiggle two tiles
    @IBAction func hintButtonPressed(_ sender: AnyObject) {
        self.tileArea.showHintByWigglingTiles()
//        guard
//            let t1 = self.gameBoard.findTile(at: Coordinate(0,0)),
//            let t2 = self.gameBoard.findTile(at: Coordinate(0,1)),
//            let t3 = self.gameBoard.findTile(at: Coordinate(1,0)),
//            let t4 = self.gameBoard.findTile(at: Coordinate(0,1))
//        else { return }
//
//        self.gameBoard.swapCoordinates(t1, t2)
//        self.tileArea.animateSwap(t1, t2)
//        self.gameBoard.swapCoordinates(t3, t4)
//        self.tileArea.animateSwap(t3, t4)
    }

    @IBAction func backToMainScreen(_ sender: AnyObject) {
//        if self.tileArea.isPuzzleSolved {
//            self.dismiss(animated: true, completion: nil)
//        } else {
            if let alert = LossOfProgressAlert(delegate: self).make() {
                self.present(alert, animated: true, completion: nil)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
//        }
    }

    
    @IBAction func solveButtonPressed(_ sender: AnyObject) {
        let alert = AutoSolveAlert(delegate: self).make()
        self.present(alert, animated: true, completion: nil)
    }
    
 
    
    // MARK: Other class methods
    func puzzleIsSolved() {
        self.congratsMessage.text = Congrats.generateMessage()

        // Update stats
        let stats = Stats()
        stats.updateSolveStats(self.gameBoard.tilesPerRow)
        
        // Hide and disable buttons
        self.hintButton.isUserInteractionEnabled = false
        self.hintButton.alpha = 0
        self.solveButton.isUserInteractionEnabled = false
        self.solveButton.alpha = 0
        self.showOriginalButton.isUserInteractionEnabled = false
        self.showOriginalButton.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            // Slide off the banks of buttons
            for grip in self.columnGrips {
                grip.center.x = grip.center.x + 2000
            }
            for grip in self.rowGrips {
                grip.center.y = grip.center.y + 2000
            }
            
            }, completion: { (finished) -> Void in
                // Grow the tile area by sliding the left bank off screen to the left
                self.leftBankMarginConstraint.constant =  -self.leftBank.frame.width + 10
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                    
                    }, completion: { (finished) -> Void in
                        // Calling this again to resize all the tiles to take up the full TileArea
//                        self.tileArea.layoutTiles()
                })
        }) 
    }

    func addMask(row: Int? = nil, column: Int? = nil) {
        var rect: CGRect?
        if let row = row {
            rect = CGRect(
                x: 0,
                y: self.tileArea.frame.height * CGFloat(row) / CGFloat(self.gameBoard.tilesPerRow),
                width: self.tileArea.frame.width,
                height: self.tileArea.frame.height / CGFloat(self.gameBoard.tilesPerRow)
            )
        } else if let column = column {
            rect = CGRect(
                x: self.tileArea.frame.width * CGFloat(column) / CGFloat(self.gameBoard.tilesPerRow),
                y: 0,
                width: self.tileArea.frame.width / CGFloat(self.gameBoard.tilesPerRow),
                height: self.tileArea.frame.height
            )
        }
        guard let frame = rect else { return }
        let convertedRect = self.tileArea.convert(frame, to: self.view)
        let mask = UIView(frame: convertedRect)
        mask.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        mask.layer.borderColor = UIColor.black.cgColor
        mask.layer.borderWidth = 2
        self.view.addSubview(mask)
        self.highlightedRowColumnMask = mask
    }

}


extension GameBoardVC: GripDelegate {
    func deselectGrip() {
        self.selectedGrip = nil
        self.highlightedRowColumnMask?.removeFromSuperview()
        self.resetGrips()
    }

    func selected(grip: Grip) {
        if let firstGrip = self.selectedGrip {
            // firstGrip was already selected. now a second grip was selected
            // find tiles in the two lines and swap
            firstGrip.gripState = .normal
            firstGrip.rotate()

            self.tileArea.swapLines(firstGrip.index, grip.index, type: grip.gripType)
            self.selectedGrip = nil
            self.highlightedRowColumnMask?.removeFromSuperview()
            self.resetGrips()
        } else {
            // this is the first grip selected
            self.tileArea.gameBoard.tileSelectionAllowed = false
            self.tileArea.gameBoard.deselectAnySelectedTiles()
            grip.rotate()
            grip.gripState = .selected

            self.selectedGrip = grip
            switch grip.gripType {
            case .column:
                for grip in self.rowGrips {
                    grip.gripState = .disabled
                }
                self.addMask(column: grip.index)
            case .row:
                for grip in self.columnGrips {
                    grip.gripState = .disabled
                }
                self.addMask(row: grip.index)
            }
        }
    }
}

extension GameBoardVC: AutoSolveAlertDelegate {
    func autosolve() {
//        self.puzzleIsSolved()
//        self.tileArea.layoutTiles()
        self.tileArea.orientAllTiles()
//        self.tileArea.isPuzzleSolved = true
    }
}

extension GameBoardVC: LossOfProgressAlertDelegate {
    func lossOfProgressAccepted() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension GameBoardVC: TileAreaViewDelegate {
    func doneShuffling() {
        self.resetGrips()
    }

    func puzzleSolved() {
        self.puzzleIsSolved()
    }
}
