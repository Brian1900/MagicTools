//
//  LSHNoticeView.m
//  LuShiHelper
//
//  Created by Brian on 13-12-2.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "BaseTipView.h"

@implementation BaseTipView

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

- (void)disapear
{
    if (self) {
        [self removeFromSuperview];
    }
}

- (void)awakeFromNib
{
//    if (__dataSource.isIphone5) {
//        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 568);
//        [self.tipView setFrame:self.frame];
//    }
    [self.submitButton setTitle:@"知道了" forState:UIControlStateNormal];
}

- (void)setButtonText:(NSString *)buttonText
{
    [self.submitButton setTitle:buttonText forState:UIControlStateNormal];
}

- (IBAction)okButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(OKButton:)]) {
        [self.delegate OKButton:self];
    }
    [self removeFromSuperview];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    UITouch *touch = [touches anyObject];
//    if (touch.view == self.tipView) {
//        [self.delegate cancel:self];
        [self removeFromSuperview];
//    }
}

@end
