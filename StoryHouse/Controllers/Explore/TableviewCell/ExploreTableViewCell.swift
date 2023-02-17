//
//  ExploreTableViewCell.swift
//  StoryHouse
//
//  Created by kmsoft on 17/02/23.
//

import UIKit

class ExploreTableViewCell: UITableViewCell {

    @IBOutlet weak var storyImageView: UIImageView!
    @IBOutlet weak var storyTitle: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.setShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setShadow() {
        self.shadowView.layer.cornerRadius = 8
        self.shadowView.layer.masksToBounds = true;
        self.shadowView.backgroundColor = UIColor.white
        self.shadowView.layer.shadowColor = UIColor(hex: "#DCD9D9")?.cgColor
        self.shadowView.layer.shadowOpacity = 0.5
        self.shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.shadowView.layer.shadowRadius = 10.0
        self.shadowView.layer.masksToBounds = false
    }

}
