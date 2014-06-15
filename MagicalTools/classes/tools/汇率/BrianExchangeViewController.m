//
//  BrianExchangeViewController.m
//  MagicalTools
//
<<<<<<< HEAD
//  Created by 陆 文杰 on 14-5-24.
=======
//  Created by Brian on 14-5-23.
>>>>>>> FETCH_HEAD
//  Copyright (c) 2014年 陆 文杰. All rights reserved.
//

#import "BrianExchangeViewController.h"
<<<<<<< HEAD
=======
#import "BrianExchangeTableViewCell.h"
>>>>>>> FETCH_HEAD

@interface BrianExchangeViewController ()

@end

@implementation BrianExchangeViewController

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
<<<<<<< HEAD
=======
    
    [self initData];
    [self initView];
>>>>>>> FETCH_HEAD
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

<<<<<<< HEAD
=======
- (void)initData
{
    
}

- (void)initView
{
    [self.navigationBar setTitle:@"汇率"];
    
    [self.tableView setFrame:CGRectMake(0,self.startY + Navigation_Height, 320, __dataSource.viewHeight - 64)];
    
    [self.navigationBar addBackButtonWithTarget:self action:@selector(backButton:)];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return @"常用";
        }
            break;
        case 1:
        {
            return @"亚洲";
        }
            break;
        case 2:
        {
            return @"欧洲";
        }
            break;
    }
    
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellID = @"BrianExchangeTableViewCell";
    
    BrianExchangeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] objectAtIndex:0];
    }
    
    cell.tag = indexPath.section * 100 + indexPath.row;
    
    return cell;
}

>>>>>>> FETCH_HEAD
@end
