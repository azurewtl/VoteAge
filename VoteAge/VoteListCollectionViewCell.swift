//
//  VoteListCollectionViewCell.swift
//  VoteAge
//
//  Created by caiyang on 15/3/2.
//  Copyright (c) 2015年 azure. All rights reserved.
//

import UIKit

class VoteListCollectionViewCell: UICollectionViewCell {
    var backgroundImgaeView = UIImageView()
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImgaeView.frame = CGRectMake(0, 0, self.contentView.frame.width / 2, self.contentView.frame.width / 2)
        backgroundImgaeView.center = self.contentView.center
        self.contentView.addSubview(backgroundImgaeView)
        
    }
}
