//
//  BaseViewController.m
//  BaseProject
//
//  Created by 陆 文杰 on 13-9-23.
//  Copyright (c) 2013年 陆 文杰. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTabViewController.h"
//#import "gm86MainViewController.h"
#import "BaseTableView.h"
#import "BrianDataSource.h"
//#import "BaiduMobStat.h"
//#import "MainViewController.h"
#import "BaseTouchDisappearView.h"

@implementation BaseViewController

@synthesize navigationBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [[BaiduMobStat defaultStat] pageviewStartWithName:NSStringFromClass([self class])];
    
//    [self.view setBounds:[UIScreen mainScreen].bounds];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
//    [[BaiduMobStat defaultStat] pageviewEndWithName:NSStringFromClass([self class])];
}

- (void)regNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)unregNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.view setBounds:[UIScreen mainScreen].bounds];
    
//    self.view.clipsToBounds = NO;
    
    if (self.isModelView) {
        self.view.backgroundColor = [UIColor whiteColor];
    }else{
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    if (self.navigationController) {
        self.navigationVC = (BaseNavigationController *)self.navigationController;
    }
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    self.view.clipsToBounds = NO;
    
    self.startY = 0;
    if (self.isModelView) {
        self.startY = 0;
    }
    if (__dataSource.version >= 7.0) {
        self.startY = 20;
    }

    if (!navigationBar) {
        navigationBar = [[BaseNavigationBar alloc] initWithFrame:CGRectMake(0, self.startY, self.view.bounds.size.width, Navigation_Height)];
        [navigationBar setBackgroundColor:[UIColor whiteColor]];
        [navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_nav.png"]];
        [self.view addSubview:navigationBar];
    }
    
//    if(!_httpEngine)
//    {
//        _httpEngine = [[LSHHTTPEngine alloc] init];
//    }
}

- (void)viewTapped:(UITapGestureRecognizer*)tap
{
    
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return YES;
//}
//
//-(BOOL)shouldAutorotate
//{
//    return YES;
//}

#pragma mark - method
- (IBAction)backButton:(id)sender
{
    [self popViewControllerAnimated:YES selfAnimated:YES];
}

- (void)closePre
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)setNavTitle:(NSString *)title
{
    [self.navigationBar setTitle:title];
}

- (void)showStatusTip:(NSString*)tipText
{
    [WTStatusBar setStatusText:tipText timeout:1 animated:YES];
}

- (void)showTip:(NSString*)tip
{
    BaseTipView* tipView = [[[NSBundle mainBundle] loadNibNamed:@"BaseTipView" owner:nil options:nil] objectAtIndex:0];
    
    tipView.tipDestription.text = tip;
    
    NSInteger height = 480;
    if (__dataSource.isIphone5) {
        height = 568;
    }
    
    CGRect rect = tipView.frame;
    rect.size.height = height;
    [tipView setFrame:rect];
    
    [self.view addSubview:tipView];
}

- (void)showTip:(NSString*)tip buttonText:(NSString*)buttonText
{
    BaseTipView* tipView = [[[NSBundle mainBundle] loadNibNamed:@"BaseTipView" owner:nil options:nil] objectAtIndex:0];
    
    tipView.tipDestription.text = tip;
    tipView.buttonText = buttonText;
    tipView.delegate = self;
    
    NSInteger height = 480;
    if (__dataSource.isIphone5) {
        height = 568;
    }
    
    CGRect rect = tipView.frame;
    rect.size.height = height;
    [tipView setFrame:rect];
    
    [self.view addSubview:tipView];
}

- (void)showChoose:(NSString*)chooseClassName tag:(NSInteger)tag UpText:(NSString*)upText upTag:(NSInteger)upTag downText:(NSString*)downText downTag:(NSInteger)downTag
{
    BaseChooseView* choose = [[[NSBundle mainBundle] loadNibNamed:chooseClassName owner:nil options:nil] objectAtIndex:0];
    choose.tag = tag;
    choose.delegate = self;
    
    [choose setUpText:upText upTag:upTag downText:downText downTag:downTag];
    
    [self.view addSubview:choose];
}

- (void)pushViewController:(BaseViewController*)vc animated:(BOOL)animated selfAnimated:(BOOL)selfAnimated
{
    vc.lastViewController = self;
    self.nextViewController = vc;
    
    vc.navigationVC = self.navigationVC;
    
    [self.navigationVC pushViewController:vc animated:animated];
}

- (void)popViewControllerAnimated:(BaseViewController*)vc animated:(BOOL)animated selfAnimated:(BOOL)selfAnimated
{
    [self.navigationVC popToViewController:vc animated:animated];
}

- (void)popViewControllerAnimated:(BOOL)animated selfAnimated:(BOOL)selfAnimated
{
    [self.navigationVC popViewControllerAnimated:animated];
}

- (void)popToRootViewControllerAnimated:(BOOL)animated selfAnimated:(BOOL)selfAnimated
{
    [self.navigationVC popToRootViewControllerAnimated:animated];
}

//- (void)presentViewController:(BaseViewController*)vc animated:(BOOL)flag completion:(void (^)(void))completion
//{
//    BaseNavigationController* nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
//    
//    vc.navigationVC = nav;
//    
//    [self.navigationVC presentViewController:vc animated:flag completion:completion];
//}

//- (void)dismissViewControllerAnimated:(BOOL)animated completion: (void (^)(void))completion
//{
//    [self.navigationVC dismissViewControllerAnimated:YES completion:completion];
//}

- (void)setTitleImageView:(UIImage *)image
{
    [self.navigationBar setTitleImage:image];
}

//- (void)success:(id)sender success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
//{
//    success(sender);
//}
//
//- (void)fail:(id)sender success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail showTip:(BOOL)showTip
//{
//    if (!sender) {
//        [self ShowNetError];
//    }else if([sender isKindOfClass:NSClassFromString(@"NetWorkBaseResponse")]){
//        NetWorkBaseResponse* response = sender;
//        [self showTip:response.errorMessage];
//    }
//    
//    fail(sender);
//}
//
//- (void)sendRequest:(NetWorkBaseRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail delegate:(id<ASIProgressDelegate>)delegate
//{
//    if ([request isKindOfClass:NSClassFromString(@"gm8613NewsManagerRequest")]) {
//        [self.httpEngine sendNewsManager:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            fail(sender);
//        } delegate:delegate];
//    }
//}
//
//- (void)sendRequest:(NetWorkBaseRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
//{
//    [self sendRequest:request success:success fail:fail showTip:YES];
//}
//
//- (void)sendRequest:(NetWorkBaseRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail showTip:(BOOL)showTip
//{
//    lastRequest = request;
//    lastSuccessMethod = success;
//    lastFailMethod = fail;
//    lastTip = showTip;
//    
//    //1-9
//    
//    if ([request isKindOfClass:NSClassFromString(@"gm861ClientUpdateRequest")]) {
//        [self.httpEngine sendUpdate:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm862_2GetVerifyImageRequest")]) {
//        [self.httpEngine sendGetVerifyImage:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm862SendVerifyRequest")]) {
//        [self.httpEngine sendSendVerify:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm863VerifyRequest")]) {
//        [self.httpEngine sendVerify:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm864RegistRequest")]) {
//        [self.httpEngine sendRegist:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm864_2NicknameCheckRequest")]) {
//        [self.httpEngine sendNicknameCheck:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm865LoginRequest")]) {
//        [self.httpEngine sendLogin:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm865_2LoginRequest")]) {
//        [self.httpEngine sendThirdLogin:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm866SetPasswordRequest")]) {
//        [self.httpEngine sendSetPassword:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm867RecommendElementRequest")]) {
//        [self.httpEngine sendRecommendElement:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm868SendElementRequest")]) {
//        [self.httpEngine sendSendElement:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm869RecommendAttRequest")]) {
//        [self.httpEngine sendRecommendAtt:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }
//    
//    
//    //10-19
//    
//    
//    else if ([request isKindOfClass:NSClassFromString(@"gm8610_2AttListRequest")]) {
//        [self.httpEngine sendAttList:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm8610AttManagerRequest")]) {
//        [self.httpEngine sendAttManager:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm8611HotTagRequest")]) {
//        [self.httpEngine sendHotTag:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm8612SelfSettingRequest")]) {
//        [self.httpEngine sendSelfSetting:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm8614NewsRequest")]) {
//        [self.httpEngine sendNews:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm8615ZanRequest")]) {
//        [self.httpEngine sendZan:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm8616ColManagerRequest")]) {
//        [self.httpEngine sendColManager:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm8617PersonDetailRequest")]) {
//        [self.httpEngine sendPersonDetail:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm8618CommentListRequest")]) {
//        [self.httpEngine sendCommentList:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm8619CommentManagerRequest")]) {
//        [self.httpEngine sendCommentManager:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }
//    
//    //20-29
//    
//    else if ([request isKindOfClass:NSClassFromString(@"gm8620SearchRequest")]) {
//        [self.httpEngine sendSearch:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm8621InviteFriendsRequest")]) {
//        [self.httpEngine sendInviteFriends:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm8622PushSettingRequest")]) {
//        [self.httpEngine sendPushSetting:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm8622_2PushSettingRequest")]) {
//        [self.httpEngine sendPushSettingtwo:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm8623MessageManagerRequest")]) {
//        [self.httpEngine sendMessageManager:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm8624GameRecommendRequest")]) {
//        [self.httpEngine sendGameRecommend:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm8625FocusFigureRequest")]) {
//        [self.httpEngine sendFocusFigure:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm8626ClassificationRequest")]) {
//        [self.httpEngine sendClassification:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm8627ScreeningRequest")]) {
//        [self.httpEngine sendScreening:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm8628GameDetailRequest")]) {
//        [self.httpEngine sendGameDetail:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm8629SearchGameRequest")]) {
//        [self.httpEngine sendSearchGame:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }
//    
//    //30-31
//    else if ([request isKindOfClass:NSClassFromString(@"gm8630CollectManagerRequest")]) {
//        [self.httpEngine sendCollectGameManager:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }else if ([request isKindOfClass:NSClassFromString(@"gm8631MyCollectGamesRequest")]) {
//        [self.httpEngine sendMyCollectGame:request success:^(id sender) {
//            [self success:sender success:success fail:fail];
//        } fail:^(id sender) {
//            [self fail:sender success:success fail:fail showTip:showTip];
//        }];
//    }
//}
//
//- (void)sendAgain
//{
//    [self sendRequest:lastRequest success:lastSuccessMethod fail:lastFailMethod];
//}

@end
