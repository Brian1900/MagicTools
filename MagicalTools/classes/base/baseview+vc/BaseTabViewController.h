//
//  BaseTabViewController.h
//  GM86
//
//  Created by Brian on 14-3-24.
//  Copyright (c) 2014年 gm86. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@class BaseTabViewController;

@protocol BaseTabBarViewControllerDelegate <NSObject>

- (void)baseTabBarViewController:(BaseTabViewController*)baseTabViewController selectIndex:(NSInteger)selectIndex;

@end

@interface BaseTabViewController : UITabBarController

//代理
@property (nonatomic,assign) id<BaseTabBarViewControllerDelegate> baseTabBarDelegate;

@end
