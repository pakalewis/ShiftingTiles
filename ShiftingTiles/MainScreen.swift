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
//    var imageGallery = ImageGallery()
    var currentImagePackage : ImagePackage?

    let photoBrowser = PhotoBrowser()
    
    // MARK: AVFoundation vars
    var captureSession : AVCaptureSession?
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?

    
    // MARK: VIEWS
    @IBOutlet weak var shiftingTilesLabel: UILabel!
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tilesPerRowLabel: UILabel!
    @IBOutlet weak var imageCapturingButtonArea: UIView!
    @IBOutlet weak var imageCapturingButtonAreaFakeBorder: UIView!
    // Categories
//    @IBOutlet weak var categoryArea: UIView!
    @IBOutlet weak var selectCategoryButton: UIButton!
    @IBOutlet weak var categoryStack: UIStackView!
    

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
//    @IBOutlet weak var categoriesHeightConstraint: NSLayoutConstraint!

    
    
    
    // MARK: Lifecycle methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set up and style the views
        self.view.sendSubviewToBack(self.imageCapturingButtonArea)
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
        
//        for count in 0..<self.categoryButtons.count {
//            self.categoryButtons[count].setTitle(NSLocalizedString(self.categoryStrings[count], comment: ""), for: UIControl.State())
//        }
//        self.categoryArea.layer.borderWidth = 2
        // Add border to only the middle category button so there aren't double borders
//        self.categoryButtons[1].layer.borderWidth = 2
        self.enableCategoryButtons(false)
        
        self.updateColorsAndFonts()
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        shrinkCategories()
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
        for category in photoBrowser.categories {
            let button = CategoryButton(category: category, delegate: self)
            categoryStack.addArrangedSubview(button)
        }
        
        // Set initial image to display
        updateMainImageView(image: photoBrowser.image())
    }
    
    
    
    
    //MARK: CATEGORIES
    @IBAction func selectCategoryButtonPressed(_ sender: AnyObject) {
//        if self.categoriesHeightConstraint.constant == 0 {
//            self.expandCategories()
//        } else {
//            self.shrinkCategories()
//        }
    }
    
    
    func expandCategories() {
//        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
//            self.categoriesHeightConstraint.constant = 120
//        }
//        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
//            self.categoriesHeightConstraint.constant = 180
//        }
//
//        UIView.animate(withDuration: 0.5, animations: { () -> Void in
//            self.enableCategoryButtons(true)
//            self.view.layoutIfNeeded()
//        })
    }
    
    
    func shrinkCategories() {
//        if categoriesHeightConstraint.constant == 0 { return }
//
//        categoriesHeightConstraint.constant = 0
//        UIView.animate(withDuration: 0.5, animations: { () -> Void in
//            self.enableCategoryButtons(false)
//            self.view.layoutIfNeeded()
//        })
    }
    

    func enableCategoryButtons(_ bool: Bool) {
//        for button in self.categoryButtons {
//            button.isUserInteractionEnabled = bool
//            if bool {
//                button.alpha = 1
//            } else {
//                button.alpha = 0
//            }
//        }
    }
    
    //MARK: COLLECTION VIEW
    // Number of cells = number of images
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoBrowser.currentPackage().count
    }
    
    
    // Cells will be square sized
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: IndexPath!) -> CGSize {
        return CGSize(width: self.imageCollection.frame.height * 0.9, height: self.imageCollection.frame.height * 0.9)
    }

    
    // Create cell from nib and load the appropriate image
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.imageCollection.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as! CollectionViewImageCell
        let package = photoBrowser.currentPackage()[indexPath.row]
        cell.imageView.image = UIImage(named: package.getSmallFileName())
        return cell
    }
    
    
    // Selecting a cell loads the image to the main image view
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.updateMainImageView(image: photoBrowser.image(index: indexPath.row))
        self.shrinkCategories()
    }
    
    
    
    

    // MARK: Camera methods
    @IBAction func cameraButtonPressed(_ sender: AnyObject) {
        camera()
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
                self.view.sendSubviewToBack(self.imageCapturingButtonArea)
        }) 
        self.selectCategoryButton.isUserInteractionEnabled = true
    }
    
    
    @IBAction func captureImage(_ sender: AnyObject) {
        capture()

    }
    
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [AnyHashable: Any]) {
        // Crop the picked image to square
        let imagePicked = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage
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

    
    
    func updateMainImageView(image: UIImage) {
        UIView.transition(with: self.mainImageView,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: { self.mainImageView.image = image },
            completion: nil)
    }
    
    
    @IBAction func rightButtonPressed(_ sender: AnyObject) {
//        if self.categoriesHeightConstraint.constant != 0 {
//            self.shrinkCategories()
//        }

        var currentTilesPerRow = self.userDefaults.integer(forKey: "tilesPerRow")
        if currentTilesPerRow < 10 {
            currentTilesPerRow += 1
            self.tilesPerRowLabel.text = "\(currentTilesPerRow) x \(currentTilesPerRow)"
            self.userDefaults.set(currentTilesPerRow, forKey: "tilesPerRow")
            self.userDefaults.synchronize()
        }
   }

    
    @IBAction func leftButtonPressed(_ sender: AnyObject) {
//        if self.categoriesHeightConstraint.constant != 0 {
//            self.shrinkCategories()
//        }

        var currentTilesPerRow = self.userDefaults.integer(forKey: "tilesPerRow")
        if currentTilesPerRow > 2 {
            currentTilesPerRow -= 1
            self.tilesPerRowLabel.text = "\(currentTilesPerRow) x \(currentTilesPerRow)"
            self.userDefaults.set(currentTilesPerRow, forKey: "tilesPerRow")
            self.userDefaults.synchronize()
        }
    }
    
    @IBAction func statsButtonTapped(_ sender: Any) {
        let stats = StatsScreen.generate()
        present(stats, animated: true, completion: nil)
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        let infoVC = InfoScreen()
        present(infoVC, animated: true, completion: nil)
    }
    
    @IBAction func letsPlayButtonTapped(_ sender: Any) {
        let gameBoardVC = GameBoardVC.generate()
        gameBoardVC.currentImagePackage = self.currentImagePackage
        gameBoardVC.tilesPerRow = self.userDefaults.integer(forKey: "tilesPerRow")
        present(gameBoardVC, animated: true, completion: nil)

    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        let settings = SettingsScreen.generate()
        present(settings, animated: true, completion: nil)

    }
    
    func updateColorsAndFonts() {
        // Colors
        self.view.backgroundColor = self.colorPalette.fetchLightColor()
//        self.categoryArea.backgroundColor = self.colorPalette.fetchLightColor()
//        self.categoryArea.layer.borderColor = self.colorPalette.fetchDarkColor().cgColor
        self.imageCapturingButtonArea.backgroundColor = self.colorPalette.fetchLightColor()
        self.shiftingTilesLabel.textColor = self.colorPalette.fetchDarkColor()
        self.tilesPerRowLabel.textColor = self.colorPalette.fetchDarkColor()
        self.mainImageView.layer.borderColor = self.colorPalette.fetchDarkColor().cgColor
//        for count in 0..<self.categoryButtons.count {
//            self.categoryButtons[count].setTitleColor(self.colorPalette.fetchDarkColor(), for: UIControl.State())
//            self.categoryButtons[count].layer.borderColor = self.colorPalette.fetchDarkColor().cgColor
//        }

        
        // Icons
        self.selectCategoryButton.setImage(UIImage(named: "menuIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControl.State())
        self.cameraButton.setImage(UIImage(named: "cameraIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControl.State())
        self.statsButton.setImage(UIImage(named: "statsIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControl.State())
        self.decreaseButton.setImage(UIImage(named: "decreaseIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControl.State())
        self.increaseButton.setImage(UIImage(named: "increaseIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControl.State())
        self.separatorView.backgroundColor = self.colorPalette.fetchDarkColor()
        self.infoButton.setImage(UIImage(named: "infoIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControl.State())
        self.letsPlayButton.setImage(UIImage(named: "goIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControl.State())
        self.letsPlayButton.layer.borderColor = self.colorPalette.fetchDarkColor().cgColor
        self.settingsButton.setImage(UIImage(named: "settingsIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControl.State())
        self.imageCapturingButtonAreaFakeBorder.backgroundColor = self.colorPalette.fetchDarkColor()
        self.captureImageButton.setImage(UIImage(named: "targetIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControl.State())
        self.cancelButton.setImage(UIImage(named: "backIcon")?.imageWithColor(self.colorPalette.fetchDarkColor()), for: UIControl.State())
 
        // Fonts
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            self.shiftingTilesLabel.font = UIFont(name: "OpenSans-Bold", size: 40)
            self.tilesPerRowLabel.font = UIFont(name: "OpenSans-Bold", size: 15)
//            for count in 0..<self.categoryButtons.count {
//                self.categoryButtons[count].titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 15)
//            }
        }
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            self.shiftingTilesLabel.font = UIFont(name: "OpenSans-Bold", size: 70)
            self.tilesPerRowLabel.font = UIFont(name: "OpenSans-Bold", size: 30)
//            for count in 0..<self.categoryButtons.count {
//                self.categoryButtons[count].titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 30)
//            }
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVMediaType(_ input: AVMediaType) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVCaptureSessionPreset(_ input: AVCaptureSession.Preset) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVLayerVideoGravity(_ input: AVLayerVideoGravity) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}

extension MainScreen: CategoryButtonDelegate {
    func selected(category: PhotoCategory) {
        if self.photoBrowser.currentCategory == category { return }
        
        self.photoBrowser.currentCategory = category
        self.imageCollection.reloadData()
        self.updateMainImageView(image: photoBrowser.image())

        self.shrinkCategories()
    }
}









extension MainScreen {
//    var stillImageOutput : AVCaptureStillImageOutput?

    func setupAVFoundation() {
        // Capture Session
//        self.captureSession = AVCaptureSession()
//        self.captureSession!.sessionPreset = AVCaptureSession.Preset(rawValue: convertFromAVCaptureSessionPreset(AVCaptureSession.Preset.photo))
//
//        // Preview layer
//        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
//        let bounds = self.mainImageView.bounds
//        self.previewLayer!.bounds = CGRect(x: bounds.origin.x + 2, y: bounds.origin.y + 2, width: bounds.width - 4, height: bounds.height - 4)
//        self.previewLayer!.videoGravity = AVLayerVideoGravity(rawValue: convertFromAVLayerVideoGravity(AVLayerVideoGravity.resizeAspectFill))
//        self.previewLayer!.position = CGPoint(x: bounds.midX + self.mainImageView.frame.origin.x, y: bounds.midY + self.mainImageView.frame.origin.y)
//        self.view.layer.addSublayer(self.previewLayer!)
//
//        // Capture Device
//        self.captureDevice = AVCaptureDevice.default(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video)))
//        do {
//            let input = try AVCaptureDeviceInput(device: self.captureDevice)
//            self.captureSession!.addInput(input)
//        } catch _ {
//            print("error: ")
//        }
//
//
//        let outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
//        self.stillImageOutput = AVCaptureStillImageOutput()
//        self.stillImageOutput!.outputSettings = outputSettings
//        self.captureSession!.addOutput(self.stillImageOutput)
//
//        self.captureSession!.startRunning()
    }

    func camera() {
//        self.selectCategoryButton.isUserInteractionEnabled = false
//        if self.categoriesHeightConstraint.constant != 0 {
//            self.shrinkCategories()
//        }
//
//        let pickPhotoMenu = UIAlertController(title: NSLocalizedString("CameraButtonAlert_Part1", comment: ""), message: "", preferredStyle: UIAlertController.Style.alert)
//        let libraryAction = UIAlertAction(title: NSLocalizedString("CameraButtonAlert_Part2", comment: ""), style: UIAlertAction.Style.default) { (handler) -> Void in
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.allowsEditing = true
//            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
//            self.present(imagePicker, animated: true, completion: nil)
//        }
//        let cameraAction = UIAlertAction(title: NSLocalizedString("CameraButtonAlert_Part3", comment: ""), style: UIAlertAction.Style.default) { (handler) -> Void in
//
//            // Check if device has a camera
//            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
//
//                // Check authorization status
//                let status = AVCaptureDevice.authorizationStatus(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video)))
//                if status == AVAuthorizationStatus.authorized {
//                    if self.captureSession == nil {
//                        self.setupAVFoundation()
//                    } else {
//                        self.view.layer.addSublayer(self.previewLayer!)
//                        self.captureSession!.startRunning()
//                    }
//
//                    // Display the imageCapturingArea and captureImageButton button
//                    self.view.bringSubviewToFront(self.imageCapturingButtonArea)
//                    self.imageCapturingButtonArea.alpha = 1
//                    self.imageCapturingAreaTopConstraint.constant = 5
//                    UIView.animate(withDuration: 0.8, animations: { () -> Void in
//                        self.view.layoutIfNeeded()
//                    })
//                }
//                if status == AVAuthorizationStatus.denied {
//                    let noAccessAlert = UIAlertController(title: NSLocalizedString("CameraAccessAlert_Part1", comment: ""), message: NSLocalizedString("CameraAccessAlert_Part2", comment: ""), preferredStyle: UIAlertController.Style.alert)
//                    let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.cancel) { (handler) -> Void in
//                        self.selectCategoryButton.isUserInteractionEnabled = true
//                    }
//                    noAccessAlert.addAction(okAction)
//                    self.present(noAccessAlert, animated: true, completion: nil)
//                }
//                if status == AVAuthorizationStatus.notDetermined {
//                    AVCaptureDevice.requestAccess(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video)), completionHandler: { (granted) -> Void in
//                        if granted {
//                            print("Granted access to camera")
//                        } else {
//                            print("Access to camera denied")
//                        }
//                    })
//                }
//            } else { // No camera on device
//                let noCameraAlert = UIAlertController(title: "", message: NSLocalizedString("NoCameraAlert", comment: ""), preferredStyle: UIAlertController.Style.alert)
//                let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.cancel) { (handler) -> Void in
//                    self.selectCategoryButton.isUserInteractionEnabled = true
//                }
//                noCameraAlert.addAction(okAction)
//                self.present(noCameraAlert, animated: true, completion: nil)
//            }
//        }
//        let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""), style: UIAlertAction.Style.cancel) { (handler) -> Void in
//            self.selectCategoryButton.isUserInteractionEnabled = true
//        }
//
//        pickPhotoMenu.addAction(libraryAction)
//        pickPhotoMenu.addAction(cameraAction)
//        pickPhotoMenu.addAction(cancelAction)
//        self.present(pickPhotoMenu, animated: true, completion: nil)
//
    }
    func capture() {
//        // Slide the imageCapturingArea offscreen
//        self.imageCapturingAreaTopConstraint.constant = 300
//        UIView.animate(withDuration: 0.8, animations: { () -> Void in
//            self.view.layoutIfNeeded()
//        }, completion: { (closure) -> Void in
//            self.imageCapturingButtonArea.alpha = 0
//            self.view.sendSubviewToBack(self.imageCapturingButtonArea)
//        })
//
//        var videoConnection : AVCaptureConnection?
//        for connection in self.stillImageOutput!.connections {
//            if let cameraConnection = connection as? AVCaptureConnection {
//                for port in cameraConnection.inputPorts {
//                    if let videoPort = port as? AVCaptureInput.Port {
//                        if videoPort.mediaType.rawValue == convertFromAVMediaType(AVMediaType.video) {
//                            videoConnection = cameraConnection
//                            break;
//                        }
//                    }
//                }
//            }
//            if videoConnection != nil {
//                break;
//            }
//        }
//
//
//        // This might not be necessary
//        var newOrientation: AVCaptureVideoOrientation
//        switch UIDevice.current.orientation {
//        case .portraitUpsideDown:
//            newOrientation = .portraitUpsideDown;
//            break;
//        case .landscapeLeft:
//            newOrientation = .landscapeRight;
//            break;
//        case .landscapeRight:
//            newOrientation = .landscapeLeft;
//            break;
//        default:
//            newOrientation = .portrait;
//        }
//        videoConnection!.videoOrientation = newOrientation
//
//
//
//        DispatchQueue.main.async {
//
//            self.stillImageOutput!.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (buffer, error) in
//
//                let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)!
//                var capturedImage = UIImage(data: data)
//                self.previewLayer?.removeFromSuperlayer()
//                self.captureSession!.stopRunning()
//
//                // Rotates the image if its imageOrientation property is not Up
//                if !(capturedImage!.imageOrientation == UIImage.Orientation.up) {
//                    UIGraphicsBeginImageContextWithOptions(capturedImage!.size, false, capturedImage!.scale)
//                    capturedImage!.draw(in: CGRect(origin: CGPoint.zero, size: capturedImage!.size))
//                    let properImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//
//                    // Now crop to square
//                    let squareRect = CGRect(x: 0, y: (properImage.size.height / 2) - (properImage.size.width / 2), width: properImage.size.width, height: properImage.size.width)
//                    let croppedCGImage = properImage.cgImage!.cropping(to: squareRect)!
//                    let croppedUIImage = UIImage(cgImage: croppedCGImage)
//
//                    capturedImage = croppedUIImage
//                    UIGraphicsEndImageContext()
//                }
//
//                self.currentImagePackage = ImagePackage(baseFileName: "", caption: "", photographer: "")
//                self.currentImagePackage?.image = capturedImage!
//                self.mainImageView.image = capturedImage!
//
//            })
//
//
//        }
//
//        self.selectCategoryButton.isUserInteractionEnabled = true
    }
}
