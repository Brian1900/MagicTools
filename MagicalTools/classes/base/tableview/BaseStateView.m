//
//  BaseStateView.m
//  LuShiHelper
//
//  Created by Brian on 13-11-27.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "BaseStateView.h"

@implementation BaseStateView

#pragma mark 改变视图状态
- (void)changeState:(ePullStateType)state
{
    
}
#pragma mark 更新时间文本（当前时间）
- (void)updateTimeLabel
{
    
}

@end


@implementation BaseHeaderStateView

#pragma mark - --------------------退出清空--------------------

#pragma mark - --------------------初始化--------------------

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initBaseData];
        [self initBaseView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initBaseData];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initBaseView];
}

- (void)initBaseData
{
    
}

- (void)initBaseView
{
    [self setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - --------------------Delegate Method--------------------

#pragma mark 改变视图状态
- (void)changeState:(ePullStateType)state
{
    [self.indicatorView stopAnimating];
    self.arrowView.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    switch (state) {
        case ePullStateTypeNormal:
            self.state = ePullStateTypeNormal;
            self.tipsLabelView.text = @"下拉可以刷新";
            //self.arrowView.layer.transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1); //旋转箭头
            self.arrowView.transform = CGAffineTransformMakeRotation(0);
            
            break;
        case ePullStateTypeDown:
            self.state = ePullStateTypeDown;
            self.tipsLabelView.text = @"松开可以刷新";
            //self.arrowView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            self.arrowView.transform = CGAffineTransformMakeRotation(M_PI);
            
            break;
            
        case ePullStateTypeRefresh:
            self.state = ePullStateTypeRefresh;
            self.tipsLabelView.text = @"数据刷新中，请稍等...";
            [self.indicatorView startAnimating];
            self.arrowView.hidden = YES;
            break;
            
        default:
            break;
    }
    [UIView commitAnimations];
}

#pragma mark 更新时间Label
- (void)updateTimeLabel
{
    //也许刷新失败，所以让前台来修改这个值
    //    if (self.timeLabelView && !self.timeLabelView.hidden) {
    //        NSDate *date = [NSDate date];
    //        NSDateFormatter *formatter = [[DateUtil getCurrentDateFormatter] retain];
    //
    //        [formatter setDateStyle:kCFDateFormatterFullStyle];
    //        [formatter setDateFormat:@"今天 HH:mm"];
    //
    //        self.timeLabelView.text = [NSString stringWithFormat:@"最后更新：%@", [formatter stringFromDate:date]];
    //        [formatter release];
    //    }
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:CGRectMake(0, -40, 320, 40)] ;
}

@end

#pragma mark - --------------------CTFooterStateView--------------------
@implementation BaseFooterStateView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initBaseData];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initBaseView];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initBaseData];
        [self initBaseView];
    }
    return self;
}

- (void)initBaseData
{
    _loadAllHintText = @"";
}

- (void)initBaseView
{
    [self setBackgroundColor:[UIColor clearColor]];
}
#pragma mark - --------------------Delegate Method--------------------
#pragma mark 改变视图状态
- (void)changeState:(ePullStateType)state
{
    [self.indicatorView stopAnimating];
    self.arrowView.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    switch (state) {
        case ePullStateTypeNormal:
            self.state = ePullStateTypeNormal;
            self.tipsLabelView.text = @"上拉即可加载";
            //  旋转箭头
            self.arrowView.layer.transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            break;
            
        case ePullStateTypeUp:
            self.state = ePullStateTypeUp;
            self.tipsLabelView.text = @"松开即可加载";
            self.arrowView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            break;
            
        case ePullStateTypeLoadMore:
            self.state = ePullStateTypeLoadMore;
            //            self.tipsLabelView.text = @"载入中，请稍后...";
            self.tipsLabelView.text = @"数据加载中，请稍后...";
            [self.indicatorView startAnimating];
            self.arrowView.hidden = YES;
            break;
            
        case ePullStateTypeEnd:
            self.state = ePullStateTypeEnd;
            self.tipsLabelView.text = _loadAllHintText;
            self.arrowView.hidden = YES;
            break;
            
        default:
            break;
    }
    [UIView commitAnimations];
}

#pragma mark 更新时间Label
- (void)updateTimeLabel
{
//    if (self.timeLabelView && !self.timeLabelView.hidden) {
//        NSDate *date = [NSDate date];
//        NSDateFormatter *formatter = [DateUtil getCurrentDateFormatter];
//        
//        [formatter setDateStyle:kCFDateFormatterFullStyle];
//        [formatter setDateFormat:@"MM-dd HH:mm"];
//        
//        self.timeLabelView.text = [NSString stringWithFormat:@"更新于 %@", [formatter stringFromDate:date]];
//    }
}

@end