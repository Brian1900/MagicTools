//
//  BaseTopTabBarViewController.h
//  LuShiHelper
//
//  Created by Brian on 13-12-20.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define tabBar_Top_height 50
#define naviBar_Top_hieght 44
#define tabBar_Top_width 50

@class BaseTopTabBarViewController;

@protocol BaseTopTabBarViewControllerDelegate <NSObject>

- (void)baseTopTabBarViewController:(BaseTopTabBarViewController*)baseTopTabBarViewController selectIndex:(NSInteger)selectIndex;

@end

@interface BaseTopTabBarViewController : UITabBarController

//每个按钮的button图片，可以为nil
@property (nonatomic,copy) NSArray* tabBarImages;

//每个按钮的button点中图片，可以为nil
@property (nonatomic,copy) NSArray* tabBarHighLightedImages;

//每个按钮的button点中图片，可以为nil
@property (nonatomic,copy) NSArray* tabBarSelectedImages;

//代理
@property (nonatomic,assign) id<BaseTopTabBarViewControllerDelegate> baseTabBarDelegate;

//设置背景图片
- (void)setBackgroundImage:(UIImage*)image;

@end
