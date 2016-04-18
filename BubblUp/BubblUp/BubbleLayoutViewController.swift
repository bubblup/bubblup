//
//  BubbleLayoutViewController.swift
//  BubblUp
//
//  Created by WUSTL STS on 3/31/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit
import Parse

class BubbleLayoutViewController: UIViewController, UIViewControllerTransitioningDelegate {

    
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var addDrawButton: UIButton!
    @IBOutlet weak var addTextButton: UIButton!
    @IBOutlet weak var addAudioButton: UIButton!

    let transition = BubbleTransition()
    var buttonType: UIButton!
    var box: PFObject!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = box["title"] as! String

        addTextButton.layer.cornerRadius = addTextButton.frame.width/2
        addPhotoButton.layer.cornerRadius = addTextButton.frame.width/2
        addDrawButton.layer.cornerRadius = addTextButton.frame.width/2
        addAudioButton.layer.cornerRadius = addAudioButton.frame.width/2

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
        if (segue.identifier == "photoSegue"){
            let viewController = segue.destinationViewController as! BubblePhotoViewController
            viewController.box = box
        }
        if (segue.identifier == "textSegue"){
            let viewController = segue.destinationViewController as! BubbleTextViewController
            viewController.box = box
        }
        if (segue.identifier == "voiceSegue"){
            let viewController = segue.destinationViewController as! BubbleAudioViewController
            viewController.box = box
        }
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch transition.transitionType {
        case .Audio: buttonType = addAudioButton
            break
        case .Draw: buttonType = addDrawButton
            break
        case .Photo: buttonType = addPhotoButton
            break
        case .Text: buttonType = addTextButton
            break
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

    @IBAction func dismissClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func onAudioButton(sender: AnyObject) {
        transition.transitionType = .Audio
        let vc = storyboard?.instantiateViewControllerWithIdentifier("BubbleAudioViewController") as! BubbleAudioViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    @IBAction func onPhotoButton(sender: AnyObject) {
        transition.transitionType = .Photo
        let vc = storyboard?.instantiateViewControllerWithIdentifier("BubblePhotoViewController") as! BubblePhotoViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    @IBAction func onTextButton(sender: AnyObject) {
        transition.transitionType = .Text
        let vc = storyboard?.instantiateViewControllerWithIdentifier("BubbleTextViewController") as! BubbleTextViewController
        self.presentViewController(vc, animated: true, completion: nil)

    }
    @IBAction func onDrawButton(sender: AnyObject) {
        transition.transitionType = .Draw
        let vc = storyboard?.instantiateViewControllerWithIdentifier("BubbleDrawViewController") as! BubbleDrawViewController
        self.presentViewController(vc, animated: true, completion: nil)

    }

}
