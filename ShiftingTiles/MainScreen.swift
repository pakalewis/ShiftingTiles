//
//  MainScreen.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 9/3/14.
//  Copyright (c) 2014 Parker Lewis. All rights reserved.
//


// ideas for more features:
// allow user to choose picture from camera or photo library
// enable hint button that will highlight the first piece out of position
// fix how the picture gets cut into pieces (some of the edges are not quite right)


import Foundation
import UIKit

class MainScreen: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let colorPalette = ColorPalette()
    
    
    // VIEWS
    @IBOutlet weak var shiftingTilesLabel: UILabel!
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var imageCycler: UIImageView!
    @IBOutlet weak var tilesPerRowLabel: UILabel!
    
    @IBOutlet weak var letsPlayButton: UIButton!
    
    var imageArray = [UIImage]()
    var smallImageArray = [UIImage]()
    var imageToSolve = UIImage()
    var tilesPerRow = 3
    var drawGrid : DrawGrid?
    let pickerData = ["2","3","4","5","6","7","8","9","10"]
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.drawGrid?.alpha = 0
        
        // Apply color scheme
        self.view.backgroundColor = self.colorPalette.fetchLightColor()
        self.shiftingTilesLabel.textColor = self.colorPalette.fetchDarkColor()
        
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageCollection.delegate = self
        self.imageCollection.dataSource = self
        
        
        
        // register the nibs for the two types of tableview cells
        let nib = UINib(nibName: "CollectionViewImageCell", bundle: NSBundle.mainBundle())
        self.imageCollection.registerNib(nib, forCellWithReuseIdentifier: "CELL")

        var imageGallery = ImageGallery()
        self.imageArray = imageGallery.imageArray
        self.smallImageArray = imageGallery.smallImageArray
        self.imageToSolve = imageArray[0]
        self.imageCycler.image = imageArray[0]
        self.imageCycler.layer.borderColor = UIColor.blackColor().CGColor
        self.imageCycler.layer.borderWidth = 2


        self.tilesPerRow = 3
        self.tilesPerRowLabel.text = "3"
        
        
        self.letsPlayButton.titleLabel?.adjustsFontSizeToFitWidth = true        
        self.letsPlayButton.layer.cornerRadius = self.letsPlayButton.frame.width * 0.25
        self.letsPlayButton.layer.borderWidth = 2
        self.letsPlayButton.layer.borderColor = UIColor.blackColor().CGColor
        self.letsPlayButton.sizeToFit()
        
        
        
    }
    
    
    // Segue to game screen
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "playGame" {
            var gameScreen = segue.destinationViewController as GameScreen
            gameScreen.imageToSolve = self.imageToSolve
            gameScreen.tilesPerRow = self.tilesPerRow            
        }
    }
    

    
    //MARK: COLLECTION VIEW
    // Number of cells = number of images
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count
    }
    
    
    // Cells will be square sized
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        return CGSize(width: self.imageCollection.frame.height * 0.9, height: self.imageCollection.frame.height * 0.9)
    }

    
    // Create cell from nib and load the appropriate image
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.imageCollection.dequeueReusableCellWithReuseIdentifier("CELL", forIndexPath: indexPath) as CollectionViewImageCell
        cell.imageView.image = self.smallImageArray[indexPath.row]
        return cell
    }
    
    
    // Selecting a cell loads the image to the main image view
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.imageToSolve = imageArray[indexPath.row]
        self.imageCycler.image = imageArray[indexPath.row]
    }
    
    
    

    
    @IBAction func cameraButtonPressed(sender: AnyObject) {
        var pickPhotoMenu = UIAlertController(title: "Choose a photo:", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        let libraryAction = UIAlertAction(title: "Library", style: UIAlertActionStyle.Default) { (handler) -> Void in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { (handler) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                
                // TODO: try this
//                let blackVC = UIViewController()
//                blackVC.view.backgroundColor = UIColor.blackColor()
//                self.presentViewController(blackVC, animated: true, completion: nil)
                // present blackVC and on that new VC do the imagePicker stuff (four lines above and the two required methods below
                // then devise a way to send the picked photo backwards
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
            } else {
                var noCameraAlert = UIAlertController(title: "", message: "No camera is available on this device", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                noCameraAlert.addAction(okAction)
                self.presentViewController(noCameraAlert, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        pickPhotoMenu.addAction(libraryAction)
        pickPhotoMenu.addAction(cameraAction)
        pickPhotoMenu.addAction(cancelAction)
        self.presentViewController(pickPhotoMenu, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func gridButtonPressed(sender: AnyObject) {
        if self.drawGrid == nil {
            self.drawGrid = DrawGrid(frame: self.imageCycler.frame)
            self.drawGrid?.numRows = self.tilesPerRow
            self.drawGrid?.backgroundColor = UIColor.clearColor()
            self.view.addSubview(self.drawGrid!)
        } else {
            if self.drawGrid?.alpha == 0 {
                self.drawGrid?.alpha = 1
            } else {
                self.drawGrid?.alpha = 0
            }
        }
    }
    
  
    
    // MARK: ImagePicker
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var imagePicked = info[UIImagePickerControllerEditedImage] as? UIImage
        
        
        var imageWidth  = imagePicked!.size.width
        var imageHeight  = imagePicked!.size.height
        var rect = CGRect()
        if ( imageWidth < imageHeight) {
            // Potrait mode
            rect = CGRectMake (0, (imageHeight - imageWidth) / 2, imageWidth, imageWidth);
        } else {
            // Landscape mode
            rect = CGRectMake ((imageWidth - imageHeight) / 2, 0, imageHeight, imageHeight);
        }
        
        var croppedCGImage = CGImageCreateWithImageInRect(imagePicked?.CGImage, rect)
        var croppedUIImage = UIImage(CGImage: croppedCGImage)
        
        self.imageToSolve = croppedUIImage!
        self.imageCycler.image = croppedUIImage!
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        //this gets fired when the users cancel out of the process
        picker.dismissViewControllerAnimated(true, completion: nil)
    }


    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        println("MEMORY WARNING")
    }
    
    
    
    
    // MARK: Custom Stepper
    
    @IBAction func rightButtonPressed(sender: AnyObject) {

        self.tilesPerRow++
        if self.tilesPerRow > 10 {
            self.tilesPerRow--
            return
        }

        self.tilesPerRowLabel.text = "\(self.tilesPerRow)"

        self.drawGrid?.removeFromSuperview()
        self.drawGrid = DrawGrid(frame: self.imageCycler.frame)
        self.drawGrid?.numRows = self.tilesPerRow
        self.drawGrid?.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.drawGrid!)
   }

    @IBAction func leftButtonPressed(sender: AnyObject) {
        
        self.tilesPerRow--
        if self.tilesPerRow < 2 {
            self.tilesPerRow++
            return
        }
        
        self.tilesPerRowLabel.text = "\(self.tilesPerRow)"
        
        self.drawGrid?.removeFromSuperview()
        self.drawGrid = DrawGrid(frame: self.imageCycler.frame)
        self.drawGrid?.numRows = self.tilesPerRow
        self.drawGrid?.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.drawGrid!)
    }

}