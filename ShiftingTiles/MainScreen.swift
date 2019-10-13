//
//  MainScreen.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 9/3/14.
//  Copyright (c) 2014 Parker Lewis. All rights reserved.
//



import Foundation
import UIKit

class MainScreen: UIViewController, UINavigationControllerDelegate {

    let photoBrowser = PhotoBrowser()

    
    // MARK: VIEWS
    @IBOutlet weak var shiftingTilesLabel: UILabel!
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tilesPerRowLabel: UILabel!

    @IBOutlet weak var selectCategoryButton: UIButton!
    @IBOutlet weak var categoryStack: UIStackView!
    

    // Other buttons
    @IBOutlet weak var statsButton: UIButton!
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var letsPlayButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    
    
    // MARK: Lifecycle methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tilesPerRow = UserSettings.intValue(for: .tilePerRow)
        self.tilesPerRowLabel.text = "\(tilesPerRow) x \(tilesPerRow)"
        self.tilesPerRowLabel.adjustsFontSizeToFitWidth = true

        self.mainImageView.layer.borderWidth = 2
        self.letsPlayButton.layer.cornerRadius = self.letsPlayButton.frame.width * 0.25
        self.letsPlayButton.layer.borderWidth = 2
        self.letsPlayButton.layer.borderColor = Colors.fetchDarkColor().cgColor

        self.updateColorsAndFonts()
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        shrinkCategories()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        

        // CollectionView
        let nib = UINib(nibName: "CollectionViewImageCell", bundle: Bundle.main)
        self.imageCollection.register(nib, forCellWithReuseIdentifier: "CELL")
        self.photoBrowser.observe(collectionView: imageCollection, delegate: self)
        
        
        // Randomly choose a category and set the initial image
        for category in photoBrowser.categories {
            let button = CategoryButton(category: category, delegate: self)
            categoryStack.addArrangedSubview(button)
        }
    }
    
    
    
    
    //MARK: CATEGORIES
    @IBAction func selectCategoryButtonPressed(_ sender: AnyObject) {
        if categoryStack.arrangedSubviews.first?.isHidden ?? false {
            self.expandCategories()
        } else {
            self.shrinkCategories()

        }
    }
    
    
    func expandCategories() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            for sv in self.categoryStack.arrangedSubviews {
                sv.isHidden = false
            }
        })
    }
    
    
    func shrinkCategories() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            for sv in self.categoryStack.arrangedSubviews {
                sv.isHidden = true
            }
        })
    }

    func updateMainImageView(image: UIImage) {
        UIView.transition(with: self.mainImageView,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: { self.mainImageView.image = image },
            completion: nil)
    }
    
    
    @IBAction func rightButtonPressed(_ sender: AnyObject) {
        var currentTilesPerRow = UserSettings.intValue(for: .tilePerRow)

        if currentTilesPerRow < 10 {
            currentTilesPerRow += 1
            self.tilesPerRowLabel.text = "\(currentTilesPerRow) x \(currentTilesPerRow)"
            UserSettings.set(value: currentTilesPerRow, for: .tilePerRow)
        }
   }

    
    @IBAction func leftButtonPressed(_ sender: AnyObject) {
        var currentTilesPerRow = UserSettings.intValue(for: .tilePerRow)
        if currentTilesPerRow > 2 {
            currentTilesPerRow -= 1
            self.tilesPerRowLabel.text = "\(currentTilesPerRow) x \(currentTilesPerRow)"
            UserSettings.set(value: currentTilesPerRow, for: .tilePerRow)
        }
    }
    
    @IBAction func statsButtonTapped(_ sender: Any) {
        let stats = StatsScreen.generate()
        present(stats, animated: true, completion: nil)
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        let infoVC = InfoScreen()
        present(infoVC, animated: true, completion: nil)
    }
    
    @IBAction func letsPlayButtonTapped(_ sender: Any) {
        let board = GameBoard(imagePackage: self.photoBrowser.currentPackage(), tilesPerRow:             UserSettings.intValue(for: .tilePerRow))

        let gameBoardVC = GameBoardVC.generate(board: board)
        self.navigationController?.pushViewController(gameBoardVC, animated: true)
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        let settings = SettingsScreen.generate()
        present(settings, animated: true, completion: nil)

    }
    
    func updateColorsAndFonts() {
        // Colors
        self.view.backgroundColor = Colors.fetchLightColor()

        self.shiftingTilesLabel.textColor = Colors.fetchDarkColor()
        self.tilesPerRowLabel.textColor = Colors.fetchDarkColor()
        self.mainImageView.layer.borderColor = Colors.fetchDarkColor().cgColor

        // Icons
        self.selectCategoryButton.setImage(Icon.menu.image(), for: .normal)
        self.selectCategoryButton.tintColor = Colors.fetchDarkColor()
        self.statsButton.setImage(Icon.stats.image(), for: .normal)
        self.statsButton.tintColor = Colors.fetchDarkColor()
        self.decreaseButton.setImage(Icon.decrease.image(), for: .normal)
        self.decreaseButton.tintColor = Colors.fetchDarkColor()
        self.increaseButton.setImage(Icon.increase.image(), for: .normal)
        self.increaseButton.tintColor = Colors.fetchDarkColor()
        self.infoButton.setImage(Icon.info.image(), for: .normal)
        self.infoButton.tintColor = Colors.fetchDarkColor()
        self.letsPlayButton.setImage(Icon.go.image(), for: .normal)
        self.letsPlayButton.tintColor = Colors.fetchDarkColor()
        self.settingsButton.setImage(Icon.settings.image(), for: .normal)
        self.settingsButton.tintColor = Colors.fetchDarkColor()

        self.separatorView.backgroundColor = Colors.fetchLightColor()

        // Fonts
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            self.shiftingTilesLabel.font = UIFont(name: "OpenSans-Bold", size: 40)
            self.tilesPerRowLabel.font = UIFont(name: "OpenSans-Bold", size: 15)
//            for count in 0..<self.categoryButtons.count {
//                self.categoryButtons[count].titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 15)
//            }
        }
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            self.shiftingTilesLabel.font = UIFont(name: "OpenSans-Bold", size: 70)
            self.tilesPerRowLabel.font = UIFont(name: "OpenSans-Bold", size: 30)
//            for count in 0..<self.categoryButtons.count {
//                self.categoryButtons[count].titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 30)
//            }
        }
    }
}


extension MainScreen: CategoryButtonDelegate {
    func selected(category: PhotoCategory) {
        if self.photoBrowser.currentCategory == category { return }
        
        self.photoBrowser.currentCategory = category
        self.imageCollection.reloadData()
        self.updateMainImageView(image: photoBrowser.currentPackage().image())

        self.shrinkCategories()
    }
}


extension MainScreen: PhotoBrowserDelegate {
    func display() {
        self.updateMainImageView(image: photoBrowser.currentPackage().image())
    }
}
