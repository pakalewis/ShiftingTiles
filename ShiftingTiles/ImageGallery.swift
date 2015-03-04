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
    
    
    var animalImagePackages : [ImagePackage]!
    var natureImagePackages : [ImagePackage]!
    var placesImagePackages : [ImagePackage]!
    


    
    init() {
        
        // ANIMAL
        let animal01 = ImagePackage(baseFileName: "02", caption: "Great Blue Heron", photographer: "Dale Arveson")
        let animal02 = ImagePackage(baseFileName: "08", caption: "Zebras, Etosha National Park, Namibia", photographer: "Greg Jaehnig")
        let animal03 = ImagePackage(baseFileName: "09", caption: "Garden Cat", photographer: "Parker Lewis")
        let animal04 = ImagePackage(baseFileName: "16", caption: "Anna’s Hummingbird, California", photographer: "Kate Lewis")
        let animal05 = ImagePackage(baseFileName: "17", caption: "Frisbee Dog", photographer: "Kate Lewis")
        let animal06 = ImagePackage(baseFileName: "26", caption: "Black Legged Kittiwake, Chukchi Sea", photographer: "Kate Lewis")
        let animal07 = ImagePackage(baseFileName: "27", caption: "Blacktail Buck", photographer: "Dale Arveson")
        let animal08 = ImagePackage(baseFileName: "31", caption: "Bernal Heights, San Francisco", photographer: "Kate Lewis")
        let animal09 = ImagePackage(baseFileName: "32", caption: "Prairie Dog", photographer: "Dale Arveson")
        let animal10 = ImagePackage(baseFileName: "35", caption: "Snowy Owl", photographer: "Dale Arveson")
        let animal11 = ImagePackage(baseFileName: "38", caption: "Blacktail Doe", photographer: "Dale Arveson")
        let animal12 = ImagePackage(baseFileName: "39", caption: "Donkey, South Africa", photographer: "Greg Jaehnig")
        let animal13 = ImagePackage(baseFileName: "41", caption: "Goat, Okando, Namibia", photographer: "Greg Jaehnig")
        let animal14 = ImagePackage(baseFileName: "42", caption: "Female Kudu, Otavi, Namibia", photographer: "Greg Jaehnig")
        let animal15 = ImagePackage(baseFileName: "43", caption: "Male Kudu, Otavi, Namibia", photographer: "Greg Jaehnig")
        let animal16 = ImagePackage(baseFileName: "44", caption: "Oryx, Etosha National Park, Namibia", photographer: "Greg Jaehnig")
        let animal17 = ImagePackage(baseFileName: "45", caption: "Conservation", photographer: "ErikHG Photography")
        let animal18 = ImagePackage(baseFileName: "46", caption: "Harvest", photographer: "ErikHG Photography")
        let animal19 = ImagePackage(baseFileName: "47", caption: "Elephants, Etosha National Park, Namibia", photographer: "Greg Jaehnig")
        let animal20 = ImagePackage(baseFileName: "48", caption: "Giraffe, Etosha National Park, Namibia", photographer: "Greg Jaehnig")
        let animal21 = ImagePackage(baseFileName: "49", caption: "White Lady Spider, Sossusvlei, Namibia", photographer: "Greg Jaehnig")

        var animalPackagesArray = [
            animal01,
            animal02,
            animal03,
            animal04,
            animal05,
            animal06,
            animal07,
            animal08,
            animal09,
            animal10,
            animal11,
            animal12,
            animal13,
            animal14,
            animal15,
            animal16,
            animal17,
            animal18,
            animal19,
            animal20,
            animal21 ]
        

        animalPackagesArray = self.shuffle(animalPackagesArray)
        animalPackagesArray = self.shuffle(animalPackagesArray)
        animalPackagesArray = self.shuffle(animalPackagesArray)
        animalPackagesArray = self.shuffle(animalPackagesArray)
        animalPackagesArray = self.shuffle(animalPackagesArray)
        animalPackagesArray = self.shuffle(animalPackagesArray)
        animalPackagesArray = self.shuffle(animalPackagesArray)
        animalPackagesArray = self.shuffle(animalPackagesArray)
        animalPackagesArray = self.shuffle(animalPackagesArray)
        animalPackagesArray = self.shuffle(animalPackagesArray)
        self.animalImagePackages = animalPackagesArray
        
  
        
        // NATURE
        let nature01 = ImagePackage(baseFileName: "01", caption: "Tiger Mountain, Washington", photographer: "Greg Jaehnig")
        let nature02 = ImagePackage(baseFileName: "03", caption: "Fish River Canyon, Namibia", photographer: "Greg Jaehnig")
        let nature03 = ImagePackage(baseFileName: "04", caption: "Fish River Canyon, Namibia", photographer: "Greg Jaehnig")
        let nature04 = ImagePackage(baseFileName: "05", caption: "Sunrise, Otavi, Namibia", photographer: "Greg Jaehnig")
        let nature05 = ImagePackage(baseFileName: "06", caption: "Ruacana Falls, Namibia", photographer: "Greg Jaehnig")
        let nature06 = ImagePackage(baseFileName: "07", caption: "Oregon Coast", photographer: "Dale Arveson")
        let nature07 = ImagePackage(baseFileName: "12", caption: "Torres del Paine, Chile", photographer: "Kate Lewis")
        let nature08 = ImagePackage(baseFileName: "13", caption: "Olympic National Forest, Washington", photographer: "Kate Lewis")
        let nature09 = ImagePackage(baseFileName: "14", caption: "Third Beach, Olympic National Park", photographer: "Kate Lewis")
        let nature10 = ImagePackage(baseFileName: "15", caption: "Western Antarctica Peninsula", photographer: "Kate Lewis")
        let nature11 = ImagePackage(baseFileName: "18", caption: "Grand Canyon National Park", photographer: "Kate Lewis")
        let nature12 = ImagePackage(baseFileName: "19", caption: "Deadvlei, Namibia", photographer: "Greg Jaehnig")
        let nature13 = ImagePackage(baseFileName: "22", caption: "Tulips", photographer: "Dale Arveson")
        let nature14 = ImagePackage(baseFileName: "24", caption: "Mosquito Creek", photographer: "Dale Arveson")
        let nature15 = ImagePackage(baseFileName: "25", caption: "Mt. Rainier", photographer: "Dale Arveson")
        let nature16 = ImagePackage(baseFileName: "28", caption: "Okavango Delta, Botswana", photographer: "Greg Jaehnig")
        let nature17 = ImagePackage(baseFileName: "30", caption: "Waterberg Plateau, Namibia", photographer: "Greg Jaehnig")
        let nature18 = ImagePackage(baseFileName: "33", caption: "Lavender", photographer: "Dale Arveson")
        let nature19 = ImagePackage(baseFileName: "56", caption: "Olympic", photographer: "ErikHG Photography")

        var naturePackagesArray = [
            nature01,
            nature02,
            nature03,
            nature04,
            nature05,
            nature06,
            nature07,
            nature08,
            nature09,
            nature10,
            nature11,
            nature12,
            nature13,
            nature14,
            nature15,
            nature16,
            nature17,
            nature18,
            nature19 ]
        
        naturePackagesArray = self.shuffle(naturePackagesArray)
        naturePackagesArray = self.shuffle(naturePackagesArray)
        naturePackagesArray = self.shuffle(naturePackagesArray)
        naturePackagesArray = self.shuffle(naturePackagesArray)
        naturePackagesArray = self.shuffle(naturePackagesArray)
        naturePackagesArray = self.shuffle(naturePackagesArray)
        naturePackagesArray = self.shuffle(naturePackagesArray)
        naturePackagesArray = self.shuffle(naturePackagesArray)
        naturePackagesArray = self.shuffle(naturePackagesArray)
        naturePackagesArray = self.shuffle(naturePackagesArray)
        self.natureImagePackages = naturePackagesArray
        
        
        
        // PLACES
        let place01 = ImagePackage(baseFileName: "11", caption: "At Sea, Antarctica", photographer: "Kate Lewis")
        let place02 = ImagePackage(baseFileName: "20", caption: "Kolmanskop, Namibia", photographer: "Greg Jaehnig")
        let place03 = ImagePackage(baseFileName: "21", caption: "Rusty Reflection", photographer: "Dale Arveson")
        let place04 = ImagePackage(baseFileName: "23", caption: "Grant Island", photographer: "Grant Wilson")
        let place05 = ImagePackage(baseFileName: "34", caption: "Dominican Republic", photographer: "Kate Lewis")
        let place06 = ImagePackage(baseFileName: "36", caption: "Hands of Experience", photographer: "Dale Arveson")
        let place07 = ImagePackage(baseFileName: "37", caption: "Norway Pond", photographer: "Dale Arveson")
        let place08 = ImagePackage(baseFileName: "40", caption: "London Eye, London, England", photographer: "Kate Lewis")
        let place09 = ImagePackage(baseFileName: "50", caption: "Reel", photographer: "ErikHG Photography")
        let place10 = ImagePackage(baseFileName: "51", caption: "Backroad", photographer: "ErikHG Photography")
        let place11 = ImagePackage(baseFileName: "52", caption: "Companion", photographer: "ErikHG Photography")
        let place12 = ImagePackage(baseFileName: "53", caption: "Cobble", photographer: "ErikHG Photography")
        let place13 = ImagePackage(baseFileName: "54", caption: "Nærøyfjord", photographer: "ErikHG Photography")
        let place14 = ImagePackage(baseFileName: "55", caption: "Bog", photographer: "ErikHG Photography")

        var placesPackagesArray = [
            place01,
            place02,
            place03,
            place04,
            place05,
            place06,
            place07,
            place08,
            place09,
            place10,
            place11,
            place12,
            place13,
            place14 ]
        
        placesPackagesArray = self.shuffle(placesPackagesArray)
        placesPackagesArray = self.shuffle(placesPackagesArray)
        placesPackagesArray = self.shuffle(placesPackagesArray)
        placesPackagesArray = self.shuffle(placesPackagesArray)
        placesPackagesArray = self.shuffle(placesPackagesArray)
        placesPackagesArray = self.shuffle(placesPackagesArray)
        placesPackagesArray = self.shuffle(placesPackagesArray)
        placesPackagesArray = self.shuffle(placesPackagesArray)
        placesPackagesArray = self.shuffle(placesPackagesArray)
        placesPackagesArray = self.shuffle(placesPackagesArray)
        self.placesImagePackages = placesPackagesArray
        
        
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


