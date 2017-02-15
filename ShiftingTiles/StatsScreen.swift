//
//  StatsScreen.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 1/6/15.
//  Copyright (c) 2015 Parker Lewis. All rights reserved.
//

import Foundation
import UIKit


class StatsScreen: UIViewController, UITableViewDataSource, UITableViewDelegate {
    class func generate() -> StatsScreen {
        return UIStoryboard(name: "Stats", bundle: nil).instantiateInitialViewController() as! StatsScreen
    }
    

    let colorPalette = ColorPalette()

    let stats = Stats()
    
    // VIEWS
    @IBOutlet weak var statsLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var topBorder: UIView!
    @IBOutlet weak var statsTable: UITableView!
    @IBOutlet weak var bottomBorder: UIView!
    @IBOutlet weak var totalSolvesLabel: UILabel!
    
    // BUTTONS
    @IBOutlet weak var dismissButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Apply color scheme and font
        self.view.backgroundColor = self.colorPalette.fetchLightColor()
        self.topBorder.backgroundColor = self.colorPalette.fetchDarkColor()
        self.bottomBorder.backgroundColor = self.colorPalette.fetchDarkColor()
        self.statsLabel.textColor = self.colorPalette.fetchDarkColor()
        self.leftLabel.textColor = self.colorPalette.fetchDarkColor()
        self.rightLabel.textColor = self.colorPalette.fetchDarkColor()
        self.totalSolvesLabel.textColor = self.colorPalette.fetchDarkColor()

        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            self.statsLabel.font = UIFont(name: "OpenSans-Bold", size: 35)
            self.leftLabel.font = UIFont(name: "OpenSans", size: 25)
            self.rightLabel.font = UIFont(name: "OpenSans", size: 25)
            self.totalSolvesLabel.font = UIFont(name: "OpenSans", size: 25)
        }
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            self.statsLabel.font = UIFont(name: "OpenSans-Bold", size: 70)
            self.leftLabel.font = UIFont(name: "OpenSans-Bold", size: 45)
            self.rightLabel.font = UIFont(name: "OpenSans-Bold", size: 45)
            self.totalSolvesLabel.font = UIFont(name: "OpenSans-Bold", size: 45)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statsTable.dataSource = self
        self.statsTable.delegate = self
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(StatsScreen.dismissStatsScreen(_:)))
        self.view.addGestureRecognizer(dismissTap)
        
        self.totalSolvesLabel.text = NSLocalizedString("TOTAL_SOLVES", comment: "TOTAL_SOLVES") + ":  \(self.stats.fetchTotalSolves())"
        
        // Register StatCell nib
        let nib = UINib(nibName: "StatCell", bundle: Bundle.main)
        self.statsTable.register(nib, forCellReuseIdentifier: "STAT_CELL")
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.statsTable.dequeueReusableCell(withIdentifier: "STAT_CELL", for: indexPath) as! StatCell
        cell.backgroundColor = self.colorPalette.fetchLightColor()
        cell.leftLabel.text = "\(indexPath.row + 2) x \(indexPath.row + 2)"
        cell.rightLabel.text = "\(self.stats.solvesAtSizeInts[indexPath.row])"
        cell.leftLabel.textColor = self.colorPalette.fetchDarkColor()
        cell.rightLabel.textColor = self.colorPalette.fetchDarkColor()
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            cell.leftLabel.font = UIFont(name: "OpenSans", size: 15)
            cell.rightLabel.font = UIFont(name: "OpenSans", size: 15)
        }
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            cell.leftLabel.font = UIFont(name: "OpenSans", size: 30)
            cell.rightLabel.font = UIFont(name: "OpenSans", size: 30)
        }
        return cell
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stats.solvesAtSizeInts.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.statsTable.frame.height / CGFloat(self.stats.solvesAtSizeInts.count)
    }
    
    
    func dismissStatsScreen(_ sender: UIGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }

}
