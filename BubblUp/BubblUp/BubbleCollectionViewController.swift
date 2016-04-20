//
//  BubbleCollectionViewController.swift
//  BubblUp
//
//  Created by Suyeon Kang on 4/14/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit
import Parse



class BubbleCollectionViewController: UIViewController, UIViewControllerTransitioningDelegate, BubbleViewControllerDelegate {
    let panRec = UIPanGestureRecognizer()

    //weak var delegate:BubbleViewControllerDelegate?

    @IBOutlet weak var pin: UIImageView!

    @IBOutlet weak var collectionView: UICollectionView!
    
    var ideas:[PFObject]!

    
    var box:PFObject!
    var longPressGesture: UILongPressGestureRecognizer!
    
 //   @IBOutlet weak var addPhotoButton: UIButton!
 //   @IBOutlet weak var addDrawButton: UIButton!
 //   @IBOutlet weak var addTextButton: UIButton!
 //   @IBOutlet weak var addAudioButton: UIButton!
    let transition = BubbleTransition()
    var buttonType: UIButton!

    func compose(sender: BubbleViewController) {
        print("compose")
//        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
//            
//            self.addTextButton.center.y = self.collectionView.frame.height - self.addTextButton.frame.height/2 - 20
//            self.addPhotoButton.center.y = self.collectionView.frame.height - self.addPhotoButton.frame.height/2 - 20
//            self.addDrawButton.center.y = self.collectionView.frame.height - self.addDrawButton.frame.height/2 - 20
//            self.addAudioButton.center.y = self.collectionView.frame.height - self.addAudioButton.frame.height/2 - 20
//            
//            
//            }, completion: nil)
    }
    func composeCancel(sender: BubbleViewController){
//        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
//            
//            self.addTextButton.center.y = self.collectionView.frame.height - self.addTextButton.frame.height/2 + 50
//            self.addPhotoButton.center.y = self.collectionView.frame.height - self.addPhotoButton.frame.height/2 + 50
//            self.addDrawButton.center.y = self.collectionView.frame.height - self.addDrawButton.frame.height/2 + 50
//            self.addAudioButton.center.y = self.collectionView.frame.height - self.addAudioButton.frame.height/2 + 50
//            
//            }, completion: nil)

        
    }

//    func addBackgroundImage() {
//        imageView = UIImageView(frame: view.bounds)
//        imageView.contentMode = .ScaleAspectFill
//        UIGraphicsBeginImageContext(self.collectionView.frame.size)
//        UIImage(named: "background")?.drawInRect(self.collectionView.bounds)
//    
//        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
//        
//        UIGraphicsEndImageContext()
//        
//        collectionView.backgroundColor = UIColor(patternImage: image)
//    }
    
    func gradient(view: UIView){
   // var vista : UIView = init(frame: rect)
    let gradient : CAGradientLayer = CAGradientLayer()
    gradient.frame = view.bounds
    
    let cor1 = UIColor.blackColor().CGColor
    let cor2 = UIColor.whiteColor().CGColor
    let arrayColors = [cor1, cor2]
    
    gradient.colors = arrayColors
    view.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    func assignbackground(){
        let background = UIImage(named: "background2")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
       // collectionView.addSubview(imageView)
        
        //collectionView.layer.zPosition = -1
        //self.view.sendSubviewToBack(imageView)
        self.view.insertSubview(imageView, atIndex:0)
        print("assign")
      //  collectionView.backgroundColor = UIColor(patternImage: background!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.opaque = false
        //addBackgroundImage()
        assignbackground()
       // self.collectionView.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
       // self.collectionView.backgroundView =
        collectionView.dataSource = self
        collectionView.allowsSelection = true
      //  collectionView.allowsMultipleSelection = true
        collectionView.delegate = self
        longPressGesture = UILongPressGestureRecognizer(target: self, action: "handleLongGesture:")
        self.collectionView.addGestureRecognizer(longPressGesture)
        getAllIdeas(box)
        
        self.title = box["title"] as! String

        panRec.addTarget(self, action: "draggedView:")
        pin.addGestureRecognizer(panRec)
        pin.userInteractionEnabled = true
        

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        getAllIdeas(box)
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        getAllIdeas(box)

//        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
//            
//            self.addTextButton.center.y = self.collectionView.frame.height - self.addTextButton.frame.height/2 - 20
//            self.addPhotoButton.center.y = self.collectionView.frame.height - self.addPhotoButton.frame.height/2 - 20
//            self.addDrawButton.center.y = self.collectionView.frame.height - self.addDrawButton.frame.height/2 - 20
//            self.addAudioButton.center.y = self.collectionView.frame.height - self.addAudioButton.frame.height/2 - 20
//
//            
//            }, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(false)
        print("view will disappear")
//        addTextButton.center.y = self.collectionView.frame.height - addTextButton.frame.height/2 + 50
//        addPhotoButton.center.y = self.collectionView.frame.height - addPhotoButton.frame.height/2 + 50
//        addDrawButton.center.y = self.collectionView.frame.height - addDrawButton.frame.height/2 + 50
//        addAudioButton.center.y = self.collectionView.frame.height - addAudioButton.frame.height/2 + 50
//
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
    func applyCurvedShadow(view: UIView) {
        let size = view.bounds.size
        let width = size.width
        let height = size.height
        let depth = CGFloat(11.0)
        let lessDepth = 0.8 * depth
        let curvyness = CGFloat(5)
        let radius = CGFloat(1)
        
        var path = UIBezierPath()
        
        // top left
        path.moveToPoint(CGPoint(x: radius, y: height))
        
        // top right
        path.addLineToPoint(CGPoint(x: width - 2*radius, y: height))
        
        // bottom right + a little extra
        path.addLineToPoint(CGPoint(x: width - 2*radius, y: height + depth))
        
        // path to bottom left via curve
        path.addCurveToPoint(CGPoint(x: radius, y: height + depth),
            controlPoint1: CGPoint(x: width - curvyness, y: height + lessDepth - curvyness),
            controlPoint2: CGPoint(x: curvyness, y: height + lessDepth - curvyness))
        
        var layer = view.layer
        layer.shadowPath = path.CGPath
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = radius
        layer.shadowOffset = CGSize(width: 0, height: -3)
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BubbleCell", forIndexPath: indexPath) as! BubbleCell
        let idea = ideas[indexPath.row]
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "bubble-1")!)
        
        
        let type =  idea["type"] as! Int
        //case text
        //case image
        //case voice
        //case video
        switch(type){
        case 0:
            cell.typeImage.image = UIImage(named: "text")
            break
        case 1:
            cell.typeImage.image = UIImage(named: "camera")

            break
        case 2:
            cell.typeImage.image = UIImage(named: "microphone")

            break
        case 3:
            cell.typeImage.image = UIImage(named: "drawing")

            break
        default:
            break
        }

        
        UIGraphicsBeginImageContext(cell.frame.size)
        UIImage(named: "bubble-1")?.drawInRect(cell.bounds)
        
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        
        cell.backgroundColor = UIColor(patternImage: image)
        
//        let imageView = UIImageView(frame: cell.bounds)
//        imageView.image = UIImage(named: "bubble-1")//if its in images.xcassets
//        cell.insertSubview(imageView, atIndex: 0)

        cell.bubbleLabel.text = idea["text"] as! String
        cell.layer.cornerRadius = cell.frame.height / 2
       // gradient(cell)
// 
//        cell.layer.shadowOffset = CGSize(width: 3, height: 3)
//        cell.layer.shadowOpacity = 0.7
//        cell.layer.shadowRadius = 2
    //   cell.layer.masksToBounds = true;
//        cell.layer.shadowOffset = CGSizeMake(-15, 20);
//        cell.layer.shadowRadius = 15;
//        cell.layer.shadowOpacity = 0.5;
//        print(cell.bubbleLabel.text)
        applyCurvedShadow(cell)
        
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
            print("move Item")
            let temp = ideas.removeAtIndex(sourceIndexPath.item)
            ideas.insert(temp, atIndex: destinationIndexPath.item)
            for idea in ideas{
                //Change the oder number
                var index = ideas.indexOf(idea)!
                Idea.changeIndex(idea, newIndex: index, withCompletion: { (success: Bool, error: NSError?) -> Void in
                    if success{
                        //print("\(idea["text"]) new index is \(index)")
                    } else{
                        print(error?.localizedDescription)
                    }
                })
            }
    }
            // move your data order
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("select")
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! BubbleCell
      //  cell.backgroundColor = UIColor.blackColor()
         // let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BubbleCell", forIndexPath: indexPath) as! BubbleCell
        //cell.bubbleLabel.text = "select"
        transition.transitionType = .Bubble
        transition.bubbleColor = UIColor.whiteColor()
        print("select end")
    }
    
//    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
//        print("deselect")
//        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! BubbleCell
//
//         //let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BubbleCell", forIndexPath: indexPath) as! BubbleCell
//        cell.bubbleLabel.text = "deselect"
//    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
//    func collectionView(collectionView: UICollectionView, shouldDeselectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
//      //  return true
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("prepare For segue from collection")
        let controller = segue.destinationViewController
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .Custom
        if (segue.identifier == "toPageView") {
            let viewController = segue.destinationViewController as! PageViewController
            
            viewController.ideas = ideas
            let indexPaths = self.collectionView.indexPathsForSelectedItems()
            let indexPath: NSIndexPath = indexPaths![0] as NSIndexPath
            viewController.index = indexPath.row
            
            
            // pass data to next view
        }
        else {
        
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
        
        if (segue.identifier == "toPageView") {
            let viewController = segue.destinationViewController as! PageViewController
        
            viewController.ideas = ideas
            let indexPaths = self.collectionView.indexPathsForSelectedItems()
            let indexPath: NSIndexPath = indexPaths![0] as NSIndexPath
            viewController.index = indexPath.row
            
            
                // pass data to next view
        }
        }
    
    }


    

}

var center:CGPoint!
extension BubbleCollectionViewController {
    @IBAction func drag(sender: UIPanGestureRecognizer) {
        print("dragged")
        draggedView(sender)
    }
    func draggedView(sender:UIPanGestureRecognizer){
        print("dragged view")
        
        if(sender.state == .Began){
            center = sender.view?.center

        }
        
        var translation = sender.translationInView(self.view)
        
        //sender.view.
        var tmp=sender.view?.center.x  //x translation
        var tmp1=sender.view?.center.y //y translation
        
        //set limitation for x and y origin
        if(translation.x <= 100 && translation.y <= 50 )
        {
            sender.view?.center=CGPointMake(tmp!+translation.x, tmp1!+translation.y)
            sender.setTranslation(CGPointZero, inView: self.view)
        }
        if(sender.state == .Ended){
            let visibleCells = collectionView.visibleCells()
            let viewPosition = sender.locationInView(collectionView)
            for cell in visibleCells {
                //cell.layer.conta
                if cell.layer.containsPoint(cell.layer.convertPoint(viewPosition, fromLayer: cell.layer.superlayer)){
                    print("delete")
                    let indexPath = collectionView.indexPathForCell(cell)
                    removeIdea(indexPath!)
                    self.collectionView.deleteItemsAtIndexPaths([collectionView.indexPathForCell(cell)!])
                    break
                  //  self.collectionView.reloadData()
                   // self.collectionView.deleteItemsAtIndexPaths([collectionView.indexPathForCell(cell)!])
                }
            }
            
            
            
            sender.view?.center
            for idea in ideas {
                
            }
            sender.view?.center = center!
            

        }
        
        
    }
    func removeIdea(indexPath: NSIndexPath){
        
        Idea.deleteIdea(ideas[indexPath.row], withCompletion: { (success:Bool, error:NSError?) -> Void in
            if(success == true) {
                print("delete successful")
            }
            else {
                print("delete unsuccessful")
            }
        })
        ideas.removeAtIndex(indexPath.row)
    }
    func highlightCell(indexPath : NSIndexPath, flag: Bool) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        
        if flag {
            cell?.contentView.backgroundColor = UIColor.magentaColor()
        } else {
            cell?.contentView.backgroundColor = nil
        }
    }

    
}
