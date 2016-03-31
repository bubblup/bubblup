//
//  BubbleLayoutViewController.swift
//  BubblUp
//
//  Created by WUSTL STS on 3/31/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit

class BubbleLayoutViewController: UIViewController, UIViewControllerTransitioningDelegate {

    
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var addDrawButton: UIButton!
    @IBOutlet weak var addTextButton: UIButton!

    let transition = BubbleTransition()
    var buttonType: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        addTextButton.layer.cornerRadius = addTextButton.frame.width/2
        addPhotoButton.layer.cornerRadius = addTextButton.frame.width/2
        addDrawButton.layer.cornerRadius = addTextButton.frame.width/2

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .Custom
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch transition.transitionType {
        case .Draw: buttonType = addDrawButton
        case .Photo: buttonType = addPhotoButton
        case .Text: buttonType = addTextButton
        }

        transition.transitionMode = .Present
        transition.startingPoint = buttonType.center
        transition.bubbleColor = buttonType.backgroundColor!
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        transition.startingPoint = buttonType.center
        transition.bubbleColor = buttonType.backgroundColor!
        return transition
    }
    
    @IBAction func onPhotoButton(sender: AnyObject) {
        transition.transitionType = .Photo
    }
    @IBAction func onTextButton(sender: AnyObject) {
        transition.transitionType = .Text
    }
    @IBAction func onDrawButton(sender: AnyObject) {
        transition.transitionType = .Draw
    }

}
