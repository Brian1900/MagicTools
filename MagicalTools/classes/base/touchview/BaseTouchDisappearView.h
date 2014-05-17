//
//  BaseTouchDisappearView.h
//  LuShiHelper
//
//  Created by Brian on 13-11-29.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseTouchDisappearView;

@protocol BaseTouchDisappearDeleagte <NSObject>

- (void)touchedView:(BaseTouchDisappearView*)view;

@end

@interface BaseTouchDisappearView : UIView

@property (nonatomic,assign) id<BaseTouchDisappearDeleagte> delegate;

@end
