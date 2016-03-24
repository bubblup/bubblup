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

    @IBOutlet weak var tableView: UITableView!
    var boxes:[PFObject]!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self

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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goToBubbleView") {
            let controller = segue.destinationViewController as! BubbleViewController
            controller.box = boxes[tableView.indexPathForSelectedRow!.row]
        }
    }

}
