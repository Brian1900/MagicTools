//
//  LSHNoticeView.m
//  LuShiHelper
//
//  Created by Brian on 13-12-2.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "BaseChooseView.h"

@implementation BaseChooseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)awakeFromNib
{
//    if (__dataSource.isIphone5) {
//        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 568);
//        [self.chooseView setFrame:self.frame];
//    }
}

- (IBAction)buttonPush:(UIButton*)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(choose:index:)]) {
        [self.delegate choose:self index:button.tag];
    }
    
    [self removeFromSuperview];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.view == self.chooseView) {
//        [self.delegate cancel:self];
        [self removeFromSuperview];
    }
}

@end
