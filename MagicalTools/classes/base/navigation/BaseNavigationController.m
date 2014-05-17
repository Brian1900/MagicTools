//
//  BaseNavigationController.m
//  BaseProject
//
//  Created by 陆 文杰 on 13-9-23.
//  Copyright (c) 2013年 陆 文杰. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

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
    
    self.view.backgroundColor = [UIColor clearColor];
    
//    [self.view setFrame:[UIScreen mainScreen].bounds];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
//    if (self) {
//        [rootViewController.view removeFromSuperview];
//    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    UIView *view =  _containerView;
    //    UIView *view =  [self valueForKey:@"containerView"];;
    //    for (UIView *subView in [view subviews]) {
    //        [subView removeFromSuperview];
    //    }
    //    UIViewController *vc = [self.viewControllers objectAtIndex:[self.viewControllers count]-1];
    //    [vc.view removeFromSuperview];
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([self.topViewController isKindOfClass:NSClassFromString(@"gm86InfoDetailViewController")]) {
        return [self.topViewController supportedInterfaceOrientations];
    }else{
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

@end
