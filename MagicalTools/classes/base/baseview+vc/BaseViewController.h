//
//  BaseViewController.h
//  BaseProject
//
//  Created by 陆 文杰 on 13-9-23.
//  Copyright (c) 2013年 陆 文杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseUtil.h"
#import "BaseNavigationController.h"
#import "BaseNavigationBar.h"
//#import "LSHHTTPEngine.h"
#import "LSHDBManager.h"
#import "BaseNoTouchView.h"
#import "BaseNoticeView.h"
#import "BaseChooseView.h"
#import "BaseTipView.h"
#import "BaseDataSource.h"
#import "BaseChooseView.h"
#import "BaseNoticeView.h"
#import "BaseTipView.h"
#import "DateUtil.h"
#import "BaseTouchDisappearView.h"
#import "WTStatusBar.h"

typedef enum {
    EStatusNon,//初始化
    EStatusLoading,//正在读取数据
    EStatusRetry,//重试
    EStatusRetryLoading,//点击重试后的读取数据
    EStatusRetryFail,//重试
    EStatusSuccess//没有网络
}EStatus;

@class gm86MainViewController;

@interface BaseViewController : UIViewController<UIScrollViewDelegate,UINavigationControllerDelegate,BaseChooseViewDelegate,BaseNoticeViewDelegate,BaseTouchDisappearDeleagte>
{
//    NetWorkBaseRequest* lastRequest;
    SenderSuccessMethod lastSuccessMethod;
    SenderSuccessMethod lastFailMethod;
    BOOL lastTip;
    BaseTouchDisappearView* disappearView;
}

@property (assign, nonatomic) NSInteger startY;

@property (strong, nonatomic) BaseViewController* lastViewController;
@property (strong, nonatomic) BaseViewController* nextViewController;

@property (strong, nonatomic) BaseNavigationBar *navigationBar;
//@property (strong, nonatomic) LSHHTTPEngine* httpEngine;
@property (strong, nonatomic) BaseNavigationController* navigationVC;

@property (strong, nonatomic) BaseNoTouchView* backGroundView;
@property (strong, nonatomic) UIButton* stateButton;
@property (strong, nonatomic) UIButton* noNetButton;

@property (assign, nonatomic) EStatus netStatus;

@property (assign, nonatomic) BOOL isModelView;

- (void)setNavTitle:(NSString *)title;

- (void)showDisappearView;
- (void)killDisappearView;

- (void)unregNotification;
- (void)regNotification;

- (void)closePre;
- (IBAction)backButton:(id)sender;

- (void)showStatusTip:(NSString*)tipText;

- (void)ShowNetError;

- (void)showTip:(NSString*)tip;
- (void)showTip:(NSString*)tip buttonText:(NSString*)buttonText;
- (void)showChoose:(NSString*)chooseClassName tag:(NSInteger)tag UpText:(NSString*)upText upTag:(NSInteger)upTag downText:(NSString*)downText downTag:(NSInteger)downTag;

- (void)pushViewController:(BaseViewController*)vc animated:(BOOL)animated selfAnimated:(BOOL)selfAnimated;
- (void)popViewControllerAnimated:(BaseViewController*)vc animated:(BOOL)animated selfAnimated:(BOOL)selfAnimated;
- (void)popViewControllerAnimated:(BOOL)animated selfAnimated:(BOOL)selfAnimated;
- (void)popToRootViewControllerAnimated:(BOOL)animated selfAnimated:(BOOL)selfAnimated;

- (void)presentViewController:(BaseViewController*)vc animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)dismissViewControllerAnimated:(BOOL)animated completion: (void (^)(void))completion;

//- (void)sendRequest:(NetWorkBaseRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail delegate:(id<ASIProgressDelegate>)delegate;
//- (void)sendRequest:(NetWorkBaseRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;
//- (void)sendRequest:(NetWorkBaseRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail showTip:(BOOL)showTip;

@end
