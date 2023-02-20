//
//  ExploreCollectionViewCell.swift
//  StoryHouse
//
//  Created by kmsoft on 20/02/23.
//

import UIKit

class ExploreCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var storyTitleLabel: UILabel!
    @IBOutlet weak var storyImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var dateLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
