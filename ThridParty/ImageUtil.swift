//
//  ImageUtil.swift
//  VoteAge
//
//  Created by caiyang on 14/11/21.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit

class ImageUtil: NSObject {
  class  func fitSize(thissize:CGSize, insize asize:CGSize)->CGSize{
        var scale = CGFloat()
        var newSize = CGSize()
        if thissize.width < asize.width && thissize.height < asize.height {
            newSize = thissize
        }else {
            scale = asize.width / thissize.width
            newSize.width = asize.width
            newSize.height = thissize.height * scale
        }
        return newSize
    }
  class func imageFitView(image:UIImage, fitforSize size:CGSize)->UIImage{
        var sizeN = fitSize(image.size, insize: size)
        UIGraphicsBeginImageContext(size)
        var rect = CGRectMake(0, 0, size.width, size.height)
        image.drawInRect(rect)
        var newimg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    return newimg
    }
}
