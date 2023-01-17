//
//  HeroNameViewController.swift
//  StoryHouse
//
//  Created by iMac on 10/01/23.
//

import UIKit

class HeroNameViewController: UIViewController {
    
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var heroNameTextFeild: UITextField!
    var selectedHero = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.heroImageView.image = UIImage(named: selectedHero)
        self.heroImageView.makeRounded()
        
    }
    static func getInstance() -> HeroNameViewController {
        return Constant.Storyboard.CATEGORY.instantiateViewController(withIdentifier: "HeroNameViewController") as! HeroNameViewController
    }
    
    
    @IBAction func clearTextFeildButtonTapped(_ sender: UIButton) {
        self.heroNameTextFeild.text = ""
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func settingButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        let viewController = PlacesViewController.getInstance()
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
}

extension UIImageView {
    
    func makeRounded() {
        
        //layer.borderWidth = 1
        layer.masksToBounds = false
        //layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}
