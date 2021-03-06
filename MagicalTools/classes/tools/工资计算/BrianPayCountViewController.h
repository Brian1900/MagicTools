//
//  BrianPayCountViewController.h
//  MagicalTools
//
//  Created by 陆 文杰 on 14-4-26.
//  Copyright (c) 2014年 陆 文杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef enum {
    ePickerTypeSelfOld = 0,
    ePickerTypeSelfMed = 1,
    ePickerTypeSelfJob = 2,
    ePickerTypeSelfHouse = 3,
    
    ePickerTypeComOld = 4,
    ePickerTypeComMen = 5,
    ePickerTypeComJob = 6,
    ePickerTypeComHurt = 7,
    ePickerTypeComBirth = 8,
    ePickerTypeComHouse = 9
}ePickerType;

@interface BrianPayCountViewController : BaseViewController
{
    NSInteger selectCityIndex;
    BrianCityData* currentModel;
    BOOL detialOpen;
    BOOL settingOpen;
    
    NSInteger pickerType; //0:城市 1：百分比
    ePickerType pickPercentType;
    UIButton* currentPercnetButton;
}

@property (strong, nonatomic) IBOutlet UITableView* tableView;

#pragma mark - city
@property (strong, nonatomic) IBOutlet UITableViewCell* cityCell;

@property (strong, nonatomic) IBOutlet UIButton* cityButton;

@property (strong, nonatomic) IBOutlet UITextField *beforMoney;
@property (strong, nonatomic) IBOutlet UILabel *afterMoney;
@property (strong, nonatomic) IBOutlet UILabel *paidRevenue;

#pragma mark - detail
@property (strong, nonatomic) IBOutlet UITableViewCell* detailCell;

@property (strong, nonatomic) IBOutlet UIButton* oldCheckButton;
@property (strong, nonatomic) IBOutlet UIButton* medCheckButton;
@property (strong, nonatomic) IBOutlet UIButton* jobCheckButton;
@property (strong, nonatomic) IBOutlet UIButton* hurtCheckButton;
@property (strong, nonatomic) IBOutlet UIButton* birthCheckButton;
@property (strong, nonatomic) IBOutlet UIButton* houseCheckButton;

@property (strong, nonatomic) IBOutlet UIView* detailView;

@property (strong, nonatomic) IBOutlet UILabel* allSelfMoney;
@property (strong, nonatomic) IBOutlet UILabel* allComMoney;

@property (strong, nonatomic) IBOutlet UIButton* selfOldButton;
@property (strong, nonatomic) IBOutlet UILabel* selfOldMoney;
@property (strong, nonatomic) IBOutlet UIButton* comOldButton;
@property (strong, nonatomic) IBOutlet UILabel* comOldMoney;

@property (strong, nonatomic) IBOutlet UIButton* selfMedButton;
@property (strong, nonatomic) IBOutlet UILabel* selfMedMoney;
@property (strong, nonatomic) IBOutlet UIButton* comMedButton;
@property (strong, nonatomic) IBOutlet UILabel* comMedMoney;

@property (strong, nonatomic) IBOutlet UIButton* selfJobButton;
@property (strong, nonatomic) IBOutlet UILabel* selfJobMoney;
@property (strong, nonatomic) IBOutlet UIButton* comJobButton;
@property (strong, nonatomic) IBOutlet UILabel* comJobMoney;

@property (strong, nonatomic) IBOutlet UIButton* comHurtButton;
@property (strong, nonatomic) IBOutlet UILabel* comHurtMoney;

@property (strong, nonatomic) IBOutlet UIButton* comBirthButton;
@property (strong, nonatomic) IBOutlet UILabel* comBirthMoney;

@property (strong, nonatomic) IBOutlet UIButton* selfHouseButton;
@property (strong, nonatomic) IBOutlet UILabel* selfHouseMoney;
@property (strong, nonatomic) IBOutlet UIButton* comHouseButton;
@property (strong, nonatomic) IBOutlet UILabel* comHouseMoney;

#pragma mark - setting
@property (strong, nonatomic) IBOutlet UITableViewCell* settingCell;

@property (strong, nonatomic) IBOutlet UIView* settingView;

@property (strong, nonatomic) IBOutlet UITextField *baseSecurity;
@property (strong, nonatomic) IBOutlet UITextField *baseHouse;
@property (strong, nonatomic) IBOutlet UITextField *baseRevenue;
@property (strong, nonatomic) IBOutlet UILabel *basePaidRevenue;

#pragma mark - other
@property (strong, nonatomic) IBOutlet UIView *selectView;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@property (strong, nonatomic) IBOutlet UIImageView* detailArrow;
@property (strong, nonatomic) IBOutlet UIImageView* settingArrow;

@end
