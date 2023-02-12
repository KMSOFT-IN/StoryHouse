//
//  PlaceNameViewController.swift
//  StoryHouse
//
//  Created by iMac on 11/02/23.
//

import UIKit

class PlaceNameViewController: UIViewController {

    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var placeNameTextField: UITextField!
    
    var selectedHero = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.placeImageView.image = UIImage(named: selectedHero)
        self.placeImageView.makeRounded()
    }
    static func getInstance() -> PlaceNameViewController {
        return Constant.Storyboard.CATEGORY.instantiateViewController(withIdentifier: "PlaceNameViewController") as! PlaceNameViewController
    }
    
    @IBAction func clearTextFieldButtonTapped(_ sender: UIButton) {
        self.placeNameTextField.text = ""
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func settingButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        let placeName = self.placeNameTextField.text ?? ""
        if placeName.isEmpty {
            Utility.alert(message: "Please enter your place name.")
        } else {
            AppData.sharedInstance.placeName = placeName
            UserDefaultHelper.setUserPlaceName(value: AppData.sharedInstance.placeName)
            let viewController = MagicalObjectViewController.getInstance()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
}
