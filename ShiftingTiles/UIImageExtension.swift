//
//  UIImageExtension.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 1/17/15.
//  Copyright (c) 2015 Parker Lewis. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func imageWithColor(_ color: UIColor) -> UIImage {
        let height: CGFloat = self.size.height
        let rect = CGRect(x: 0.0, y: 0.0, width: height, height: height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!

//        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
//
//        let context = UIGraphicsGetCurrentContext()! as CGContext
//        context.translateBy(x: 0, y: self.size.height)
//        context.scaleBy(x: 1.0, y: -1.0);
//        context.setBlendMode(CGBlendMode.normal)
//
//        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
//        context.clip(to: rect, mask: self.cgImage!)
//        color1.setFill()
//        context.fill(rect)
//
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
//        UIGraphicsEndImageContext()
//
//        return newImage
    }
}
