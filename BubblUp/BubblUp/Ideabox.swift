//
//  Ideabox.swift
//  BubblUp
//
//  Created by Suyeon Kang on 3/19/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit
import Parse

class Ideabox: NSObject {

    class func createIdeabox(title: String?, withCompletion completion: PFBooleanResultBlock?){
        let ideabox = PFObject(className: "Ideabox")
        ideabox["user"] = PFUser.currentUser()
        ideabox["title"] = title
        
 
        
        ideabox.saveInBackgroundWithBlock(completion)
        
    }
    
    class func removeIdeabox(ideabox: PFObject!, withCompletion completion: PFBooleanResultBlock?) {
        ideabox.deleteInBackgroundWithBlock(completion)
    }
    /*
    class func getAllBoxes(){
        let query = PFQuery(className:"Ideabox")
        query.orderByDescending("_created_at")
        query.wherekey("user", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock {(media:[PFObject]?, error:NSError?) -> Void in
            if let media = media {
                
            } else {
                print(error?.localizedDescription)
            }
    }
    */

}

