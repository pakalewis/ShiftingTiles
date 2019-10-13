//
//  Grip.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 3/16/19.
//  Copyright © 2019 Parker Lewis. All rights reserved.
//

import UIKit

enum GripState {
    case normal, selected, disabled
}

enum GripType: String {
    case column, row
}

protocol GripDelegate: class {
    func gripTapped(grip: Grip)
}

class Grip: UIButton {
    private let ONE_EIGHTY = CGFloat(Double.pi * 2) / 2
    private let NINETY = CGFloat(Double.pi * 2) / 4

    let gripType: GripType
    var index: Int
    weak var delegate: GripDelegate?

    var gripState: GripState {
        didSet {
            self.updateForState()
        }
    }

    init(gripType: GripType, index: Int, delegate: GripDelegate) {
        self.gripType = gripType
        self.index = index
        self.delegate = delegate
        self.gripState = .normal

        super.init(frame: .zero)
        self.imageView?.contentMode = .scaleAspectFit
        self.tintColor = Colors.fetchDarkColor()

        self.setInitialRotation()
        self.setImage(Icon.triangle.image(), for: .normal)

        self.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }

    @objc func tapped() {
        self.delegate?.gripTapped(grip: self)
        print("tapped grip at \(self.gripType.rawValue) \(self.index)")
    }

    func setInitialRotation() {
        switch self.gripType {
        case .column:
            return
        case .row:
            self.transform = self.transform.rotated(by: -self.NINETY)
        }
    }

    func updateForState() {
        switch self.gripState {
        case .normal:
            self.tintColor = Colors.fetchDarkColor().withAlphaComponent(0.5)
            self.isUserInteractionEnabled = true
        case .selected:
            self.tintColor = Colors.fetchDarkColor()
            self.isUserInteractionEnabled = true
        case .disabled:
            self.tintColor = Colors.fetchDarkColor().withAlphaComponent(0.1)
            self.isUserInteractionEnabled = false
        }
    }

    func rotate() {
        UIView.animate(withDuration: 0.25) {
            self.transform = self.transform.rotated(by: self.ONE_EIGHTY)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
