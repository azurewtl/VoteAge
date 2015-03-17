//
//  CAiLabel.m
//  NewTabbarController
//
//  Created by caiyang on 15/3/16.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "CAiLabel.h"

@implementation CAiLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    
    self.fontAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:30], NSForegroundColorAttributeName:[UIColor whiteColor], NSStrokeWidthAttributeName:@12, NSStrokeColorAttributeName:[UIColor blackColor]};
    self.fontAttributesagain = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:30], NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.text drawInRect:rect withAttributes:_fontAttributes];
    [self.text drawInRect:rect withAttributes:_fontAttributesagain];
    
}


@end
