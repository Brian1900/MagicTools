//
//  BrianPayItemCell.m
//  MagicalTools
//
//  Created by 陆 文杰 on 14-4-26.
//  Copyright (c) 2014年 陆 文杰. All rights reserved.
//

#import "BrianPayItemCell.h"

@implementation BrianPayItemCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)openChanged:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(openChanged:)]) {
        [self.delegate openChanged:self];
    }
}

@end
