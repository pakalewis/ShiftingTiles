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
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            self.label1.font = UIFont(name: self.label1.font.fontName, size: 15)
            self.label2.font = UIFont(name: self.label2.font.fontName, size: 15)
            self.label3.font = UIFont(name: self.label3.font.fontName, size: 15)
            self.emailButton.titleLabel!.font = UIFont(name: self.label3.font.fontName, size: 15)
        }
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            self.label1.font = UIFont(name: self.label1.font.fontName, size: 30)
            self.label2.font = UIFont(name: self.label2.font.fontName, size: 30)
            self.label3.font = UIFont(name: self.label3.font.fontName, size: 30)
            self.emailButton.titleLabel!.font = UIFont(name: self.label3.font.fontName, size: 30)
        }
        

        
        self.label1.textColor = self.colorPalette.fetchDarkColor()
        self.label2.textColor = self.colorPalette.fetchDarkColor()
        self.label3.textColor = self.colorPalette.fetchDarkColor()
        self.emailButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.emailButton.layer.cornerRadius = 5
        self.emailButton.layer.borderWidth = 1
        self.emailButton.layer.borderColor = self.colorPalette.fetchDarkColor().CGColor

        
        self.label1.text = "Shifting Tiles developed by:\nParker Lewis"
        self.label2.text = "Images provided by:\nDale Arveson\nGreg Jaehnig\nKate Lewis\nGrant Wilson\nParker Lewis"
        self.label3.text = "Feedback, comments, questions can be sent here:"

    }
    
    
    @IBAction func emailAddressedTapped(sender: AnyObject) {
        
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.mailComposeDelegate = self
            mailComposeViewController.setToRecipients(["shiftingtiles@gmail.com"])
            mailComposeViewController.setSubject("Shifting Tiles feedback")
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            let mailErrorAlert = UIAlertController(title: "Error", message: "Check your e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            mailErrorAlert.addAction(okAction)
            self.presentViewController(mailErrorAlert, animated: true, completion: nil)
        }
    }

    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
