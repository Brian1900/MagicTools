//
//  BaseTabBarViewController.h
//  LuShiHelper
//
//  Created by Brian on 13-12-19.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

#define tabBar_bottom_height 49

@class BaseTabBarViewController;

@protocol BaseTabBarViewControllerDelegate <NSObject>

- (void)baseTabBarViewController:(BaseTabBarViewController*)baseTabBarViewController selectIndex:(NSInteger)selectIndex;

@end

@interface BaseTabBarViewController : UITabBarController

//每个按钮的button图片，可以为nil
@property (nonatomic,copy) NSArray* tabBarImages;

//每个按钮的button高亮图片，可以为nil
@property (nonatomic,copy) NSArray* tabBarHighLightedImages;

//每个按钮的button点中图片，可以为nil
@property (nonatomic,copy) NSArray* tabBarSelectedImages;

@property (strong, nonatomic) BaseNavigationController* navigationVC;

//tabBar View
@property (nonatomic,strong) UIView* tabBarView;

//代理
@property (nonatomic,assign) id<BaseTabBarViewControllerDelegate> baseTabBarDelegate;

//设置背景图片
- (void)setBackgroundImage:(UIImage*)image;

@end
