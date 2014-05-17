//
//  BrianPayCountViewController.h
//  MagicalTools
//
//  Created by 陆 文杰 on 14-4-26.
//  Copyright (c) 2014年 陆 文杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrianPayItemCell.h"
#import "BaseViewController.h"

@interface BrianPayCountViewController : BaseViewController<BrianPayItemDelegate>
{
    NSArray* nameArray;
    NSArray* currentArray;
    NSInteger selectCityIndex;
    BOOL openOld;
    BOOL openMed;
    BOOL openJob;
    BOOL openHurt;
    BOOL openBirth;
    BOOL openHouse;
}

@property (strong, nonatomic) IBOutlet UIButton* cityButton;
@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) IBOutlet UITextField *beforMoney;
@property (strong, nonatomic) IBOutlet UITextField *afterMoney;
@property (strong, nonatomic) IBOutlet UIView *selectView;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@end
