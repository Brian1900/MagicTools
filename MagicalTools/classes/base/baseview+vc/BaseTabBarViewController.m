//
//  BaseTabBarViewController.m
//  LuShiHelper
//
//  Created by Brian on 13-12-19.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "BaseDefine.h"
#import "BaseViewController.h"
//#import "BaiduMobStat.h"
//#import "gm86SettingViewController.h"

@interface BaseTabBarViewController ()

//背景图片
@property (nonatomic,strong) UIImageView* tabBarImageView;

//tabBar buttons
@property (nonatomic,strong) NSMutableArray* tabBarButtons;
@property (nonatomic,strong) UIButton* currentButton;

@end

@implementation BaseTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (self.navigationController) {
        self.navigationVC = (BaseNavigationController *)self.navigationController;
    }
    
    [self initData];
    [self initView];
}

- (id)init
{
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortraitUpsideDown;
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

#pragma mark - private method

- (void)tabBarSelect:(UIButton*)button
{
    if (_baseTabBarDelegate && [_baseTabBarDelegate respondsToSelector:@selector(baseTabBarViewController:selectIndex:)]) {
        [_baseTabBarDelegate baseTabBarViewController:self selectIndex:button.tag];
    }
    self.selectedIndex = button.tag;
    
    NSString* count = @"tab_btn_video";
    switch (button.tag) {
        case 0:
        {
            count = @"tab_btn_home";
        }
            break;
        case 1:
        {
            count = @"tab_btn_card";
        }
            break;
        case 2:
        {
            count = @"tab_btn_info";
        }
            break;
        case 3:
        {
            count = @"tab_btn_gl";
        }
            break;
        default:
            break;
    }
    
    for (int i=0; i<[_tabBarButtons count]; i++) {
        UIButton* tempButton = [_tabBarButtons objectAtIndex:i];
        [tempButton setImage:[_tabBarImages objectAtIndex:i] forState:UIControlStateNormal];
    }
    
    [button setImage:[_tabBarSelectedImages objectAtIndex:self.selectedIndex] forState:UIControlStateNormal];
}

- (void)initView
{
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    if (!_tabBarView) {
        _tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - tabBar_bottom_height, self.view.frame.size.width, tabBar_bottom_height)];
        _tabBarView.backgroundColor = [UIColor clearColor];
        
        if (!_tabBarImageView) {
            _tabBarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, tabBar_bottom_height)];
            _tabBarImageView.backgroundColor = [UIColor clearColor];
            [_tabBarView addSubview:_tabBarImageView];
        }
        
//        [_tabBarView setHidden:YES];
        
        [self.view addSubview:_tabBarView];
    }
    
    [self.tabBar setHidden:YES];
    self.hidesBottomBarWhenPushed = YES;
}

- (void)initData
{
    
}

- (void)setViewControllers:(NSArray *)newViewControllers
{
    super.viewControllers = newViewControllers;
    
    if (_tabBarButtons) {
        for (UIButton* button in _tabBarButtons) {
            [button removeFromSuperview];
        }
        _tabBarButtons = nil;
    }
    _tabBarButtons = [NSMutableArray arrayWithCapacity:1];
    
    NSInteger perWidth = self.view.frame.size.width/[self.viewControllers count];
    for (int i = 0;i < [self.viewControllers count]; i++) {
        BaseNavigationController* navVC = (BaseNavigationController*)[self.viewControllers objectAtIndex:i];
        BaseViewController* baseVC = (BaseViewController*)[navVC topViewController];
//        baseVC.mainTabBarVC = self;
        
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(perWidth * i, 0, perWidth, tabBar_bottom_height)];
        button.backgroundColor = [UIColor clearColor];
        button.tag = i;
        
        [button addTarget:self action:@selector(tabBarSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        [_tabBarView addSubview:button];
        [_tabBarButtons addObject:button];
        
        if (i == 0 && _tabBarSelectedImages) {
            [button setImage:[_tabBarSelectedImages objectAtIndex:i] forState:UIControlStateNormal];
        }
    }
}

- (void)setTabBarImages:(NSArray *)tabBarImages
{
    if (!_tabBarButtons || [tabBarImages count] != [_tabBarButtons count]) {
//        return;
    }
    
    _tabBarImages = tabBarImages;
    
    if (_tabBarButtons) {
        for (int i = 0 ; i < [_tabBarButtons count] ; i++) {
            UIButton* button = [_tabBarButtons objectAtIndex:i];
            [button setImage:[_tabBarImages objectAtIndex:i] forState:UIControlStateNormal];
        }
    }
}

- (void)setTabBarHighLightedImages:(NSArray *)tabBarHighLightedImages
{
    if (!_tabBarButtons || [tabBarHighLightedImages count] != [_tabBarButtons count]) {
//        return;
    }
    
    _tabBarHighLightedImages = tabBarHighLightedImages;
    
    if (_tabBarButtons) {
        for (int i = 0 ; i < [_tabBarButtons count] ; i++) {
            UIButton* button = [_tabBarButtons objectAtIndex:i];
            [button setImage:[_tabBarHighLightedImages objectAtIndex:i] forState:UIControlStateHighlighted];
        }
    }
}

- (void)setTabBarSelectedImages:(NSArray *)tabBarSelectedImages
{
    if (!_tabBarButtons || [tabBarSelectedImages count] != [_tabBarButtons count]) {
//        return;
    }
    
    _tabBarSelectedImages = tabBarSelectedImages;
    
    if (_tabBarButtons) {
        for (int i = 0 ; i < [_tabBarButtons count] ; i++) {
            UIButton* button = [_tabBarButtons objectAtIndex:i];
//            [button setImage:[_tabBarSelectedImages objectAtIndex:i] forState:UIControlStateSelected];
            
            if (i == 0) {
                [button setImage:[_tabBarSelectedImages objectAtIndex:i] forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark - public method
- (void)setBackgroundImage:(UIImage*)image
{
    [_tabBarImageView setImage:image];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

@end
