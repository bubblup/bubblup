//
//  BubbleCollectionViewController.swift
//  BubblUp
//
//  Created by Suyeon Kang on 4/14/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit
import Parse

class BubbleCollectionViewController: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var ideas:[PFObject]!

    
    var box:PFObject!
    var longPressGesture: UILongPressGestureRecognizer!
    
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var addDrawButton: UIButton!
    @IBOutlet weak var addTextButton: UIButton!
    @IBOutlet weak var addAudioButton: UIButton!
    let transition = BubbleTransition()
    var buttonType: UIButton!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.delegate = self
        longPressGesture = UILongPressGestureRecognizer(target: self, action: "handleLongGesture:")
        self.collectionView.addGestureRecognizer(longPressGesture)
        getAllIdeas(box)
        
        self.title = box["title"] as! String
        
        addTextButton.layer.cornerRadius = addTextButton.frame.width/2
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.width/2
        addDrawButton.layer.cornerRadius = addDrawButton.frame.width/2
        addAudioButton.layer.cornerRadius = addAudioButton.frame.width/2

//        addTextButton.center.y = self.collectionView.frame.height - addTextButton.frame.height/2 + 50
//        addPhotoButton.center.y = self.collectionView.frame.height - addPhotoButton.frame.height/2 + 50
//        addDrawButton.center.y = self.collectionView.frame.height - addDrawButton.frame.height/2 + 50
//        addAudioButton.center.y = self.collectionView.frame.height - addAudioButton.frame.height/2 + 50
        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            self.addTextButton.center.y = self.collectionView.frame.height - self.addTextButton.frame.height/2 - 20
            self.addPhotoButton.center.y = self.collectionView.frame.height - self.addPhotoButton.frame.height/2 - 20
            self.addDrawButton.center.y = self.collectionView.frame.height - self.addDrawButton.frame.height/2 - 20
            self.addAudioButton.center.y = self.collectionView.frame.height - self.addAudioButton.frame.height/2 - 20

            
            }, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(false)
        
        addTextButton.center.y = self.collectionView.frame.height - addTextButton.frame.height/2 + 50
        addPhotoButton.center.y = self.collectionView.frame.height - addPhotoButton.frame.height/2 + 50
        addDrawButton.center.y = self.collectionView.frame.height - addDrawButton.frame.height/2 + 50
        addAudioButton.center.y = self.collectionView.frame.height - addAudioButton.frame.height/2 + 50

    }
    
    
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.Began:
            guard let selectedIndexPath = self.collectionView.indexPathForItemAtPoint(gesture.locationInView(self.collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItemAtIndexPath(selectedIndexPath)
        case UIGestureRecognizerState.Changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.locationInView(gesture.view!))
        
        case UIGestureRecognizerState.Ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
}
let totalColors: Int = 100

func colorForIndexPath(indexPath: NSIndexPath) -> UIColor {
    if indexPath.row >= totalColors {
        return UIColor.blackColor()	// return black if we get an unexpected row index
    }
    
    var hueValue: CGFloat = CGFloat(indexPath.row) / CGFloat(totalColors)
    return UIColor(hue: hueValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
}
extension BubbleCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func getAllIdeas(box: PFObject!){
        let query = PFQuery(className:"Idea")
        query.orderByDescending("_created_at")
        query.whereKey("box", equalTo: box)
        query.findObjectsInBackgroundWithBlock {(media:[PFObject]?, error:NSError?) -> Void in
            if let media = media {
                self.ideas = media
                self.ideas.sortInPlace({($0["index"] as? Int) < ($1["index"] as? Int)})
                self.collectionView.reloadData()
              //  self.tableView.reloadData()
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let ideas = ideas{
            print(ideas.count)
            return ideas.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BubbleCell", forIndexPath: indexPath) as! BubbleCell
        let idea = ideas[indexPath.row]
        cell.backgroundColor = UIColor.whiteColor()
        cell.bubbleLabel.text = idea["text"] as! String
        cell.layer.cornerRadius = cell.frame.height / 2


        print(cell.bubbleLabel.text)
        let type =  idea["type"] as! Int
        //case text
        //case image
        //case voice
        //case video
        switch(type){
        case 0:
       //     cell.typeImage = UIImage(
            break
        case 1:
            break
        case 2:
            break
        case 3:
            break
        default:
            break
        }
        
        //cell.typeLabel.text =  "\(Type.mediaToString(Type.MediaType(rawValue: type)!))"
        //   let cellColor = colorForIndexPath(indexPath)
    
        //cell.backgroundColor = cellColor
        
      //  cell.bubbleLabel
        /*if CGColorGetNumberOfComponents(cellColor.CGColor) == 4 {
            let redComponent = CGColorGetComponents(cellColor.CGColor)[0] * 255
            let greenComponent = CGColorGetComponents(cellColor.CGColor)[1] * 255
            let blueComponent = CGColorGetComponents(cellColor.CGColor)[2] * 255
            cell.bubbleLabel.text = String(format: "%.0f, %.0f, %.0f", redComponent, greenComponent, blueComponent)
        }*/
     
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView,
        moveItemAtIndexPath sourceIndexPath: NSIndexPath,
        toIndexPath destinationIndexPath: NSIndexPath) {
            //let temp = numbers.removeAtIndex(sourceIndexPath.item)
            //numbers.insert(temp, atIndex: destinationIndexPath.item)
    }
            // move your data order
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("select")
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! BubbleCell
        cell.backgroundColor = UIColor.blackColor()
         // let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BubbleCell", forIndexPath: indexPath) as! BubbleCell
        cell.bubbleLabel.text = "select"
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        print("deselect")
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! BubbleCell

         //let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BubbleCell", forIndexPath: indexPath) as! BubbleCell
        cell.bubbleLabel.text = "deselect"
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func collectionView(collectionView: UICollectionView, shouldDeselectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .Custom
        if (segue.identifier == "photoSegue"){
            let viewController = segue.destinationViewController as! BubblePhotoViewController
            viewController.box = box
        }
        if (segue.identifier == "textSegue"){
            let viewController = segue.destinationViewController as! BubbleTextViewController
            viewController.box = box
        }
        if (segue.identifier == "voiceSegue"){
            let viewController = segue.destinationViewController as! BubbleAudioViewController
            viewController.box = box
        }
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch transition.transitionType {
        case .Audio: buttonType = addAudioButton
            break
        case .Draw: buttonType = addDrawButton
            break
        case .Photo: buttonType = addPhotoButton
            break
        case .Text: buttonType = addTextButton
            break
        }
        
        transition.transitionMode = .Present
        transition.startingPoint = buttonType.center
        transition.bubbleColor = buttonType.backgroundColor!
        
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.transitionMode = .Dismiss
        transition.startingPoint = buttonType.center
        transition.bubbleColor = buttonType.backgroundColor!
        return transition
    }

    
    @IBAction func onAudioButton(sender: AnyObject) {
        transition.transitionType = .Audio
        let vc = storyboard?.instantiateViewControllerWithIdentifier("BubbleAudioViewController") as! BubbleAudioViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    @IBAction func onPhotoButton(sender: AnyObject) {
        transition.transitionType = .Photo
        let vc = storyboard?.instantiateViewControllerWithIdentifier("BubblePhotoViewController") as! BubblePhotoViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    @IBAction func onTextButton(sender: AnyObject) {
        transition.transitionType = .Text
        let vc = storyboard?.instantiateViewControllerWithIdentifier("BubbleTextViewController") as! BubbleTextViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    @IBAction func onDrawButton(sender: AnyObject) {
        transition.transitionType = .Draw
        let vc = storyboard?.instantiateViewControllerWithIdentifier("BubbleDrawViewController") as! BubbleDrawViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
    }

}
