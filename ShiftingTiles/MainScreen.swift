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
import AVFoundation
import CoreMedia
import CoreVideo
import ImageIO
import QuartzCore

class MainScreen: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let colorPalette = ColorPalette()
    let userDefaults = NSUserDefaults.standardUserDefaults()

    
    // AVFoundation
    var captureSession : AVCaptureSession?
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    var stillImageOutput : AVCaptureStillImageOutput?

    
    // VIEWS
    @IBOutlet weak var shiftingTilesLabel: UILabel!
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tilesPerRowLabel: UILabel!
    @IBOutlet weak var imageCapturingButtonArea: UIView!
    @IBOutlet weak var imageCapturingButtonAreaFakeBorder: UIView!

    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var statsButton: UIButton!
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var letsPlayButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var captureImageButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var imageCapturingAreaTopConstraint: NSLayoutConstraint!
    var imageNameArray = [String]()
    var smallImageNameArray = [String]()
    var imageToSolve = UIImage()
    var tilesPerRow = 3
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.sendSubviewToBack(self.imageCapturingButtonArea)
        self.imageCapturingButtonArea.alpha = 0
        self.updateColorsAndFonts()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageCollection.delegate = self
        self.imageCollection.dataSource = self
        
        // register the nibs for the two types of tableview cells
        let nib = UINib(nibName: "CollectionViewImageCell", bundle: NSBundle.mainBundle())
        self.imageCollection.registerNib(nib, forCellWithReuseIdentifier: "CELL")

        var imageGallery = ImageGallery()
        self.imageNameArray = imageGallery.imageNameArray
        self.smallImageNameArray = imageGallery.smallImageNameArray
        self.imageToSolve = UIImage(named: self.imageNameArray[0])!
        self.mainImageView.image = UIImage(named: self.imageNameArray[0])!
        self.mainImageView.layer.borderColor = self.colorPalette.fetchDarkColor().CGColor
        self.mainImageView.layer.borderWidth = 2


        self.tilesPerRow = 3
        self.tilesPerRowLabel.text = "3 x 3"
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
        return self.imageNameArray.count
    }
    
    
    // Cells will be square sized
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        return CGSize(width: self.imageCollection.frame.height * 0.9, height: self.imageCollection.frame.height * 0.9)
    }

    
    // Create cell from nib and load the appropriate image
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.imageCollection.dequeueReusableCellWithReuseIdentifier("CELL", forIndexPath: indexPath) as CollectionViewImageCell
        cell.imageView.image = UIImage(named: self.smallImageNameArray[indexPath.row])!
        return cell
    }
    
    
    // Selecting a cell loads the image to the main image view
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.imageToSolve = UIImage(named: self.imageNameArray[indexPath.row])!
        self.mainImageView.image = UIImage(named: self.imageNameArray[indexPath.row])!
    }
    
    
    

    // MARK: Image funcs
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
                if self.captureSession == nil {
                    self.setupAVFoundation()
                } else {
                    self.view.layer.addSublayer(self.previewLayer)
                    self.captureSession!.startRunning()
                }

                // Display the capture button and block out other controls
                self.view.bringSubviewToFront(self.imageCapturingButtonArea)
                self.imageCapturingButtonArea.alpha = 1

                self.imageCapturingAreaTopConstraint.constant = 5
                UIView.animateWithDuration(0.8, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
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
    
    
    
    func setupAVFoundation() {
        // Capture Session
        self.captureSession = AVCaptureSession()
        self.captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        
        // Preview layer
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
        var bounds = self.mainImageView.bounds
        self.previewLayer!.bounds = CGRectMake(bounds.origin.x + 2, bounds.origin.y + 2, bounds.width - 4, bounds.height - 4)
        self.previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.previewLayer!.position = CGPointMake(CGRectGetMidX(bounds) + self.mainImageView.frame.origin.x, CGRectGetMidY(bounds) + self.mainImageView.frame.origin.y)
        self.view.layer.addSublayer(self.previewLayer)
        
        // Capture Device
        self.captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var err : NSError? = nil
        var input = AVCaptureDeviceInput.deviceInputWithDevice(self.captureDevice, error: &err) as AVCaptureDeviceInput!
        if err != nil {
            println("error: \(err?.localizedDescription)")
        }
        self.captureSession!.addInput(input)

    
        var outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
        self.stillImageOutput = AVCaptureStillImageOutput()
        self.stillImageOutput!.outputSettings = outputSettings
        self.captureSession!.addOutput(self.stillImageOutput)
    
        self.captureSession!.startRunning()
    }
  
    
    @IBAction func cancelImageCaptureMode(sender: AnyObject) {
        self.captureSession!.stopRunning()
        self.previewLayer?.removeFromSuperlayer()

        self.imageCapturingAreaTopConstraint.constant = 300
        UIView.animateWithDuration(0.8, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }) { (closure) -> Void in
                self.imageCapturingButtonArea.alpha = 0
                self.view.sendSubviewToBack(self.imageCapturingButtonArea)
        }
    }
    
    @IBAction func captureImage(sender: AnyObject) {
        self.imageCapturingAreaTopConstraint.constant = 300
        UIView.animateWithDuration(0.8, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }) { (closure) -> Void in
            self.imageCapturingButtonArea.alpha = 0
            self.view.sendSubviewToBack(self.imageCapturingButtonArea)
        }

        var videoConnection : AVCaptureConnection?
        for connection in self.stillImageOutput!.connections {
            if let cameraConnection = connection as? AVCaptureConnection {
                for port in cameraConnection.inputPorts {
                    if let videoPort = port as? AVCaptureInputPort {
                        if videoPort.mediaType == AVMediaTypeVideo {
                            videoConnection = cameraConnection
                            break;
                        }
                    }
                }
            }
            if videoConnection != nil {
                break;
            }
        }
        

        // This might not be necessary
        var newOrientation: AVCaptureVideoOrientation
        switch UIDevice.currentDevice().orientation {
        case .PortraitUpsideDown:
            newOrientation = .PortraitUpsideDown;
            break;
        case .LandscapeLeft:
            newOrientation = .LandscapeRight;
            break;
        case .LandscapeRight:
            newOrientation = .LandscapeLeft;
            break;
        default:
            newOrientation = .Portrait;
        }
        videoConnection!.videoOrientation = newOrientation
        
        
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.stillImageOutput!.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(buffer : CMSampleBuffer!, error : NSError!) -> Void in
                var data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                var capturedImage = UIImage(data: data)
                
                // Rotates the image if its imageOrientation property is not Up
                if !(capturedImage!.imageOrientation == UIImageOrientation.Up) {
                    UIGraphicsBeginImageContextWithOptions(capturedImage!.size, false, capturedImage!.scale)
                    capturedImage!.drawInRect(CGRect(origin: CGPointZero, size: capturedImage!.size))
                    var properImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
                    
                    // Now crop to square
                    var squareRect = CGRectMake(0, (properImage.size.height / 2) - (properImage.size.width / 2), properImage.size.width, properImage.size.width)
                    var croppedCGImage = CGImageCreateWithImageInRect(properImage.CGImage, squareRect)
                    var croppedUIImage = UIImage(CGImage: croppedCGImage)

                    capturedImage = croppedUIImage
                    UIGraphicsEndImageContext()
                }
                
                self.imageToSolve = capturedImage!
                self.mainImageView.image = capturedImage!
                self.previewLayer?.removeFromSuperlayer()

            })

            self.captureSession!.stopRunning()
        }
    }
    
    
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
        self.mainImageView.image = croppedUIImage!
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        //this gets fired when the users cancel out of the process
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    
    // MARK: Other funcs
    @IBAction func rightButtonPressed(sender: AnyObject) {

        self.tilesPerRow++
        if self.tilesPerRow > 10 {
            self.tilesPerRow--
            return
        }
        self.tilesPerRowLabel.text = "\(self.tilesPerRow) x \(self.tilesPerRow)"
   }

    
    @IBAction func leftButtonPressed(sender: AnyObject) {
        
        self.tilesPerRow--
        if self.tilesPerRow < 2 {
            self.tilesPerRow++
            return
        }
        self.tilesPerRowLabel.text = "\(self.tilesPerRow) x \(self.tilesPerRow)"
    }
    
    
    func updateColorsAndFonts() {
        // Colors
        self.view.backgroundColor = self.colorPalette.fetchLightColor()
        self.imageCapturingButtonArea.backgroundColor = self.colorPalette.fetchLightColor()
        self.shiftingTilesLabel.textColor = self.colorPalette.fetchDarkColor()
        self.tilesPerRowLabel.textColor = self.colorPalette.fetchDarkColor()
        self.mainImageView.layer.borderColor = self.colorPalette.fetchDarkColor().CGColor
        
        // Icons
        self.cameraButton.setImage(UIImage(named: "cameraIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), forState: UIControlState.Normal)
        self.statsButton.setImage(UIImage(named: "statsIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), forState: UIControlState.Normal)
        self.decreaseButton.setImage(UIImage(named: "decreaseIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), forState: UIControlState.Normal)
        self.increaseButton.setImage(UIImage(named: "increaseIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), forState: UIControlState.Normal)
        self.separatorView.backgroundColor = self.colorPalette.fetchDarkColor()
        self.infoButton.setImage(UIImage(named: "infoIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), forState: UIControlState.Normal)
        self.letsPlayButton.setImage(UIImage(named: "goIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), forState: UIControlState.Normal)
        self.letsPlayButton.layer.borderColor = self.colorPalette.fetchDarkColor().CGColor
        self.letsPlayButton.layer.cornerRadius = self.letsPlayButton.frame.width * 0.25
        self.letsPlayButton.layer.borderWidth = 2
        self.settingsButton.setImage(UIImage(named: "settingsIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), forState: UIControlState.Normal)
        self.imageCapturingButtonAreaFakeBorder.backgroundColor = self.colorPalette.fetchDarkColor()
        self.captureImageButton.setImage(UIImage(named: "targetIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), forState: UIControlState.Normal)
        self.cancelButton.setImage(UIImage(named: "backIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), forState: UIControlState.Normal)
 
        // Fonts
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            self.shiftingTilesLabel.font = UIFont(name: self.shiftingTilesLabel.font.fontName, size: 40)
            self.tilesPerRowLabel.font = UIFont(name: self.tilesPerRowLabel.font.fontName, size: 15)
        }
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            self.shiftingTilesLabel.font = UIFont(name: self.shiftingTilesLabel.font.fontName, size: 70)
            self.tilesPerRowLabel.font = UIFont(name: self.tilesPerRowLabel.font.fontName, size: 30)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        println("MEMORY WARNING")
    }
}