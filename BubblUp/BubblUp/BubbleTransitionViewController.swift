//
//  BubbleTransitionViewController.swift
//  BubblUp
//
//  Created by WUSTL STS on 3/24/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit

class BubbleTransitionViewController: UIViewController {


    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        closeButton.layer.cornerRadius = closeButton.frame.width / 2
        closeButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onCloseButton(sender: AnyObject) {
        
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
