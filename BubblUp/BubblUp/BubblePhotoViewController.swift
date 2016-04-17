//
//  BubblePhotoViewController.swift
//  BubblUp
//
//  Created by Adam Epstein on 3/29/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit
import Parse

class BubblePhotoViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var newPhoto: UIImageView!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var captionTextField: UITextField!
    var vc: UIImagePickerController!
    var box: PFObject!
    override func viewDidLoad() {
        super.viewDidLoad()
        newPhoto.hidden = true
        captionTextField.hidden = true
        submitButton.hidden = true

        dismissButton.layer.cornerRadius = dismissButton.frame.height / 2
        dismissButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTakePhoto(sender: AnyObject) {
        vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(vc, animated: true, completion: nil)
    }

    @IBAction func onChoosePhoto(sender: AnyObject)
        {
            vc = UIImagePickerController()
            vc.delegate = self
            vc.allowsEditing = true
            vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            // Get the image captured by the UIImagePickerController
            let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            
            // Do something with the images (based on your use case)
            
            // Dismiss UIImagePickerController to go back to your original view controller
            
            dismissViewControllerAnimated(true, completion: nil)
            newPhoto.image = editedImage
            newPhoto.hidden = false
            captionTextField.hidden = false
            submitButton.hidden = false
    }
    @IBAction func onSubmit(sender: AnyObject) {
        var fileImage = getPFFileFromImage(newPhoto.image)
        Idea.createNewIdea(captionTextField.text!, type: Type.MediaType.image, file: fileImage, containedIn: box) { (success: Bool, error: NSError?) -> Void in
            if success{
                print("Image successfully submitted")
                
                
            } else{
                print(error?.localizedDescription)
            }
            
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
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
                var fileImage = getPFFileFromImage(newPhoto.image)
                Idea.createNewIdea(captionTextField.text!, type: Type.MediaType.image, file: fileImage, containedIn: box) { (success: Bool, error: NSError?) -> Void in
                    if success {
                        print("successful")
                        CATransaction.begin()
                        CATransaction.setCompletionBlock({ () -> Void in
                            self.captionTextField.text = ""
                            self.newPhoto.hidden = true
                            self.captionTextField.hidden = true
                            self.submitButton.hidden = true
                        })
                        let anim = CAKeyframeAnimation( keyPath:"transform" )
                        anim.values = [
                            NSValue( CATransform3D:CATransform3DMakeTranslation(-5, 0, 0 ) ),
                            NSValue( CATransform3D:CATransform3DMakeTranslation( 5, 0, 0 ) )
                        ]
                        anim.autoreverses = true
                        anim.repeatCount = 2
                        anim.duration = 7/100
                        self.captionTextField.layer.addAnimation( anim, forKey:nil )
                        self.newPhoto.layer.addAnimation( anim, forKey:nil )
                        
                        CATransaction.commit()
                    }
                    else{
                        print("unsuccessful")
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }}
        }
    }


}
