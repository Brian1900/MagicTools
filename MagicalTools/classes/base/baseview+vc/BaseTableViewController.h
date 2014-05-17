//
//  BaseViewWithTableViewController.h
//  LuShiHelper
//
//  Created by Brian on 13-12-19.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseTableViewController : BaseViewController
{
    CGFloat preOffsetY_;
    CGFloat preLoadBuffer;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end
