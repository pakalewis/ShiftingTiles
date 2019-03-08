//
//  PhotoBrowser.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 2/18/19.
//  Copyright © 2019 Parker Lewis. All rights reserved.
//

import Foundation
import UIKit

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

protocol PhotoBrowserDelegate: class {
    func display()
}


class PhotoBrowser: NSObject {
    override init() {
        let randomInt = Int.random(in: 0...2)
        currentCategory = PhotoCategory(rawValue: randomInt)!
        super.init()
    }
    weak var delegate: PhotoBrowserDelegate?
    
    var currentCategory: PhotoCategory {
        didSet {
            index = 0
        }
    }
    var index: Int = 0 {
        didSet {
            self.delegate?.display()
        }
    }
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
    
    func observe(collectionView: UICollectionView, delegate: PhotoBrowserDelegate) {
        collectionView.delegate = self
        collectionView.dataSource = self
        self.delegate = delegate
        self.delegate?.display()
    }
}


extension PhotoBrowser: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentPackages().count
    }

    // Cells will be square sized
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: IndexPath!) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    

    // Create cell from nib and load the appropriate image
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as! CollectionViewImageCell
        cell.imageView.image = currentPackages()[indexPath.row].image()
        return cell
    }


    // Selecting a cell loads the image to the main image view
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.index = indexPath.row
    }
}
