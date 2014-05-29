//
//  BrianExchangeTableViewCell.m
//  MagicalTools
//
//  Created by Brian on 14-5-23.
//  Copyright (c) 2014年 陆 文杰. All rights reserved.
//

#import "BrianExchangeTableViewCell.h"

@implementation BrianExchangeTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString*)reuseIdentifier
{
    NSLog(@"%d",self.tag);
    
    return [NSString stringWithFormat:@"BrianExchangeTableViewCell_%ld",(long)self.tag];
}

@end
