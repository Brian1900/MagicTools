//
//  BaseTouchDisappearView.m
//  LuShiHelper
//
//  Created by Brian on 13-11-29.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "BaseTouchDisappearView.h"

@implementation BaseTouchDisappearView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.view == self) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(touchedView:)]) {
            [self.delegate touchedView:self];
        }else{
            if (self.superview) {
                [self removeFromSuperview];
            }
        }
    }
}

@end
