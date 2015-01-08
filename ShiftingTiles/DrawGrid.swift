//
//  DrawGrid.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 12/19/14.
//  Copyright (c) 2014 Parker Lewis. All rights reserved.
//

import UIKit

class DrawGrid: UIView {
    
    var numRows : Int?
    
    override init(frame: CGRect) {
        self.numRows = 0
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func drawRect(rect: CGRect) {
        var tileWidth = rect.width / CGFloat(self.numRows!)

        var path = UIBezierPath()
        path.lineWidth = 1.5
        UIColor.blackColor().setStroke()
        UIColor.blackColor().setFill()
        for index in 1..<self.numRows! {
            // draw column
            path.moveToPoint(CGPointMake(tileWidth * CGFloat(index), 0))
            path.addLineToPoint(CGPointMake(tileWidth * CGFloat(index), rect.height))
            // draw row
            path.moveToPoint(CGPointMake(0, tileWidth * CGFloat(index)))
            path.addLineToPoint(CGPointMake(rect.width, tileWidth * CGFloat(index)))
            path.stroke()
            
        }
        
    }




}
