//
//  BubbleViewController.swift
//  BubblUp
//
//  Created by WUSTL STS on 3/8/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit
import Parse
class BubbleViewController: UIViewController {
    var box:PFObject!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSaveClicked(sender: AnyObject) {
        if(box == nil) {
            print("box does not exist")
        }else{
        Idea.createNewIdea(bubbleField.text, type: Type.MediaType.text, file: nil, containedIn: box) { (success:Bool, error:NSError?) -> Void in
            if success {
                print("successful")
            }
            else{
                print("unsuccessful")
            }
            }}
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toListView") {
            let viewController = segue.destinationViewController as! ListViewController
            viewController.box = box
            // pass data to next view
        }
    }

    @IBOutlet weak var bubbleField: UITextField!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
