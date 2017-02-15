//
//  Stats.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 1/6/15.
//  Copyright (c) 2015 Parker Lewis. All rights reserved.
//

import Foundation

class Stats {
    let userDefaults = UserDefaults.standard
    let solvesAtSizeKeys = [
        "solvesAtSize2",
        "solvesAtSize3",
        "solvesAtSize4",
        "solvesAtSize5",
        "solvesAtSize6",
        "solvesAtSize7",
        "solvesAtSize8",
        "solvesAtSize9",
        "solvesAtSize10"
    ]
    var solvesAtSizeInts = [Int]()
    
    init () {
        self.solvesAtSizeInts = self.fetchSolvesPerSize()
    }

    
    func updateSolveStats(_ tilePerRow: Int) {
        
        // Update total solves
        var totalSolves = userDefaults.integer(forKey: "totalSolves")
        totalSolves += 1
        self.userDefaults.set(totalSolves, forKey: "totalSolves")
        
        // Update solves for the appropriate size
        let key = self.solvesAtSizeKeys[tilePerRow - 2]
        var solves = userDefaults.integer(forKey: key)
        solves += 1
        self.userDefaults.set(solves, forKey: key)

        self.userDefaults.synchronize()
    }
    
    
    func fetchSolvesPerSize() -> [Int] {
        var solvesPerSizeArray = [Int]()
        for key in self.solvesAtSizeKeys {
            let integerForKey = self.userDefaults.integer(forKey: key)
            solvesPerSizeArray.append(integerForKey)
        }
        return solvesPerSizeArray
    }
    
    
    func fetchTotalSolves() -> Int {
        return userDefaults.integer(forKey: "totalSolves")
    }
}



