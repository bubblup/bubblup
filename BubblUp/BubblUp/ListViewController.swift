//
//  ListViewController.swift
//  BubblUp
//
//  Created by Suyeon Kang on 3/23/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit
import Parse

class ListViewController: UIViewController {
    
     @IBOutlet weak var tableView: UITableView!
    var box:PFObject!
    var ideas:[PFObject]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight=UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100

        getAllIdeas(box)
    }
    
    func getAllIdeas(box: PFObject!){
    let query = PFQuery(className:"Idea")
    query.orderByDescending("_created_at")
    query.whereKey("box", equalTo: box)
    query.findObjectsInBackgroundWithBlock {(media:[PFObject]?, error:NSError?) -> Void in
    if let media = media {
        self.ideas = media
        self.tableView.reloadData()
    } else {
    print(error?.localizedDescription)
    }
    }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
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
    
    
}




