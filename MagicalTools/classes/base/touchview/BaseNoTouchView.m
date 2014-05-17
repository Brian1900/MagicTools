//
//  BaseNoTouchView.m
//  LuShiHelper
//
//  Created by Brian on 13-11-19.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "BaseNoTouchView.h"

@implementation BaseNoTouchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    //当事件是传递给此View内部的子View时，让子View自己捕获事件，如果是传递给此View自己时，放弃事件捕获
    UIView* __tmpView = [super hitTest:point withEvent:event];
    
    if (__tmpView == self) {
        return nil;
    }
    return __tmpView;
}

@end
