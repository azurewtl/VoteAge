//
//  VoteAddPersonCell.swift
//  VoteAge
//
//  Created by caiyang on 14/12/8.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit
class VoteAddPersonCell: UICollectionViewCell {
    var image = UIImageView()
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
          super.init(frame: frame)
          image.frame = CGRectMake(0, 0, self.contentView.frame.width, self.contentView.frame.height)
        self.contentView.addSubview(image)
        
    }
    override func layoutSubviews() {
        
    }
}
