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
            "01.jpeg",
            "02.jpeg",
            "03.jpeg",
            "04.jpeg",
            "05.jpeg",
            "06.jpeg",
            "07.jpeg",
            "08.jpeg",
            "09.jpeg",
            "10.jpeg",
            "11.jpeg",
            "12.jpeg",
            "13.jpeg",
            "14.jpeg",
            "15.jpeg",
            "16.jpeg",
            "17.jpeg",
            "18.jpeg",
            "19.jpeg",
            "20.jpeg",
            "21.jpeg",
            "22.jpeg",
            "23.jpeg",
            "24.jpeg",
            "25.jpeg" ]
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


