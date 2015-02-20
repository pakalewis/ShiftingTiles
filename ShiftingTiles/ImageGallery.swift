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
    
    
    var animalLargeImageName : [String]!
    var animalMediumImageName : [String]!
    var animalSmallImageName : [String]!

    var natureLargeImageName : [String]!
    var natureMediumImageName : [String]!
    var natureSmallImageName : [String]!

    var placesLargeImageName : [String]!
    var placesMediumImageName : [String]!
    var placesSmallImageName : [String]!

    
    init() {
        
        // ANIMAL
        var animalFileNames = [
            "02.jpg",
            "08.jpg",
            "09.jpg",
            "10.jpg",
            "16.jpg",
            "17.jpg",
            "26.jpg",
            "27.jpg",
            "29.jpg",
            "31.jpg",
            "32.jpg",
            "35.jpg",
            "38.jpg",
            "39.jpg",
             ]

        animalFileNames = self.shuffle(animalFileNames)
        animalFileNames = self.shuffle(animalFileNames)
        animalFileNames = self.shuffle(animalFileNames)
        animalFileNames = self.shuffle(animalFileNames)
        animalFileNames = self.shuffle(animalFileNames)
        animalFileNames = self.shuffle(animalFileNames)
        animalFileNames = self.shuffle(animalFileNames)
        animalFileNames = self.shuffle(animalFileNames)
        animalFileNames = self.shuffle(animalFileNames)
        animalFileNames = self.shuffle(animalFileNames)

        
        var animalAlteredNamesSmall = [String]()
        var animalAlteredNamesMedium = [String]()
        var animalAlteredNamesLarge = [String]()

        for imageFileName in animalFileNames {
            
            let smallName = imageFileName.stringByReplacingOccurrencesOfString(".j", withString: "small.j", options: NSStringCompareOptions.LiteralSearch, range: nil)
            animalAlteredNamesSmall.append(smallName)
            
            let mediumName = imageFileName.stringByReplacingOccurrencesOfString(".j", withString: "medium.j", options: NSStringCompareOptions.LiteralSearch, range: nil)
            animalAlteredNamesMedium.append(mediumName)
            
            let largeName = imageFileName.stringByReplacingOccurrencesOfString(".j", withString: "large.j", options: NSStringCompareOptions.LiteralSearch, range: nil)
            animalAlteredNamesLarge.append(largeName)
        }
        self.animalSmallImageName = animalAlteredNamesSmall
        self.animalMediumImageName = animalAlteredNamesMedium
        self.animalLargeImageName = animalAlteredNamesLarge

        
        
        
        // NATURE
        var natureFileNames = [
            "01.jpg",
            "03.jpg",
            "04.jpg",
            "05.jpg",
            "06.jpg",
            "07.jpg",
            "12.jpg",
            "13.jpg",
            "14.jpg",
            "15.jpg",
            "18.jpg",
            "19.jpg",
            "22.jpg",
            "24.jpg",
            "25.jpg",
            "28.jpg",
            "30.jpg" ]
        
        natureFileNames = self.shuffle(natureFileNames)
        natureFileNames = self.shuffle(natureFileNames)
        natureFileNames = self.shuffle(natureFileNames)
        natureFileNames = self.shuffle(natureFileNames)
        natureFileNames = self.shuffle(natureFileNames)
        natureFileNames = self.shuffle(natureFileNames)
        natureFileNames = self.shuffle(natureFileNames)
        natureFileNames = self.shuffle(natureFileNames)
        natureFileNames = self.shuffle(natureFileNames)
        natureFileNames = self.shuffle(natureFileNames)

        var natureAlteredNamesSmall = [String]()
        var natureAlteredNamesMedium = [String]()
        var natureAlteredNamesLarge = [String]()
        
        for imageFileName in natureFileNames {
            
            let smallName = imageFileName.stringByReplacingOccurrencesOfString(".j", withString: "small.j", options: NSStringCompareOptions.LiteralSearch, range: nil)
            natureAlteredNamesSmall.append(smallName)
            
            let mediumName = imageFileName.stringByReplacingOccurrencesOfString(".j", withString: "medium.j", options: NSStringCompareOptions.LiteralSearch, range: nil)
            natureAlteredNamesMedium.append(mediumName)
            
            let largeName = imageFileName.stringByReplacingOccurrencesOfString(".j", withString: "large.j", options: NSStringCompareOptions.LiteralSearch, range: nil)
            natureAlteredNamesLarge.append(largeName)
        }
        self.natureSmallImageName = natureAlteredNamesSmall
        self.natureMediumImageName = natureAlteredNamesMedium
        self.natureLargeImageName = natureAlteredNamesLarge

        
        
        
        // PLACES
        var placesFileNames = [
            "11.jpg",
            "20.jpg",
            "21.jpg",
            "23.jpg",
            "33.jpg",
            "34.jpg",
            "36.jpg",
            "37.jpg",
            "40.jpg" ]
        
        placesFileNames = self.shuffle(placesFileNames)
        placesFileNames = self.shuffle(placesFileNames)
        placesFileNames = self.shuffle(placesFileNames)
        placesFileNames = self.shuffle(placesFileNames)
        placesFileNames = self.shuffle(placesFileNames)
        placesFileNames = self.shuffle(placesFileNames)
        placesFileNames = self.shuffle(placesFileNames)
        placesFileNames = self.shuffle(placesFileNames)
        placesFileNames = self.shuffle(placesFileNames)
        placesFileNames = self.shuffle(placesFileNames)

        
        var placesAlteredNamesSmall = [String]()
        var placesAlteredNamesMedium = [String]()
        var placesAlteredNamesLarge = [String]()
        
        for imageFileName in placesFileNames {
            
            let smallName = imageFileName.stringByReplacingOccurrencesOfString(".j", withString: "small.j", options: NSStringCompareOptions.LiteralSearch, range: nil)
            placesAlteredNamesSmall.append(smallName)
            
            let mediumName = imageFileName.stringByReplacingOccurrencesOfString(".j", withString: "medium.j", options: NSStringCompareOptions.LiteralSearch, range: nil)
            placesAlteredNamesMedium.append(mediumName)
            
            let largeName = imageFileName.stringByReplacingOccurrencesOfString(".j", withString: "large.j", options: NSStringCompareOptions.LiteralSearch, range: nil)
            placesAlteredNamesLarge.append(largeName)
            
        }

    
        self.placesSmallImageName = placesAlteredNamesSmall
        self.placesMediumImageName = placesAlteredNamesMedium
        self.placesLargeImageName = placesAlteredNamesLarge
        
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


