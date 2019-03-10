//
//  CategoryButton.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 2/18/19.
//  Copyright © 2019 Parker Lewis. All rights reserved.
//

import Foundation
import UIKit

protocol CategoryButtonDelegate: class {
    func selected(category: PhotoCategory)
}

class CategoryButton: UIButton {
    let category: PhotoCategory
    weak var delegate: CategoryButtonDelegate?
    
    init(category: PhotoCategory, delegate: CategoryButtonDelegate) {
        self.category = category
        super.init(frame: CGRect(x: 0, y: 0, width: 100.0, height: 45.0))
        self.setTitleColor(Colors.fetchDarkColor(), for: .normal)
        self.layer.borderColor = Colors.fetchDarkColor().cgColor
        self.backgroundColor = Colors.fetchLightColor()
        self.setTitle(self.category.titleText(), for: .normal)
        self.titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 15)
        self.addTarget(self, action: #selector(tap), for: .touchUpInside)
        self.layer.borderWidth = 2
        
        
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tap() {
        self.delegate?.selected(category: self.category)
    }
}
