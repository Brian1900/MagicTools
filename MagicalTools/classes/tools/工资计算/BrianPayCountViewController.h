//
//  BrianPayCountViewController.h
//  MagicalTools
//
//  Created by 陆 文杰 on 14-4-26.
//  Copyright (c) 2014年 陆 文杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "BrianDataSource.h"

@interface BrianPayCountViewController : BaseViewController
{
    NSInteger selectCityIndex;
    BrianCityData* currentModel;
}

#pragma mark - city
@property (strong, nonatomic) IBOutlet UITableViewCell* cityCell;

@property (strong, nonatomic) IBOutlet UIButton* cityButton;
@property (strong, nonatomic) IBOutlet UITableView* tableView;

@property (strong, nonatomic) IBOutlet UITextField *beforMoney;
@property (strong, nonatomic) IBOutlet UITextField *afterMoney;

#pragma mark - detail
@property (strong, nonatomic) IBOutlet UITableViewCell* detailCell;

@property (strong, nonatomic) IBOutlet UIView* detailView;

@property (strong, nonatomic) IBOutlet UIButton* selfOldButton;
@property (strong, nonatomic) IBOutlet UIButton* comOldButton;

@property (strong, nonatomic) IBOutlet UIButton* selfMedButton;
@property (strong, nonatomic) IBOutlet UIButton* comMedButton;

@property (strong, nonatomic) IBOutlet UIButton* selfJobButton;
@property (strong, nonatomic) IBOutlet UIButton* comJobButton;

@property (strong, nonatomic) IBOutlet UIButton* comHurtButton;

@property (strong, nonatomic) IBOutlet UIButton* comBirthButton;

@property (strong, nonatomic) IBOutlet UIButton* selfHouseButton;
@property (strong, nonatomic) IBOutlet UIButton* comHouseButton;

#pragma mark - setting
@property (strong, nonatomic) IBOutlet UITableViewCell* settingCell;

@property (strong, nonatomic) IBOutlet UIView* settingView;

@property (strong, nonatomic) IBOutlet UITextField *baseSecurity;
@property (strong, nonatomic) IBOutlet UITextField *baseHouse;
@property (strong, nonatomic) IBOutlet UITextField *baseRevenue;
@property (strong, nonatomic) IBOutlet UITextField *paidRevenue;

#pragma mark - other
@property (strong, nonatomic) IBOutlet UIView *selectView;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@end
