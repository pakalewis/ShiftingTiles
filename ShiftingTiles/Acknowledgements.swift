//
//  Acknowledgements.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 1/16/15.
//  Copyright (c) 2015 Parker Lewis. All rights reserved.
//

import UIKit
import MessageUI

class Acknowledgements: UIViewController, MFMailComposeViewControllerDelegate {

    let colorPalette = ColorPalette()

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.label1.textColor = self.colorPalette.fetchDarkColor()
        self.label2.textColor = self.colorPalette.fetchDarkColor()
        

    }
    
    
    @IBAction func emailAddressedTapped(sender: AnyObject) {
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self
        
        mailComposeViewController.setToRecipients(["shiftingtiles@gmail.com"])
        mailComposeViewController.setSubject("Shifting Tiles feedback")
        
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            println("ERROR")
        }
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
