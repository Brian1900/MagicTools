//
//  LSHNoticeView.m
//  LuShiHelper
//
//  Created by Brian on 13-12-2.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "BaseNoticeView.h"

@implementation BaseNoticeView

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
//        [self.noticeView setFrame:self.frame];
//    }
}

- (IBAction)buttonPush:(UIButton*)button
{
    if (button.tag == 0) {
        [self.delegate submit:self];
    }else{
        [self.delegate cancel:self];
    }
    
    [self removeFromSuperview];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.view == self.noticeView) {
//        [self.delegate cancel:self];
        [self removeFromSuperview];
    }
}

@end
