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
class Type {
enum MediaType: Int {
    case text
    case image
    case voice
    case video
}
   class func mediaToString(type:MediaType) -> String {
        var mediaString:String;
        switch (type) {
        case MediaType.text:
            mediaString = "text"
            break
        case MediaType.image:
            mediaString = "image"
            break
        case MediaType.voice:
            mediaString = "voice"
            break
        case MediaType.video:
            mediaString = "video"
            break
        default:
            mediaString = "invalid"
            break
        }
        return mediaString
    }
}



class Idea: NSObject {
    class func createNewIdea(texts:String?, type: Type.MediaType, file: PFFile?, containedIn box: PFObject, withCompletion completion: PFBooleanResultBlock? ){
        let idea = PFObject(className: "Idea")
        idea["type"] = type.rawValue
        idea["text"] = texts
        if file != nil {
        idea["file"] = file
        }
        idea["box"] = box
        idea["index"] = 0
        
        idea.saveInBackgroundWithBlock(completion)

    }
    
    class func changeIndex(idea:PFObject!, newIndex:Int!, withCompletion completion: PFBooleanResultBlock? ){
        idea["index"] = newIndex
        idea.saveInBackgroundWithBlock(completion)
    }
    
    class func deleteIdea(idea:PFObject!, withCompletion completion: PFBooleanResultBlock? ){
        idea.deleteInBackgroundWithBlock(completion)
    }
    

}

