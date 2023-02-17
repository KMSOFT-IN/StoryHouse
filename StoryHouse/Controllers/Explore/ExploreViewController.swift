//
//  ExploreViewController.swift
//  StoryHouse
//
//  Created by kmsoft on 17/02/23.
//

import UIKit

class ExploreViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    var exploreStoryList: [ExploreStory] = []
    
    static func getInstance() -> ExploreViewController {
        return Constant.Storyboard.EXPLORE.instantiateViewController(withIdentifier: "ExploreViewController") as! ExploreViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupTableView()
    }
    
    
    func setupTableView() {
        self.exploreStoryList = UserDefaultHelper.getExploreStory() ?? []
        if self.exploreStoryList.isEmpty {
            self.tableView.isHidden = true
            self.noDataLabel.isHidden = false
        } else {
            self.tableView.isHidden = false
            self.noDataLabel.isHidden = true
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView(frame: .zero)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func settingButtonTapped(_ sender: UIButton) {
        let vc = SettingsViewController.getInstance()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension ExploreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exploreStoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreTableViewCell", for: indexPath) as! ExploreTableViewCell
        cell.storyImageView.image = UIImage(named: self.exploreStoryList[indexPath.row].storyImage ?? "ic_placeHolder")
        let childname = self.exploreStoryList[indexPath.row].childName ?? UserDefaultHelper.getChildname() ?? ""
        let heroName = self.exploreStoryList[indexPath.row].heroName ?? ""
        let placeName = self.exploreStoryList[indexPath.row].placeName ?? ""
        let animalName = self.exploreStoryList[indexPath.row].animalName ?? ""
        let objectName = self.exploreStoryList[indexPath.row].magicalObjectName ?? ""
        cell.storyTitle.text = "\(childname)'s story of \(heroName) the \(animalName), in \(placeName), with \(objectName)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
}
