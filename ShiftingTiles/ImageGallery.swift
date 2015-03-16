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
        self.animalImagePackages = [
            ImagePackage(baseFileName: "02", caption: "Great Blue Heron", photographer: "Dale Arveson"),
            ImagePackage(baseFileName: "08", caption: "Zebras, Etosha National Park, Namibia", photographer: "Greg Jaehnig"),
            ImagePackage(baseFileName: "09", caption: "Garden Cat", photographer: "Parker Lewis"),
            ImagePackage(baseFileName: "16", caption: "Anna’s Hummingbird, California", photographer: "Kate Lewis"),
            ImagePackage(baseFileName: "17", caption: "Frisbee Dog", photographer: "Kate Lewis"),
            ImagePackage(baseFileName: "26", caption: "Black Legged Kittiwake, Chukchi Sea", photographer: "Kate Lewis"),
            ImagePackage(baseFileName: "27", caption: "Blacktail Buck", photographer: "Dale Arveson"),
            ImagePackage(baseFileName: "31", caption: "Bernal Heights, San Francisco", photographer: "Kate Lewis"),
            ImagePackage(baseFileName: "32", caption: "Prairie Dog", photographer: "Dale Arveson"),
            ImagePackage(baseFileName: "35", caption: "Snowy Owl", photographer: "Dale Arveson"),
            ImagePackage(baseFileName: "38", caption: "Blacktail Doe", photographer: "Dale Arveson"),
            ImagePackage(baseFileName: "39", caption: "Donkey, South Africa", photographer: "Greg Jaehnig"),
            ImagePackage(baseFileName: "41", caption: "Goat, Okando, Namibia", photographer: "Greg Jaehnig"),
            ImagePackage(baseFileName: "42", caption: "Female Kudu, Otavi, Namibia", photographer: "Greg Jaehnig"),
            ImagePackage(baseFileName: "43", caption: "Male Kudu, Otavi, Namibia", photographer: "Greg Jaehnig"),
            ImagePackage(baseFileName: "44", caption: "Oryx, Etosha National Park, Namibia", photographer: "Greg Jaehnig"),
            ImagePackage(baseFileName: "45", caption: "Conservation", photographer: "ErikHG Photography"),
            ImagePackage(baseFileName: "46", caption: "Harvest", photographer: "ErikHG Photography"),
            ImagePackage(baseFileName: "47", caption: "Elephants, Etosha National Park, Namibia", photographer: "Greg Jaehnig"),
            ImagePackage(baseFileName: "48", caption: "Giraffe, Etosha National Park, Namibia", photographer: "Greg Jaehnig"),
            ImagePackage(baseFileName: "49", caption: "White Lady Spider, Sossusvlei, Namibia", photographer: "Greg Jaehnig")
        ]
        self.animalImagePackages.shuffle()
        
  
        // NATURE
        self.natureImagePackages = [
            ImagePackage(baseFileName: "01", caption: "Tiger Mountain, Washington", photographer: "Greg Jaehnig"),
            ImagePackage(baseFileName: "03", caption: "Fish River Canyon, Namibia", photographer: "Greg Jaehnig"),
            ImagePackage(baseFileName: "04", caption: "Fish River Canyon, Namibia", photographer: "Greg Jaehnig"),
            ImagePackage(baseFileName: "05", caption: "Sunrise, Otavi, Namibia", photographer: "Greg Jaehnig"),
            ImagePackage(baseFileName: "06", caption: "Ruacana Falls, Namibia", photographer: "Greg Jaehnig"),
            ImagePackage(baseFileName: "07", caption: "Oregon Coast", photographer: "Dale Arveson"),
            ImagePackage(baseFileName: "12", caption: "Torres del Paine, Chile", photographer: "Kate Lewis"),
            ImagePackage(baseFileName: "13", caption: "Olympic National Forest, Washington", photographer: "Kate Lewis"),
            ImagePackage(baseFileName: "14", caption: "Third Beach, Olympic National Park", photographer: "Kate Lewis"),
            ImagePackage(baseFileName: "15", caption: "Western Antarctica Peninsula", photographer: "Kate Lewis"),
            ImagePackage(baseFileName: "18", caption: "Grand Canyon National Park", photographer: "Kate Lewis"),
            ImagePackage(baseFileName: "19", caption: "Deadvlei, Namibia", photographer: "Greg Jaehnig"),
            ImagePackage(baseFileName: "22", caption: "Tulips", photographer: "Dale Arveson"),
            ImagePackage(baseFileName: "24", caption: "Mosquito Creek", photographer: "Dale Arveson"),
            ImagePackage(baseFileName: "25", caption: "Mt. Rainier", photographer: "Dale Arveson"),
            ImagePackage(baseFileName: "28", caption: "Okavango Delta, Botswana", photographer: "Greg Jaehnig"),
            ImagePackage(baseFileName: "30", caption: "Waterberg Plateau, Namibia", photographer: "Greg Jaehnig"),
            ImagePackage(baseFileName: "33", caption: "Lavender", photographer: "Dale Arveson"),
            ImagePackage(baseFileName: "56", caption: "Olympic", photographer: "ErikHG Photography")
        ]
        self.natureImagePackages.shuffle()
        
        
        // PLACES
        self.placesImagePackages = [
            ImagePackage(baseFileName: "11", caption: "At Sea, Antarctica", photographer: "Kate Lewis"),
            ImagePackage(baseFileName: "20", caption: "Kolmanskop, Namibia", photographer: "Greg Jaehnig"),
            ImagePackage(baseFileName: "21", caption: "Rusty Reflection", photographer: "Dale Arveson"),
            ImagePackage(baseFileName: "23", caption: "Grant Island", photographer: "Grant Wilson"),
            ImagePackage(baseFileName: "34", caption: "Dominican Republic", photographer: "Kate Lewis"),
            ImagePackage(baseFileName: "36", caption: "Hands of Experience", photographer: "Dale Arveson"),
            ImagePackage(baseFileName: "37", caption: "Norway Pond", photographer: "Dale Arveson"),
            ImagePackage(baseFileName: "40", caption: "London Eye, London, England", photographer: "Kate Lewis"),
            ImagePackage(baseFileName: "50", caption: "Reel", photographer: "ErikHG Photography"),
            ImagePackage(baseFileName: "51", caption: "Backroad", photographer: "ErikHG Photography"),
            ImagePackage(baseFileName: "52", caption: "Companion", photographer: "ErikHG Photography"),
            ImagePackage(baseFileName: "53", caption: "Cobble", photographer: "ErikHG Photography"),
            ImagePackage(baseFileName: "54", caption: "Nærøyfjord", photographer: "ErikHG Photography"),
            ImagePackage(baseFileName: "55", caption: "Bog", photographer: "ErikHG Photography")
        ]
        self.placesImagePackages.shuffle()
    }
}


extension Array
{
    // Randomizes the order of an array's elements.
    mutating func shuffle()
    {
        for _ in 0..<self.count
        {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}


