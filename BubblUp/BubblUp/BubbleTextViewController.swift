//
//  BubbleTextViewController.swift
//  BubblUp
//
//  Created by WUSTL STS on 3/8/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit
import Parse

class BubbleTextViewController: UIViewController {

    @IBOutlet weak var dismissButton: UIButton!
    let transition = BubbleTransition()

    @IBOutlet weak var bubbleField: UITextField!
   
    var box:PFObject!

    override func viewDidLoad() {
        super.viewDidLoad()

        dismissButton.layer.cornerRadius = dismissButton.frame.width / 2
        dismissButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))

    }
    
    @IBAction func onSaveClicked(sender: AnyObject) {
        if(box == nil) {
            print("box does not exist")
        }else{
            Idea.createNewIdea(bubbleField.text, type: Type.MediaType.text, file: nil, containedIn: box) { (success:Bool, error:NSError?) -> Void in
                if success {
                    print("successful")
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                else{
                    print("unsuccessful")
                       self.dismissViewControllerAnimated(true, completion: nil)
                }
            }}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onDismissButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
   

 
}
