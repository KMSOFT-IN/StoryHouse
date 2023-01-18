//
//  TabbarViewController.swift
//  StoryHouse
//
//  Created by iMac on 11/01/23.

import UIKit
import AVKit
//ic_mute
//ic_unMute

class TabbarViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var playPauseImageView: UIImageView!
    @IBOutlet weak var muteImageView: UIImageView!
    @IBOutlet weak var pageLable: UILabel!
    
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secoundView: UIView!
    var synthesizer = AVSpeechSynthesizer()
    var playQueue = [AVSpeechUtterance]()
    var paragraphDetails: [ParagraphDetails]?
    var storydata: StoryModels?
    
    var currentIndex: Int = 0  // Story Paragraph Index Number for next / Prev Page
    var totalIndex: Int = 0 // Number of Paragraph
    var isPlayAudioON: Bool = false
    var isPageChanged: Bool = false
    var charCount = 0  // seperate paragraph into Words array
    var characterIndexTimer: Timer?
    var lastSelectedIndex = 0
    
    var isHE: Bool = true
    var storyNumber: Int = 0
    var isFirstTimeCall = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadJson()
        self.setUpUI()
        self.firstView.applyShadow()
        self.secoundView.applyShadow()
        
    }
    
    static func getInstance() -> TabbarViewController {
        return Constant.Storyboard.TABBAR.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func loadJson(){
        if let path = Bundle.main.path(forResource: "StoriesJSON", ofType: "json"){
            do{
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
        UserDefaultHelper.setParagraphIndex(value: index)
        self.pageLable.text = "\(self.currentIndex + 1) / \(totalIndex)"
        self.image.image = UIImage(named : self.paragraphDetails?[index].imageName ?? "")
        self.imageTitle.text = isHE ? self.paragraphDetails?[index].he : self.paragraphDetails?[index].she
        Utility.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        
        let viewController = SelectStoryViewController.getInstance()
        var navigationController = UINavigationController()
        let window = self.view.window
        navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.stopTimer()
        Utility.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    @IBAction func prevPageButtonTapped(_ sender: Any) {
        self.currentIndex -= 1
        if (self.currentIndex < 0) {
            self.currentIndex = 0
        }
        self.setUpStory(index: self.currentIndex)
        self.resetUI()
    }
    
    @IBAction func nextPageButtontapped(_ sender: Any) {
        self.currentIndex += 1
        if self.currentIndex >= self.totalIndex {
            self.currentIndex = 0
        }
        self.setUpStory(index: self.currentIndex)
        self.resetUI()
    }
    
    func resetUI() {
        self.isFirstTimeCall = true
        self.charCount = 0
        self.lastSelectedIndex = 0
        self.characterIndexTimer = nil
        self.imageTitle.textColor = UIColor.black
        self.isPageChanged = true
        self.isPlayAudioON = false
        
        self.playPauseImageView.image = UIImage(named: "ic_TAB_play")
    }
    
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
        self.isPageChanged = false
        self.isPlayAudioON = !self.isPlayAudioON
        if isPlayAudioON {
            // Start to Play
            self.playPauseImageView.image = UIImage(named: "ic_TAB_pause")
            self.continueSpeaking()
            
            if isFirstTimeCall {
                Utility.playAudio(text: self.imageTitle.text ?? "")
            }
            self.setCharacter(title: self.imageTitle.text ?? "")
            
        }
        else {
            self.pauseSpeaking()
            self.playPauseImageView.image = UIImage(named: "ic_TAB_play")
        }
    }
    
    
    func continueSpeaking() {
        if (Utility.synthesizer.isPaused) {
            if (Utility.synthesizer.continueSpeaking()) {
                print("CONTINUE")
            }
        }
    }
    
    func pauseSpeaking() {
        if (Utility.synthesizer.isSpeaking) {
            if (Utility.synthesizer.pauseSpeaking(at: .immediate)) {
                print("PAUSE")
            }
        }
    }
    
    
    @IBAction func muteButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.muteImageView.image = UIImage(named: "ic_mute")
        }
        else {
            self.muteImageView.image = UIImage(named: "ic_unMute")
        }
        
        
    }
    
    @IBAction func shareButtontapped(_ sender: Any) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        //let image = UIImage(named: "AppIcon")!
        UIGraphicsEndImageContext()
        let textToShare = "Check out Story House app"
        if let myWebsite = URL(string: "http://itunes.apple.com/app/id1645684020") {
            let objectsToShare = [textToShare, myWebsite/*, image*/] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            activityVC.popoverPresentationController?.sourceView = sender as? UIView
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}

extension TabbarViewController {
    
    func callCharacter() {
        self.isFirstTimeCall = false
        self.stopTimer()
        self.setCharacter(title: self.imageTitle.text ?? "")
        Utility.playAudio(text: self.imageTitle.text ?? "")
    }
    
    func setCharacter(title: String) {
        self.isFirstTimeCall = false
        if !isPlayAudioON || isPageChanged { return }
        let words = title.components(separatedBy: " ")
        if self.charCount >= words.count {
         //   self.resetUI()
            return }
        
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
