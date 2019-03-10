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
    roundedSquare


    func image() -> UIImage? {
        switch self {
        case .menu:
            return UIImage(named: "menuIcon")?.withRenderingMode(.alwaysTemplate)
        case .stats:
            return UIImage(named: "statsIcon")?.withRenderingMode(.alwaysTemplate)
        case .decrease:
            return UIImage(named: "decreaseIcon")?.withRenderingMode(.alwaysTemplate)
        case .increase:
            return UIImage(named: "increaseIcon")?.withRenderingMode(.alwaysTemplate)
        case .info:
            return UIImage(named: "infoIcon")?.withRenderingMode(.alwaysTemplate)
        case .go:
            return UIImage(named: "goIcon")?.withRenderingMode(.alwaysTemplate)
        case .settings:
            return UIImage(named: "settingsIcon")?.withRenderingMode(.alwaysTemplate)
        case .roundedSquare:
            return UIImage(named: "roundedSquareIcon")?.withRenderingMode(.alwaysTemplate)
        }
    }
}

//self.separatorView.backgroundColor = Colors.fetchLightColor()
//self.infoButton.setImage(UIImage(named: "infoIcon")?.imageWithColor(Colors.fetchDarkColor()), for: UIControl.State())
//self.letsPlayButton.setImage(UIImage(named: "goIcon")?.imageWithColor(Colors.fetchDarkColor()), for: UIControl.State())
//self.letsPlayButton.layer.borderColor = Colors.fetchDarkColor().cgColor
//self.settingsButton.setImage(UIImage(named: "settingsIcon")?.imageWithColor(Colors.fetchDarkColor()), for: UIControl.State())
