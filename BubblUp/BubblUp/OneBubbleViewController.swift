//
//  OneBubbleViewController.swift
//  BubblUp
//
//  Created by Suyeon Kang on 4/19/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit
import Parse

class OneBubbleViewController: UIViewController {
    
    var idea: PFObject!

    @IBOutlet weak var bubbleContainer: UIView!

    @IBOutlet weak var textLabel: UILabel!
    @IBAction func exitBubble(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)

       // self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bubbleContainer.layer.cornerRadius = 30
        textLabel.clipsToBounds = true
        textLabel.layer.cornerRadius = 10
        textLabel.text = idea["text"] as! String
        print(idea["text"])
    }

    
}
