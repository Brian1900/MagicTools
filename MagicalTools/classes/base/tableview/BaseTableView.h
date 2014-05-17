//
//  LSHTableView.h
//  LuShiHelper
//
//  Created by Brian on 13-11-27.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseStateView.h"

@class BaseTableView;

@protocol BaseTableViewDelegate <NSObject>

@optional
/**
 下拉刷新回调
 
 @param tableView 列表视图对象
 */
- (void)pullDownToRefreshData:(BaseTableView *)tableView;
/**
 上拉加载回调
 
 @param tableView 列表视图对象
 */
- (void)pullUpToAddData:(BaseTableView *)tableView;

@end

@interface BaseTableView : UITableView

/** header加载提示视图 */
@property (nonatomic, strong) IBOutlet BaseHeaderStateView *headerView;
/** footerView加载提示视图 */
@property (nonatomic, strong) IBOutlet BaseFooterStateView *footerView;
/** 更新代理 */
@property (nonatomic, unsafe_unretained) IBOutlet id<BaseTableViewDelegate> updateDelegate;

/**
 初始化数据
 */
- (void)initBaseData;
/**
 初始化视图
 */
- (void)initBaseView;
/**
 模拟header转圈
 */
- (void)setHeaderLoading;
/**
 模拟footer转圈
 */
- (void)setFooterLoading;

/**
 表视图拖动时执行此方法
 */
- (void)tableViewDidDragging;

/**
 表视图拖动结束，返回key值
 
 @return 拖动后操作类型
 */
- (ePullActionType)tableViewDidEndDragging;

/**
 表视图拖动结束，通过key值分支处理
 
 @param key 拖动结束返回动作类型
 */
- (void)startUpdateWithKey:(ePullActionType)key;
/**
 更新视图
 
 @param isAllLoaded 数据是否全部加载完
 */
- (void)reloadDataWithIsAllLoaded:(BOOL)isAllLoaded;

- (void)reloadDataWithIsAllLoaded:(BOOL)isAllLoaded isTabView:(BOOL)isTabView;

/**
 修改加载完提示语
 
 @param hintText 加载完提示语
 */
- (void)setLoadAllHintText:(NSString *)hintText;

/**
 设置headerView隐藏状态
 
 @param hidden 是否隐藏
 */
- (void)setHeaderViewHidden:(BOOL)hidden;
/**
 设置footerView隐藏状态态
 
 @param hidden 是否隐藏
 */
- (void)setFooterViewHidden:(BOOL)hidden;

/**
 隐藏多余的横线
 */
- (void)setExtraCellLineHidden: (UITableView *)tableView;
@end
