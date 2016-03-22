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
        
 
        
        ideabox.saveInBackgroundWithBlock{ (success: Bool, error: NSError?) -> Void in
            if(success){
                print("Successfully created")
                
            } else {
                print(error?.localizedDescription)
            }
            
            
        }
        
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

