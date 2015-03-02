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
    
    var baseFileName : String!
    var caption : String!
    var photographer : String!
    var image : UIImage?
    
    
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

}
