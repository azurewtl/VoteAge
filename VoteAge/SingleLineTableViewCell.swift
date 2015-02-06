//
//  SingleLineTableViewCell.swift
//  VoteAge
//
//  Created by caiyang on 15/2/6.
//  Copyright (c) 2015年 azure. All rights reserved.
//

import UIKit

class SingleLineTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func drawRect(rect: CGRect) {
        var context = UIGraphicsGetCurrentContext()
        CGContextSetRGBStrokeColor(context, 0.7, 0.7, 0.7, 1)
        CGContextMoveToPoint(context, 0, self.contentView.frame.height - 0.5)
        CGContextAddLineToPoint(context, self.contentView.frame.width, self.contentView.frame.height - 0.5)
        CGContextSetLineWidth(context, 0.5)
        CGContextStrokePath(context)
    }
   
    
    
}
