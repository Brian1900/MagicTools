//
//  LSHNoticeView.h
//  LuShiHelper
//
//  Created by Brian on 13-12-2.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseNoticeView;

@protocol BaseNoticeViewDelegate<NSObject>
@required

-(void)submit:(BaseNoticeView*)view;
-(void)cancel:(BaseNoticeView*)view;

@end

@interface BaseNoticeView : UIView

@property (strong,nonatomic) IBOutlet UIView* noticeView;
@property (assign,nonatomic) id<BaseNoticeViewDelegate> delegate;
@property (strong,nonatomic) IBOutlet UILabel* labelDestription;

@end
