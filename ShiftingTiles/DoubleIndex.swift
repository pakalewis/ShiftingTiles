//
//  DoubleIndex.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 12/18/14.
//  Copyright (c) 2014 Parker Lewis. All rights reserved.
//

import Foundation

typealias Coordinate = IndexPath
extension IndexPath {
    init(row: Int, column: Int) {
        self.init(row: row, section: column)
    }
    init(_ row: Int, _ column: Int) {
        self.init(row: row, section: column)
    }
    func gridCoordinate() -> Int {
        return (self.row * 10) + self.section
    }
}

class DoubleIndex {
    let rowIndex: Int!
    let columnIndex: Int!
    
    
    init(index1 : Int, index2 : Int) {
        self.rowIndex = index1
        self.columnIndex = index2
    }

    
    func concatenateToInt() -> Int {
        var coo = Coordinate(row: 2, column: 5)
        print(coo.gridCoordinate())

        coo = Coordinate(row: 4, column: 3)
        print(coo.gridCoordinate())

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
