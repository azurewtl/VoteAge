//
//  VoteThreadTableViewCell.swift
//  VoteAge
//
//  Created by azure on 14/11/6.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit

class VoteTableViewCell: UITableViewCell {

    @IBOutlet weak var voteTitle: UILabel!
    @IBOutlet weak var voteImage: UIImageView!
    @IBOutlet var voteAuthor: UIButton!
    var authorID: NSString = NSString()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        voteImage.layer.cornerRadius = voteImage.frame.width / 2
        voteImage.clipsToBounds = true
    }
 
  
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
