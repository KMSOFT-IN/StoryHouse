//
//  TabbarViewController.swift
//  StoryHouse
//
//  Created by iMac on 11/01/23.

import UIKit
import AVKit
import MediaPlayer

//ic_mute
//ic_unMute

class TabbarViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var playPauseImageView: UIImageView!
    @IBOutlet weak var muteImageView: UIImageView!
    @IBOutlet weak var pageLable: UILabel!
    let gifHandler: Gif = Gif()
    
    @IBOutlet weak var sliderView: Slider!
    var synthesizer = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance(string: "")
    var volume = 1
    
    var callback: ((_ volume: Float) -> Void)?
    
    let systemVolume = AVAudioSession.sharedInstance().outputVolume
    
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secoundView: UIView!
    var playQueue = [AVSpeechUtterance]()
    var paragraphDetails: [ParagraphDetails]?
    var storydata: StoryModels?
    
    var currentIndex: Int = 0  // Story Paragraph Index Number for next / Prev Page
    var totalIndex: Int = 0 // Number of Paragraph
    var isPlayAudioON: Bool = false
    var charCount = 0  // seperate paragraph into Words array
    var characterIndexTimer: Timer?
    var lastSelectedIndex = 0
    var isPageChaned: Bool = false
    
    var isHE: Bool = true
    var storyNumber: Int = 0
    var isFirstTimeCall = true
    var isMute: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadJson()
        self.setUpUI()
        self.sliderView.value = self.systemVolume
        
        self.sliderView.sliderValueChangedCallback = {
            MPVolumeView.setVolume(self.sliderView.value)
            print(self.sliderView.value)
            if self.sliderView.value == 0 {
                self.muteImageView.image = UIImage(named: "ic_mute")
            }
            else
            {
                self.muteImageView.image = UIImage(named: "ic_unMute")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.isFirstTimeCall = true
        self.sliderView.isHidden = true
        self.muteImageView.image = UIImage(named: "ic_unMute")
        let gender =  UserDefaultHelper.getGender()
        if gender == GENDER.BOY.rawValue {
            self.isHE = true
        }
        else {
            self.isHE = false
        }
    }
    
    static func getInstance() -> TabbarViewController {
        return Constant.Storyboard.TABBAR.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func loadJson() {
        if let path = Bundle.main.path(forResource: "StoriesJSON", ofType: "json"){
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                let jsonData = try JSONSerialization.data(withJSONObject: jsonResult, options: .prettyPrinted)
                let jsonDecoder = JSONDecoder()
                self.storydata = try jsonDecoder.decode(StoryModels.self, from: jsonData)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func setUpUI() {
        
        self.isFirstTimeCall = true
        self.playPauseImageView.image = UIImage(named: "ic_TAB_play")
        self.paragraphDetails = self.storydata?.story?[self.storyNumber].data
        
        self.totalIndex = self.paragraphDetails?.count ?? 0
        if (totalIndex > 0) {
            if let index  = UserDefaultHelper.getParagraphIndex() {
                self.currentIndex = index
                self.setUpStory(index: self.currentIndex)
            }
            else {
                self.setUpStory(index: 0)
            }
        }
        
        self.imageTitle.textColor = UIColor.black
        self.lastSelectedIndex = 0
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setUpStory(index: Int) {
        if index >= totalIndex {
            self.currentIndex = 0
            UserDefaultHelper.setParagraphIndex(value: 0)
            return }
        UserDefaultHelper.setParagraphIndex(value: index)
        self.pageLable.text = "\(self.currentIndex + 1) / \(totalIndex)"
        self.image.image = UIImage(named : self.paragraphDetails?[index].imageName ?? "")
        self.imageTitle.text = isHE ? self.paragraphDetails?[index].he : self.paragraphDetails?[index].she
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        
      
        
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        let viewController = HomeViewController.getInstance()
        viewController.isFromTabbar = true
        var navigationController = UINavigationController()
        let window = self.view.window
        navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    @IBAction func prevPageButtonTapped(_ sender: Any) {
        self.isPageChaned = true
        self.currentIndex -= 1
        if (self.currentIndex < 0) {
            self.currentIndex = 0
        }
        
        self.setUpStory(index: self.currentIndex)
        self.resetUI()
    }
    
    @IBAction func nextPageButtontapped(_ sender: Any) {
        self.isPageChaned = true
        self.currentIndex += 1
        if self.currentIndex >= self.totalIndex {
            self.currentIndex = 0
        }
        self.setUpStory(index: self.currentIndex)
        self.resetUI()
    }
    
    func autoNextPage() {
        self.currentIndex += 1
        if self.currentIndex >= self.totalIndex {
            UserDefaultHelper.setParagraphIndex(value: 0)
            synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            let viewController = EndViewController.getInstance()
            self.navigationController?.pushViewController(viewController, animated: true)
            return
        }
        self.setUpStory(index: self.currentIndex)
         self.playAudio(text: self.imageTitle.text ?? "")
    }
    
    func resetUI() {
        self.isPlayAudioON = false
        self.playPauseImageView.image = UIImage(named: "ic_TAB_play")
    }
    
    
    @IBAction func playPauseButtonTapped(_ sender: Any) {
        isPlayAudioON = !isPlayAudioON
        if isPlayAudioON {
            self.playPauseImageView.image = UIImage(named: "ic_TAB_pause")
            if isFirstTimeCall {
                self.playAudio(text: self.imageTitle.text ?? "")
            }
            self.continueSpeaking()
        }
        else {
            self.pauseSpeaking()
            self.playPauseImageView.image = UIImage(named: "ic_TAB_play")
        }
    }
    
    func continueSpeaking() {
        if (synthesizer.isPaused) {
            if (synthesizer.continueSpeaking()) {
                print("CONTINUE")
            }
        }
    }
    
    func pauseSpeaking() {
        if (synthesizer.isSpeaking) {
            if (synthesizer.pauseSpeaking(at: .immediate)) {
                print("PAUSE")
            }
        }
    }
    
    @IBAction func muteButtonTapped(_ sender: UIButton) {
        isMute = !isMute
        
        if isMute {
            self.sliderView.isHidden = true
            print("VALUE" , self.sliderView.value)
           // self.muteImageView.image = UIImage(named: "ic_mute")
            self.volume = 0
            callback?(0)
        }
        else {
            self.sliderView.isHidden = false
           // self.muteImageView.image = UIImage(named: "ic_unMute")
            self.volume = 1
            callback?(1)
        }
        
        if self.sliderView.value == 0 {
            //self.muteImageView.image = UIImage(named: "ic_mute")
        }
        
    }
    
    @IBAction func shareButtontapped(_ sender: Any) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIImage(named: "AppIcon")!
        UIGraphicsEndImageContext()
        let textToShare = "Check out Magic House app"
        if let myWebsite = URL(string: "http://itunes.apple.com/app/id1645684020") {
            let objectsToShare = [textToShare, myWebsite, image] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            activityVC.popoverPresentationController?.sourceView = sender as? UIView
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}



extension TabbarViewController : AVSpeechSynthesizerDelegate {
    
    func playAudio(text: String) {
        
        self.isFirstTimeCall = false
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
    //utterance.volume = Float(self.volume)
        self.callback = { (v) in
      //      utterance.volume = v
        }
        self.synthesizer.delegate = self
        self.synthesizer.speak(utterance)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
        let range: NSRange = NSMakeRange(0, characterRange.location)
        mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
        mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.red, range: characterRange)
        self.imageTitle.attributedText = mutableAttributedString
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.imageTitle.attributedText = NSAttributedString(string: utterance.speechString)
        if self.isPageChaned {
            self.isPageChaned = false
            self.isFirstTimeCall = true
        }
        else {
            self.autoNextPage()
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        print("CANCEL")
    }
    
    
    
}

/*
 extension TabbarViewController {
 
 func playAudio1(text: String) {
 //if text == "!" || text == "," { return }
 self.utterance = AVSpeechUtterance(string: text)
 var voice = " "
 if let voiceObj = AVSpeechSynthesisVoice.speechVoices().filter({$0.name == "Samantha" }).first {
 voice = voiceObj.identifier
 }
 self.utterance.voice = AVSpeechSynthesisVoice(identifier: voice)
 //   self.utterance.rate = 0.5
 //   self.utterance.volume = Float(self.volume)
 self.callback = { (v) in
 self.utterance.volume = Float(v)
 print(v)
 }
 self.synthesizer.delegate = self
 self.synthesizer.speak(utterance)
 }
 
 func callCharacter() {
 self.isFirstTimeCall = false
 self.stopTimer()
 self.setCharacter(title: self.imageTitle.text ?? "")
 self.playAudio(text: self.imageTitle.text ?? "")
 }
 
 func setCharacter(title: String) {
 self.isFirstTimeCall = false
 if !isPlayAudioON || isPageChanged { return }
 let words = title.components(separatedBy: " ")
 
 if self.charCount >= words.count {
 self.resetUI()
 self.nextPageButtontapped(self)
 return
 }
 
 let word = words[self.charCount]
 self.lastSelectedIndex += (word.count + 1)
 if word == words.last {
 self.lastSelectedIndex -= 1
 }
 
 let attributedString = NSMutableAttributedString(string:title.trimmingCharacters(in: .whitespacesAndNewlines))
 attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
 value: UIColor.red ,
 range: NSRange(location: 0, length: self.lastSelectedIndex))
 self.imageTitle.attributedText = attributedString
 self.characterIndexTimer = Timer.scheduledTimer(withTimeInterval: 0.35
 , repeats: false) { (timer) in
 self.charCount += 1
 self.setCharacter(title: title)
 }
 }
 
 func stopTimer()  {
 if characterIndexTimer != nil {
 self.characterIndexTimer?.invalidate()
 self.characterIndexTimer = nil
 }
 }
 }
 
 */

extension MPVolumeView {
    
    static func setVolume(_ volume: Float) -> Void {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            slider?.value = volume
        }
    }
}
