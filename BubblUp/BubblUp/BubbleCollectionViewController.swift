//
//  BubbleCollectionViewController.swift
//  BubblUp
//
//  Created by Suyeon Kang on 4/14/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit
import Parse

class BubbleCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var ideas:[PFObject]!

    
    var box:PFObject!
    var longPressGesture: UILongPressGestureRecognizer!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.delegate = self
        longPressGesture = UILongPressGestureRecognizer(target: self, action: "handleLongGesture:")
        self.collectionView.addGestureRecognizer(longPressGesture)
        getAllIdeas(box)
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
}
