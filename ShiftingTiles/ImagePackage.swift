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
    
    
    var smallFileName : String!
    var mediumFileName : String!
    var largeFileName : String!
    var image : UIImage?
    
    var caption : String!
    var photographer : String!
    
    init(baseFileName: String, caption: String, photographer: String) {
        
        self.smallFileName = baseFileName + "small.jpg"
        self.mediumFileName = baseFileName + "medium.jpg"
        self.largeFileName = baseFileName + "large.jpg"
        
        self.caption = caption
        self.photographer = photographer
    }
    
    
}
