//
//  BrianPayCountViewController.m
//  MagicalTools
//
//  Created by 陆 文杰 on 14-4-26.
//  Copyright (c) 2014年 陆 文杰. All rights reserved.
//

#import "BrianPayCountViewController.h"

@interface BrianPayCountViewController ()

@end

@implementation BrianPayCountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        detialOpen = YES;
        settingOpen = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initData];
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData
{
    selectCityIndex = 0;
    
    [self setCurrentCity:selectCityIndex];
}

- (void)initView
{
    [self.navigationBar setTitle:@"工资计算器"];
    
    [self.tableView setFrame:CGRectMake(0,self.startY + Navigation_Height, 320, __dataSource.viewHeight - 64)];
    
    [self.navigationBar addBackButtonWithTarget:self action:@selector(backButton:)];
}

- (void)setCurrentCity:(NSInteger)cityIndex
{
    currentModel = [__dataSource.dataManager.cityDatas objectAtIndex:selectCityIndex];
    
    if ([self.beforMoney.text integerValue] != 0) {
        [self startCount:nil];
    }
}

- (IBAction)chooseCity:(id)sender {
    [self.selectView setHidden:NO];
    self.pickerView.tag = 1;
}

- (IBAction)startCount:(id)sender {
    [self.beforMoney resignFirstResponder];
    [self.afterMoney resignFirstResponder];
    
    if ([self.beforMoney.text integerValue] == 0) {
        return ;
    }
    
    [self countMoney:[NSDecimalNumber decimalNumberWithString:self.beforMoney.text]];
    [self refreshView];
    
    self.afterMoney.text = [NSString stringWithFormat:@"%.2lf",[currentModel.salaryAfter doubleValue]];
}

- (IBAction)showMore:(UIButton*)button {
    if (button.tag == 1) {
        detialOpen = !detialOpen;
    }
    
    if (button.tag == 2) {
        settingOpen = !settingOpen;
    }
    
    [self.tableView reloadData];
}

- (IBAction)cancelSelectCity:(id)sender {
    [self.selectView setHidden:YES];
}

- (IBAction)selectCity:(id)sender {
    selectCityIndex = [self.pickerView selectedRowInComponent:0];
    [self setCurrentCity:selectCityIndex];
    
    [self.cityButton setTitle:currentModel.cityName forState:UIControlStateNormal];
    [self.tableView reloadData];
    [self.selectView setHidden:YES];
}

- (void)countMoney:(NSDecimalNumber*)money
{
    NSDecimalNumber* result = [NSDecimalNumber decimalNumberWithString:@"0"];
    
    [currentModel reset];
    
    if ([money doubleValue] > [currentModel.minSecurity doubleValue] && [money doubleValue] < [currentModel.maxSecurity doubleValue]) {
        currentModel.baseSecurity = money;
        currentModel.baseHouse = money;
    }else if([money doubleValue] > [currentModel.maxSecurity doubleValue]){
        currentModel.baseSecurity = currentModel.maxHouse;
        currentModel.baseHouse = currentModel.maxHouse;
    }
    
    currentModel.salaryBefore = money;
    
    if (self.oldCheckButton.selected) {
        currentModel.selfPaidOld = [currentModel.baseSecurity decimalNumberByMultiplyingBy:currentModel.selfOld];
        currentModel.comPaidOld = [currentModel.baseSecurity decimalNumberByMultiplyingBy:currentModel.comOld];
    }else{
        currentModel.selfPaidOld = [NSDecimalNumber decimalNumberWithString:@"0"];
        currentModel.comPaidOld = [NSDecimalNumber decimalNumberWithString:@"0"];
    }
    
    if (self.medCheckButton.selected) {
        currentModel.selfPaidMed = [currentModel.baseSecurity decimalNumberByMultiplyingBy:currentModel.selfMed];
        currentModel.comPaidMed = [currentModel.baseSecurity decimalNumberByMultiplyingBy:currentModel.comMed];
    }else{
        currentModel.selfPaidMed = [NSDecimalNumber decimalNumberWithString:@"0"];
        currentModel.comPaidMed = [NSDecimalNumber decimalNumberWithString:@"0"];
    }
    
    if (self.jobCheckButton.selected) {
        currentModel.selfPaidJob = [currentModel.baseSecurity decimalNumberByMultiplyingBy:currentModel.selfJob];
        currentModel.comPaidJob = [currentModel.baseSecurity decimalNumberByMultiplyingBy:currentModel.comJob];
    }else{
        currentModel.selfPaidJob = [NSDecimalNumber decimalNumberWithString:@"0"];
        currentModel.comPaidJob = [NSDecimalNumber decimalNumberWithString:@"0"];
    }
    
    if (self.hurtCheckButton.selected) {
        currentModel.selfPaidHurt = [currentModel.baseSecurity decimalNumberByMultiplyingBy:currentModel.selfHurt];
        currentModel.comPaidHurt = [currentModel.baseSecurity decimalNumberByMultiplyingBy:currentModel.comHurt];
    }else{
        currentModel.selfPaidHurt = [NSDecimalNumber decimalNumberWithString:@"0"];
        currentModel.comPaidHurt = [NSDecimalNumber decimalNumberWithString:@"0"];
    }
    
    if (self.birthCheckButton.selected) {
        currentModel.selfPaidBirth = [currentModel.baseSecurity decimalNumberByMultiplyingBy:currentModel.selfBirth];
        currentModel.comPaidBirth = [currentModel.baseSecurity decimalNumberByMultiplyingBy:currentModel.comBirth];
    }else{
        currentModel.selfPaidBirth = [NSDecimalNumber decimalNumberWithString:@"0"];
        currentModel.comPaidBirth = [NSDecimalNumber decimalNumberWithString:@"0"];
    }
    
    if (self.houseCheckButton.selected) {
        currentModel.selfPaidHouse = [currentModel.baseHouse decimalNumberByMultiplyingBy:currentModel.selfHouse];
        currentModel.comPaidHouse = [currentModel.baseHouse decimalNumberByMultiplyingBy:currentModel.comHouse];
    }else{
        currentModel.selfPaidHouse = [NSDecimalNumber decimalNumberWithString:@"0"];
        currentModel.comPaidHouse = [NSDecimalNumber decimalNumberWithString:@"0"];
    }
    
    result = [[[[[[money decimalNumberBySubtracting:currentModel.selfPaidOld] decimalNumberBySubtracting: currentModel.selfPaidMed] decimalNumberBySubtracting:currentModel.selfPaidJob] decimalNumberBySubtracting:currentModel.selfPaidHurt] decimalNumberBySubtracting:currentModel.selfPaidBirth] decimalNumberBySubtracting:currentModel.selfPaidHouse];
    
    currentModel.paidTax = [self countTax:result];
    
    currentModel.salaryAfter = [result decimalNumberBySubtracting:currentModel.paidTax] ;
}

- (void)refreshView
{
    //输入
    self.afterMoney.text = [NSString stringWithFormat:@"%.2f",[currentModel.salaryAfter doubleValue]];
    
    self.paidRevenue.text = [NSString stringWithFormat:@"%.2f",[currentModel.paidTax doubleValue]];
    
    //详情
    self.allSelfMoney.text = [NSString stringWithFormat:@"%.2f",[[[[[currentModel.selfPaidOld decimalNumberByAdding:currentModel.selfPaidMed] decimalNumberByAdding:currentModel.selfPaidMed] decimalNumberByAdding:currentModel.selfPaidJob] decimalNumberByAdding:currentModel.selfPaidHouse] doubleValue]];
    
    self.allComMoney.text = [NSString stringWithFormat:@"%.2f",[[[[[[currentModel.comPaidOld decimalNumberByAdding: currentModel.comPaidMed] decimalNumberByAdding: currentModel.comPaidJob] decimalNumberByAdding: currentModel.comPaidHurt] decimalNumberByAdding: currentModel.comPaidBirth] decimalNumberByAdding: currentModel.comPaidHouse] doubleValue]];
    
//    if (self.oldCheckButton.selected) {
        self.selfOldMoney.text = [NSString stringWithFormat:@"%.2f",[currentModel.selfPaidOld doubleValue]];
        [self.selfOldButton setTitle:[NSString stringWithFormat:@"%.1f%%",[[currentModel.selfOld decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]] doubleValue]] forState:UIControlStateNormal];
        self.comOldMoney.text = [NSString stringWithFormat:@"%.2f",[currentModel.comPaidOld doubleValue]];
        [self.comOldButton setTitle:[NSString stringWithFormat:@"%.1f%%",[[currentModel.comOld decimalNumberByMultiplyingBy: [NSDecimalNumber decimalNumberWithString:@"100"]] doubleValue]] forState:UIControlStateNormal];
//    }else{
//        self.selfOldMoney.text = @"0";
//        [self.selfOldButton setTitle:[NSString stringWithFormat:@"%.1f%%",[[currentModel.selfOld decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]] doubleValue]] forState:UIControlStateNormal];
//        self.comOldMoney.text = @"0";
//        [self.comOldButton setTitle:[NSString stringWithFormat:@"%.1f%%",[[currentModel.comOld decimalNumberByMultiplyingBy: [NSDecimalNumber decimalNumberWithString:@"100"]] doubleValue]] forState:UIControlStateNormal];
//    }
    
//    if (self.medCheckButton.selected) {
        self.selfMedMoney.text = [NSString stringWithFormat:@"%.2f",[currentModel.selfPaidMed doubleValue]];
        [self.selfMedButton setTitle:[NSString stringWithFormat:@"%.1f%%",[[currentModel.selfMed decimalNumberByMultiplyingBy: [NSDecimalNumber decimalNumberWithString:@"100"]] doubleValue]] forState:UIControlStateNormal];
        self.comMedMoney.text = [NSString stringWithFormat:@"%.2f",[currentModel.comPaidMed doubleValue]];
        [self.comMedButton setTitle:[NSString stringWithFormat:@"%.1f%%",[[currentModel.comMed decimalNumberByMultiplyingBy: [NSDecimalNumber decimalNumberWithString:@"100"]] doubleValue]] forState:UIControlStateNormal];
//    }else{
//        self.selfMedMoney.text = @"0";
//        [self.selfMedButton setTitle:[NSString stringWithFormat:@"%.1f%%",[[currentModel.selfMed decimalNumberByMultiplyingBy: [NSDecimalNumber decimalNumberWithString:@"100"]] doubleValue]] forState:UIControlStateNormal];
//        self.comMedMoney.text = @"0";
//        [self.comMedButton setTitle:[NSString stringWithFormat:@"%.1f%%",[[currentModel.comMed decimalNumberByMultiplyingBy: [NSDecimalNumber decimalNumberWithString:@"100"]] doubleValue]] forState:UIControlStateNormal];
//    }
    
//    if (self.jobCheckButton.selected) {
        self.selfJobMoney.text = [NSString stringWithFormat:@"%.2f",[currentModel.selfPaidJob doubleValue]];
        [self.selfJobButton setTitle:[NSString stringWithFormat:@"%.1f%%",[[currentModel.selfJob decimalNumberByMultiplyingBy: [NSDecimalNumber decimalNumberWithString:@"100"]] doubleValue]] forState:UIControlStateNormal];
        self.comJobMoney.text = [NSString stringWithFormat:@"%.2f",[currentModel.comPaidJob doubleValue]];
        [self.comJobButton setTitle:[NSString stringWithFormat:@"%.1f%%",[[currentModel.comJob decimalNumberByMultiplyingBy: [NSDecimalNumber decimalNumberWithString:@"100"]] doubleValue]] forState:UIControlStateNormal];
//    }else{
//        self.selfJobMoney.text = @"0";
//        [self.selfJobButton setTitle:[NSString stringWithFormat:@"%.1f%%",[[currentModel.selfJob decimalNumberByMultiplyingBy: [NSDecimalNumber decimalNumberWithString:@"100"]] doubleValue]] forState:UIControlStateNormal];
//        self.comJobMoney.text = @"0";
//        [self.comJobButton setTitle:[NSString stringWithFormat:@"%.1f%%",[[currentModel.comJob decimalNumberByMultiplyingBy: [NSDecimalNumber decimalNumberWithString:@"100"]] doubleValue]] forState:UIControlStateNormal];
//    }
    
//    if (self.hurtCheckButton.selected) {
        self.comHurtMoney.text = [NSString stringWithFormat:@"%.2f",[currentModel.comPaidHurt doubleValue]];
        [self.comHurtButton setTitle:[NSString stringWithFormat:@"%.1f%%",[[currentModel.comHurt decimalNumberByMultiplyingBy: [NSDecimalNumber decimalNumberWithString:@"100"]] doubleValue]] forState:UIControlStateNormal];
//    }else{
//        self.comHurtMoney.text = @"0";
//        [self.comHurtButton setTitle:[NSString stringWithFormat:@"%.1f%%",[[currentModel.comHurt decimalNumberByMultiplyingBy: [NSDecimalNumber decimalNumberWithString:@"100"]] doubleValue]] forState:UIControlStateNormal];
//    }
    
//    if (self.birthCheckButton.selected) {
        self.comBirthMoney.text = [NSString stringWithFormat:@"%.2f",[currentModel.comPaidBirth doubleValue]];
        [self.comBirthButton setTitle:[NSString stringWithFormat:@"%.1f%%",[[currentModel.comBirth decimalNumberByMultiplyingBy: [NSDecimalNumber decimalNumberWithString:@"100"]] doubleValue]] forState:UIControlStateNormal];
//    }else{
//        self.comBirthMoney.text = @"0";
//        [self.comBirthButton setTitle:[NSString stringWithFormat:@"%.1f%%",[[currentModel.comBirth decimalNumberByMultiplyingBy: [NSDecimalNumber decimalNumberWithString:@"100"]] doubleValue]] forState:UIControlStateNormal];
//    }
    
//    if (self.houseCheckButton.selected) {
        self.selfHouseMoney.text = [NSString stringWithFormat:@"%.2f",[currentModel.selfPaidHouse doubleValue]];
        [self.selfHouseButton setTitle:[NSString stringWithFormat:@"%.1f%%",[[currentModel.selfHouse decimalNumberByMultiplyingBy: [NSDecimalNumber decimalNumberWithString:@"100"]] doubleValue]] forState:UIControlStateNormal];
        self.comHouseMoney.text = [NSString stringWithFormat:@"%.2f",[currentModel.comPaidHouse doubleValue]];
        [self.comHouseButton setTitle:[NSString stringWithFormat:@"%.1f%%",[[currentModel.comHouse decimalNumberByMultiplyingBy: [NSDecimalNumber decimalNumberWithString:@"100"]] doubleValue]] forState:UIControlStateNormal];
//    }else{
//        self.selfHouseMoney.text = @"0";
//        [self.selfHouseButton setTitle:[NSString stringWithFormat:@"%.1f%%",[[currentModel.selfHouse decimalNumberByMultiplyingBy: [NSDecimalNumber decimalNumberWithString:@"100"]] doubleValue]] forState:UIControlStateNormal];
//        self.comHouseMoney.text = @"0";
//        [self.comHouseButton setTitle:[NSString stringWithFormat:@"%.1f%%",[[currentModel.comHouse decimalNumberByMultiplyingBy: [NSDecimalNumber decimalNumberWithString:@"100"]] doubleValue]] forState:UIControlStateNormal];
//    }
    
    
    //起征点
    self.baseSecurity.text = [NSString stringWithFormat:@"%.0f",[currentModel.baseSecurity doubleValue]];
    
    self.baseHouse.text = [NSString stringWithFormat:@"%.0f",[currentModel.baseHouse doubleValue]];
    
    self.baseRevenue.text = [NSString stringWithFormat:@"%.0f",[currentModel.startTax doubleValue]];
    
    self.basePaidRevenue.text = [NSString stringWithFormat:@"%.2f",[currentModel.startPaidTax doubleValue]];
}

- (NSDecimalNumber*)countTax:(NSDecimalNumber*)money
{
    money = [money decimalNumberBySubtracting:currentModel.startTax];
    
    if ([money doubleValue] < 0) {
        currentModel.startPaidTax = [NSDecimalNumber decimalNumberWithString:@"0"];
        return currentModel.startPaidTax;
    }
    
    currentModel.startPaidTax = money;
    
    if ([money doubleValue]<= 1500) {
        return [money decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"0.03"]];
    }else if ([money doubleValue] > 1500 && [money doubleValue] <= 4500) {
        return [[money decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"0.1"]] decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:@"105"]];
    }else if ([money doubleValue] > 4500 && [money doubleValue] <= 9000) {
        return [[money decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"0.2"]] decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:@"555"]];
    }else if ([money doubleValue] > 9000 && [money doubleValue] <= 35000) {
        return [[money decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"0.25"]] decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:@"1005"]];
    }else if ([money doubleValue] > 35000 && [money doubleValue] <= 55000) {
        return [[money decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"0.3"]] decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:@"2755"]];
    }else if ([money doubleValue] > 55000 && [money doubleValue] <= 80000) {
        return [[money decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"0.35"]] decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:@"5505"]];
    }else{
        return [[money decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"0.45"]] decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:@"13505"]];
    }
}

- (IBAction)selectCheck:(UIButton*)button
{
    [button setSelected:!button.selected];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    return YES;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    switch (pickerView.tag) {
        case 1:
        {
            return 1;
        }
            break;
        default:
            return 4;
            break;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case 1:
        {
            return [__dataSource.dataManager.cityDatas count];
        }
            break;
        default:
        {
            switch (component) {
                case 0:
                {
                    return 1;
                }
                    break;
                case 1:
                {
                    return 20;
                }
                    break;
                case 2:
                {
                    return 1;
                }
                    break;
                case 3:
                {
                    return 20;
                }
                    break;
            }
        }
            break;
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return currentModel.cityName;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 1:
        {
//            if (detialOpen) {
                return self.detailView.frame.size.height;
//            }else{
//                return 0;
//            }
        }
            break;
        case 2:
        {
//            if (settingOpen) {
                return self.settingView.frame.size.height;
//            }else{
//                return 0;
//            }
        }
            break;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 1:
        {
            return self.detailView;
        }
            break;
        case 2:
        {
            return self.settingView;
        }
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            return self.cityCell.frame.size.height;
        }
            break;
        case 1:
        {
//            if (detialOpen) {
//                return self.detailView.frame.size.height;
//            }else{
//                return 0;
//            }
            return self.detailCell.frame.size.height;
        }
            break;
        case 2:
        {
            return self.settingCell.frame.size.height;
        }
            break;
        default:
            return 0;
            break;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            if (detialOpen) {
                return 1;
            }else{
                return 0;
            }
        }
            break;
        case 2:
        {
            if (settingOpen) {
                return 1;
            }else{
                return 0;
            }
        }
            break;
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            return self.cityCell;
        }
            break;
        case 1:
        {
            return self.detailCell;
        }
            break;
        case 2:
        {
            return self.settingCell;
        }
            break;
        default:
            return nil;
            break;
    }
}

@end
