//
//  TabbarViewController.swift
//  StoryHouse
//
//  Created by iMac on 11/01/23.
//

import UIKit
import AVKit

class TabbarViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var playPauseImageView: UIImageView!
    @IBOutlet weak var pageLable: UILabel!
    
    var synthesizer = AVSpeechSynthesizer()
    var playQueue = [AVSpeechUtterance]()
    var stories:Story?
    var story:Story1?
    var paragraphDetails: [ParagraphDetails]?
    
    var storydata: StoryModels?
    var currentIndex: Int = 0  // Story Paragraph Index Number for next / Prev Page
    var totalIndex: Int = 0 // Number of Paragraph
    var isPlayAudioON: Bool = false
    var isPageChanged: Bool = false
    var charCount = 0  // seperate paragraph into Words array
    var characterIndexTimer: Timer?
    var lastSelectedIndex = 0
    var isFinishedAudio: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadJason()
        self.setUpUI()
        
    }
    
    static func getInstance() -> TabbarViewController {
        return Constant.Storyboard.TABBAR.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func loadJason(){
        
        if let path = Bundle.main.path(forResource: "StoriesJSON", ofType: "json"){
            do{
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                let jsonData = try JSONSerialization.data(withJSONObject: jsonResult, options: .prettyPrinted)
                let jsonDecoder = JSONDecoder()
                self.storydata = try jsonDecoder.decode(StoryModels.self, from: jsonData)
            } catch {
                print(error.localizedDescription)
                print("Json Data Loading Error")
            }
        }
    }
    
    func setUpUI() {
        
        self.playPauseImageView.image = UIImage(named: "ic_TAB_play")
        
//        self.story = self.storydata?.story?.first?.data
        self.stories = Story.story
        
        self.totalIndex = self.stories?.storyDetail?.count ?? 0
        if (totalIndex > 0) {
            self.setUpStory(index: 0)
        }
        self.imageTitle.textColor = UIColor.black
        self.lastSelectedIndex = 0
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    func setUpStory(index: Int) {
        self.pageLable.text = "\(currentIndex + 1) / \(totalIndex)"
        self.image.image = UIImage(named : self.stories?.storyImage?[index] ?? "")
        self.imageTitle.text = self.stories?.storyDetail?[index] ?? ""
        Utility.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.stopTimer()
        //Utility.stopSound()
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
        self.charCount = 0
        self.lastSelectedIndex = 0
        self.characterIndexTimer = nil
        self.imageTitle.textColor = UIColor.black
        self.isPageChanged = true
        self.isPlayAudioON = false
        self.isFinishedAudio = false
        self.playPauseImageView.image = UIImage(named: "ic_TAB_play")
    }
    
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
        
        self.isPageChanged = false
        isPlayAudioON = !isPlayAudioON
        if isPlayAudioON {
            // Play
            self.playPauseImageView.image = UIImage(named: "ic_TAB_pause")
            if (Utility.synthesizer.isPaused == true) {
                if (Utility.synthesizer.continueSpeaking()) {
                    print("CONTINUE")
                }
            }
                self.callCharacter(title: self.stories?.storyDetail?[self.currentIndex] ?? "")
        }
        else {
            // Pause
            self.playPauseImageView.image = UIImage(named: "ic_TAB_play")
            if (Utility.synthesizer.isSpeaking == true) {
                if (Utility.synthesizer.pauseSpeaking(at: .immediate)) {
                    print("PAUSE")
                }
            }
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
    
    func callCharacter(title: String) {
        self.imageTitle.text = title
        self.stopTimer()
        self.setCharacter(title: title)
    }
    
    func setCharacter(title: String) {
        if !isPlayAudioON || isPageChanged { return }
        
        if self.isFinishedAudio {
         //   Utility.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            self.resetUI()
            return
        }
        
        
        let words = title.components(separatedBy: " ")
        
        if self.charCount >= words.count { return }
     
        if !Utility.synthesizer.continueSpeaking() {
            Utility.playAudio(text: title)
        }
        
        let word = words[self.charCount]
        self.lastSelectedIndex += (word.count + 1)
        
        if word == words.last {
            self.isFinishedAudio = true
            Utility.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            self.lastSelectedIndex -= 1
        }
        
        let attributedString = NSMutableAttributedString(string:title.trimmingCharacters(in: .whitespacesAndNewlines))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                      value: UIColor.red ,
                                      range: NSRange(location: 0, length: self.lastSelectedIndex))
        
        
        
        self.imageTitle.attributedText = attributedString
        self.characterIndexTimer = Timer.scheduledTimer(withTimeInterval: 0.37
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
