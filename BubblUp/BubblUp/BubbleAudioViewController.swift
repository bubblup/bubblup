//
//  BubbleAudioViewController.swift
//  BubblUp
//
//  Created by WUSTL STS on 3/31/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit
import AVFoundation
import Parse

class BubbleAudioViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    @IBOutlet weak var dismissButton: UIButton!

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    var player: AVAudioPlayer!
    var recorder: AVAudioRecorder!
    var box: PFObject!
    weak var controller: BubbleViewController?
    weak var delegate:BubbleCollectionViewControllerDelegate?

    @IBOutlet var statusLabel: UILabel!
    var meterTimer:NSTimer!
    var soundFileURL:NSURL!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        dismissButton.layer.cornerRadius = dismissButton.frame.height / 2
        dismissButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
        
        
        playButton.enabled = false
        stopButton.enabled = false
        saveButton.enabled = false
        statusLabel.text = ""
        
        setupRecorder()
        
    }
    
    func setupRecorder() {
        
        let format = NSDateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        let currentFileName = "recording-\(format.stringFromDate(NSDate())).m4a"
        print(currentFileName)

        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        self.soundFileURL = documentsDirectory.URLByAppendingPathComponent(currentFileName)
        
        if NSFileManager.defaultManager().fileExistsAtPath(soundFileURL.absoluteString) {
            // probably won't happen. want to do something about it?
            print("soundfile \(soundFileURL.absoluteString) exists")
        }
        
        let recordSettings:[String : AnyObject] = [
            AVFormatIDKey: NSNumber(unsignedInt:kAudioFormatAppleLossless),
            AVEncoderAudioQualityKey : AVAudioQuality.High.rawValue,
            AVEncoderBitRateKey : 320000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey : 44100.0
        ]
        do {
            recorder = try AVAudioRecorder(URL: soundFileURL, settings: recordSettings)
            recorder.delegate = self
            recorder.meteringEnabled = true
            recorder.prepareToRecord() // creates/overwrites the file at soundFileURL
        } catch let error as NSError {
            recorder = nil
            print(error.localizedDescription)
        }


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setSessionPlayAndRecord() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
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

    func updateAudioMeter(timer:NSTimer) {
        
        if recorder.recording {
            let min = Int(recorder.currentTime / 60)
            let sec = Int(recorder.currentTime % 60)
            let s = String(format: "%02d:%02d", min, sec)
            statusLabel.text = s
            recorder.updateMeters()
            // if you want to draw some graphics...
            //var apc0 = recorder.averagePowerForChannel(0)
            //var peak0 = recorder.peakPowerForChannel(0)
        }
    }

    
    func recordWithPermission(setup:Bool) {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        // ios 8 and later
        if (session.respondsToSelector("requestRecordPermission:")) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    print("Permission to record granted")
                    self.setSessionPlayAndRecord()
                    if setup {
                        self.setupRecorder()
                    }
                    self.recorder.record()
                    self.meterTimer = NSTimer.scheduledTimerWithTimeInterval(0.1,
                        target:self,
                        selector:"updateAudioMeter:",
                        userInfo:nil,
                        repeats:true)
                } else {
                    print("Permission to record not granted")
                }
            })
        } else {
            print("requestRecordPermission unrecognized")
        }
    }

    
    @IBAction func onRecordButton(sender: AnyObject) {
        
        if player != nil && player.playing {
            player.stop()
        }
        
        if recorder == nil {
            print("recording. recorder nil")
            recordButton.setTitle("Pause", forState:.Normal)
            playButton.enabled = false
            saveButton.enabled = false
            stopButton.enabled = true
            recordWithPermission(true)
            return
        }
        
        if recorder != nil && recorder.recording {
            print("pausing")
            recorder.pause()
            recordButton.setTitle("Resume", forState:.Normal)
            
        } else {
            print("recording")
            recordButton.setTitle("Pause", forState:.Normal)
            playButton.enabled = false
            saveButton.enabled = false
            stopButton.enabled = true
            //            recorder.record()
            recordWithPermission(false)
        }
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
        var url:NSURL?
        if self.recorder != nil {
            url = self.recorder.url
        } else {
            url = self.soundFileURL!
        }
        print("playing \(url)")
        
        do {
            self.player = try AVAudioPlayer(contentsOfURL: url!)
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
    @IBAction func onSaveButton(sender: AnyObject) {
        let path = self.soundFileURL!
        var dataToUpload: NSData = NSData(contentsOfURL: path)!
        let soundFile = PFFile(name: textField.text, data: dataToUpload)
        Idea.createNewIdea(textField.text, type: Type.MediaType.voice, file: soundFile, containedIn: box) { (success:Bool, error: NSError?) -> Void in
            if success {
                print("voice successfully saved")
                self.delegate?.didFinishTask(self)

                self.dismissViewControllerAnimated(true, completion: nil)
                self.deleteAllRecordings()
                self.dismissViewControllerAnimated(true, completion: nil)
            }else {
                print(error?.localizedDescription)
            }
        }
        
    }

    @IBAction func onStopButton(sender: AnyObject) {
        
        print("stop")
        
        recorder?.stop()
        player?.stop()
        
        meterTimer.invalidate()
        
        recordButton.setTitle("Record", forState:.Normal)
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
            playButton.enabled = true
            stopButton.enabled = false
            recordButton.enabled = true
            saveButton.enabled = true
        } catch let error as NSError {
            print("could not make session inactive")
            print(error.localizedDescription)
        }
        
        //recorder = nil

    }
    
    func deleteAllRecordings() {
        let docsDir =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        let fileManager = NSFileManager.defaultManager()
        
        do {
            let files = try fileManager.contentsOfDirectoryAtPath(docsDir)
            var recordings = files.filter( { (name: String) -> Bool in
                return name.hasSuffix("m4a")
            })
            for var i = 0; i < recordings.count; i++ {
                let path = docsDir + "/" + recordings[i]
                
                print("removing \(path)")
                do {
                    try fileManager.removeItemAtPath(path)
                } catch let error as NSError {
                    NSLog("could not remove \(path)")
                    print(error.localizedDescription)
                }
            }
            
        } catch let error as NSError {
            print("could not get contents of directory at \(docsDir)")
            print(error.localizedDescription)
        }
        
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
                let path = self.soundFileURL!
                var dataToUpload: NSData = NSData(contentsOfURL: path)!
                let soundFile = PFFile(name: textField.text, data: dataToUpload)
                Idea.createNewIdea(textField.text, type: Type.MediaType.voice, file: soundFile, containedIn: box) { (success:Bool, error: NSError?) -> Void in
                    if success {
                        print("successful")
                        CATransaction.begin()
                        CATransaction.setCompletionBlock({ () -> Void in
                            self.textField.text = ""
                            self.playButton.enabled = false
                            self.stopButton.enabled = false
                            self.saveButton.enabled = false
                            self.statusLabel.text = ""
                            self.setupRecorder()
                        })
                        let anim = CAKeyframeAnimation( keyPath:"transform" )
                        anim.values = [
                            NSValue( CATransform3D:CATransform3DMakeTranslation(-5, 0, 0 ) ),
                            NSValue( CATransform3D:CATransform3DMakeTranslation( 5, 0, 0 ) )
                        ]
                        anim.autoreverses = true
                        anim.repeatCount = 2
                        anim.duration = 7/100
                        self.textField.layer.addAnimation( anim, forKey:nil )
                        self.playButton.layer.addAnimation( anim, forKey:nil )
                        self.stopButton.layer.addAnimation( anim, forKey:nil )
                        self.saveButton.layer.addAnimation( anim, forKey:nil )
                        self.statusLabel.layer.addAnimation( anim, forKey:nil )
                        
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
