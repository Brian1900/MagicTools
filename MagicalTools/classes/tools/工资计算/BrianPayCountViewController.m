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
    
    
    [self.navigationBar addBackButtonWithTarget:self action:@selector(backButton:)];
}

- (void)setCurrentCity:(NSInteger)cityIndex
{
    currentModel = [__dataSource.dataManager.cityDatas objectAtIndex:selectCityIndex];
    
    if ([self.beforMoney.text integerValue] != 0) {
        
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
    
    self.afterMoney.text = [NSString stringWithFormat:@"%.2lf",currentModel.salaryAfter];
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

- (float)countTax:(float)money
{
    money = money - currentModel.startTax;
    
    if (money < 0) {
        return 0;
    }
    
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
            return self.detailView.frame.size.height;
        }
            break;
        case 2:
        {
            return self.settingView.frame.size.height;
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
    return 1;
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
