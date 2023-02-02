//
//  imageCollectionViewCell.swift
//  StoryHouse
//
//  Created by iMac on 10/01/23.
//

import UIKit

class imageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageBorderView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    /*override func awakeFromNib() {
           super.awakeFromNib()

           layer.borderWidth = 1
           layer.borderColor = borderColor1
       }

       override var isSelected: Bool {
           didSet {
               layer.borderColor = borderColor1
           }
       }

        var borderColor1: CGColor {
           return isSelected ? UIColor.red.cgColor : UIColor.lightGray.cgColor
       }
     */
    
}
