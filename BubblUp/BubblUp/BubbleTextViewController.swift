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
   
    var box:PFObject?

    override func viewDidLoad() {
        super.viewDidLoad()

        dismissButton.layer.cornerRadius = dismissButton.frame.width / 2
        dismissButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onDismissButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onSaveButton(sender: AnyObject) {
        var newBubble = bubbleField.text
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
