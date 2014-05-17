//
//  BrianMainViewController.m
//  MagicalTools
//
//  Created by 陆 文杰 on 14-4-26.
//  Copyright (c) 2014年 陆 文杰. All rights reserved.
//

#import "BrianMainViewController.h"
#import "BrianPayCountViewController.h"

@interface BrianMainViewController ()

@end

@implementation BrianMainViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gotoPayCount:(id)sender {
    BrianPayCountViewController* payCount = [[BrianPayCountViewController alloc] initWithNibName:@"BrianPayCountViewController" bundle:nil];
    
    [self.navigationController pushViewController:payCount animated:YES];
}

- (IBAction)gotoScan:(id)sender {
    BrianPayCountViewController* payCount = [[BrianPayCountViewController alloc] initWithNibName:@"BrianPayCountViewController" bundle:nil];
    
    [self.navigationController pushViewController:payCount animated:YES];
}

@end
