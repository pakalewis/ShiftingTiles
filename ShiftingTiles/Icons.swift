//
//  Icons.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 3/10/19.
//  Copyright © 2019 Parker Lewis. All rights reserved.
//

import UIKit

enum Icon {
    case
    menu,
    stats,
    decrease,
    increase,
    info,
    go,
    settings,
    roundedSquare,
    back,
    showOriginal,
    solve,
    hint,
    checkedBox,
    uncheckedBox,
    triangle


    func image() -> UIImage? {
        let image: UIImage?
        switch self {
        case .menu:
            image = UIImage(named: "menuIcon")
        case .stats:
            image = UIImage(named: "statsIcon")
        case .decrease:
            image = UIImage(named: "decreaseIcon")
        case .increase:
            image = UIImage(named: "increaseIcon")
        case .info:
            image = UIImage(named: "infoIcon")
        case .go:
            image = UIImage(named: "goIcon")
        case .settings:
            image = UIImage(named: "settingsIcon")
        case .roundedSquare:
            image = UIImage(named: "roundedSquareIcon")
        case .back:
            image = UIImage(named: "backIcon")
        case .showOriginal:
            image = UIImage(named: "originalImageIcon")
        case .solve:
            image = UIImage(named: "solveIcon")
        case .hint:
            image = UIImage(named: "hintIcon")
        case .checkedBox:
            image = UIImage(named: "checkedBox")
        case .uncheckedBox:
            image = UIImage(named: "uncheckedBox")
        case .triangle:
            image = UIImage(named: "triangle")
        }
        return image?.withRenderingMode(.alwaysTemplate)
    }
}
