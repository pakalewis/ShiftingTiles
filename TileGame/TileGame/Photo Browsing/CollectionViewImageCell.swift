//
//  CollectionViewImageCell.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 12/19/14.
//  Copyright (c) 2014 Parker Lewis. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewImageCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imageView.layer.cornerRadius = self.frame.width * 0.02
        self.imageView.clipsToBounds = true
        
    }
    
}
