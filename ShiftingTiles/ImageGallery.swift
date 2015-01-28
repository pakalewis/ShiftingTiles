//
//  ImageGallery.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 12/21/14.
//  Copyright (c) 2014 Parker Lewis. All rights reserved.
//

import Foundation
import UIKit

class ImageGallery {
    
    var imageNameArray : [String]!
    var smallImageNameArray : [String]!
    
    init() {
        

        var imageFileNames = [
            "01.jpg",
            "02.jpg",
            "03.jpg",
            "04.jpg",
            "05.jpg",
            "06.jpg",
            "07.jpg",
            "08.jpg",
            "09.jpg",
            "10.jpg",
            "11.jpg",
            "12.jpg",
            "13.jpg",
            "14.jpg",
            "15.jpg",
            "16.jpg",
            "17.jpg",
            "18.jpg",
            "19.jpg",
            "20.jpg",
            "21.jpg",
            "22.jpg",
            "23.jpg",
            "24.jpg",
            "25.jpg",
            "26.jpg",
            "27.jpg",
            "28.jpg",
            "29.jpg",
            "30.jpg",
            "31.jpg",
            "32.jpg",
            "33.jpg",
            "34.jpg",
            "35.jpg",
            "36.jpg",
            "37.jpg",
            "38.jpg",
            "39.jpg",
            "40.jpg" ]
        imageFileNames = self.shuffle(imageFileNames)
        imageFileNames = self.shuffle(imageFileNames)
        imageFileNames = self.shuffle(imageFileNames)
        imageFileNames = self.shuffle(imageFileNames)
        imageFileNames = self.shuffle(imageFileNames)
        imageFileNames = self.shuffle(imageFileNames)
        imageFileNames = self.shuffle(imageFileNames)
        imageFileNames = self.shuffle(imageFileNames)
        imageFileNames = self.shuffle(imageFileNames)
        imageFileNames = self.shuffle(imageFileNames)
        imageFileNames = self.shuffle(imageFileNames)
        imageFileNames = self.shuffle(imageFileNames)
        imageFileNames = self.shuffle(imageFileNames)
        imageFileNames = self.shuffle(imageFileNames)
        imageFileNames = self.shuffle(imageFileNames)
        imageFileNames = self.shuffle(imageFileNames)
        self.imageNameArray = imageFileNames

    
        var alteredNames = [String]()
        for imageName in self.imageNameArray {
            let newName = imageName.stringByReplacingOccurrencesOfString(".j", withString: "small.j", options: NSStringCompareOptions.LiteralSearch, range: nil)
            alteredNames.append(newName)
            
        }
        self.smallImageNameArray = alteredNames
    
    }
    
    func shuffle<C: MutableCollectionType where C.Index == Int>(var list: C) -> C {
        let count = countElements(list)
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swap(&list[i], &list[j])
        }
        return list
    }
    
}


