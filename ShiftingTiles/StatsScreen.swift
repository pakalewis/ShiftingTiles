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
    
    let colorPalette = ColorPalette()

    var solvesPerSize = NSArray()
    let stats = Stats()
    
    // VIEWS
    @IBOutlet weak var statsLabel: UILabel!
    @IBOutlet weak var statsTable: UITableView!
    @IBOutlet weak var totalSolvesLabel: UILabel!
    
    // BUTTONS
    @IBOutlet weak var dismissButton: UIButton!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Apply color scheme
        self.view.backgroundColor = self.colorPalette.fetchLightColor()
        self.statsLabel.textColor = self.colorPalette.fetchDarkColor()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statsTable.dataSource = self
        self.statsTable.delegate = self
        
        var dismissTap = UITapGestureRecognizer(target: self, action: "dismissStatsScreen:")
        self.view.addGestureRecognizer(dismissTap)
        
        self.totalSolvesLabel.text = "Total:  \(self.stats.fetchTotalSolves())"
        
        // Get the solve stats and store in local array
        self.solvesPerSize = self.stats.fetchSolvesPerSize()
        
        
        let nib = UINib(nibName: "StatCell", bundle: NSBundle.mainBundle())
        self.statsTable.registerNib(nib, forCellReuseIdentifier: "STAT_CELL")

    }
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.statsTable.dequeueReusableCellWithIdentifier("STAT_CELL", forIndexPath: indexPath) as StatCell
        
        cell.leftLabel.text = "\(indexPath.row + 2) x \(indexPath.row + 2)"
        cell.rightLabel.text = "\(self.solvesPerSize[indexPath.row])"
        cell.backgroundColor = self.colorPalette.fetchLightColor()

        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.statsTable.frame.height / 9
    }
    
    
    func dismissStatsScreen(sender: UIGestureRecognizer) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}