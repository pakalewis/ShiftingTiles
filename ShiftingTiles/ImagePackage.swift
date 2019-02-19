//
//  ImagePackage.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 2/27/15.
//  Copyright (c) 2015 Parker Lewis. All rights reserved.
//

import Foundation
import UIKit

class ImagePackage {
    
    let baseFileName: String
    let caption: String
    let photographer: String
    
    init(baseFileName: String, caption: String, photographer: String) {
        self.baseFileName = baseFileName
        self.caption = caption
        self.photographer = photographer
    }
    
    func getSmallFileName() -> String {
        return self.baseFileName + "small.jpg"
    }
    
    func getMediumFileName() -> String {
        return self.baseFileName + "medium.jpg"
    }

    func getLargeFileName() -> String {
        return self.baseFileName + "large.jpg"
    }

    func image() -> UIImage {
        let fileName: String
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            fileName = getMediumFileName()
        } else {
            fileName = getLargeFileName()
        }
        
        return UIImage(named: fileName)!
    }
}
