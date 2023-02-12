//
//  TabbarViewController.swift
//  StoryHouse
//
//  Created by iMac on 11/01/23.

import UIKit
import AVKit
import MediaPlayer
import AVFoundation
import LinkPresentation
class TabbarViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var playPauseImageView: UIImageView!
    @IBOutlet weak var muteImageView: UIImageView!
    @IBOutlet weak var pageLable: UILabel!
    @IBOutlet weak var sliderView: Slider!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secoundView: UIView!
    
    @IBOutlet weak var number: UILabel!
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
    var characterIndexTimer: Timer?
    var isFirstTimePlay: Bool = true
    var isPageChanged: Bool = false
    var isHE: Bool = true
    var filterdStoryIndex: String = "111"
    var isMute: Bool = true
    let name = UserDefaultHelper.getChildname()
    let gifHandler = Gif()
    var animationTimer: Timer?
    let femaleName = ["Gizzy","Gertie","Gira","Gigi","Gracie","Gertrude","Giselle","Zara","Zoe","Zoey","Cassandra","Maria","Carla","Foxy","Fraya","Freya","Fennec","Fawna","Fia","Fiora","Ferris","Lisa","Fuzzy","Fury","Gazelle","Minty","Poppy","Winkie","Fuzzy","Cinderella","Twiggy","Nanny"]
    let maleName = ["Gerald","George","Gizmo","Zebra","Zack","Zippy","Zor","Zeb","Fox","Fin","Felix","Foxy","Finnegan","Fenton","Monkey","Max","Mango"]
    
    let placesName = ["forest", "Forest", "underwater", "UnderWater", "Outer Space", "outer space", "savannah", "Savannah"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setStoryNumber()
        self.loadJson()
        
        let gender =  UserDefaultHelper.getGender()
        if gender == GENDER.BOY.rawValue {
            self.isHE = true
        }
        else {
            self.isHE = false
        }
        
        //  self.setStoryNumber()
        CustomLoader.instance.gifName = "demo"
        self.setUpGesture()
        self.setUpSlider()
        self.isFirstTimePlay = true
        self.navigationController?.setViewControllers([self], animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setStoryNumber()
        self.imageTitle.textColor = GRAY_COLOR
        self.setUpUI()
        self.sliderView.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.setGifs(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.setGifs(touches: touches)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.setGifs(touches: touches)
    }
    
    func setGifs(touches: Set<UITouch>) {
        guard let location = touches.first?.location(in: self.view) else { return }
        let view = UIView(frame: CGRect(x: location.x - 25, y: location.y - 25, width: 50, height: 50))
        view.layer.cornerRadius = 25
        self.view.addSubview(view)
        self.gifHandler.setTouchGif(name: "glitter", duration: 0.5, view: view, cornerRadius: 25)
    }
    
    func setUpSlider() {
        self.sliderView.value = self.systemVolume
        self.sliderView.sliderValueChangedCallback = {
            self.muteLabel.text = "VOLUME"
            if self.sliderView.value > 0.0 && self.sliderView.value <= 0.20 {
                self.sliderView.value = 0.20
            } else if self.sliderView.value > 0.20 && self.sliderView.value <= 0.40 {
                self.sliderView.value = 0.40
            } else if self.sliderView.value > 0.40 && self.sliderView.value <= 0.60 {
                self.sliderView.value = 0.60
            } else if self.sliderView.value > 0.60 && self.sliderView.value <= 0.80 {
                self.sliderView.value = 0.80
            } else if self.sliderView.value > 0.80 && self.sliderView.value <= 1.0 {
                self.sliderView.value = 1
            }
            self.sliderView.layoutIfNeeded()
            MPVolumeView.setVolume(self.sliderView.value)
            print(self.sliderView.value)
            self.utterance.volume = self.sliderView.value
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
                self.prevPageButtonTapped(self)
            case .left:
                self.nextPageButtontapped(self)
            default:
                break
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.isFirstTimePlay = true
        self.pauseSpeaking()
        self.synthesizer.stopSpeaking(at: .immediate)
    }
    
    func setStoryNumber() {
        if let storyNumber = UserDefaultHelper.getSelectedStoryNumber() {
            AppData.sharedInstance.selectedStoryNumber = storyNumber
            AppData.sharedInstance.heroName = UserDefaultHelper.getUserHeroName()
            AppData.sharedInstance.placeName = UserDefaultHelper.getUserPlaceName()
            self.filterdStoryIndex = storyNumber
        }
        else {
            self.filterdStoryIndex = "000"
            AppData.sharedInstance.selectedStoryNumber = self.filterdStoryIndex
        }
    }
    
    static func getInstance() -> TabbarViewController {
        return Constant.Storyboard.TABBAR.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func loadJson() {
        if let path = Bundle.main.path(forResource: "\(self.filterdStoryIndex)", ofType: "json") {
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
        self.paragraphDetails = self.storydata?.story?.first?.data
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
        if Utility.isDebug() {
            self.number.text = self.storydata?.story?.first?.storyNumber
        } else {
            self.number.isHidden = true
        }
        self.imageTitle.textColor = GRAY_COLOR
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setUpStory(index: Int) {
        if index >= totalIndex {
            self.currentIndex = 0
            UserDefaultHelper.setParagraphIndex(value: 0)
            return }
        UserDefaultHelper.setParagraphIndex(value: index)
        self.pageLable.text = "\(self.currentIndex + 1) / \(totalIndex)"
        
        self.image.image = UIImage(named : self.paragraphDetails?[index].imageName ?? "") ?? UIImage(named: "ic_placeHolder")
        if !AppData.sharedInstance.heroName.isEmpty {
            let imageTitleStr = isHE ? self.paragraphDetails?[index].he! : self.paragraphDetails?[index].she!
            if let findIndex = isHE ? self.maleName.firstIndex(where: {(imageTitleStr?.contains($0) ?? false)}) : self.femaleName.firstIndex(where: {(imageTitleStr?.contains($0) ?? false)}) {
                let nameReplace = isHE ? self.maleName[findIndex] : self.femaleName[findIndex]
                var nameReplaceImageTitle = imageTitleStr?.replacingOccurrences(of: nameReplace, with: AppData.sharedInstance.heroName)
                if let findPlaceIndex = self.placesName.firstIndex(where: {imageTitleStr?.contains($0) ?? false}) {
                    let placeReplace = self.placesName[findPlaceIndex]
                    let placeRplaceImageTitle = nameReplaceImageTitle?.replacingOccurrences(of: placeReplace, with: AppData.sharedInstance.placeName)
                    nameReplaceImageTitle = placeRplaceImageTitle
                }
                self.imageTitle.text = nameReplaceImageTitle
            }
            //self.imageTitle.text = replacingString//isHE ? self.paragraphDetails?[index].he : self.paragraphDetails?[index].she
        } else {
            self.imageTitle.text = isHE ? self.paragraphDetails?[index].he : self.paragraphDetails?[index].she
        }
        self.imageTitle.textColor = GRAY_COLOR
        self.startImageAnimationTimer()
        if self.currentIndex == 0 {
            self.addStartStoryEvent()
        } else if self.currentIndex == (totalIndex - 1) {
            self.addEndStoryEvent()
        }
    }
    
    func addStartStoryEvent() {
        AppData.sharedInstance.storyStartTime = Date().toTimeString
        let storyParam = [Constant.Analytics.USER_ID : UserDefaultHelper.getUser(),
                          "startTime" : AppData.sharedInstance.storyStartTime,
                          "endTime" : "",
                          "lapsed" : "",
                          "completed_page_index" : self.currentIndex,
                          "story_index": UserDefaultHelper.getSelectedStoryNumber() ?? ""] as [String : Any]
        AppData.sharedInstance.logger.logAnalyticsEvent(eventName: Constant.Analytics.STORY_READ_TIME, parameters: storyParam)
    }
    
    func addEndStoryEvent() {
        AppData.sharedInstance.storyEndTime = Date().toTimeString
        AppData.sharedInstance.totalStroyReadingEndTime = Date().toTimeString
        let getDiffernece = Utility.findDateDiff(time1Str: AppData.sharedInstance.storyStartTime, time2Str: AppData.sharedInstance.storyEndTime)
        let storyParam = [Constant.Analytics.USER_ID : UserDefaultHelper.getUser(),
                          "startTime" : AppData.sharedInstance.storyStartTime,
                          "endTime" : AppData.sharedInstance.storyEndTime,
                          "lapsed" : getDiffernece,
                          "completed_page_index" : self.currentIndex,
                          "story_index": UserDefaultHelper.getSelectedStoryNumber() ?? ""] as [String : Any]
        AppData.sharedInstance.logger.logAnalyticsEvent(eventName: Constant.Analytics.STORY_READ_TIME, parameters: storyParam)
        if self.currentIndex == (self.totalIndex - 1) {
            let completeStoryParam = [Constant.Analytics.USER_ID : UserDefaultHelper.getUser(),
                                      "completed_page_index" : self.currentIndex,
                                      "story_index": UserDefaultHelper.getSelectedStoryNumber() ?? ""] as [String : Any]
            AppData.sharedInstance.logger.logAnalyticsEvent(eventName: Constant.Analytics.STORY_COMPLETED, parameters: completeStoryParam)
        }
    }
    
    
    @objc func imageAnimationStart() {
        self.gifHandler.setUpGif(name: "dust", duration: 11, view: self.image)
        UIView.animate(withDuration: 5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.image.transform = CGAffineTransform.identity.scaledBy(x: 1.2, y: 1.2) // Scale your image
         }) { (finished) in
             UIView.animate(withDuration: 5, animations: {
              self.image.transform = CGAffineTransform.identity // undo in 1 seconds
             }) { (finished) in
                 self.startImageAnimationTimer()
             }
        }
    }
    
    func resetImageAnimation() {
        self.stopAnimationTimer()
        self.view.subviews.forEach({$0.layer.removeAllAnimations()})
        self.view.layer.removeAllAnimations()
        self.view.layoutIfNeeded()
        self.image.image = UIImage(named: self.paragraphDetails?[self.currentIndex].imageName ?? "ic_placeHolder") // undo in 1 seconds
    }
    
    func startImageAnimationTimer() {
        self.stopAnimationTimer()
        self.animationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.imageAnimationStart), userInfo: nil, repeats: false)
    }
    
    func stopAnimationTimer() {
        if self.animationTimer != nil {
            self.animationTimer?.invalidate()
            self.animationTimer = nil
        }
    }

    @IBAction func homeButtonTapped(_ sender: Any) {
        self.addEndStoryEvent()
        self.pauseSpeaking()
        self.synthesizer.stopSpeaking(at: .immediate)
        UserDefaultHelper.setParagraphIndex(value: 0)
        let viewController = HomeViewController.getInstance()
        //let viewController = ChildNameViewController.getInstance()
        UserDefaultHelper.set_Is_Onboarding_Done(value: false)
        //viewController.isFromTabbar = true
        var navigationController = UINavigationController()
        let window = self.view.window
        navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    @IBAction func nextPageButtontapped(_ sender: Any) {
        self.currentIndex += 1
        if self.currentIndex >= self.totalIndex {
            UserDefaultHelper.setParagraphIndex(value: 0)
            self.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            let viewController = EndViewController.getInstance()
            let index = 0
            viewController.image = self.paragraphDetails?[index].imageName ?? "ic_placeHolder"
            viewController.imageTitle = (isHE ? self.paragraphDetails?[index].he : self.paragraphDetails?[index].she) ?? self.paragraphDetails?[index] as! String
            self.navigationController?.pushViewController(viewController, animated: true)
            return
        }
        self.resetImageAnimation()
        self.setUpStory(index: self.currentIndex)
        self.resetUI()
    }
    
    @IBAction func prevPageButtonTapped(_ sender: Any) {
        self.currentIndex -= 1
        if (self.currentIndex < 0) {
            self.currentIndex = 0
        }
        self.resetImageAnimation()
        self.setUpStory(index: self.currentIndex)
        self.resetUI()
        
        
    }
    
    func resetUI() {
        self.imageTitle.textColor = GRAY_COLOR
        self.synthesizer.stopSpeaking(at: .immediate)
        self.isPageChanged = true
        self.isFirstTimePlay = true
    }
    
    func autoNextPage() {
        if self.isPageChanged {
            self.isPageChanged = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.setUpAudio()
            }
            return
        }
        
        self.currentIndex += 1
        if self.currentIndex >= self.totalIndex {
            UserDefaultHelper.setParagraphIndex(value: 0)
            synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            let viewController = EndViewController.getInstance()
            let index = 0
            viewController.image = self.paragraphDetails?[index].imageName ?? "ic_placeHolder"
            viewController.imageTitle = (isHE ? self.paragraphDetails?[index].he : self.paragraphDetails?[index].she) ?? self.paragraphDetails?[index].he as! String
            self.navigationController?.pushViewController(viewController, animated: true)
            return
        }
        self.setUpStory(index: self.currentIndex)
        self.isFirstTimePlay = true
        self.isPlayAudioON = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.setUpAudio()
        }
        
    }
    
    @IBAction func playPauseButtonTapped(_ sender: Any) {
        isPlayAudioON = !isPlayAudioON
        self.setUpAudio()
    }
    
    func setUpAudio() {
        self.isPageChanged = false
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
        self.addWaterMarkToImage { tempImage in
            UIGraphicsBeginImageContext(self.view.frame.size)
            self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
            
            var image = self.image.image
            if tempImage != nil {
                image = tempImage
            }
            UIGraphicsEndImageContext()
    //        let childName = (UserDefaultHelper.getChildname() ?? "") + "'s Magic House Story, assisted by MagicalHouse.studio\n\(self.imageTitle.text ?? "")"
            let objectsToShare = [image, self] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            activityVC.popoverPresentationController?.sourceView = sender as? UIView
            AppData.sharedInstance.logger.logAnalyticsEvent(eventName: Constant.Analytics.SHARE_STORY, parameters: ["STORY_INDEX" : AppData.sharedInstance.selectedStoryNumber])
            self.present(activityVC, animated: true, completion: nil)
        }
        
    }
    
    func addWaterMarkToImage(_ callBack: ((_ image: UIImage?) -> Void)?) {
        let backgroundImage = self.image.image!
        let watermarkImage = #imageLiteral(resourceName: "ic_placeHolder1")

        let size = backgroundImage.size
        let scale = backgroundImage.scale

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        backgroundImage.draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        watermarkImage.draw(in: CGRect(x: 10, y: size.height - 60, width: 50, height: 50))

        if let result = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            callBack?(result)
        }
        callBack?(nil)
    }
    
    
    @IBAction func settingButtontapped(_ sender: Any) {
        self.pauseSpeaking()
        self.synthesizer.stopSpeaking(at: .immediate)
        let viewController = SettingViewController.getInstance()
        self.navigationController?.pushViewController(viewController, animated: true
        )
    }
    
}

extension TabbarViewController: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
//        let childName = (UserDefaultHelper.getChildname()?.capitalizingFirstLetter() ?? "") + "'s Magic House Story, assisted by MagicalHouse.studio\n\(self.imageTitle.text ?? "")"
        let childName = (UserDefaultHelper.getChildname()?.capitalizingFirstLetter() ?? "")+"'s Magic House story. Download to create your own: \(APPLINK).\n\(self.imageTitle.text ?? "")"
        return childName
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = (UserDefaultHelper.getChildname()?.capitalizingFirstLetter() ?? "")+"'s Magic House story. Download to create your own: \(APPLINK)./n\n\(self.imageTitle.text ?? "")"
//        "\(UserDefaultHelper.getChildname() ?? "") 's Story, assisted by MagicalHouse.studio\n\(self.imageTitle.text ?? "")"
        let image = UIImage(named: self.paragraphDetails?[self.currentIndex].imageName ?? "ic_placeHolder")!
        metadata.iconProvider = NSItemProvider(object: image)
        return metadata
    }
}

extension TabbarViewController : AVSpeechSynthesizerDelegate {
    
    func playAudio(text: String) {
        // "Rishi,com.apple.voice.compact.en-IN.Rishi"
        self.utterance = AVSpeechUtterance(string: text)
        self.utterance.voice = AVSpeechSynthesisVoice(identifier: UserDefaultHelper.getVoiceIdentifier() ?? "com.apple.voice.compact.en-IN.Rishi")
        self.utterance.rate = 0.35
        self.utterance.postUtteranceDelay = 0.01
        self.utterance.volume = self.sliderView.value
        
        self.synthesizer.delegate = self
        self.synthesizer.speak(utterance)
    }
    
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
        self.autoNextPage()
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
