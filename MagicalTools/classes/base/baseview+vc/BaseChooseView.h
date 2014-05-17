//
//  LSHNoticeView.h
//  LuShiHelper
//
//  Created by Brian on 13-12-2.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseChooseView;

@protocol BaseChooseViewDelegate<NSObject>
@required

-(void)choose:(BaseChooseView*)view index:(NSInteger)index;

@end

@interface BaseChooseView : UIView

@property (strong,nonatomic) IBOutlet UIView* chooseView;
@property (assign,nonatomic) id<BaseChooseViewDelegate> delegate;

- (void)setUpText:(NSString*)upText upTag:(NSInteger)upTag downText:(NSString*)downText downTag:(NSInteger)downTag;

@end
