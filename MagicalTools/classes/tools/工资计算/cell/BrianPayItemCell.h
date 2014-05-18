//
//  BrianPayItemCell.h
//  MagicalTools
//
//  Created by 陆 文杰 on 14-4-26.
//  Copyright (c) 2014年 陆 文杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BrianPayItemCell;

@protocol BrianPayItemDelegate <NSObject>

- (void)openChanged:(BrianPayItemCell*)cell;

@end

@interface BrianPayItemCell : UITableViewCell

@property (assign, nonatomic) id<BrianPayItemDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *itemKey;
@property (strong, nonatomic) IBOutlet UITextField *personPay;
@property (strong, nonatomic) IBOutlet UITextField *companyPay;
@property (strong, nonatomic) IBOutlet UISwitch *isOpen;

@end
