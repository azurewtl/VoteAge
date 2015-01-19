//
//  BlurImageView.h
//  定位1
//
//  Created by caiyang on 15/1/19.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
@interface BlurImageView : UIImageView
- (void)blurryImage:(UIImage *)image
           withBlurLevel:(CGFloat)blur;
@end
