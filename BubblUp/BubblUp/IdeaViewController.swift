//
//  IdeaViewController.swift
//  BubblUp
//
//  Created by Adam Epstein on 4/7/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit
import Parse

class IdeaViewController: UIViewController {
    
    var idea: PFObject!
    var ideas: [PFObject]!
    var type: Int!
    
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    @IBAction func onEdit(sender: AnyObject) {
        if captionTextField.userInteractionEnabled{
            captionTextField.userInteractionEnabled = false
            textField.userInteractionEnabled = false
            editButton.style = UIBarButtonItemStyle.Plain;
            editButton.title = "Edit";
            if type == 0{
                idea["text"] = textField.text
            }
            else{
                idea["text"] = captionTextField.text
            }
            idea.saveInBackground()
            
        }
        else{
            editButton.title = "Done";
            editButton.style =  UIBarButtonItemStyle.Done;
            captionTextField.userInteractionEnabled = true
            textField.userInteractionEnabled = true

        }
    }
    
    @IBAction func onGoDown(sender: AnyObject) {
        var index = ideas.indexOf(idea) as Int!
        if index < ideas.endIndex - 1{
            idea = ideas[index+1]
            if captionTextField.userInteractionEnabled{
                captionTextField.userInteractionEnabled = false
                textField.userInteractionEnabled = false
            }

            loadData()
        }
    }
    
    @IBAction func onGoUp(sender: AnyObject) {
        var index = ideas.indexOf(idea) as Int!
        if index > 0{
            idea = ideas[index-1]
            if captionTextField.userInteractionEnabled{
                captionTextField.userInteractionEnabled = false
                textField.userInteractionEnabled = false
            }
            
            loadData()
        }
    }
    
    func loadData(){
        type = idea["type"] as! Int
        
        if type == 0{
            //type is text
            textField.hidden = false
            imageView.hidden = true
            captionTextField.hidden = true
            textField.text = idea["text"] as! String

        }
        else if type == 1{
            //type is image

            textField.hidden = true
            imageView.hidden = false
            captionTextField.hidden = false
            if let image = idea["file"] as! PFFile! {
                image.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil){
                        self.imageView.image = UIImage(data:imageData!)
                    }
                    else{
                        print(error?.localizedDescription)
                    }
                })
            }
            let text = idea["text"] as? String
            if text != nil{
                captionTextField.text = text!
            } else{
                captionTextField.text = "No Caption"
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
