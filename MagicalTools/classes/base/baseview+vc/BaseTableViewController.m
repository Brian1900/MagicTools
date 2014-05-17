//
//  BaseViewWithTableViewController.m
//  LuShiHelper
//
//  Created by Brian on 13-12-19.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "BaseTableViewController.h"
#import "BaseTableView.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[BaseTableView class]]) {
        BaseTableView *theTableView = (BaseTableView *)scrollView;
        if ((theTableView.headerView && !theTableView.headerView.hidden) || (theTableView.footerView && !theTableView.footerView.hidden)) {
            [theTableView tableViewDidDragging];
        }
        
        //自动预加载
        if (theTableView.footerView && !theTableView.footerView.hidden) {
            if (scrollView.contentOffset.y > preOffsetY_
                && ePullStateTypeNormal == theTableView.footerView.state
                ) {
                
                CGSize contentSize = theTableView.contentSize;
                CGFloat buffer = -30;//theTableView.bounds.size.height/1.0;
                if (preLoadBuffer != 0) {
                    buffer = preLoadBuffer;
                }
                
                CGFloat thresholdOffsetY = contentSize.height-buffer-theTableView.footerView.bounds.size.height-theTableView.frame.size.height;
                
                //                TLog(@"%f > %f",theTableView.contentOffset.y,thresholdOffsetY);
                
                if (theTableView.contentOffset.y > (thresholdOffsetY > 0 ? thresholdOffsetY : 0)) {
                    [theTableView setFooterLoading];
                }
            }
            preOffsetY_ = scrollView.contentOffset.y;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if ([scrollView isKindOfClass:[BaseTableView class]]) {
        BaseTableView *theTableView = (BaseTableView *)scrollView;
        
        if ((theTableView.headerView && !theTableView.headerView.hidden) || (theTableView.footerView && !theTableView.footerView.hidden)) {
            ePullActionType returnKey = [theTableView tableViewDidEndDragging];
            
            //            //第一套方案:
            //            if (returnKey != ePullActionTypeDoNothing) {
            //                [NSThread detachNewThreadSelector:@selector(updateCTTableViewThread:) toTarget:self withObject:[NSDictionary dictionaryWithObjectsAndKeys:theTableView, @"TableObject", [NSString stringWithFormat:@"%d", returnKey], @"ReturnKey", nil]];
            //            }
            
            //第二套方案:
            [theTableView startUpdateWithKey:returnKey];
        }
    }
}

@end
