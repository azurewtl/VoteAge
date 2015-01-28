//
//  ActivityButton.swift
//  Suibian
//
//  Created by caiyang on 15/1/27.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

import UIKit
//带菊花的自定义button
class ActivityButton: UIButton {
    
    var juhua = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    override func layoutSubviews() {
        super.layoutSubviews()
        juhua.frame = CGRectMake(0.3 * self.frame.width, 0, 0.5 * self.frame.height, 0.5 * self.frame.height)
        juhua.center = CGPointMake(juhua.frame.origin.x, self.frame.height / 2)
        self.addSubview(juhua)
    }

}
