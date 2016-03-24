//
//  ComposeViewController.swift
//  BubblUp
//
//  Created by WUSTL STS on 3/8/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit
import Parse

class ComposeViewController: UIViewController {

    @IBOutlet weak var bubbleField: UITextField!
   
    var box:PFObject?
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        var navController = self.presentingViewController as! UINavigationController
//        var controller = navController.presentingViewController as! BubbleViewController
//        box = controller.box
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDismissButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onSaveButton(sender: AnyObject) {
        var newBubble = bubbleField.text
        
        self.dismissViewControllerAnimated(true, completion: nil)
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
