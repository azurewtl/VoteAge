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
    
    self.fontsize = 20;
    self.fontAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:30], NSForegroundColorAttributeName:[UIColor whiteColor], NSStrokeWidthAttributeName:@-4, NSStrokeColorAttributeName:[UIColor blackColor]};
    [self.text drawInRect:rect withAttributes:_fontAttributes];
 
}


@end
