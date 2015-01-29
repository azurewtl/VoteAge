//
//  VoteThreadTableViewCell.swift
//  VoteAge
//
//  Created by azure on 14/11/6.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit
protocol sendInfoDelegate {
    func sendNumber(num:Int)
}
class VoteTableViewCell: UITableViewCell {
    
    var delegate = sendInfoDelegate?()
    var num = Int()
    var authorID: NSString? = NSString()
    
    
    @IBOutlet var statusImageView: UIImageView!
    @IBOutlet weak var voteTitle: UILabel!
    @IBOutlet weak var voteImage: UIImageView?
    @IBOutlet var voteAuthor: UIButton!
    
    @IBAction func userOnclick(sender: UIButton) {
        self.delegate?.sendNumber(num)
    }
  
    @IBAction func contactUserOnclick(sender: UIButton) {
        self.delegate?.sendNumber(num)
    }

    @IBAction func hasVoteOnclick(sender: UIButton) {
        self.delegate?.sendNumber(num)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
//        voteImage!.layer.cornerRadius = voteImage!.frame.width / 2
//        voteImage!.clipsToBounds = true
     
    }
   
  
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
