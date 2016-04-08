//
//  BubbleViewController.swift
//  BubblUp
//
//  Created by WUSTL STS on 3/8/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit
import Parse
class BubbleViewController: UIViewController {
    var box:PFObject!
    var ideas:[PFObject]!

    @IBOutlet weak var bubbleField: UITextField!

    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight=UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        getAllIdeas(box)
        segmentedControl.selectedSegmentIndex = 0
        tableView.hidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        getAllIdeas(box)
    }
    
    @IBAction func switchClicked(sender: AnyObject) {
        if(segmentedControl.selectedSegmentIndex == 0) {
            tableView.hidden = true
        }
        else {
            tableView.hidden = false
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
        if (segue.identifier == "toAnimationSegue"){
            let viewController = segue.destinationViewController as! UINavigationController
            let controller = viewController.topViewController as! BubbleLayoutViewController
            controller.box = box
        }
        if(segue.identifier == "onIdeaSegue"){
            let controller = segue.destinationViewController as! IdeaViewController
                controller.idea = ideas[tableView.indexPathForSelectedRow!.row]
                controller.ideas = ideas
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



