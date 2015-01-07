//
//  DoubleIndex.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 12/18/14.
//  Copyright (c) 2014 Parker Lewis. All rights reserved.
//

import Foundation


class DoubleIndex {
    let rowIndex: Int!
    let columnIndex: Int!
    
    
    init(index1 : Int, index2 : Int) {
        self.rowIndex = index1
        self.columnIndex = index2
    }

    
    func concatenateToInt() -> Int {
        
        return ((self.rowIndex * 10) + self.columnIndex)
    }
    

    func concatenateToString() -> String {
        var concatenationString = ""
        if self.rowIndex == 0 {
            concatenationString += " "
        } else {
            concatenationString += "\(self.rowIndex)"
        }
        
        concatenationString += "\(self.columnIndex)"

        return concatenationString
    }
    
}