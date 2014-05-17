//
//  BaseNavigationController.h
//  BaseProject
//
//  Created by 陆 文杰 on 13-9-23.
//  Copyright (c) 2013年 陆 文杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface BaseNavigationController : UINavigationController

@property (nonatomic,strong) MainViewController* mainVC;

@end
