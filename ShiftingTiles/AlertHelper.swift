//
//  AlertHelper.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 3/8/19.
//  Copyright © 2019 Parker Lewis. All rights reserved.
//

import UIKit

protocol AutoSolveAlertDelegate: class {
    func autosolve()
}

class AutoSolveAlert {
    deinit {
        print("DEINIT AutoSolveAlert")
    }
    weak var delegate: AutoSolveAlertDelegate?

    init(delegate: AutoSolveAlertDelegate) {
        self.delegate = delegate
    }

    func make() -> UIAlertController {
        let solveAlert = UIAlertController(title: NSLocalizedString("SolveAlert_Part1", comment: ""), message: NSLocalizedString("SolveAlert_Part2", comment: ""), preferredStyle: UIAlertController.Style.alert)
        let noAction = UIAlertAction(title: NSLocalizedString("NO", comment: ""), style: UIAlertAction.Style.cancel, handler: nil)
        let yesAction = UIAlertAction(title: NSLocalizedString("YES", comment: ""), style: UIAlertAction.Style.default) { (finished) -> Void in

            self.delegate?.autosolve()

        }
        solveAlert.addAction(yesAction)
        solveAlert.addAction(noAction)
        return solveAlert
    }

}


protocol LossOfProgressAlertDelegate: class {
    func lossOfProgressAccepted()
}


class LossOfProgressAlert {
    deinit {
        print("DEINIT LossOfProgressAlert")
    }
    weak var delegate: LossOfProgressAlertDelegate?

    init(delegate: LossOfProgressAlertDelegate) {
        self.delegate = delegate
    }

    func make() -> UIAlertController? {
        var numTimesBackButtonPressed = UserDefaults.standard.integer(forKey: "backButtonPressed")
        numTimesBackButtonPressed += 1
        UserDefaults.standard.set(numTimesBackButtonPressed, forKey: "backButtonPressed")

        // Only show this alert for the first 3 times the user presses the back button
        guard UserDefaults.standard.integer(forKey: "backButtonPressed") < 3 else { return nil}

        let lossOfProgressAlert = UIAlertController(title: NSLocalizedString("LossOfProgressAlert_Part1", comment: ""), message: NSLocalizedString("LossOfProgressAlert_Part2", comment: ""), preferredStyle: UIAlertController.Style.alert)
        let noAction = UIAlertAction(title: NSLocalizedString("NO", comment: ""), style: UIAlertAction.Style.cancel, handler: nil)
        let yesAction = UIAlertAction(title: NSLocalizedString("YES", comment: ""), style: UIAlertAction.Style.default, handler: { (ok) -> Void in
            self.delegate?.lossOfProgressAccepted()
        })
        lossOfProgressAlert.addAction(yesAction)
        lossOfProgressAlert.addAction(noAction)
        return lossOfProgressAlert
    }
}
