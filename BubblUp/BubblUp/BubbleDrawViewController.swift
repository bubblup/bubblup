//
//  BubbleDrawViewController.swift
//  BubblUp
//
//  Created by WUSTL STS on 3/31/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit

class BubbleDrawViewController: UIViewController {

    weak var controller: BubbleViewController?
    weak var delegate:BubbleCollectionViewControllerDelegate?

    @IBOutlet weak var dismissButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        dismissButton.layer.cornerRadius = dismissButton.frame.height / 2
        dismissButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onDismissButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }


}
