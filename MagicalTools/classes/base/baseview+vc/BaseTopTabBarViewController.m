//
//  BaseTopTabBarViewController.m
//  LuShiHelper
//
//  Created by Brian on 13-12-20.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "BaseTopTabBarViewController.h"
#import "BaseDefine.h"

@interface BaseTopTabBarViewController ()

//背景图片
@property (nonatomic,strong) UIImageView* tabBarImageView;

//tabBar View
@property (nonatomic,strong) UIView* tabBarView;

//tabBar ScrollView
@property (nonatomic,strong) UIScrollView* tabBarScrollView;

//tabBar buttons
@property (nonatomic,strong) NSMutableArray* tabBarButtons;

//tabBar高度
@property (nonatomic,assign) NSInteger tabBarHeight;

@end

@implementation BaseTopTabBarViewController

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
    
    [self initData];
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - private method

- (void)tabBarSelect:(UIButton*)button
{
    if (_baseTabBarDelegate && [_baseTabBarDelegate respondsToSelector:@selector(baseTopTabBarViewController:selectIndex:)]) {
        [_baseTabBarDelegate baseTopTabBarViewController:self selectIndex:button.tag];
    }
    self.selectedIndex = button.tag;
}

- (void)initView
{
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    if (!_tabBarView) {
        _tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, naviBar_Top_hieght, self.view.frame.size.width, tabBar_Top_height)];
        _tabBarView.backgroundColor = [UIColor whiteColor];
        
        if (!_tabBarImageView) {
            _tabBarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, tabBar_Top_height)];
            _tabBarImageView.backgroundColor = [UIColor whiteColor];
            [_tabBarView addSubview:_tabBarImageView];
        }
        
        if (!_tabBarScrollView) {
            _tabBarScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, tabBar_Top_height)];
            _tabBarScrollView.backgroundColor = [UIColor redColor];
            _tabBarScrollView.showsVerticalScrollIndicator = NO;
            [_tabBarView addSubview:_tabBarScrollView];
        }
        
        [_tabBarView setHidden:YES];
        [self.view addSubview:_tabBarView];
    }
    
    [self.tabBar setHidden:YES];
}

- (void)initData
{
    _tabBarHeight = tabBar_Top_height;
}

- (void)setViewControllers:(NSArray *)newViewControllers
{
    super.viewControllers = newViewControllers;
    
    for (int i = 0; i<[newViewControllers count]; i++) {
        UIViewController* vc = [newViewControllers objectAtIndex:i];
        
        PrintRect(vc.view.frame);
        
        [vc.view setFrame:self.view.frame];
        
        PrintRect(vc.view.frame);
    }
    
    if (_tabBarButtons) {
        for (UIButton* button in _tabBarButtons) {
            [button removeFromSuperview];
        }
        _tabBarButtons = nil;
    }
    _tabBarButtons = [NSMutableArray arrayWithCapacity:1];
    
    for (int i = 0;i < [self.viewControllers count]; i++) {
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(tabBar_Top_width * i, 0, tabBar_Top_width, tabBar_Top_height)];
        //        button.backgroundColor = [UIColor clearColor];
        button.backgroundColor = [UIColor colorWithRed:i*0.1 green:i*0.1 blue:i*0.1 alpha:1];
        button.tag = i;
        
        [button addTarget:self action:@selector(tabBarSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        [_tabBarScrollView addSubview:button];
        [_tabBarButtons addObject:button];
    }
    
    [_tabBarScrollView setContentSize:CGSizeMake(tabBar_Top_width*[self.viewControllers count], tabBar_Top_height)];
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

@end
