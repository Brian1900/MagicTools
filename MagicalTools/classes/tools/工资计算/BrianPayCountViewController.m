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
    
    [self countMoney:[self.beforMoney.text floatValue]];
    [self refreshView];
    
    self.afterMoney.text = [NSString stringWithFormat:@"%.2lf",currentModel.salaryAfter];
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

- (void)countMoney:(float)money
{
    CGFloat result = 0;
    
    [currentModel reset];
    
    if (money > currentModel.minSecurity && money < currentModel.maxHouse) {
        currentModel.baseSecurity = money;
        currentModel.baseHouse = money;
    }else if(money > currentModel.maxHouse){
        currentModel.baseSecurity = currentModel.maxHouse;
        currentModel.baseHouse = currentModel.maxHouse;
    }
    
    currentModel.salaryBefore = money;
    
    //个人
    currentModel.selfPaidOld = currentModel.baseSecurity*currentModel.selfOld;
    currentModel.selfPaidMed = currentModel.baseSecurity*currentModel.selfMed;
    currentModel.selfPaidJob = currentModel.baseSecurity*currentModel.selfJob;
    currentModel.selfPaidHurt = currentModel.baseSecurity*currentModel.selfHurt;
    currentModel.selfPaidBirth = currentModel.baseSecurity*currentModel.selfBirth;
    
    currentModel.selfPaidHouse = currentModel.baseHouse*currentModel.selfHouse;
    
    //公司
    currentModel.comPaidOld = currentModel.baseSecurity*currentModel.comOld;
    currentModel.comPaidMed = currentModel.baseSecurity*currentModel.comMed;
    currentModel.comPaidJob = currentModel.baseSecurity*currentModel.comJob;
    currentModel.comPaidHurt = currentModel.baseSecurity*currentModel.comHurt;
    currentModel.comPaidBirth = currentModel.baseSecurity*currentModel.comBirth;
    
    currentModel.comPaidHouse = currentModel.baseHouse*currentModel.comHouse;
    
    
    result = money - currentModel.selfPaidOld - currentModel.selfPaidMed - currentModel.selfPaidJob - currentModel.selfPaidHurt - currentModel.selfPaidBirth - currentModel.selfPaidHouse;
    
    currentModel.paidTax = [self countTax:result];
    
    currentModel.salaryAfter = result - currentModel.paidTax;
}

- (void)refreshView
{
    //输入
    self.afterMoney.text = [NSString stringWithFormat:@"%.2f",currentModel.salaryAfter];
    
    self.paidRevenue.text = [NSString stringWithFormat:@"%.2f",currentModel.paidTax];
    
    //详情
    self.allSelfMoney.text = [NSString stringWithFormat:@"%.2f",currentModel.selfPaidOld + currentModel.selfPaidMed + currentModel.selfPaidJob + currentModel.selfPaidHouse];
    
    self.allComMoney.text = [NSString stringWithFormat:@"%.2f",currentModel.comPaidOld + currentModel.comPaidMed + currentModel.comPaidJob + currentModel.comPaidHurt + currentModel.comPaidBirth + currentModel.comPaidHouse];
    
    self.selfOldMoney.text = [NSString stringWithFormat:@"%.2f",currentModel.selfPaidOld];
    [self.selfOldButton setTitle:[NSString stringWithFormat:@"%.1f%%",currentModel.selfOld * 100] forState:UIControlStateNormal];
    self.comOldMoney.text = [NSString stringWithFormat:@"%.2f",currentModel.comPaidOld];
    [self.comOldButton setTitle:[NSString stringWithFormat:@"%.1f%%",currentModel.comOld * 100] forState:UIControlStateNormal];
    
    self.selfMedMoney.text = [NSString stringWithFormat:@"%.2f",currentModel.selfPaidMed];
    [self.selfMedButton setTitle:[NSString stringWithFormat:@"%.1f%%",currentModel.selfMed * 100] forState:UIControlStateNormal];
    self.comMedMoney.text = [NSString stringWithFormat:@"%.2f",currentModel.comPaidMed];
    [self.comMedButton setTitle:[NSString stringWithFormat:@"%.1f%%",currentModel.comMed * 100] forState:UIControlStateNormal];
    
    self.selfJobMoney.text = [NSString stringWithFormat:@"%.2f",currentModel.selfPaidJob];
    [self.selfJobButton setTitle:[NSString stringWithFormat:@"%.1f%%",currentModel.selfJob * 100] forState:UIControlStateNormal];
    self.comJobMoney.text = [NSString stringWithFormat:@"%.2f",currentModel.comPaidJob];
    [self.comJobButton setTitle:[NSString stringWithFormat:@"%.1f%%",currentModel.comJob * 100] forState:UIControlStateNormal];
    
    self.comHurtMoney.text = [NSString stringWithFormat:@"%.2f",currentModel.comPaidHurt];
    [self.comHurtButton setTitle:[NSString stringWithFormat:@"%.1f%%",currentModel.comHurt * 100] forState:UIControlStateNormal];
    
    self.comBirthMoney.text = [NSString stringWithFormat:@"%.2f",currentModel.comPaidBirth];
    [self.comBirthButton setTitle:[NSString stringWithFormat:@"%.1f%%",currentModel.comBirth * 100] forState:UIControlStateNormal];
    
    self.selfHouseMoney.text = [NSString stringWithFormat:@"%.2f",currentModel.selfPaidHouse];
    [self.selfHouseButton setTitle:[NSString stringWithFormat:@"%.1f%%",currentModel.selfHouse * 100] forState:UIControlStateNormal];
    self.comHouseMoney.text = [NSString stringWithFormat:@"%.2f",currentModel.comPaidHouse];
    [self.comHouseButton setTitle:[NSString stringWithFormat:@"%.1f%%",currentModel.comHouse * 100] forState:UIControlStateNormal];
    
    //起征点
    self.baseSecurity.text = [NSString stringWithFormat:@"%d",currentModel.baseSecurity];
    
    self.baseHouse.text = [NSString stringWithFormat:@"%d",currentModel.baseHouse];
    
    self.baseRevenue.text = [NSString stringWithFormat:@"%d",currentModel.startTax];
    
    self.basePaidRevenue.text = [NSString stringWithFormat:@"%.2f",currentModel.startPaidTax];
}

- (float)countTax:(float)money
{
    money = money - currentModel.startTax;
    
    if (money < 0) {
        currentModel.startPaidTax = 0;
        return 0;
    }
    
    currentModel.startPaidTax = money;
    
    if (money <= 1500) {
        return money * 0.03;
    }else if (money > 1500 && money <= 4500) {
        return money * 0.1 - 105;
    }else if (money > 4500 && money <= 9000) {
        return money * 0.2 - 555;
    }else if (money > 9000 && money <= 35000) {
        return money * 0.25 - 1005;
    }else if (money > 35000 && money <= 55000) {
        return money * 0.3 - 2755;
    }else if (money > 55000 && money <= 80000) {
        return money * 0.35 - 5505;
    }else{
        return money * 0.45 - 13505;
    }
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
