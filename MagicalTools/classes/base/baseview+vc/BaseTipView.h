//
//  LSHNoticeView.h
//  LuShiHelper
//
//  Created by Brian on 13-12-2.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseTipView;

@protocol tipViewDelegate <NSObject>

- (void)OKButton:(BaseTipView*)tipView;

@end



@interface BaseTipView : UIView

@property (assign,nonatomic) id<tipViewDelegate> delegate;
@property (strong,nonatomic) IBOutlet UIView* tipView;
@property (strong,nonatomic) NSString* buttonText;
@property (strong,nonatomic) IBOutlet UILabel* tipDestription;
@property (strong,nonatomic) IBOutlet UIButton* submitButton;

@end
