//
//  MainScreen.swift
//  TileGame
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

class MainScreen: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
                            
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var imageCycler: UIImageView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var tilesPerRowLabel: UILabel!
    
    @IBOutlet weak var letsPlayButton: UIButton!
    
    let image99 = UIImage(named: "augs")
    let image1 = UIImage(named: "01.jpeg")
    let image2 = UIImage(named: "02.jpeg")
    let image3 = UIImage(named: "03.jpeg")
    let image4 = UIImage(named: "04.jpeg")
    let image5 = UIImage(named: "05.jpeg")
    let image6 = UIImage(named: "06.jpeg")
    let image7 = UIImage(named: "07.jpeg")
    let image8 = UIImage(named: "08.jpeg")
    let image9 = UIImage(named: "09.jpeg")
    let image10 = UIImage(named: "10.jpeg")
    var imageArray = [UIImage]()
    var imageToSolve = UIImage()
    var tilesPerRow = 3
    var drawGrid : DrawGrid?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageCollection.delegate = self
        self.imageCollection.dataSource = self
        
        
        // register the nibs for the two types of tableview cells
        let nib = UINib(nibName: "CollectionViewImageCell", bundle: NSBundle.mainBundle())
        self.imageCollection.registerNib(nib, forCellWithReuseIdentifier: "CELL")

        imageArray = [image1!, image2!, image3!, image4!, image5!, image6!, image7!, image8!, image9!, image10!, image99!    ]
        self.imageToSolve = imageArray[0]
        self.imageCycler.image = imageArray[0]
        self.imageCycler.layer.borderColor = UIColor.blackColor().CGColor
        self.imageCycler.layer.borderWidth = 2


        stepper.value = 3
        self.tilesPerRow = Int(stepper.value)
        self.tilesPerRowLabel.text = "\(Int(stepper.value).description) Tiles Per Row"
        stepper.wraps = true
        stepper.autorepeat = true
        stepper.maximumValue = 10
        stepper.minimumValue = 2
        
        
        self.letsPlayButton.titleLabel?.adjustsFontSizeToFitWidth = true        
        self.letsPlayButton.layer.cornerRadius = 3
        self.letsPlayButton.layer.borderWidth = 2
        self.letsPlayButton.layer.borderColor = UIColor.blackColor().CGColor
        self.letsPlayButton.sizeToFit()
        
        
        
        
        
    }

    override func viewDidAppear(animated: Bool) {
        self.drawGrid?.removeFromSuperview()
        self.drawGrid = DrawGrid(frame: self.imageCycler.frame)
        self.drawGrid?.numRows = self.tilesPerRow
        self.drawGrid?.backgroundColor = UIColor.clearColor()
        self.drawGrid?.frame = self.imageCycler.frame
        self.view.addSubview(self.drawGrid!)
        

    }
    
    @IBAction func stepperPressed(sender: UIStepper) {
        self.tilesPerRowLabel.text = "\(Int(sender.value).description) Tiles Per Row"
        self.tilesPerRow = Int(sender.value)

        self.drawGrid?.removeFromSuperview()
        self.drawGrid = DrawGrid(frame: self.imageCycler.frame)
        self.drawGrid?.numRows = self.tilesPerRow
        self.drawGrid?.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.drawGrid!)

    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var gameScreen = segue.destinationViewController as GameScreen

        gameScreen.imageToSolve = self.imageToSolve
        gameScreen.tilesPerRow = self.tilesPerRow
        
    }
    

    
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
        cell.imageView.image = self.imageArray[indexPath.row]
        return cell
        
    }
    
    // Selecting a cell loads the image to the main image view
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
            println("selected item at index \(indexPath)")
        self.imageToSolve = imageArray[indexPath.row]
        self.imageCycler.image = imageArray[indexPath.row]

    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        println("MEMORY WARNING")
    }
    


}