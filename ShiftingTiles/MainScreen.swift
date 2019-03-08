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

    // MARK: Misc vars
    let colorPalette = ColorPalette()
    let userDefaults = UserDefaults.standard

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
        

        var tilesPerRow = self.userDefaults.integer(forKey: "tilesPerRow")
        if tilesPerRow < 2 || tilesPerRow > 10 {
            // This may occur when the tilesPerRow userDefault was never set on a previous version of the app
            tilesPerRow = 3
            self.userDefaults.set(3, forKey: "tilesPerRow")
            self.userDefaults.synchronize()
        }
        self.tilesPerRowLabel.text = "\(tilesPerRow) x \(tilesPerRow)"
        self.tilesPerRowLabel.adjustsFontSizeToFitWidth = true

        self.mainImageView.layer.borderWidth = 2
        self.letsPlayButton.layer.cornerRadius = self.letsPlayButton.frame.width * 0.25
        self.letsPlayButton.layer.borderWidth = 2
        
        self.updateColorsAndFonts()
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        shrinkCategories()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Set user defaults upon the first launch
        if(!self.userDefaults.bool(forKey: "firstlaunch1.0")){
            // Only gets called once ever
            self.userDefaults.set(true, forKey: "firstlaunch1.0")
            self.userDefaults.set(true, forKey: "congratsOn")
            self.userDefaults.set(2, forKey: "colorPaletteInt")
            self.userDefaults.set(3, forKey: "tilesPerRow")
            self.userDefaults.synchronize()
        }
        

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
        var currentTilesPerRow = self.userDefaults.integer(forKey: "tilesPerRow")
        if currentTilesPerRow < 10 {
            currentTilesPerRow += 1
            self.tilesPerRowLabel.text = "\(currentTilesPerRow) x \(currentTilesPerRow)"
            self.userDefaults.set(currentTilesPerRow, forKey: "tilesPerRow")
            self.userDefaults.synchronize()
        }
   }

    
    @IBAction func leftButtonPressed(_ sender: AnyObject) {
        var currentTilesPerRow = self.userDefaults.integer(forKey: "tilesPerRow")
        if currentTilesPerRow > 2 {
            currentTilesPerRow -= 1
            self.tilesPerRowLabel.text = "\(currentTilesPerRow) x \(currentTilesPerRow)"
            self.userDefaults.set(currentTilesPerRow, forKey: "tilesPerRow")
            self.userDefaults.synchronize()
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
        let board = GameBoard(imagePackage: self.photoBrowser.currentPackage(), tilesPerRow: self.userDefaults.integer(forKey: "tilesPerRow"))
        let gameBoardVC = GameBoardVC.generate(board: board)
        present(gameBoardVC, animated: true, completion: nil)

    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        let settings = SettingsScreen.generate()
        present(settings, animated: true, completion: nil)

    }
    
    func updateColorsAndFonts() {
        // Colors
        self.view.backgroundColor = self.colorPalette.fetchLightColor()

        self.shiftingTilesLabel.textColor = self.colorPalette.fetchDarkColor()
        self.tilesPerRowLabel.textColor = self.colorPalette.fetchDarkColor()
        self.mainImageView.layer.borderColor = self.colorPalette.fetchDarkColor().cgColor

        // Icons
        self.selectCategoryButton.setImage(UIImage(named: "menuIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControl.State())
        self.statsButton.setImage(UIImage(named: "statsIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControl.State())
        self.decreaseButton.setImage(UIImage(named: "decreaseIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControl.State())
        self.increaseButton.setImage(UIImage(named: "increaseIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControl.State())
        self.separatorView.backgroundColor = self.colorPalette.fetchLightColor()
        self.infoButton.setImage(UIImage(named: "infoIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControl.State())
        self.letsPlayButton.setImage(UIImage(named: "goIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControl.State())
        self.letsPlayButton.layer.borderColor = self.colorPalette.fetchDarkColor().cgColor
        self.settingsButton.setImage(UIImage(named: "settingsIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControl.State())
 
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
