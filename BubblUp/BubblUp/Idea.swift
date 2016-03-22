//
//  Idea.swift
//  BubblUp
//
//  Created by Suyeon Kang on 3/19/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit
import Parse
/*
field: type
field: contents
field: file
embedded_in: ideabox
*/

enum MediaType: Int {
    case text
    case image
    case voice
    case video
}


class Idea: NSObject {
    class func createNewIdea(texts:String?, type: MediaType, file: PFFile?, containedIn box: Ideabox, withCompletion completion: PFBooleanResultBlock? ){
        let idea = PFObject(className: "Idea")
        idea["type"] = type.rawValue
        idea["text"] = texts
        idea["file"] = file
        idea["box"] = box
        
        idea.saveInBackgroundWithBlock{ (success: Bool, error: NSError?) -> Void in
            if(success){
                print("Successfully created")
                
            } else {
                print(error?.localizedDescription)
            }
            
            
        }

    }
}

