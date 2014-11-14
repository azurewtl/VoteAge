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
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
