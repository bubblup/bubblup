//
//  NewFolderViewController.swift
//  BubblUp
//
//  Created by Suyeon Kang on 3/22/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit
import Parse


class NewFolderViewController: UIViewController {

    @IBOutlet weak var folderName: UITextField!
    @IBAction func createButtonClicked(sender: AnyObject) {
        var newFolderName = folderName.text
        Ideabox.createIdeabox(newFolderName) { (success:Bool, error: NSError?) -> Void in
            if(success){
                print("ideabox successfully created")
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    self.performSegueWithIdentifier("goToBubbleViewController", sender: self)

                })
            }
            else{
                print("unsuccessful")
            }
        }
        
        
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
