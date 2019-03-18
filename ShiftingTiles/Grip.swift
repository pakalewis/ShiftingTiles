//
//  Grip.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 3/16/19.
//  Copyright © 2019 Parker Lewis. All rights reserved.
//

import UIKit

enum GripType: String {
    case column, row
}

protocol GripDelegate: class {
    func selected(grip: Grip)
    func deselectGrip()
}

class Grip: UIButton {
    private let ONE_EIGHTY = CGFloat(Double.pi * 2) / 2
    private let NINETY = CGFloat(Double.pi * 2) / 4

    let gripType: GripType
    var index: Int
    weak var delegate: GripDelegate?

    override var isSelected: Bool {
        didSet {
            updateForSelection()
        }
    }

    init(gripType: GripType, index: Int, frame: CGRect, delegate: GripDelegate) {
        self.gripType = gripType
        self.index = index
        self.delegate = delegate
        super.init(frame: frame)
        self.imageView?.contentMode = .scaleAspectFit
        self.tintColor = Colors.fetchDarkColor()

        self.initialRotation()
        self.updateImage()

        self.isUserInteractionEnabled = false

        self.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func tapped() {
        print("tapped grip at \(self.gripType.rawValue) \(self.index)")
        if self.isSelected {
            self.isSelected = false
            self.delegate?.deselectGrip()
        } else {
            self.delegate?.selected(grip: self)
        }
    }

    func initialRotation() {
        switch self.gripType {
        case .column:
            return
        case .row:
            self.transform = self.transform.rotated(by: -self.NINETY)
        }

    }

    func updateImage() {
        self.setImage(Icon.triangle.image(), for: .normal)
        if self.isSelected {
            self.tintColor = Colors.fetchDarkColor()
        } else {
            self.tintColor = Colors.fetchDarkColor().withAlphaComponent(0.5)
        }
    }

    func updateForSelection() {
        self.rotate()
        self.updateImage()
    }

    func rotate() {
        UIView.animate(withDuration: 0.25) {
            self.transform = self.transform.rotated(by: self.ONE_EIGHTY)
        }
    }
}
