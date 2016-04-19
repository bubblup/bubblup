//
//  BubbleViewController.swift
//  BubblUp
//
//  Created by WUSTL STS on 3/8/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit
import Parse


protocol BubbleViewControllerDelegate: class {
    func compose(sender: BubbleViewController)
    func composeCancel(sender: BubbleViewController)
}

class BubbleViewController: UIViewController, UIGestureRecognizerDelegate {
    var box:PFObject!
    var ideas:[PFObject]!
    
    
    @IBOutlet weak var tabGesture: UITapGestureRecognizer!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var addDrawButton: UIButton!
    @IBOutlet weak var addTextButton: UIButton!
    @IBOutlet weak var addAudioButton: UIButton!
    let transition = BubbleTransition()
    var buttonType: UIButton!

    @IBOutlet weak var composeButton: UIBarButtonItem!
    @IBOutlet weak var bubbleField: UITextField!

    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
   weak var delegate:BubbleViewControllerDelegate?
    
    @IBAction func composeCanceled(sender: AnyObject) {
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            self.addTextButton.center.y = self.tableView.frame.height - self.addTextButton.frame.height/2 + 50
            self.addPhotoButton.center.y = self.tableView.frame.height - self.addPhotoButton.frame.height/2 + 50
            self.addDrawButton.center.y = self.tableView.frame.height - self.addDrawButton.frame.height/2 + 50
            self.addAudioButton.center.y = self.tableView.frame.height - self.addAudioButton.frame.height/2 + 50
            
            }, completion: nil)
        

    }
    @IBAction func composeClicked(sender: AnyObject) {
//        if(self.tableView.alpha != 1) {
//        print("compose clicked")
//        delegate?.compose(self)
//        composeButton.image = UIImage(named: "cancel")
//        }
//        else {
           print("compose")
            UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                
                self.addTextButton.center.y = self.tableView.frame.height - self.addTextButton.frame.height/2 + 50
                self.addPhotoButton.center.y = self.tableView.frame.height - self.addPhotoButton.frame.height/2 + 50
                self.addDrawButton.center.y = self.tableView.frame.height - self.addDrawButton.frame.height/2 + 50
                self.addAudioButton.center.y = self.tableView.frame.height - self.addAudioButton.frame.height/2 + 50
                
                }, completion: nil)

      //  }
        
    }
    @IBAction func viewTapped(sender: AnyObject) {
        print("view tapped")
       // delegate?.composeCancel(self)
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            self.addTextButton.center.y = self.tableView.frame.height - self.addTextButton.frame.height/2 + 150
            self.addPhotoButton.center.y = self.tableView.frame.height - self.addPhotoButton.frame.height/2 + 150
            self.addDrawButton.center.y = self.tableView.frame.height - self.addDrawButton.frame.height/2 + 150
            self.addAudioButton.center.y = self.tableView.frame.height - self.addAudioButton.frame.height/2 + 150
            
            }, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tabGesture.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight=UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        getAllIdeas(box)
        //     let viewController = containerView.inputViewController
        segmentedControl.selectedSegmentIndex = 0
        tableView.alpha = 0
        //delegate = self
        self.view.bringSubviewToFront(addTextButton)
        self.view.bringSubviewToFront(addPhotoButton)
        self.view.bringSubviewToFront(addAudioButton)
        self.view.bringSubviewToFront(addDrawButton)
      //  addTextButton.send
            
       // addTextButton.layer.zPosition = 1
       // addPhotoButton.layer.zPosition = 1
       // addDrawButton.layer.zPosition = 1
       // addAudioButton.layer.zPosition = 1
        addTextButton.layer.cornerRadius = addTextButton.frame.width/2
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.width/2
        addDrawButton.layer.cornerRadius = addDrawButton.frame.width/2
        addAudioButton.layer.cornerRadius = addAudioButton.frame.width/2
        
        self.addAudioButton.center.y = self.tableView.frame.height - self.addAudioButton.frame.height/2 + 50
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        getAllIdeas(box)
    }
    
    @IBAction func switchClicked(sender: AnyObject) {
        if(segmentedControl.selectedSegmentIndex == 0) {
            UIView.animateWithDuration(0.5, animations: {
                self.containerView.alpha = 1
                self.tableView.alpha = 0
            })
            
        }
        else {
            UIView.animateWithDuration(0.5, animations: {
                self.containerView.alpha = 0
                self.tableView.alpha = 1
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSaveClicked(sender: AnyObject) {
        if(box == nil) {
            print("box does not exist")
        }else{
        Idea.createNewIdea(bubbleField.text, type: Type.MediaType.text, file: nil, containedIn: box) { (success:Bool, error:NSError?) -> Void in
            if success {
                print("successful")
            }
            else{
                print("unsuccessful")
            }
            }}
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toListView") {
            let viewController = segue.destinationViewController as! ListViewController
            viewController.box = box
            // pass data to next view
        }
        else if (segue.identifier == "toAnimationSegue"){
            let viewController = segue.destinationViewController as! UINavigationController
            let controller = viewController.topViewController as! BubbleLayoutViewController
            controller.box = box
        }
        else if(segue.identifier == "onIdeaSegue"){
            let controller = segue.destinationViewController as! IdeaViewController
                controller.idea = ideas[tableView.indexPathForSelectedRow!.row]
                controller.ideas = ideas
            }
        else if(segue.identifier == "toBubbleView"){
            let viewController = segue.destinationViewController as! UINavigationController
            let controller = viewController.topViewController as! BubbleCollectionViewController
            delegate = controller
          //  delegate!.compose(self)
            //controller.delegate = self
            controller.box = box
        }
        else {
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
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BubbleViewController:UITableViewDataSource, UITableViewDelegate {
  
    func getAllIdeas(box: PFObject!){
        let query = PFQuery(className:"Idea")
        query.orderByDescending("_created_at")
        query.whereKey("box", equalTo: box)
        query.findObjectsInBackgroundWithBlock {(media:[PFObject]?, error:NSError?) -> Void in
            if let media = media {
                self.ideas = media
                self.ideas.sortInPlace({($0["index"] as? Int) < ($1["index"] as? Int)})
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ideas != nil {
            return ideas.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell", forIndexPath: indexPath) as! ListCell
        
        let idea = ideas[indexPath.row]
        
        cell.contentLabel.text = idea["text"] as! String
        let type =  idea["type"] as! Int
        cell.typeLabel.text =  "\(Type.mediaToString(Type.MediaType(rawValue: type)!))"
        
        
        return cell
    }
    
    @IBAction func onEdit(sender: AnyObject) {
        if tableView.editing{
            //listTableView.editing = false;
            tableView.setEditing(false, animated: false);
            editButton.style = UIBarButtonItemStyle.Plain;
            editButton.title = "Edit";
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
            //listTableView.reloadData();
        }
        else{
            //listTableView.editing = true;
            tableView.setEditing(true, animated: true);
            editButton.title = "Done";
            editButton.style =  UIBarButtonItemStyle.Done;
            //listTableView.reloadData();
            
        }
    }
    
    
   // @IBAction func composeClicked(sender: AnyObject) {
       // delegate?.compose(self.containerView.)
   // }
    func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true // Yes, the table view can be reordered
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            print("indexpath\(indexPath.row)")
          //  tableView.deleteRowsAtInde
          //  tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimation.Fade)
            Idea.deleteIdea(ideas[indexPath.row], withCompletion: { (success:Bool, error:NSError?) -> Void in
                if(success == true) {
                print("delete successful")
                }
                else {
                    print("delete unsuccessful")
                }
            })
            ideas.removeAtIndex(indexPath.row)

            tableView.reloadData()
            
        }
    }
    
    func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {
        // update the item in my data source by first removing at the from index, then inserting at the to index.
        let idea = ideas[fromIndexPath.row]
        ideas.removeAtIndex(fromIndexPath.row)
        ideas.insert(idea, atIndex: toIndexPath.row)
    }
    


}

extension BubbleViewController: UIViewControllerTransitioningDelegate {
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
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        print("should receive touch")
        
        print(touch.view)
        
        if(touch.view == addAudioButton){
        return false
        }
        if(touch.view == addPhotoButton){
        return false
        }
        if(touch.view == addTextButton){
            return false
        }
        if(touch.view == addDrawButton){
            return false
        }
    print("true")
        
        return true
        
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



