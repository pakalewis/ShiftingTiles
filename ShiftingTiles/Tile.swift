//
//  Tile.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 12/18/14.
//  Copyright (c) 2014 Parker Lewis. All rights reserved.
//

import UIKit

enum TileState {
    case normal, selected
}

protocol TileDelegate: class {
    func selected(tile: Tile)
    func deselected()
}

class Tile: UIImageView {
    deinit {
        print("DEINIT Tile")
    }

    override var description: String {
        return "targetCoordinate = \(self.targetCoordinate)\n"
    }
    var doubleIndex: DoubleIndex
    var targetCoordinate: Coordinate
    var currentCoordinate: Coordinate
    var orientationCount : CGFloat = 1
    var originalFrame: CGRect?
    var state = TileState.normal {
        didSet {
            self.adjust(for: state)
        }
    }
    let overlay = UIView()

    weak var delegate: TileDelegate?

    init(image: UIImage, doubleIndex: DoubleIndex, coordinate: Coordinate, delegate: TileDelegate, frame: CGRect) {
        self.doubleIndex = doubleIndex
        self.targetCoordinate = coordinate
        self.currentCoordinate = coordinate
        print(targetCoordinate)
        self.delegate = delegate

        super.init(image: image)

        self.tag = doubleIndex.concatenateToInt()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.addGestureRecognizer(tap)

//        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
//        doubleTapGesture.numberOfTapsRequired = 2
//        self.addGestureRecognizer(doubleTapGesture)
        self.addSubview(self.overlay)
        self.isUserInteractionEnabled = true
        self.frame = frame
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func tapped() {
        print("tapped \(self.targetCoordinate)")
        self.delegate?.selected(tile: self)
    }

    @objc func doubleTapped() {
        print("double tapped \(tag)")
    }

    func adjust(for state: TileState) {
        switch state {
        case .normal:
            self.layer.borderColor = UIColor.clear.cgColor
            self.layer.borderWidth = 0
//            self.overlay.backgroundColor = .clear
//            self.sendSubviewToBack(self.overlay)
//            let newLayer = CALayer()
//            newLayer.backgroundColor = UIColor.red.cgColor
//            self.layer.addSublayer(newLayer)
        case .selected:
            self.layer.borderColor = UIColor.black.cgColor
            self.layer.borderWidth = 2

            //            overlay.backgroundColor = .yellow
//            self.bringSubviewToFront(self.overlay)
        }
    }

    func getDoubleIndex() -> DoubleIndex {
        return self.doubleIndex
    }
}
