//
//  BaseStateView.h
//  LuShiHelper
//
//  Created by Brian on 13-11-27.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ePullStateTypeNormal = 1,
    ePullStateTypeDown,         //状态标识：释放可以刷新
    ePullStateTypeUp,           //状态标识：释放加载更多
    ePullStateTypeRefresh,      //状态标识：正在刷新
    ePullStateTypeLoadMore,     //状态标识：正在加载
    ePullStateTypeEnd,          //状态标识：已加载全部数据
} ePullStateType;

typedef enum {
    ePullActionTypeDoNothing,   //动作：不执行
    ePullActionTypeRefresh,     //动作：下拉刷新
    ePullActionTypeLoadMore,    //动作：加载更多
} ePullActionType;

@protocol CTStateViewDelegate <NSObject>

@required
/**
 改变视图状态
 @param state 状态标示
 */
- (void)changeState:(ePullStateType)state;
/** 更新时间文本（当前时间） */
- (void)updateTimeLabel;

@end

@interface BaseStateView : UIView<CTStateViewDelegate>

/** 箭头视图 */
@property (nonatomic, strong) IBOutlet UIImageView *arrowView;
/** 转圈视图 */
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *indicatorView;
/** 提示文本视图 */
@property (nonatomic, strong) IBOutlet UILabel *tipsLabelView;
/** 更新时间视图 */
@property (nonatomic, strong) IBOutlet UILabel *timeLabelView;
/** 视图状态 */
@property (nonatomic) ePullStateType state;

@end


/** 下拉刷新表头元件父类 */
@interface BaseHeaderStateView : BaseStateView


@end

/** 上拉加载尾部元件父类 */
@interface BaseFooterStateView : BaseStateView

/** 已经全部加载完成提示字符串 */
@property (nonatomic, copy) NSString *loadAllHintText;

@end