//
//  IdeaViewController.swift
//  BubblUp
//
//  Created by Adam Epstein on 4/7/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit
import Parse
import AVFoundation


class IdeaViewController: UIViewController, AVAudioPlayerDelegate {
    
    var idea: PFObject!
    var ideas: [PFObject]!
    var type: Int!
    
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    var player: AVAudioPlayer!
    var soundFileURL:NSURL!
    var soundFileData:NSData!
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
        playButton.hidden = true
        stopButton.hidden = true
        if type == Type.MediaType.text.rawValue{
            //type is text
            textField.hidden = false
            imageView.hidden = true
            captionTextField.hidden = true
            textField.text = idea["text"] as! String

        }
        else if type == Type.MediaType.image.rawValue{
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
        else if type == Type.MediaType.voice.rawValue {
            playButton.hidden = false
            stopButton.hidden = false
            let audioFile:PFFile = idea["file"] as! PFFile
            
          //  soundFileURL = NSURL(fileURLWithPath:file.url!)
            
            
            audioFile.getDataInBackgroundWithBlock{ (audioFile: NSData?, error:NSError?) -> Void in
                if error == nil {
                    self.soundFileData = audioFile
                    print("audio loaded")
                   // player.init(audioFile)
//                    let path = "temp"
//                    if !audioFile!.writeToFile(path, atomically: true){
//                        print("Error saving")
//                    }
                } else {
                    print("audio failed")
                }
            }
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func setSessionPlayback() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch let error as NSError {
            print("could not set session category")
            print(error.localizedDescription)
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    
    func play() {
       // var url = self.soundFileURL
       // print("playing \(url)")
        
        do {
            self.player = try AVAudioPlayer(data: self.soundFileData)
           // self.player = try AVAudioPlayer(contentsOfURL: url!)
            stopButton.enabled = true
            player.delegate = self
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        } catch let error as NSError {
            self.player = nil
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func onPlayButton(sender: AnyObject) {
        
        setSessionPlayback()
        play()
        
    }
    
    @IBAction func onStopButton(sender: AnyObject) {
        
        print("stop")
        
        player?.stop()
        
       
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
            playButton.enabled = true
            stopButton.enabled = false
        } catch let error as NSError {
            print("could not make session inactive")
            print(error.localizedDescription)
        }
        
        //recorder = nil
        
    }
    
    

}
