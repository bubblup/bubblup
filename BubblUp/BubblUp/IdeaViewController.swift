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
    
    
    @IBOutlet weak var captionTextField: UITextView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var leftButton: UIBarButtonItem!
    @IBOutlet weak var rightButton: UIBarButtonItem!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    var player: AVAudioPlayer!
    var soundFileURL:NSURL!
    var soundFileData:NSData!
    override func viewDidLoad() {
        super.viewDidLoad()
        captionTextField.userInteractionEnabled = false
        textField.userInteractionEnabled = false
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.toolbarHidden = false
        self.navigationController?.toolbar.setBackgroundImage(UIImage(),
            forToolbarPosition: UIBarPosition.Any,
            barMetrics: UIBarMetrics.Default)
        self.navigationController?.toolbar.setShadowImage(UIImage(),
            forToolbarPosition: UIBarPosition.Any)
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        

        loadData()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
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
            editButton.style = UIBarButtonItemStyle.Plain;
            editButton.title = "Edit";
            playButton.hidden = true
            stopButton.hidden = true
            pauseButton.hidden = true
            imageView.hidden = true
            textField.hidden = true
            captionTextField.hidden = true
            captionTextField.text = ""
            textField.text = ""

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
            editButton.style = UIBarButtonItemStyle.Plain;
            editButton.title = "Edit";
            playButton.hidden = true
            stopButton.hidden = true
            pauseButton.hidden = true
            imageView.hidden = true
            textField.hidden = true
            captionTextField.hidden = true
            captionTextField.text = ""
            textField.text = ""
            
            loadData()
        }
    }
    
    func loadData(){
        type = idea["type"] as! Int
        playButton.hidden = true
        stopButton.hidden = true
        pauseButton.hidden = true
        var index = ideas.indexOf(idea) as Int!
        if(index == 0){
            leftButton.enabled = false
        }
        else if (index == ideas.endIndex-1){
            rightButton.enabled = false
        }
        else{
            leftButton.enabled = true
            rightButton.enabled = true
        }
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
            pauseButton.hidden = false
            captionTextField.hidden = false
            textField.hidden = true
            let text = idea["text"] as? String
            if text != nil{
                captionTextField.text = text!
            } else{
                captionTextField.text = "No Caption"
            }
            let audioFile:PFFile = idea["file"] as! PFFile
            
          //  soundFileURL = NSURL(fileURLWithPath:file.url!)
            
            
            audioFile.getDataInBackgroundWithBlock{ (audioFile: NSData?, error:NSError?) -> Void in
                if error == nil {
                    self.soundFileData = audioFile
                    print("audio loaded")
                    self.setSessionPlayback()
                    do{
                        self.player = try AVAudioPlayer(data: self.soundFileData)
                        self.player.delegate = self
                        self.player.prepareToPlay()
                    }
                   // player.init(audioFile)
//                    let path = "temp"
//                    if !audioFile!.writeToFile(path, atomically: true){
//                        print("Error saving")
//                    }
                    catch let error as NSError {
                        self.player = nil
                        print(error.localizedDescription)
                    }
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
            
           // self.player = try AVAudioPlayer(contentsOfURL: url!)
            stopButton.enabled = true
            pauseButton.enabled = true
            
            player.volume = 1.0
            player.play()
        }
        catch let error as NSError {
            print("could not make session play")
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func onPlayButton(sender: AnyObject) {
        
        
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
            pauseButton.enabled = false
        } catch let error as NSError {
            print("could not make session inactive")
            print(error.localizedDescription)
        }
        
        setSessionPlayback()
        
        //recorder = nil
        
    }
    
    @IBAction func onPauseButton(sender: AnyObject) {
        print("pause")
        player?.pause()
        
        
        
        //let session = AVAudioSession.sharedInstance()
        playButton.enabled = true
        pauseButton.enabled = false

    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            onGoDown(self)
        }
        
        if (sender.direction == .Right) {
            onGoUp(self)
        }
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.toolbarHidden = true
    }
    
    

}
