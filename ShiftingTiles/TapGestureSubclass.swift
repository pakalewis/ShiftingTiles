//
//  TapGestureSubclass.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 1/18/15.
//  Copyright (c) 2015 Parker Lewis. All rights reserved.
//

import Foundation
import UIKit
import UIKit.UIGestureRecognizerSubclass

class TapGestureSubclass: UITapGestureRecognizer {

    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)
    {
        super.touchesBegan(touches, withEvent: event)
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC, dispatch_get_main_queue(), ^{
//            
//        }
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), { () -> Void in
////            if  (self.state != UIGestureRecognizerStateRecognized)
////            {
////                self.state = UIGestureRecognizerStateFailed;
////            }
//            println()
//            println()
//        })

    
    
    
    
        let offset = 0.1
        println("\(Int64(offset * Double(NSEC_PER_SEC)))")
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(offset * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            if self.state != UIGestureRecognizerState.Ended {
                self.state = UIGestureRecognizerState.Failed
            }
        
        })
    
    }
    
}
