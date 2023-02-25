//
//  RecordingManager.swift
//  StoryHouse
//
//  Created by kmsoft on 25/02/23.
//

import Foundation
import AVFoundation
import UIKit

protocol RecordAudioDelegate {
    func playAudioRecording()
    func startAudioRecording()
    func finishAudioRecording()
    func audioRecordingError()
}

class RecordAudioManager: NSObject,AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    class func shareInstance() -> RecordAudioManager {
        return RecordAudioManager()
    }
    
    func setupView() {
        AppData.sharedInstance.recordingSession = AVAudioSession.sharedInstance()
        do {
            try AppData.sharedInstance.recordingSession.setCategory(.playAndRecord, mode: .default)
            try AppData.sharedInstance.recordingSession.setActive(true)
            AppData.sharedInstance.recordingSession.requestRecordPermission() { allowed in
                DispatchQueue.main.async {
                    if allowed {
//                        self.loadRecordingUI()
                    } else {
                        // failed to record
                    }
                }
            }
        } catch {
            // failed to record
        }
    }
    
//    func loadRecordingUI() {
//        recordButton.isEnabled = true
//        playButton.isEnabled = false
//        recordButton.setTitle("Tap to Record", for: .normal)
//        recordButton.addTarget(self, action: #selector(recordAudioButtonTapped), for: .touchUpInside)
//        view.addSubview(recordButton)
//    }
    
    @objc func recordAudioButtonTapped(_ sender: UIButton) {
        if AppData.sharedInstance.audioRecorder == nil {
            self.startRecording(fileName: "")
        } else {
            finishRecording(success: true)
        }
    }
    
    func startRecording(fileName: String) {
        let audioFilename = getFileURL(fileName: fileName)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            AppData.sharedInstance.audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            AppData.sharedInstance.audioRecorder.delegate = self
            AppData.sharedInstance.audioRecorder.record()
            
//            recordButton.setTitle("Tap to Stop", for: .normal)
//            playButton.isEnabled = false
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        AppData.sharedInstance.audioRecorder.stop()
        AppData.sharedInstance.audioRecorder = nil
    }
    
    @IBAction func playAudioButtonTapped(_ sender: UIButton) {
//        if (sender.titleLabel?.text == "Play"){
////            recordButton.isEnabled = false
//            sender.setTitle("Stop", for: .normal)
//            preparePlayer(fileName: "")
//            audioPlayer.play()
//        } else {
//            audioPlayer.stop()
//            sender.setTitle("Play", for: .normal)
//        }
    }
    
    func preparePlayer(fileName: String) {
        var error: NSError?
        do {
            AppData.sharedInstance.audioPlayer = try AVAudioPlayer(contentsOf: getFileURL(fileName: fileName) as URL)
        } catch let error1 as NSError {
            error = error1
            AppData.sharedInstance.audioPlayer = nil
        }
        
        if let err = error {
            print("AVAudioPlayer error: \(err.localizedDescription)")
        } else {
            AppData.sharedInstance.audioPlayer.delegate = self
            AppData.sharedInstance.audioPlayer.prepareToPlay()
            AppData.sharedInstance.audioPlayer.volume = 10.0
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getFileURL(fileName: String) -> URL {
        let path = getDocumentsDirectory().appendingPathComponent(fileName)
        return path as URL
    }
    
    //MARK: Delegates
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {

    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Error while playing audio \(error!.localizedDescription)")
    }
    
    //MARK: To upload video on server
    
    func uploadAudioToServer() {
        /*Alamofire.upload(
         multipartFormData: { multipartFormData in
         multipartFormData.append(getFileURL(), withName: "audio.m4a")
         },
         to: "https://yourServerLink",
         encodingCompletion: { encodingResult in
         switch encodingResult {
         case .success(let upload, _, _):
         upload.responseJSON { response in
         Print(response)
         }
         case .failure(let encodingError):
         print(encodingError)
         }
         })*/
    }
    
    
}

