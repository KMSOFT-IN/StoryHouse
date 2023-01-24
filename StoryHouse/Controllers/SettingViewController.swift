//
//  SettingViewController.swift
//  StoryHouse
//
//  Created by iMac on 23/01/23.
//

import UIKit
import AVFoundation

class SettingViewController: UIViewController {
    
    @IBOutlet weak var voiceView: UIView!
    @IBOutlet weak var voiceTextFeldView: UIView!
    @IBOutlet weak var voiceTextfeild: UITextField!
    
    let transparentView = UIView()
    let tableView = UITableView()
    var selectedTextfieldFrame = CGRect()
    var dataSource = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    static func getInstance() -> SettingViewController {
        return Constant.Storyboard.SETTING.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
    }
    
    func setUpUI() {
        self.voiceTextfeild.placeholder = "Please select voice from here."
        self.voiceTextfeild.text = UserDefaultHelper.getVoice()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(Cellclass.self, forCellReuseIdentifier: "Cell")
    }
    
    @IBAction func voiceSelectionButtontapped(_ sender: Any) {
        
        let males = AVSpeechSynthesisVoice.speechVoices().filter({$0.language.contains("en")})
        let voices = males.map({$0.name + "," + $0.identifier})
        self.dataSource = voices
        print(voices)
        if let frame = self.voiceTextFeldView.superview?.convert(self.voiceTextFeldView.frame, to: nil) {
            self.selectedTextfieldFrame = frame
            self.addTransparentView(frames: frame)
        }
    }
    
    @IBAction func voiceButtontapped(_ sender: Any) {
        let data = self.voiceTextfeild.text ?? ""
        Utility.playAudio(text: data)
    }
    
    @IBAction func saveButtontapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let data = dataSource[indexPath.row]
        let name = String(data.split(separator: ",").first ?? "")
        cell.textLabel?.text = name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = dataSource[indexPath.row]
        let name = String(data.split(separator: ",").first ?? "")
        self.voiceTextfeild.text = name
        let identifier = String(data.split(separator: ",").last ?? "")
        AppData.sharedInstance.voiceIdentifier = identifier
        UserDefaultHelper.setVoice(value: name)
        removeTransparentView()
    }
}


extension SettingViewController {
    func addTransparentView(frames: CGRect) {
        let window = AppDelegate.getKeyWindow()
        
        transparentView.frame = window?.frame ?? self.voiceView.frame
        self.view.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        
        tableView.layer.cornerRadius = 5
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        
        tableView.reloadData()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 50))
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(500))
        }, completion: nil)
    }
    
    @objc func removeTransparentView() {
        let frames = self.selectedTextfieldFrame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }
}

class Cellclass:UITableViewCell{
}
