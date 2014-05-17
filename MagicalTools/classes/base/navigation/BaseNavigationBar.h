//
//  BaseNavigationBar.h
//  BaseProject
//
//  Created by 陆 文杰 on 13-9-23.
//  Copyright (c) 2013年 陆 文杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

#define kNavigationBarLeftGap 0 //default 5
#define kNavigationBarRightGap 0 //default 5
#define kNavigationBarHorizonGap 8 //default 8
#define kNavigationBarButtonFont [UIFont boldSystemFontOfSize:13]
#define kNavigationBarButtonNormalColor [UIColor whiteColor]
#define kNavigationBarButtonHighlightColor [UIColor whiteColor]
#define kNavigationBarButtonDisableColor [[UIColor colorWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1.0] colorWithAlphaComponent:0.4]

#define kNavigationBarTitleViewMaxWidth 180
#define kNavigationBarTitleFont [UIFont fontWithName:@"STHeitiSC-Medium" size:20]

@interface BaseNavigationBar : UIView

/**	背景视图 */
@property (nonatomic, strong) UIImageView *backgroundImageView;
/**	标题 */
@property (nonatomic, copy)   NSString *title;
/**	标题视图 */
@property (nonatomic, strong) UIView *titleView;
/**	返回按钮 */
@property (nonatomic, strong) UIBarButtonItem *backBarButtonItem;
/**	最左侧按钮 */
@property (nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
/**	最右侧按钮 */
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
/**	左侧按钮列表 */
@property (nonatomic, copy)   NSArray *leftBarButtonItems;
/**	右侧按钮列表 */
@property (nonatomic, copy)   NSArray *rightBarButtonItems;


- (void)setBackgroundImage:(UIImage *)image;
- (void)setTitleImage:(UIImage *)image;
- (void)setTitle:(NSString *)title color:(UIColor*)color;

#pragma mark - 添加按钮左按钮
/**
 增加返回按钮
 @param target 消息绑定目标
 @param selector 消息绑定方法
 */
- (void)addBackButtonWithTarget:(id)target action:(SEL)selector;

- (void)addCancelButtonWithTarget:(id)target action:(SEL)selector;

/**
 增加关闭按钮
 @param target 消息绑定目标
 @param selector 消息绑定方法
 */
- (void)addCloseButtonWithTarget:(id)target action:(SEL)selector;

/**
 增加保存按钮
 @param target 消息绑定目标
 @param selector 消息绑定方法
 */
- (void)addMenuButtonWithTarget:(id)target action:(SEL)selector;

#pragma mark 添加按钮右按钮
/**
 增加设置按钮
 @param target 消息绑定目标
 @param selector 消息绑定方法
 */
- (void)addRightSendButton:(id)target action:(SEL)selector;

/**
 增加设置按钮
 @param target 消息绑定目标
 @param selector 消息绑定方法
 */
- (void)addRightSubmitButton:(id)target action:(SEL)selector;

/**
 增加切换按钮
 @param target 消息绑定目标
 @param selector 消息绑定方法
 */
- (void)setRightAdd:(id)target action:(SEL)selector;

- (void)setRightSend:(id)target action:(SEL)selector;

/**
 增加切换按钮
 @param target 消息绑定目标
 @param selector 消息绑定方法
 */
- (void)setRightSearch:(id)target action:(SEL)selector;

/**
 增加切换按钮
 @param target 消息绑定目标
 @param selector 消息绑定方法
 */
- (void)setRightDownload:(id)target action:(SEL)selector;

///**
// 增加搜索按钮
// @param target 消息绑定目标
// @param selector 消息绑定方法
// */
//- (void)addRightSearchButtonWithTarget:(id)target action:(SEL)selector;

/**
 增加分享按钮
 @param target 消息绑定目标
 @param selector 消息绑定方法
 */
- (void)addRightDoneButtonWithTarget:(id)target action:(SEL)selector;

/**
 增加重置按钮
 @param target 消息绑定目标
 @param selector 消息绑定方法
 */
- (void)addRightReFreshButtonWithTarget:(id)target action:(SEL)selector;

@end
