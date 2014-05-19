//
//  BrianPayCountViewController.m
//  MagicalTools
//
//  Created by 陆 文杰 on 14-4-26.
//  Copyright (c) 2014年 陆 文杰. All rights reserved.
//

#import "BrianPayCountViewController.h"
#import "BrianDataSource.h"

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
    
    self.afterMoney.text = [NSString stringWithFormat:@"%.2lf",[self countMoney:[self.beforMoney.text floatValue]]];
}

- (IBAction)cancelSelectCity:(id)sender {
    [self.selectView setHidden:YES];
}

- (IBAction)selectCity:(id)sender {
    selectCityIndex = [self.pickerView selectedRowInComponent:0];
    BrianCityData* model = [__dataSource.dataManager.cityDatas objectAtIndex:selectCityIndex];
    [self.cityButton setTitle:model.cityName forState:UIControlStateNormal];
    [self.tableView reloadData];
    [self.selectView setHidden:YES];
}

- (float)countMoney:(float)money
{
    float result = 0.0;
    
    BrianCityData* cityData = [__dataSource.dataManager.cityDatas objectAtIndex:selectCityIndex];
    
    float oldMoney = 0.0,medMoney = 0.0,jobMoney = 0.0,hurtMoney = 0.0,birthMoney = 0.0,houseMoney = 0.0;
    
    oldMoney = money*cityData.selfOld;
    
    medMoney = money*cityData.selfMed;
    
    jobMoney = money*cityData.selfJob;
    
    hurtMoney = money*cityData.selfHurt;
    
    birthMoney = money*cityData.selfBirth;
    
    houseMoney = money*cityData.selfHouse;
    
    result = money - oldMoney - medMoney - jobMoney - hurtMoney - birthMoney - houseMoney;
    
    result = result - [self countTax:result];
    
    return result;
}

- (float)countTax:(float)money
{
    float result = 0.0;
    
    return result;
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
    
    return [__dataSource.dataManager.cityDatas count];
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    BrianCityData* model = [__dataSource.dataManager.cityDatas objectAtIndex:selectCityIndex];
    return model.cityName;
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
