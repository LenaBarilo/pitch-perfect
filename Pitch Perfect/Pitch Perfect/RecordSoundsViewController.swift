//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Yelena Barilo on 3/26/15.
//  Copyright (c) 2015 Yelena Barilo. All rights reserved.

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var Recording: UILabel!
    @IBOutlet weak var Microphone: UIButton!
    @IBOutlet weak var TapToRecord: UILabel!
    @IBOutlet weak var StopRecording: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        TapToRecord.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        TapToRecord.hidden = false
        Recording.hidden = true
        StopRecording.hidden = true
    }

    @IBAction func Microphone(sender: UIButton) {
        //add ability to record audio
        //when pressed, hide the recording label
        TapToRecord.hidden = true
        Recording.hidden = false
        StopRecording.hidden = false
        
        //Inside func recordAudio(sender: UIButton)
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
        func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
            if(flag) {
            //Save the recorded audio
            recordedAudio = RecordedAudio (path: recorder.url, name: recorder.url.lastPathComponent)
                
            //Move the recorded audio to scene 2
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            }
            else {
                println("the recording was not successful")
                Recording.enabled = true
                StopRecording.hidden = true
            }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.recievedAudio = data
        }
    }
    
    @IBAction func StopRecording(sender: UIButton) {
        //when pressed, dispaly the recording label
        Recording.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

