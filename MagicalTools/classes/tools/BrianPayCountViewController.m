//
//  BrianPayCountViewController.m
//  MagicalTools
//
//  Created by 陆 文杰 on 14-4-26.
//  Copyright (c) 2014年 陆 文杰. All rights reserved.
//

#import "BrianPayCountViewController.h"
#import "BrianPayItemCell.h"
#import "BrianDataSource.h"

@interface BrianPayCountViewController ()

@end

@implementation BrianPayCountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        openOld = YES;
        openHouse = YES;
        openBirth = YES;
        openHurt= YES;
        openJob = YES;
        openMed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData
{
    nameArray = @[@"养老金",@"医疗",@"失业",@"工伤",@"生育",@"公积金"];
    currentArray = __dataSource.dataManager.cityDatas;
    selectCityIndex = 0;
}

- (IBAction)chooseCity:(id)sender {
    [self.selectView setHidden:NO];
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
    BrianCityData* model = [currentArray objectAtIndex:selectCityIndex];
    [self.cityButton setTitle:model.cityName forState:UIControlStateNormal];
    [self.tableView reloadData];
    [self.selectView setHidden:YES];
}

- (float)countMoney:(float)money
{
    float result = 0.0;
    
    BrianCityData* cityData = [currentArray objectAtIndex:selectCityIndex];
    
    float oldMoney = 0.0,medMoney = 0.0,jobMoney = 0.0,hurtMoney = 0.0,birthMoney = 0.0,houseMoney = 0.0;
    
    if (openOld) {
        oldMoney = money*cityData.selfOld;
    }
    
    if (openMed) {
        medMoney = money*cityData.selfMed;
    }
    
    if (openJob) {
        jobMoney = money*cityData.selfJob;
    }
    
    if (openHurt) {
        hurtMoney = money*cityData.selfHurt;
    }
    
    if (openBirth) {
        birthMoney = money*cityData.selfBirth;
    }
    
    if (openHouse) {
        houseMoney = money*cityData.selfHouse;
    }
    
    result = money - oldMoney - medMoney - jobMoney - hurtMoney - birthMoney - houseMoney;
    
    result = result - [self countTax:result];
    
    return result;
}

- (float)countTax:(float)money
{
    float result = 0.0;
    
    return result;
}

#pragma mark - BrianPayItemDelegate
- (void)openChanged:(BrianPayItemCell*)cell
{
    switch (cell.tag) {
        case 0:
        {
            openOld = cell.isOpen.on;
        }
            break;
        case 1:
        {
            openMed = cell.isOpen.on;
        }
            break;
        case 2:
        {
            openJob = cell.isOpen.on;
        }
            break;
        case 3:
        {
            openHurt = cell.isOpen.on;
        }
            break;
        case 4:
        {
            openBirth = cell.isOpen.on;
        }
            break;
        case 5:
        {
            openHouse = cell.isOpen.on;
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [currentArray count];
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    BrianCityData* model = [currentArray objectAtIndex:selectCityIndex];
    return model.cityName;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [nameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellID = @"BrianPayItemCell";
    
    BrianPayItemCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] objectAtIndex:0];
    }
    
    NSString* selfKey = @"selfOld";
    NSString* comKey = @"comOld";
    
    switch (indexPath.row) {
        case 1:
            selfKey = @"selfMed";
            comKey = @"comMed";
            break;
        case 2:
            selfKey = @"selfMed";
            comKey = @"comMed";
            break;
        case 3:
            selfKey = @"selfMed";
            comKey = @"comMed";
            break;
        case 4:
            selfKey = @"selfMed";
            comKey = @"comMed";
            break;
        case 5:
            selfKey = @"selfMed";
            comKey = @"comMed";
            break;
    }
    
    cell.itemKey.text = [nameArray objectAtIndex:indexPath.row];
    NSNumber* number = [[currentArray objectAtIndex:selectCityIndex] valueForKey:selfKey];
    cell.personPay.text = [NSString stringWithFormat:@"%.2f%%",[number floatValue]*100];
    
    number = [[currentArray objectAtIndex:selectCityIndex] valueForKey:comKey];
    cell.companyPay.text = [NSString stringWithFormat:@"%.2f%%",[number floatValue]*100];
    
    cell.tag = indexPath.row;
    
    return cell;
}

@end
