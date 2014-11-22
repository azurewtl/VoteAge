//
//  optionTableViewCell.swift
//  VoteAge
//
//  Created by azure on 14/11/6.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit

class OptionTableViewCell: UITableViewCell {

    @IBOutlet weak var optionImage: UIImageView!
    @IBOutlet var optionProgress: UIProgressView!
    @IBOutlet weak var optionTitle: UILabel!
    @IBOutlet weak var optionDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        optionProgress.progress = 0
        optionDetail.text = ""
       self.contentView.addConstraint(NSLayoutConstraint(item: optionImage, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Width, multiplier: 0.001, constant: 0))
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
