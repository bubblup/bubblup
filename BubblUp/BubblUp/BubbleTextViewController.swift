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
    weak var controller: BubbleViewController?

    @IBOutlet weak var bubbleField: UITextView!

    weak var delegate:BubbleCollectionViewControllerDelegate?

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
                    self.delegate?.didFinishTask(self)
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
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            print("was shaken")
            if(box == nil) {
                print("box does not exist")
            }else{
                Idea.createNewIdea(bubbleField.text, type: Type.MediaType.text, file: nil, containedIn: box) { (success:Bool, error:NSError?) -> Void in
                    if success {
                        print("successful")
                        self.delegate?.didFinishTask(self)

                        let anim = CAKeyframeAnimation( keyPath:"transform" )
                        anim.values = [
                            NSValue( CATransform3D:CATransform3DMakeTranslation(-5, 0, 0 ) ),
                            NSValue( CATransform3D:CATransform3DMakeTranslation( 5, 0, 0 ) )
                        ]
                        anim.autoreverses = true
                        anim.repeatCount = 2
                        anim.duration = 7/100
                        self.bubbleField.layer.addAnimation( anim, forKey:nil )
                        self.bubbleField.text = ""
                    }
                    else{
                        print("unsuccessful")
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }}
        }
    }
    
   

 
}
