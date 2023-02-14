//
//  HeroNameViewController.swift
//  StoryHouse
//
//  Created by iMac on 10/01/23.
//

import UIKit

class HeroNameViewController: UIViewController {
    
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var heroNameTextField: UITextField!
    @IBOutlet weak var hisherLabel: UILabel!
    @IBOutlet weak var hisherNameTextField: UITextField!
    @IBOutlet weak var hisherChooseButton: UIButton!
    @IBOutlet weak var rememberButton: UIButton!
    @IBOutlet weak var rememberImageView: UIImageView!
    
    let chooseOptionsDropDown = DropDown()
    var selectedHero = ""
    var selectedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.heroImageView.image = selectedImage
        self.heroImageView.layer.cornerRadius = 20
        self.heroNameTextField.text = UserDefaultHelper.getChildname() ?? ""
        if !UserDefaultHelper.getIsRemember() {
            self.hisherLabel.text = "His name is \(self.heroNameTextField.text ?? "")"
            UserDefaultHelper.setGender(value: GENDER.BOY.rawValue)
        }
        self.setUpDropDownMenu()
    }
    static func getInstance() -> HeroNameViewController {
        return Constant.Storyboard.CATEGORY.instantiateViewController(withIdentifier: "HeroNameViewController") as! HeroNameViewController
    }
    
    func setUpDropDownMenu() {
        chooseOptionsDropDown.anchorView = hisherLabel
        chooseOptionsDropDown.bottomOffset = CGPoint(x: 0, y: hisherLabel.bounds.height)
        chooseOptionsDropDown.dataSource = ["His","Her"]
        chooseOptionsDropDown.selectionAction = { [weak self] (index, item) in
            self?.hisherLabel.text = "\(item) name is \(self?.heroNameTextField.text ?? "")"
            if index == 0 {
                UserDefaultHelper.setGender(value: GENDER.BOY.rawValue)
            } else {
                UserDefaultHelper.setGender(value: GENDER.GIRL.rawValue)
            }
        }
        
        if UserDefaultHelper.getIsRemember() {
            self.rememberImageView.image = UIImage(named: "ic_check")
            if UserDefaultHelper.getGender() == GENDER.BOY.rawValue {
                chooseOptionsDropDown.selectRow(0)
                self.hisherLabel.text = "His name is \(self.heroNameTextField.text ?? "")"
            } else {
                chooseOptionsDropDown.selectRow(at: 1)
                self.hisherLabel.text = "Her name is \(self.heroNameTextField.text ?? "")"
            }
        } else {
            self.rememberImageView.image = UIImage(named: "ic_uncheck")
            UserDefaultHelper.setGender(value: GENDER.BOY.rawValue)
        }
        let appearance = DropDown.appearance()
        
        appearance.cellHeight = 60
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = .darkGray
        
        if #available(iOS 11.0, *) {
            appearance.setupMaskedCorners([.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
        }
        chooseOptionsDropDown.cellNib = UINib(nibName: "MyCell", bundle: nil)
        chooseOptionsDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? MyCell else { return }
            if index == 0 {
                cell.logoImageView.image = UIImage(named: "ic_boy")
            } else {
                cell.logoImageView.image = UIImage(named: "ic_girl")
            }
        }
    }
    
    
    @IBAction func clearTextFieldButtonTapped(_ sender: UIButton) {
        self.heroNameTextField.text = ""
    }
    
    @IBAction func clearTextHisHerFielddButtonTapped(_ sender: UIButton) {
        self.hisherNameTextField.text = ""
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func settingButtonTapped(_ sender: Any) {
        let viewController = SettingsViewController.getInstance()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        let heroName = self.heroNameTextField.text ?? ""
        if heroName.isEmpty {
            Utility.alert(message: "Please enter your hero name.")
        } else {
            AppData.sharedInstance.heroName = heroName
            UserDefaultHelper.setChildname(value: AppData.sharedInstance.heroName)
            let viewController = PlacesViewController.getInstance()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func dropDOwnButtonTapped(_ sender: UIButton) {
        self.chooseOptionsDropDown.show()
    }
    
    @IBAction func rememberButtonTapped(_ sender: UIButton) {
        if self.rememberImageView.image == UIImage(named: "ic_uncheck") {
            self.rememberImageView.image = UIImage(named: "ic_check")
            UserDefaultHelper.setIsRemember(value: true)
        } else {
            self.rememberImageView.image = UIImage(named: "ic_uncheck")
            UserDefaultHelper.setIsRemember(value: false)
        }
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
