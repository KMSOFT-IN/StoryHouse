//
//  TabbarViewController.swift
//  StoryHouse
//
//  Created by iMac on 11/01/23.

import UIKit
import AVKit
import MediaPlayer
import AVFoundation

class TabbarViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var playPauseImageView: UIImageView!
    @IBOutlet weak var muteImageView: UIImageView!
    @IBOutlet weak var pageLable: UILabel!
    @IBOutlet weak var sliderView: Slider!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secoundView: UIView!
    
    @IBOutlet weak var muteLabel: UILabel!
    var synthesizer = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance(string: "")
    var callback: ((_ volume: Float) -> Void)?
    let systemVolume = AVAudioSession.sharedInstance().outputVolume
    var playQueue = [AVSpeechUtterance]()
    var paragraphDetails: [ParagraphDetails]?
    var storydata: StoryModels?
    var currentIndex: Int = 0  // Story Paragraph Index Number for next / Prev Page
    var totalIndex: Int = 0 // Number of Paragraph
    var isPlayAudioON: Bool = false
    var charCount = 0  // seperate paragraph into Words array
    var characterIndexTimer: Timer?
    var lastSelectedIndex = 0
    var isFirstTimePlay: Bool = true
    var isPageChanged: Bool = false
    var isHE: Bool = true
    var storyNumber: Int = 0
    var isMute: Bool = true
    let name = UserDefaultHelper.getChildname()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomLoader.instance.gifName = "demo"
        self.setUpGesture()
        self.isFirstTimePlay = true
        self.sliderView.value = self.systemVolume
        
        self.sliderView.sliderValueChangedCallback = {
            self.muteLabel.text = "VOLUME"
            MPVolumeView.setVolume(self.sliderView.value)
            print(self.sliderView.value)
            if self.sliderView.value == 0 {
                self.muteImageView.image = UIImage(named: "ic_mute")
            }
            else if self.sliderView.value == 1 {
                self.muteImageView.image = UIImage(named: "ic_muteH")
            }
            else if self.sliderView.value < 0.5 {
                self.muteImageView.image = UIImage(named: "ic_muteL")
            }
            else if self.sliderView.value > 0.5 {
                self.muteImageView.image = UIImage(named: "ic_muteM")
            }
        }
        
        self.sliderView.hideSliderCallback = {
            self.sliderView.isHidden = true
            self.isMute = true
        }
    }
    
    func setUpGesture() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right:
                print("Swiped right [PREV]")
                //self.prevButtontapped()
                self.prevPageButtonTapped(self)
            case .left:
                print("Swiped left [NEXT]")
                self.nextPageButtontapped(self)
                //self.nextButtontapped()
            default:
                break
            }
        }
    }
    
    @IBAction func prevPageButtonTapped(_ sender: Any) {
        self.playPauseImageView.image = UIImage(named: "ic_TAB_play")
        self.imageTitle.textColor = GRAY_COLOR
        self.synthesizer.stopSpeaking(at: .immediate)
        self.isPageChanged = true
        
        self.currentIndex -= 1
        if (self.currentIndex < 0) {
            self.currentIndex = 0
        }
        self.resetUI()
      //  DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.setUpStory(index: self.currentIndex)
       // }
    }
    
    
    func prevButtontapped() {
       // CustomLoader.instance.showLoaderView()
        self.synthesizer.stopSpeaking(at: .immediate)
        self.isPageChanged = true
        
        self.currentIndex -= 1
        if (self.currentIndex < 0) {
            self.currentIndex = 0
        }
        self.resetUI()
      //  DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.setUpStory(index: self.currentIndex)
          //  CustomLoader.instance.hideLoaderView()
      //  }
        
    }
    
    func nextButtontapped() {
     //   CustomLoader.instance.showLoaderView()
        self.synthesizer.stopSpeaking(at: .immediate)
        self.isPageChanged = true
        
        self.currentIndex += 1
        if self.currentIndex >= self.totalIndex {
            UserDefaultHelper.setParagraphIndex(value: 0)
            self.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            let viewController = EndViewController.getInstance()
            self.navigationController?.pushViewController(viewController, animated: true)
            return
        }
        self.resetUI()
     //   DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.setUpStory(index: self.currentIndex)
         //   CustomLoader.instance.hideLoaderView()
     //   }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.isFirstTimePlay = true
        self.pauseSpeaking()
        self.synthesizer.stopSpeaking(at: .immediate)
        //CustomLoader.instance.hideLoaderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.imageTitle.textColor = GRAY_COLOR
        self.loadJson()
        self.setUpUI()
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
        
        self.imageTitle.textColor = GRAY_COLOR
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
        self.imageTitle.textColor = GRAY_COLOR
        
        
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        self.pauseSpeaking()
        self.synthesizer.stopSpeaking(at: .immediate)
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
    
   
    
    @IBAction func nextPageButtontapped(_ sender: Any) {
        self.playPauseImageView.image = UIImage(named: "ic_TAB_play")
        self.imageTitle.textColor = GRAY_COLOR
        self.synthesizer.stopSpeaking(at: .immediate)
        self.isPageChanged = true
        
        self.currentIndex += 1
        if self.currentIndex >= self.totalIndex {
            UserDefaultHelper.setParagraphIndex(value: 0)
            self.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            let viewController = EndViewController.getInstance()
            self.navigationController?.pushViewController(viewController, animated: true)
            return
        }
        DispatchQueue.main.async {
            self.resetUI()
            self.setUpStory(index: self.currentIndex)
        }
        
     //   DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
      //  }
    }
    
    
    func resetUI() {
        self.isFirstTimePlay = true
        self.isPlayAudioON = false
        self.playPauseImageView.image = UIImage(named: "ic_TAB_play")
    }
    
    func autoNextPage() {
        self.currentIndex += 1
        if self.currentIndex >= self.totalIndex {
            UserDefaultHelper.setParagraphIndex(value: 0)
            synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            let viewController = EndViewController.getInstance()
            let index = 0
            viewController.image = self.paragraphDetails?[index].imageName ?? " "
            viewController.imageTitle = (isHE ? self.paragraphDetails?[index].he : self.paragraphDetails?[index].she) ?? self.paragraphDetails?[index] as! String
            self.navigationController?.pushViewController(viewController, animated: true)
            return
        }
      //  DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.setUpStory(index: self.currentIndex)
       // }
        self.isFirstTimePlay = true
        self.isPlayAudioON = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.playPauseButtonTapped(self)
        }
        
    }
    
       @IBAction func playPauseButtonTapped(_ sender: Any) {
           self.isPageChanged = false
        isPlayAudioON = !isPlayAudioON
        if isPlayAudioON {
            self.playPauseImageView.image = UIImage(named: "ic_TAB_pause")
            if self.isFirstTimePlay {
                self.isFirstTimePlay = false
                
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
        self.sliderView.isHidden = !self.sliderView.isHidden
    }
    
    @IBAction func shareButtontapped(_ sender: Any) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        //let image = UIImage(named: "AppIcon")!
        let image = self.image.image
        UIGraphicsEndImageContext()
        var childName = (UserDefaultHelper.getChildname() ?? "") + "'s ’s Magic House Story"
        
      //  let attributes = [[NSAttributedString.Key.foregroundColor:UIColor.red], [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]]
       //   childName = "This is a text".highlightWordsIn(highlightedWords: "is a text", attributes: attributes)
        
        let textToShare = (self.imageTitle.text ?? "")
        //if let myWebsite = URL(string: "http://itunes.apple.com/app/id1645684020") {
        let objectsToShare = [childName ,textToShare, image] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        activityVC.popoverPresentationController?.sourceView = sender as? UIView
        self.present(activityVC, animated: true, completion: nil)
        //}
      
    }
    
    func fileToShare() {
        let urlArray = ["A", "B"]
        let activityController = UIActivityViewController(activityItems: urlArray, applicationActivities: nil)
        activityController.completionWithItemsHandler = { (nil , completed , _, error) in
            if (completed) {
                print("Completed")
            }
            else {
                print("Canceled !!!")
            }
            
        }
        self.present(activityController, animated: true) {
            print(" Present Sucess !!")
        }
                     
        
    }
    

}



extension TabbarViewController : AVSpeechSynthesizerDelegate {
    
    func playAudio(text: String) {
        let utterance = AVSpeechUtterance(string: text)
         var voice = ""
         if let voiceObj = AVSpeechSynthesisVoice.speechVoices().filter({$0.name == "Catherine" }).first {
         voice = voiceObj.identifier
         }
        
        // utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.voice = AVSpeechSynthesisVoice(identifier: voice)
        utterance.rate = 0.4
       // utterance.pitchMultiplier = 0.25
        utterance.postUtteranceDelay = 0.01
        utterance.volume = self.sliderView.value
        
        self.synthesizer.delegate = self
        self.synthesizer.speak(utterance)
    }
    
    /*  class func playAudio1(text: String) {
     // Utility.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
     if text == "!" || text == "," { return }
     Utility.utterance = AVSpeechUtterance(string: text)
     var voice = " "
     if let voiceObj = AVSpeechSynthesisVoice.speechVoices().filter({$0.name == "Samantha" }).first {
     voice = voiceObj.identifier
     }
     Utility.utterance.voice = AVSpeechSynthesisVoice(identifier: voice)
     Utility.utterance.rate = 0.5
     Utility.utterance.volume = Float(Utility.volume)
     
     Utility.synthesizer.speak(utterance)
     }
     */
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
        let range: NSRange = NSMakeRange(0, characterRange.location)
        mutableAttributedString.addAttribute(.foregroundColor, value: LIGHT_BLUE, range: range)
        mutableAttributedString.addAttribute(.foregroundColor, value: LIGHT_BLUE, range: characterRange)
        self.imageTitle.attributedText = mutableAttributedString
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        //self.imageTitle.attributedText = NSAttributedString(string: utterance.speechString)
        
        if let rootViewController = UIApplication.topViewController() {
            if rootViewController != self {
                return
            }
        }
        
        if (synthesizer.isSpeaking) {
            self.autoNextPage()
        }
        
       if self.isPageChanged {
            self.isPageChanged = false
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


