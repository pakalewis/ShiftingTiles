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
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            self.label1.font = UIFont(name: "OpenSans", size: 15)
            self.label2.font = UIFont(name: "OpenSans", size: 15)
            self.label3.font = UIFont(name: "OpenSans", size: 15)
            self.emailButton.titleLabel!.font = UIFont(name: "OpenSans", size: 15)
        }
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            self.label1.font = UIFont(name: "OpenSans", size: 30)
            self.label2.font = UIFont(name: "OpenSans", size: 30)
            self.label3.font = UIFont(name: "OpenSans", size: 30)
            self.emailButton.titleLabel!.font = UIFont(name: "OpenSans", size: 30)
        }
        

        
        self.label1.textColor = Colors.fetchDarkColor()
        self.label2.textColor = Colors.fetchDarkColor()
        self.label3.textColor = Colors.fetchDarkColor()
        self.emailButton.setTitleColor(UIColor.black, for: UIControl.State())
        self.emailButton.layer.cornerRadius = 5
        self.emailButton.layer.borderWidth = 2
        self.emailButton.layer.borderColor = Colors.fetchDarkColor().cgColor


        self.label1.text = NSLocalizedString("Acknowledgements_Part1", comment: "") + "\nParker Lewis"
        self.label2.text = NSLocalizedString("Acknowledgements_Part2", comment: "") + "\nDale Arveson\nGreg Jaehnig\nKate Lewis\nGrant Wilson\nErik Haugen-Goodman\nParker Lewis"
        self.label3.text = NSLocalizedString("Acknowledgements_Part3", comment: "")
    }
    
    
    @IBAction func emailAddressedTapped(_ sender: AnyObject) {
        
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.mailComposeDelegate = self
            mailComposeViewController.setToRecipients(["shiftingtiles@gmail.com"])
            mailComposeViewController.setSubject("Shifting Tiles feedback")
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            let mailErrorAlert = UIAlertController(title: NSLocalizedString("ERROR", comment: ""), message: NSLocalizedString("EmailAlert", comment: ""), preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.cancel, handler: nil)
            mailErrorAlert.addAction(okAction)
            self.present(mailErrorAlert, animated: true, completion: nil)
        }
    }

    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
