//
//  Stats.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 1/6/15.
//  Copyright (c) 2015 Parker Lewis. All rights reserved.
//

import Foundation

class Stats {
    let userDefaults : NSUserDefaults!
    
    init () {
        self.userDefaults = NSUserDefaults.standardUserDefaults()
    }
    
    func updateSolveStats(tilePerRow: Int) {
        
        // TODO: do I need to do an if let
        // seems like it pulls out a zero if there is nothing stored
//        if let totalSolves = self.userDefaults.objectForKey("totalSolves") as? Int {
//            println("THIS WORKED \(totalSolves)")
//        }

        
        // Update total solves
        var totalSolves = userDefaults.integerForKey("totalSolves")
        totalSolves++
        userDefaults.setInteger(totalSolves, forKey: "totalSolves")
        
        
        // Update solves for the appropriate size
        switch tilePerRow {
        case 2:
            var solves = userDefaults.integerForKey("solvesAtSize2")
            solves++
            userDefaults.setInteger(solves, forKey: "solvesAtSize2")
        case 3:
            var solves = userDefaults.integerForKey("solvesAtSize3")
            solves++
            userDefaults.setInteger(solves, forKey: "solvesAtSize3")
        case 4:
            var solves = userDefaults.integerForKey("solvesAtSize4")
            solves++
            userDefaults.setInteger(solves, forKey: "solvesAtSize4")
        case 5:
            var solves = userDefaults.integerForKey("solvesAtSize5")
            solves++
            userDefaults.setInteger(solves, forKey: "solvesAtSize5")
        case 6:
            var solves = userDefaults.integerForKey("solvesAtSize6")
            solves++
            userDefaults.setInteger(solves, forKey: "solvesAtSize6")
        case 7:
            var solves = userDefaults.integerForKey("solvesAtSize7")
            solves++
            userDefaults.setInteger(solves, forKey: "solvesAtSize7")
        case 8:
            var solves = userDefaults.integerForKey("solvesAtSize8")
            solves++
            userDefaults.setInteger(solves, forKey: "solvesAtSize8")
        case 9:
            var solves = userDefaults.integerForKey("solvesAtSize9")
            solves++
            userDefaults.setInteger(solves, forKey: "solvesAtSize9")
        case 10:
            var solves = userDefaults.integerForKey("solvesAtSize10")
            solves++
            userDefaults.setInteger(solves, forKey: "solvesAtSize10")
        default:
            println("This should never get printed")
        }

        userDefaults.synchronize()

    }
    
    
    func fetchSolvesPerSize() -> [Int] {
        let solvesPerSizeArray = [
            userDefaults.integerForKey("solvesAtSize2"),
            userDefaults.integerForKey("solvesAtSize3"),
            userDefaults.integerForKey("solvesAtSize4"),
            userDefaults.integerForKey("solvesAtSize5"),
            userDefaults.integerForKey("solvesAtSize6"),
            userDefaults.integerForKey("solvesAtSize7"),
            userDefaults.integerForKey("solvesAtSize8"),
            userDefaults.integerForKey("solvesAtSize9"),
            userDefaults.integerForKey("solvesAtSize10")]
        
        return solvesPerSizeArray
    }
    
    func fetchTotalSolves() -> Int {
        return userDefaults.integerForKey("totalSolves")
    }
}



