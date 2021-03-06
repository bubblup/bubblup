//
//  OneBubbleViewController.swift
//  BubblUp
//
//  Created by Suyeon Kang on 4/19/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit
import Parse
import AVFoundation


class OneBubbleViewController: UIViewController, UIScrollViewDelegate, AVAudioPlayerDelegate {
    weak var controller:BubbleCollectionViewController?
    var idea: PFObject!
    var type: Int!
    var pageIndex:Int!
    
    weak var delegate:BubbleCollectionViewControllerDelegate?


    var player: AVAudioPlayer!
    var soundFileURL:NSURL!
    var soundFileData:NSData!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextView!

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!

    @IBOutlet weak var bubbleContainer: UIView!

    @IBOutlet weak var textLabel: UITextView!
 
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var check_button: UIButton!
    @IBAction func exitBubble(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)

       // self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func onEdit(sender: AnyObject) {
        check_button.hidden = false
        editButton.hidden = true
        
      
            captionTextField.userInteractionEnabled = true
            textLabel.userInteractionEnabled = true
        captionTextField.becomeFirstResponder()
        textLabel.becomeFirstResponder()
            
        controller?.getAllIdeas(controller?.box)
    
    }
    @IBAction func onCheck(sender: AnyObject) {
        check_button.hidden = true
        editButton.hidden = false
        captionTextField.userInteractionEnabled = false
        textLabel.userInteractionEnabled = false
        
        if type == 0{
            idea["text"] = textLabel.text
        }
        else{
            idea["text"] = captionTextField.text
        }
        idea.saveInBackground()
        print(self.controller)
        delegate?.didFinishTask(self)
        //self.controller?.getAllIdeas(controller?.box)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        captionTextField.userInteractionEnabled = false
        textLabel.userInteractionEnabled = false
        bubbleContainer.layer.cornerRadius = 30
        textLabel.clipsToBounds = true
        textLabel.layer.cornerRadius = 10
        textLabel.text = idea["text"] as! String
        captionTextField.layer.borderWidth = 5.0;
        captionTextField.layer.borderColor = self.view.tintColor.CGColor
        textLabel.layer.borderWidth = 5.0;
        textLabel.layer.borderColor = self.view.tintColor.CGColor
        loadData()


    }
    
    override func viewDidAppear(animated: Bool) {

        super.viewDidAppear(animated)
        print(idea["type"] as! Int)
        editButton.hidden = false
        check_button.hidden = true
        captionTextField.userInteractionEnabled = false
        textLabel.userInteractionEnabled = false
        // loadData()
      //  print("view did appear")
    }


}
extension OneBubbleViewController {
    func loadData(){
        type = idea["type"] as! Int
        playButton.hidden = true
        stopButton.hidden = true
        pauseButton.hidden = true
        stopButton.enabled = false
        pauseButton.enabled = false
        if type == Type.MediaType.text.rawValue{
            //type is text
            textLabel.hidden = false
            imageView.hidden = true
            captionTextField.hidden = true
            textLabel.text = idea["text"] as! String
            
        }
        else if type == Type.MediaType.image.rawValue{
            //type is image
            
            textLabel.hidden = true
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
            textLabel.hidden = true
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
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
        }
        
    }
    
    @IBAction func onPlayButton(sender: AnyObject) {
        
        setSessionPlayback()
        playButton.enabled = false
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
        
        //recorder = nil
        
    }
    
    @IBAction func onPauseButton(sender: AnyObject) {
        print("pause")
        player?.pause()
        
        
        
        //let session = AVAudioSession.sharedInstance()
        playButton.enabled = true
        pauseButton.enabled = false
        
    }
   
}