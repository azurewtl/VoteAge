//
//  optionTableViewCell.swift
//  VoteAge
//
//  Created by azure on 14/11/6.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit
protocol ImagesendDelegate {
    func setSelect(number:Int)
}
class OptionTableViewCell: UITableViewCell {

    @IBOutlet var checkImageView: UIImageView!
    var line = UIView()
    @IBOutlet weak var optionImage: UIImageView?
    @IBOutlet var optionProgress: UIProgressView!
    @IBOutlet weak var optionTitle: UILabel!
    @IBOutlet weak var optionDetail: UILabel!
    var imagenumber = Int()
    var delegate = ImagesendDelegate?()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        optionProgress?.progress = 0
        optionDetail?.text = ""
        var tap = UITapGestureRecognizer(target: self, action: "tap")
        optionImage?.userInteractionEnabled = true
        optionImage?.addGestureRecognizer(tap)
        self.contentView.addSubview(line)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        line.frame = CGRectMake(0, contentView.frame.height - 1, contentView.frame.width, 1)
        line.backgroundColor = UIColor(white: 0.7, alpha: 1)
    }
    func tap() {
        self.delegate?.setSelect(imagenumber)
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
