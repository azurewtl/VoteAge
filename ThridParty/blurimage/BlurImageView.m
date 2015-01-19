//
//  BlurImageView.m
//  定位1
//
//  Created by caiyang on 15/1/19.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "BlurImageView.h"

@implementation BlurImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:kCIInputImageKey, inputImage,
                        @"inputRadius", @(blur),
                        nil];
    CIImage *outputImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef outImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    image = [UIImage imageWithCGImage:outImage];
    self.image = image;

}
@end
