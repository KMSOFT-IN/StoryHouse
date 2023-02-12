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
    let chooseOptionsDropDown = DropDown()
    var selectedHero = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.heroImageView.image = UIImage(named: selectedHero)
        self.heroImageView.makeRounded()
        self.setUpDropDownMenu()
        UserDefaultHelper.setGender(value: GENDER.BOY.rawValue)
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
        //self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        let heroName = self.heroNameTextField.text ?? ""
        if heroName.isEmpty {
            Utility.alert(message: "Please enter your hero name.")
        } else {
            AppData.sharedInstance.heroName = heroName
            UserDefaultHelper.setUserHeroName(value: AppData.sharedInstance.heroName)
            let viewController = PlacesViewController.getInstance()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func dropDOwnButtonTapped(_ sender: UIButton) {
        self.chooseOptionsDropDown.show()
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
