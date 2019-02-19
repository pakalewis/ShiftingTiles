//
//  PhotoBrowser.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 2/18/19.
//  Copyright © 2019 Parker Lewis. All rights reserved.
//

import Foundation
import UIKit
class CategoryButton: UIButton {
    let category: PhotoCategory
    weak var delegate: CategoryButtonDelegate?
    
    init(category: PhotoCategory, delegate: CategoryButtonDelegate) {
        self.category = category
        super.init(frame: CGRect(x: 0, y: 0, width: 100.0, height: 45.0))
        self.setTitleColor(ColorPalette().fetchDarkColor(), for: .normal)
        self.layer.borderColor = ColorPalette().fetchDarkColor().cgColor
        self.backgroundColor = .yellow
        self.setTitle(self.category.titleText(), for: .normal)
        self.titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 15)
        self.addTarget(self, action: #selector(tap), for: .touchUpInside)
        self.layer.borderWidth = 2
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tap() {
        self.delegate?.selected(category: self.category)
    }
}
protocol CategoryButtonDelegate: class {
    func selected(category: PhotoCategory)
}

enum PhotoCategory: Int {
    case animals, nature, places
    
    func titleText() -> String {
        switch self {
        case .animals:
            return  "ANIMALS"
        case .nature:
            return "NATURE"
        case .places:
            return "PLACES"
        }
    }
}

class PhotoBrowser {
    init() {
        let randomInt = Int.random(in: 0...2)
        currentCategory = PhotoCategory(rawValue: randomInt)!
    }
    var currentCategory: PhotoCategory {
        didSet {
            index = 0
        }
    }
    var index: Int = 0
    var imageGallery = ImageGallery()
    var currentImagePackageArray : [ImagePackage]?

    var categories: [PhotoCategory] {
        return [.animals, .nature, .places]
    }
    
    func currentPackage() -> ImagePackage {
        return currentPackages()[self.index]
    }
    
    func currentPackages() -> [ImagePackage] {
        switch currentCategory {
        case .animals:
            return imageGallery.animalImagePackages
        case .nature:
            return imageGallery.natureImagePackages
        case .places:
            return imageGallery.placesImagePackages
        }
    }
}





//
//extension PhotoBrowser: UICollectionViewDelegate, UICollectionViewDataSource {
//
//    //MARK: COLLECTION VIEW
//    // Number of cells = number of images
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.photoBrowser.imagePackages().count
//    }
//
//
//    // Cells will be square sized
//    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: IndexPath!) -> CGSize {
//        return CGSize(width: self.imageCollection.frame.height * 0.9, height: self.imageCollection.frame.height * 0.9)
//    }
//    
//
//    // Create cell from nib and load the appropriate image
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = self.imageCollection.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as! CollectionViewImageCell
//        let package = photoBrowser.imagePackages()[indexPath.row]
//        cell.imageView.image = UIImage(named: package.getSmallFileName())
//        return cell
//    }
//
//
//    // Selecting a cell loads the image to the main image view
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.updateCurrentImagePackageWithIndex(indexPath.row)
//        self.updateMainImageView()
//        self.shrinkCategories()
//    }
//
//
//}
