//
//  LineGripsView.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 10/9/19.
//  Copyright © 2019 Parker Lewis. All rights reserved.
//

import UIKit

protocol LineGripsViewDelegate: class {
    func gripSelected(_ gripSelection: GripSelection)
    func gripDeselected(_ gripSelection: GripSelection)
    func secondGripSelected(_ gripSelection: GripSelection)
}

struct GripSelection {
    init(grip: Grip) {
        self.type = grip.gripType
        self.index = grip.index
    }
    let type: GripType
    let index: Int
}

/// Contains multiple Grips that allow selection/movement of an entire row or column of tiles
class LineGripsView: UIView {
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Bundle.main.loadNibNamed("LineGripsView", owner: self, options: nil)
        self.addSubview(view)
        view.frame = self.bounds
    }
    deinit {
        print("DEINIT OfflineView")
    }

    @IBOutlet var view: UIView!
    @IBOutlet var stack: UIStackView!

    var grips = [Grip]()
    var selectedGrip: Grip?
    weak var delegate: LineGripsViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.view.backgroundColor = .clear
    }

    func setup(type: GripType, count: Int, delegate: LineGripsViewDelegate) {
        stack.axis = type == .column ? .horizontal : .vertical
        stack.distribution = .fillEqually

        for index in 0..<count {
            let grip = Grip(gripType: type, index: index, delegate: self)
            self.grips.append(grip)
            stack.addArrangedSubview(grip)
        }

        self.delegate = delegate
    }

    func setAllGripsTo(_ state: GripState) {
        for grip in self.grips {
            grip.gripState = state
        }
    }

    func reset() {
        self.selectedGrip = nil
        self.setAllGripsTo(.normal)
    }
}

extension LineGripsView: GripDelegate {
    func gripTapped(grip: Grip) {
        if grip.gripState == .selected {
            grip.gripState = .normal
            grip.rotate()
            self.selectedGrip = nil
            self.delegate?.gripDeselected(GripSelection(grip: grip))
        } else {
            if let alreadySelectedGrip = self.selectedGrip {
                alreadySelectedGrip.gripState = .normal
                alreadySelectedGrip.rotate()
                self.delegate?.secondGripSelected(GripSelection(grip: grip))
            } else {
                grip.gripState = .selected
                grip.rotate()
                self.selectedGrip = grip
                self.delegate?.gripSelected(GripSelection(grip: grip))
            }
        }
    }
}

extension UIView {
    func addSubviewAndConstrain(subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        let bottom = subview.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        let left = subview.leftAnchor.constraint(equalTo: self.leftAnchor)
        let right = subview.rightAnchor.constraint(equalTo: self.rightAnchor)
        let top = subview.topAnchor.constraint(equalTo: self.topAnchor)
        self.addSubview(subview)
        self.addConstraints([bottom, left, right, top])
    }
}
