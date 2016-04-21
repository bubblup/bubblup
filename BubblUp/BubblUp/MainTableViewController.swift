//
//  MainTableViewController.swift
//  BubblUp
//
//  Created by WUSTL STS on 3/8/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit
import Parse

class MainTableViewController: UIViewController {

    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var boxes:[PFObject]!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    @IBAction func newFolderClicked(sender: AnyObject) {
        let alertController = UIAlertController(title: "New Folder", message: "Enter your folder name", preferredStyle: .Alert)
        var nameTextField: UITextField?

        let okClosure: ((UIAlertAction!) -> Void)! = { action in
            var newFolderName = nameTextField!.text
            if newFolderName?.characters.count == 0 {
                var date = NSDate()
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy/MM/dd HH:mm"
                
                newFolderName = formatter.stringFromDate(date)
            }
            //if newFolderName?.characters.count != 0 {
            Ideabox.createIdeabox(newFolderName) { (success:Bool, error: NSError?) -> Void in
                if(success){
                    print("ideabox successfully created")
                    self.getAllBoxes()
                }
                else{
                    print("unsuccessful")
                }
            }
           // }
        }
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: okClosure)
        alertController.addAction(okAction)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            nameTextField = textField
            nameTextField?.placeholder = "Folder Name"
        }
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        getAllBoxes()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        
        PFUser.logOut()
        
        NSNotificationCenter.defaultCenter().postNotificationName("didLogout", object: nil)

    }
    
    @IBAction func onEditButton(sender: AnyObject) {
        if tableView.editing{
            //listTableView.editing = false;
            tableView.setEditing(false, animated: false);
            editButton.style = UIBarButtonItemStyle.Plain;
            editButton.title = "Edit";
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
    
    func getAllBoxes(){
        let query = PFQuery(className:"Ideabox")
        query.orderByDescending("_created_at")
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock {(media:[PFObject]?, error:NSError?) -> Void in
            if let media = media {
                self.boxes = media
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription)
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

extension MainTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if boxes != nil {
        return boxes.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MainCell", forIndexPath: indexPath) as! MainCell
        let box = boxes[indexPath.row]
        
        cell.titleLabel.text = box["title"] as! String
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("goToBubbleView", sender: self)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            Ideabox.removeIdeabox(boxes[indexPath.row], withCompletion: { (success:Bool, error:NSError?) -> Void in
                if(success == true) {
                    print("delete successful")
                }
                else {
                    print("delete unsuccessful")
                }
            })
            boxes.removeAtIndex(indexPath.row)
            
            tableView.reloadData()
            
        }
    }
    
    func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {
        // update the item in my data source by first removing at the from index, then inserting at the to index.
        let ideabox = boxes[fromIndexPath.row]
        boxes.removeAtIndex(fromIndexPath.row)
        boxes.insert(ideabox, atIndex: toIndexPath.row)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goToBubbleView") {
            let controller = segue.destinationViewController as! BubbleViewController
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            controller.box = boxes[tableView.indexPathForSelectedRow!.row]
        }
    }

}
