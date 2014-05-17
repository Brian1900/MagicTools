//
//  LSHTableView.m
//  LuShiHelper
//
//  Created by Brian on 13-11-27.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "BaseTableView.h"

@implementation BaseTableView

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

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initBaseData];
        [self initBaseView];
    }
    return self;
}

- (void)initBaseData
{
    
}
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    //    [view release];
}
- (void)initBaseView
{
    if (!_headerView) {
        
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BaseHeaderStateView class]) owner:self options:nil];
        BaseHeaderStateView *view  = [array objectAtIndex:0];
        _headerView = (BaseHeaderStateView *)view;
        [_headerView setHidden:YES];
    }
    [_headerView setFrame:CGRectMake(0, 20-_headerView.bounds.size.height, self.bounds.size.width, _headerView.bounds.size.height)];
    [_headerView changeState:ePullStateTypeNormal];
    
    if (!_footerView) {
        
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BaseFooterStateView class]) owner:nil options:nil];
        UIView *view  = [array objectAtIndex:0];
        _footerView = (BaseFooterStateView *)view;
        [_footerView setHidden:YES];
    }
    [_footerView setBounds:CGRectMake(0, 0, self.bounds.size.width, _footerView.bounds.size.height)];
    [_footerView changeState:ePullStateTypeNormal];
    
    [self addSubview:_headerView];
    //    [self setTableFooterView:_footerView];
}

#pragma mark - --------------------接口API--------------------
#pragma mark 更新数据
- (void)reloadDataWithIsAllLoaded:(BOOL)isAllLoaded
{
    [self reloadDataWithIsAllLoaded:isAllLoaded isTabView:NO];
}

- (void)reloadDataWithIsAllLoaded:(BOOL)isAllLoaded isTabView:(BOOL)isTabView{
    [super reloadData];
    [UIView animateWithDuration:0.3 animations:^(void){
//        if (isTabView) {
//            self.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
//        }else{
            self.contentInset = UIEdgeInsetsZero;
//        }
    }] ;
    
    [_headerView changeState:ePullStateTypeNormal];
    //更新时间提示文本
    [_headerView updateTimeLabel];
    
    //如果数据已全部加载，则禁用“上拖加载”
    if (isAllLoaded) {
        [_footerView changeState:ePullStateTypeEnd];
    } else {
        [_footerView changeState:ePullStateTypeNormal];
    }
    //更新时间提示文本
    [_footerView updateTimeLabel];
}

#pragma mark 当表视图拖动时的执行方法
- (void)tableViewDidDragging{
    CGFloat offsetY = self.contentOffset.y;
    //  判断是否正在加载
    if (_headerView.state == ePullStateTypeRefresh ||
        _footerView.state == ePullStateTypeLoadMore) {
        return;
    }
    //  改变“下拉可以刷新”视图的文字提示
    if (offsetY < -_headerView.bounds.size.height) {
        [_headerView changeState:ePullStateTypeDown];
    } else {
        [_headerView changeState:ePullStateTypeNormal];
    }
    //判断数据是否已全部加载
    if (ePullStateTypeEnd == _footerView.state) {
        return;
    }
    //计算表内容大小与窗体大小的实际差距
    CGFloat differenceY = self.contentSize.height > self.frame.size.height ? (self.contentSize.height - self.frame.size.height) : 0;
    //改变“上拖加载更多”视图的文字提示
    if (offsetY > differenceY + _footerView.bounds.size.height / 3 * 2) {
        [_footerView changeState:ePullStateTypeUp];
    } else {
        [_footerView changeState:ePullStateTypeNormal];
    }
}

#pragma mark 当表视图结束拖动时的执行方法
- (ePullActionType)tableViewDidEndDragging{
    CGFloat offsetY = self.contentOffset.y;
    //判断是否正在加载数据
    if (_headerView.state == ePullStateTypeRefresh ||
        _footerView.state == ePullStateTypeLoadMore) {
        return ePullActionTypeDoNothing;
    }
    //改变“下拉可以刷新”视图的文字及箭头提示
    if (!_headerView.hidden && offsetY < -_headerView.bounds.size.height) {
        [_headerView changeState:ePullStateTypeRefresh];
        self.contentInset = UIEdgeInsetsMake(_headerView.bounds.size.height, 0, 0, 0);
        return ePullActionTypeRefresh;
    }
    //改变“上拉加载更多”视图的文字及箭头提示
    CGFloat differenceY = self.contentSize.height > self.frame.size.height ? (self.contentSize.height - self.frame.size.height) : 0;
    if (!_footerView.hidden && _footerView.state != ePullStateTypeEnd &&
        offsetY > differenceY + _footerView.bounds.size.height / 3 * 2) {
        [_footerView changeState:ePullStateTypeLoadMore];
        return ePullActionTypeLoadMore;
    }
    return ePullActionTypeDoNothing;
}

#pragma mark - 第二套解决方案
- (void)startUpdateWithKey:(ePullActionType)key
{
    //returnKey用来判断执行的拖动是下拉还是上拖，如果数据正在加载，则返回DO_NOTHING
    if (key != ePullActionTypeDoNothing) {
        [NSThread detachNewThreadSelector:@selector(updateCTTableViewThread:) toTarget:self withObject:[NSDictionary dictionaryWithObjectsAndKeys:self, @"TableObject", [NSString stringWithFormat:@"%d", key], @"ReturnKey", nil]];
    }
}

#pragma mark 更新线程
- (void)updateCTTableViewThread:(NSDictionary *)dictionary
{
    @autoreleasepool {
        
        [[NSThread currentThread] setName:@"updateCTTableViewThread"];
        
        BaseTableView *theTableView = [dictionary objectForKey:@"TableObject"];
        ePullActionType returnKey = (ePullActionType)[[dictionary objectForKey:@"ReturnKey"] intValue];
        NSObject *theUpdateDelegate = self.updateDelegate;
        
        switch (returnKey) {
            case ePullActionTypeRefresh:
                if (theTableView.headerView && !theTableView.headerView.hidden && theUpdateDelegate && [theUpdateDelegate respondsToSelector:@selector(pullDownToRefreshData:)]) {
                    [theUpdateDelegate performSelectorOnMainThread:@selector(pullDownToRefreshData:) withObject:theTableView waitUntilDone:NO];
                }
                break;
                
            case ePullActionTypeLoadMore:
                if (theTableView.footerView && !theTableView.footerView.hidden && theUpdateDelegate && [theUpdateDelegate respondsToSelector:@selector(pullUpToAddData:)]) {
                    [theUpdateDelegate performSelectorOnMainThread:@selector(pullUpToAddData:) withObject:theTableView waitUntilDone:NO];
                }
                break;
                
            default:
                break;
        }
    }
}
#pragma mark 模拟header转圈
- (void)setHeaderLoading
{
    [_headerView changeState:ePullStateTypeRefresh];
    self.contentInset = UIEdgeInsetsMake(_headerView.bounds.size.height, 0, 0, 0);
}
#pragma mark 模拟footer转圈
- (void)setFooterLoading
{
    [_footerView changeState:ePullStateTypeUp];//ePullStateTypeLoadMore
}
#pragma mark 修改加载结束提示符
- (void)setLoadAllHintText:(NSString *)hintText;
{
    _footerView.loadAllHintText = hintText;
}

#pragma mark 设置headerView隐藏状态
- (void)setHeaderViewHidden:(BOOL)hidden
{
//    return ;
    
    self.headerView.hidden = hidden;
//    [_headerView setHidden:hidden];
//    if (hidden) {
//        self.tableHeaderView = nil;
//    }else{
//        self.tableHeaderView = _headerView;
//    }
}
#pragma mark 设置footerView隐藏状态
- (void)setFooterViewHidden:(BOOL)hidden
{
//    return ;
    
    [_footerView setHidden:hidden];
    if (hidden) {
        self.tableFooterView = nil;
    }
    else
    {
        self.tableFooterView = _footerView;
    }
}

@end
