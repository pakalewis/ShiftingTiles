//
//  MainScreen.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 9/3/14.
//  Copyright (c) 2014 Parker Lewis. All rights reserved.
//



import Foundation
import UIKit
import AVFoundation
import CoreMedia
import CoreVideo
import ImageIO
import QuartzCore

class MainScreen: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Misc vars
    let colorPalette = ColorPalette()
    let userDefaults = UserDefaults.standard
    var imageGallery = ImageGallery()
    var currentImagePackageArray : [ImagePackage]?
    var currentImagePackage : ImagePackage?
    var currentCategory = ""

    
    // MARK: AVFoundation vars
    var captureSession : AVCaptureSession?
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    var stillImageOutput : AVCaptureStillImageOutput?

    
    // MARK: VIEWS
    @IBOutlet weak var shiftingTilesLabel: UILabel!
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tilesPerRowLabel: UILabel!
    @IBOutlet weak var imageCapturingButtonArea: UIView!
    @IBOutlet weak var imageCapturingButtonAreaFakeBorder: UIView!
    // Categories
    @IBOutlet weak var categoryArea: UIView!
    @IBOutlet weak var selectCategoryButton: UIButton!
    @IBOutlet var categoryButtons: [UIButton]! // Array of three buttons
    var categoryStrings = [
        NSLocalizedString("ANIMALS", comment: ""),
        NSLocalizedString("NATURE", comment: ""),
        NSLocalizedString("PLACES", comment: "") ]

    // Other buttons
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
    
    // MARK: Constraints
    @IBOutlet weak var imageCapturingAreaTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoriesHeightConstraint: NSLayoutConstraint!

    
    
    
    // MARK: Lifecycle methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set up and style the views
        self.view.sendSubview(toBack: self.imageCapturingButtonArea)
        self.imageCapturingButtonArea.alpha = 0

        var tilesPerRow = self.userDefaults.integer(forKey: "tilesPerRow")
        if tilesPerRow < 2 || tilesPerRow > 10 {
            // This may occur when the tilesPerRow userDefault was never set on a previous version of the app
            tilesPerRow = 3
            self.userDefaults.set(3, forKey: "tilesPerRow")
            self.userDefaults.synchronize()
        }
        self.tilesPerRowLabel.text = "\(tilesPerRow) x \(tilesPerRow)"
        self.tilesPerRowLabel.adjustsFontSizeToFitWidth = true

        self.mainImageView.layer.borderWidth = 2
        self.letsPlayButton.layer.cornerRadius = self.letsPlayButton.frame.width * 0.25
        self.letsPlayButton.layer.borderWidth = 2
        
        for count in 0..<self.categoryButtons.count {
            self.categoryButtons[count].setTitle(NSLocalizedString(self.categoryStrings[count], comment: ""), for: UIControlState())
        }
        self.categoryArea.layer.borderWidth = 2
        // Add border to only the middle category button so there aren't double borders
        self.categoryButtons[1].layer.borderWidth = 2
        self.enableCategoryButtons(false)
        
        self.updateColorsAndFonts()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Set user defaults upon the first launch
        if(!self.userDefaults.bool(forKey: "firstlaunch1.0")){
            // Only gets called once ever
            self.userDefaults.set(true, forKey: "firstlaunch1.0")
            self.userDefaults.set(true, forKey: "congratsOn")
            self.userDefaults.set(2, forKey: "colorPaletteInt")
            self.userDefaults.set(3, forKey: "tilesPerRow")
            self.userDefaults.synchronize()
        }
        

        // CollectionView
        self.imageCollection.delegate = self
        self.imageCollection.dataSource = self
        let nib = UINib(nibName: "CollectionViewImageCell", bundle: Bundle.main)
        self.imageCollection.register(nib, forCellWithReuseIdentifier: "CELL")
        
        
        // Randomly choose a category and set the initial image
        let randomInt = Int(arc4random_uniform(UInt32(3)))
        _ = shouldChangeToCategory(self.categoryStrings[randomInt] as NSString)
        // Set initial image to display
        mainImageView.image = self.currentImagePackage?.image
    }
    
    
    
    // Segue to game screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if self.categoriesHeightConstraint.constant != 0 {
            self.shrinkCategories()
        }

        if segue.identifier == "playGame" {
            let gameScreen = segue.destination as! GameScreen
            gameScreen.currentImagePackage = self.currentImagePackage
            gameScreen.tilesPerRow = self.userDefaults.integer(forKey: "tilesPerRow")
        }
    }
    

    
    //MARK: CATEGORIES
    @IBAction func selectCategoryButtonPressed(_ sender: AnyObject) {
        if self.categoriesHeightConstraint.constant == 0 {
            self.expandCategories()
        } else {
            self.shrinkCategories()
        }
    }
    
    
    func expandCategories() {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            self.categoriesHeightConstraint.constant = 120
        }
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            self.categoriesHeightConstraint.constant = 180
        }
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.enableCategoryButtons(true)
            self.view.layoutIfNeeded()
        })
    }
    
    
    func shrinkCategories() {
        self.categoriesHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.enableCategoryButtons(false)
            self.view.layoutIfNeeded()
        })
    }
    

    func enableCategoryButtons(_ bool: Bool) {
        for button in self.categoryButtons {
            button.isUserInteractionEnabled = bool
            if bool {
                button.alpha = 1
            } else {
                button.alpha = 0
            }
        }
    }
    
    @IBAction func categoryButtonPressed(_ sender: UIButton) {
        if self.shouldChangeToCategory(sender.titleLabel!.text! as NSString) {
            self.updateMainImageView()
        }
        self.shrinkCategories()
    }
    
    
    func shouldChangeToCategory(_ category: NSString) -> Bool {
        // Check if it's necessary to change
        if !category.isEqual(to: self.currentCategory) {
            // Update the currentCategory and currentImagePackageArray
            self.currentCategory = category as String
            if category.isEqual(to: self.categoryStrings[0]) {
                self.currentImagePackageArray = self.imageGallery.animalImagePackages
            } else if category.isEqual(to: self.categoryStrings[1]) {
                self.currentImagePackageArray = self.imageGallery.natureImagePackages
            } else if category.isEqual(to: self.categoryStrings[2]) {
                self.currentImagePackageArray = self.imageGallery.placesImagePackages
            }
            self.updateCurrentImagePackageWithIndex(0)
            self.imageCollection.reloadData()
            return true
        }
        return false
    }
    
    
    
    
    //MARK: COLLECTION VIEW
    // Number of cells = number of images
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currentImagePackageArray!.count
    }
    
    
    // Cells will be square sized
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: IndexPath!) -> CGSize {
        return CGSize(width: self.imageCollection.frame.height * 0.9, height: self.imageCollection.frame.height * 0.9)
    }

    
    // Create cell from nib and load the appropriate image
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.imageCollection.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as! CollectionViewImageCell
        cell.imageView.image = UIImage(named: self.currentImagePackageArray![indexPath.row].getSmallFileName())
        return cell
    }
    
    
    // Selecting a cell loads the image to the main image view
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.updateCurrentImagePackageWithIndex(indexPath.row)
        self.updateMainImageView()
        self.shrinkCategories()
    }
    
    
    
    

    // MARK: Camera methods
    @IBAction func cameraButtonPressed(_ sender: AnyObject) {
        self.selectCategoryButton.isUserInteractionEnabled = false
        if self.categoriesHeightConstraint.constant != 0 {
            self.shrinkCategories()
        }

        let pickPhotoMenu = UIAlertController(title: NSLocalizedString("CameraButtonAlert_Part1", comment: ""), message: "", preferredStyle: UIAlertControllerStyle.alert)
        let libraryAction = UIAlertAction(title: NSLocalizedString("CameraButtonAlert_Part2", comment: ""), style: UIAlertActionStyle.default) { (handler) -> Void in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: NSLocalizedString("CameraButtonAlert_Part3", comment: ""), style: UIAlertActionStyle.default) { (handler) -> Void in
            
            // Check if device has a camera
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                
                // Check authorization status
                let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
                if status == AVAuthorizationStatus.authorized {
                    if self.captureSession == nil {
                        self.setupAVFoundation()
                    } else {
                        self.view.layer.addSublayer(self.previewLayer!)
                        self.captureSession!.startRunning()
                    }
                    
                    // Display the imageCapturingArea and captureImageButton button
                    self.view.bringSubview(toFront: self.imageCapturingButtonArea)
                    self.imageCapturingButtonArea.alpha = 1
                    self.imageCapturingAreaTopConstraint.constant = 5
                    UIView.animate(withDuration: 0.8, animations: { () -> Void in
                        self.view.layoutIfNeeded()
                    })
                }
                if status == AVAuthorizationStatus.denied {
                    let noAccessAlert = UIAlertController(title: NSLocalizedString("CameraAccessAlert_Part1", comment: ""), message: NSLocalizedString("CameraAccessAlert_Part2", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.cancel) { (handler) -> Void in
                        self.selectCategoryButton.isUserInteractionEnabled = true
                    }
                    noAccessAlert.addAction(okAction)
                    self.present(noAccessAlert, animated: true, completion: nil)
                }
                if status == AVAuthorizationStatus.notDetermined {
                    AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) -> Void in
                        if granted {
                            print("Granted access to camera")
                        } else {
                            print("Access to camera denied")
                        }
                    })
                }
            } else { // No camera on device
                let noCameraAlert = UIAlertController(title: "", message: NSLocalizedString("NoCameraAlert", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.cancel) { (handler) -> Void in
                    self.selectCategoryButton.isUserInteractionEnabled = true
                }
                noCameraAlert.addAction(okAction)
                self.present(noCameraAlert, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""), style: UIAlertActionStyle.cancel) { (handler) -> Void in
            self.selectCategoryButton.isUserInteractionEnabled = true
        }

        pickPhotoMenu.addAction(libraryAction)
        pickPhotoMenu.addAction(cameraAction)
        pickPhotoMenu.addAction(cancelAction)
        self.present(pickPhotoMenu, animated: true, completion: nil)
    }
    
    
    
    func setupAVFoundation() {
        // Capture Session
        self.captureSession = AVCaptureSession()
        self.captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        
        // Preview layer
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
        let bounds = self.mainImageView.bounds
        self.previewLayer!.bounds = CGRect(x: bounds.origin.x + 2, y: bounds.origin.y + 2, width: bounds.width - 4, height: bounds.height - 4)
        self.previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.previewLayer!.position = CGPoint(x: bounds.midX + self.mainImageView.frame.origin.x, y: bounds.midY + self.mainImageView.frame.origin.y)
        self.view.layer.addSublayer(self.previewLayer!)
        
        // Capture Device
        self.captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput(device: self.captureDevice)
            self.captureSession!.addInput(input)
        } catch _ {
            print("error: ")
        }

    
        let outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
        self.stillImageOutput = AVCaptureStillImageOutput()
        self.stillImageOutput!.outputSettings = outputSettings
        self.captureSession!.addOutput(self.stillImageOutput)
    
        self.captureSession!.startRunning()
    }
  
    
    @IBAction func cancelImageCaptureMode(_ sender: AnyObject) {
        self.captureSession!.stopRunning()
        self.previewLayer?.removeFromSuperlayer()

        // Slide the imageCapturingArea offscreen
        self.imageCapturingAreaTopConstraint.constant = 300
        UIView.animate(withDuration: 0.8, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }, completion: { (closure) -> Void in
                self.imageCapturingButtonArea.alpha = 0
                self.view.sendSubview(toBack: self.imageCapturingButtonArea)
        }) 
        self.selectCategoryButton.isUserInteractionEnabled = true
    }
    
    
    @IBAction func captureImage(_ sender: AnyObject) {
        // Slide the imageCapturingArea offscreen
        self.imageCapturingAreaTopConstraint.constant = 300
        UIView.animate(withDuration: 0.8, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: { (closure) -> Void in
            self.imageCapturingButtonArea.alpha = 0
            self.view.sendSubview(toBack: self.imageCapturingButtonArea)
        }) 

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
        switch UIDevice.current.orientation {
        case .portraitUpsideDown:
            newOrientation = .portraitUpsideDown;
            break;
        case .landscapeLeft:
            newOrientation = .landscapeRight;
            break;
        case .landscapeRight:
            newOrientation = .landscapeLeft;
            break;
        default:
            newOrientation = .portrait;
        }
        videoConnection!.videoOrientation = newOrientation
        
        
        
        DispatchQueue.main.async {
            
            self.stillImageOutput!.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (buffer, error) in
                
                let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)!
                var capturedImage = UIImage(data: data)
                self.previewLayer?.removeFromSuperlayer()
                self.captureSession!.stopRunning()
                
                // Rotates the image if its imageOrientation property is not Up
                if !(capturedImage!.imageOrientation == UIImageOrientation.up) {
                    UIGraphicsBeginImageContextWithOptions(capturedImage!.size, false, capturedImage!.scale)
                    capturedImage!.draw(in: CGRect(origin: CGPoint.zero, size: capturedImage!.size))
                    let properImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                    
                    // Now crop to square
                    let squareRect = CGRect(x: 0, y: (properImage.size.height / 2) - (properImage.size.width / 2), width: properImage.size.width, height: properImage.size.width)
                    let croppedCGImage = properImage.cgImage!.cropping(to: squareRect)!
                    let croppedUIImage = UIImage(cgImage: croppedCGImage)
                    
                    capturedImage = croppedUIImage
                    UIGraphicsEndImageContext()
                }
                
                self.currentImagePackage = ImagePackage(baseFileName: "", caption: "", photographer: "")
                self.currentImagePackage?.image = capturedImage!
                self.mainImageView.image = capturedImage!
                
            })
            

        }

        self.selectCategoryButton.isUserInteractionEnabled = true
    }
    
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [AnyHashable: Any]) {
        // Crop the picked image to square
        let imagePicked = info[UIImagePickerControllerEditedImage] as? UIImage
        let imageWidth  = imagePicked!.size.width
        let imageHeight  = imagePicked!.size.height
        var rect = CGRect()
        if ( imageWidth < imageHeight) { // Image is in potrait mode
            rect = CGRect (x: 0, y: (imageHeight - imageWidth) / 2, width: imageWidth, height: imageWidth);
        } else { // Image is in landscape mode
            rect = CGRect (x: (imageWidth - imageHeight) / 2, y: 0, width: imageHeight, height: imageHeight);
        }
        let croppedCGImage = imagePicked?.cgImage?.cropping(to: rect)
        let croppedUIImage = UIImage(cgImage: croppedCGImage!)
        
        // Update currentImagePackage
        self.currentImagePackage = ImagePackage(baseFileName: "", caption: "", photographer: "")
        self.currentImagePackage?.image = croppedUIImage
        self.mainImageView.image = croppedUIImage

        // Dismiss picker
        picker.dismiss(animated: true, completion: nil)
        self.selectCategoryButton.isUserInteractionEnabled = true
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //this gets fired when the users cancel out of the process
        picker.dismiss(animated: true, completion: nil)
        self.selectCategoryButton.isUserInteractionEnabled = true
    }

    
    
    
    // MARK: Other methods
    func updateCurrentImagePackageWithIndex(_ index: Int) {
        // Load the most appropriate size image
        self.currentImagePackage = self.currentImagePackageArray![index]
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            self.currentImagePackage?.image = UIImage(named: self.currentImagePackage!.getMediumFileName())
        }
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            self.currentImagePackage?.image = UIImage(named: self.currentImagePackage!.getLargeFileName())
        }
    }
    
    
    func updateMainImageView() {
        UIView.transition(with: self.mainImageView,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: { self.mainImageView.image = self.currentImagePackage?.image },
            completion: nil)
    }
    
    
    @IBAction func rightButtonPressed(_ sender: AnyObject) {
        if self.categoriesHeightConstraint.constant != 0 {
            self.shrinkCategories()
        }

        var currentTilesPerRow = self.userDefaults.integer(forKey: "tilesPerRow")
        if currentTilesPerRow < 10 {
            currentTilesPerRow += 1
            self.tilesPerRowLabel.text = "\(currentTilesPerRow) x \(currentTilesPerRow)"
            self.userDefaults.set(currentTilesPerRow, forKey: "tilesPerRow")
            self.userDefaults.synchronize()
        }
   }

    
    @IBAction func leftButtonPressed(_ sender: AnyObject) {
        if self.categoriesHeightConstraint.constant != 0 {
            self.shrinkCategories()
        }

        var currentTilesPerRow = self.userDefaults.integer(forKey: "tilesPerRow")
        if currentTilesPerRow > 2 {
            currentTilesPerRow -= 1
            self.tilesPerRowLabel.text = "\(currentTilesPerRow) x \(currentTilesPerRow)"
            self.userDefaults.set(currentTilesPerRow, forKey: "tilesPerRow")
            self.userDefaults.synchronize()
        }
    }
    
    
    func updateColorsAndFonts() {
        // Colors
        self.view.backgroundColor = self.colorPalette.fetchLightColor()
        self.categoryArea.backgroundColor = self.colorPalette.fetchLightColor()
        self.categoryArea.layer.borderColor = self.colorPalette.fetchDarkColor().cgColor
        self.imageCapturingButtonArea.backgroundColor = self.colorPalette.fetchLightColor()
        self.shiftingTilesLabel.textColor = self.colorPalette.fetchDarkColor()
        self.tilesPerRowLabel.textColor = self.colorPalette.fetchDarkColor()
        self.mainImageView.layer.borderColor = self.colorPalette.fetchDarkColor().cgColor
        for count in 0..<self.categoryButtons.count {
            self.categoryButtons[count].setTitleColor(self.colorPalette.fetchDarkColor(), for: UIControlState())
            self.categoryButtons[count].layer.borderColor = self.colorPalette.fetchDarkColor().cgColor
        }

        
        // Icons
        self.selectCategoryButton.setImage(UIImage(named: "menuIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControlState())
        self.cameraButton.setImage(UIImage(named: "cameraIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControlState())
        self.statsButton.setImage(UIImage(named: "statsIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControlState())
        self.decreaseButton.setImage(UIImage(named: "decreaseIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControlState())
        self.increaseButton.setImage(UIImage(named: "increaseIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControlState())
        self.separatorView.backgroundColor = self.colorPalette.fetchDarkColor()
        self.infoButton.setImage(UIImage(named: "infoIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControlState())
        self.letsPlayButton.setImage(UIImage(named: "goIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControlState())
        self.letsPlayButton.layer.borderColor = self.colorPalette.fetchDarkColor().cgColor
        self.settingsButton.setImage(UIImage(named: "settingsIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControlState())
        self.imageCapturingButtonAreaFakeBorder.backgroundColor = self.colorPalette.fetchDarkColor()
        self.captureImageButton.setImage(UIImage(named: "targetIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControlState())
        self.cancelButton.setImage(UIImage(named: "backIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControlState())
 
        // Fonts
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            self.shiftingTilesLabel.font = UIFont(name: "OpenSans-Bold", size: 40)
            self.tilesPerRowLabel.font = UIFont(name: "OpenSans-Bold", size: 15)
            for count in 0..<self.categoryButtons.count {
                self.categoryButtons[count].titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 15)
            }
        }
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            self.shiftingTilesLabel.font = UIFont(name: "OpenSans-Bold", size: 70)
            self.tilesPerRowLabel.font = UIFont(name: "OpenSans-Bold", size: 30)
            for count in 0..<self.categoryButtons.count {
                self.categoryButtons[count].titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 30)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        print("MEMORY WARNING")
    }
}
