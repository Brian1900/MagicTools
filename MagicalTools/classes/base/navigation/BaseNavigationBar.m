//
//  BaseNavigationBar.m
//  BaseProject
//
//  Created by 陆 文杰 on 13-9-23.
//  Copyright (c) 2013年 陆 文杰. All rights reserved.
//

#import "BaseNavigationBar.h"
#import "BaseDefine.h"

@implementation BaseNavigationBar

@synthesize backgroundImageView = backgroundImageView_;
@synthesize titleView = titleView_;
@synthesize title = title_;
@synthesize backBarButtonItem = backBarButtonItem_;
@synthesize leftBarButtonItem = leftBarButtonItem_;
@synthesize rightBarButtonItem = rightBarButtonItem_;
@synthesize leftBarButtonItems = leftBarButtonItems_;
@synthesize rightBarButtonItems = rightBarButtonItems_;

#pragma mark - 系统方法

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initBaseData];
        [self initBaseView];
    }
    return self;
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
    if (!leftBarButtonItems_) {
        leftBarButtonItems_ = [[NSArray alloc] init];
    }
    if (!rightBarButtonItems_) {
        rightBarButtonItems_ = [[NSArray alloc] init];
    }
}

- (void)initBaseView
{
    [self setBackgroundColor:[UIColor clearColor]];
    if (!backgroundImageView_) {
        backgroundImageView_ = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:backgroundImageView_];
    }
    if (!titleView_) {
        titleView_ = [[UIView alloc] init];
        [titleView_ setCenter:CGPointMake(self.frame.size.width/2, Navigation_Height/2)];
        [self addSubview:titleView_];
    }
}

- (void)setBackgroundImage:(UIImage *)image
{
    [backgroundImageView_ setImage:image];
}

- (void)setTitle:(NSString *)title color:(UIColor*)color
{
    if (title_) {
        title_ = nil;
    }
    title_ = [title copy];
    
    CGFloat width = [title_ sizeWithFont:kNavigationBarTitleFont].width;
    width = (width > kNavigationBarTitleViewMaxWidth) ? kNavigationBarTitleViewMaxWidth : width;
    for (UIView *subView in [titleView_ subviews]) {
        [subView removeFromSuperview];
    }
    [titleView_ setBounds:CGRectMake(0, 0, width, self.bounds.size.height-0.5)];
    [titleView_ setCenter:CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0-0.5)];
    [titleView_ setBackgroundColor:[UIColor clearColor]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleView_.bounds];
    [titleLabel setFont:kNavigationBarTitleFont];
    [titleLabel setText:title];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    [titleLabel setShadowOffset:CGSizeMake(1, 1)];
    [titleLabel setTextColor:color];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleView_ addSubview:titleLabel];
}

- (void)setTitle:(NSString *)title 
{
    [self setTitle:title color:[UIColor blackColor]];
}

#pragma mark - 功能函数
+ (UIBarButtonItem *)createBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    return item;
}

+ (UIBarButtonItem *)createBarButtonItemWithCustomView:(UIView *)view
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
    return item;
}

+ (UIButton *)createButtonWithBarButtonItem:(UIBarButtonItem *)item
{
    if (!item.title) {
        return nil;
    }
    CGFloat width = [item.title sizeWithFont:kNavigationBarButtonFont].width;
    UIButton *customeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customeButton setTitle:item.title forState:UIControlStateNormal];
    [customeButton.titleLabel setFont:kNavigationBarButtonFont];
    [customeButton setTitleColor:kNavigationBarButtonNormalColor forState:UIControlStateNormal];
    [customeButton setTitleColor:kNavigationBarButtonHighlightColor forState:UIControlStateHighlighted];
    [customeButton setTitleColor:kNavigationBarButtonDisableColor forState:UIControlStateDisabled];
    [customeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 1)];
    UIImage* image = nil;
    UIImage* highlightImage = nil;
    if ([item.title isEqualToString:@"完成"]) {
        image = [[UIImage imageNamed:@"btn_titlebar2.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:2];
        highlightImage = [[UIImage imageNamed:@"btn_titlebar2press.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:2];
    }
    else
    {
        image = [[UIImage imageNamed:@"btn_titlebar1.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:0];
        highlightImage = [[UIImage imageNamed:@"btn_titlebar1press.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:0];
    }
    [customeButton setBackgroundImage:image forState:UIControlStateNormal];
    [customeButton setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [customeButton setFrame:CGRectMake(0, 0, (width+20 > 65) ? width+20 : 65, 48)];
    [customeButton addTarget:item.target action:item.action forControlEvents:UIControlEventTouchUpInside];
    return customeButton;
}

#pragma mark - 添加左按钮
- (void)addBackButtonWithTarget:(id)target action:(SEL)selector
{
    UIButton *customeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [customeButton setTitle:@"返回" forState:UIControlStateNormal];
    //    [customeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    //    customeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 9, 2, 1);
    //    [customeButton setTitleColor:[UIColor colorWithRed:87/255.0 green:184/255.0 blue:246/255.0 alpha:1.0] forState:UIControlStateNormal];
    //    UIImage* image = [UIImage imageNamed:@"NavigationBar_BackButton.png"];
    UIImage* image = [UIImage imageNamed:@"btn_back.png"];
    UIImage* pressedImage = [UIImage imageNamed:@"btn_back_focus.png"];
    [customeButton setImage:image forState:UIControlStateNormal];
    [customeButton setImage:pressedImage forState:UIControlStateHighlighted];
    [customeButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [customeButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:[BaseNavigationBar createBarButtonItemWithCustomView:customeButton]];
}

- (void)addCancelButtonWithTarget:(id)target action:(SEL)selector
{
    UIButton *customeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [customeButton setTitle:@"返回" forState:UIControlStateNormal];
    //    [customeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    //    customeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 9, 2, 1);
    //    [customeButton setTitleColor:[UIColor colorWithRed:87/255.0 green:184/255.0 blue:246/255.0 alpha:1.0] forState:UIControlStateNormal];
    //    UIImage* image = [UIImage imageNamed:@"NavigationBar_BackButton.png"];
    UIImage* image = [UIImage imageNamed:@"btn_cancel.png"];
    UIImage* pressedImage = [UIImage imageNamed:@"btn_cancel_focus.png"];
    [customeButton setImage:image forState:UIControlStateNormal];
    [customeButton setImage:pressedImage forState:UIControlStateHighlighted];
    [customeButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [customeButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:[BaseNavigationBar createBarButtonItemWithCustomView:customeButton]];
}

- (void)addCloseButtonWithTarget:(id)target action:(SEL)selector
{
    UIButton *customeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [customeButton setTitle:@"返回" forState:UIControlStateNormal];
    //    [customeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    //    customeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 9, 2, 1);
    //    [customeButton setTitleColor:[UIColor colorWithRed:87/255.0 green:184/255.0 blue:246/255.0 alpha:1.0] forState:UIControlStateNormal];
    //    UIImage* image = [UIImage imageNamed:@"NavigationBar_BackButton.png"];
    UIImage* image = [UIImage imageNamed:@"hamburger.png"];
    UIImage* pressedImage = [UIImage imageNamed:@"hamburger.png"];
    [customeButton setImage:image forState:UIControlStateNormal];
    [customeButton setImage:pressedImage forState:UIControlStateHighlighted];
    [customeButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [customeButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [self addLeftBarButtonItem:[BaseNavigationBar createBarButtonItemWithCustomView:customeButton]];
}

- (void)addMenuButtonWithTarget:(id)target action:(SEL)selector
{
    UIButton *customeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [customeButton setTitle:@"返回" forState:UIControlStateNormal];
    //    [customeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    //    customeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 9, 2, 1);
    //    [customeButton setTitleColor:[UIColor colorWithRed:87/255.0 green:184/255.0 blue:246/255.0 alpha:1.0] forState:UIControlStateNormal];
    //    UIImage* image = [UIImage imageNamed:@"NavigationBar_BackButton.png"];
    UIImage* image = [UIImage imageNamed:@"btn_menu.png"];
    UIImage* pressedImage = [UIImage imageNamed:@"btn_menu_focus.png"];
    [customeButton setImage:image forState:UIControlStateNormal];
    [customeButton setImage:pressedImage forState:UIControlStateHighlighted];
    [customeButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [customeButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [self addLeftBarButtonItem:[BaseNavigationBar createBarButtonItemWithCustomView:customeButton]];
}

- (void)addLeftBarButtonItem:(UIBarButtonItem *)item
{
    if (!item || [leftBarButtonItems_ containsObject:item]) {
        return;
    }
    
    if (!leftBarButtonItem_) {
        [self setLeftBarButtonItem:item];
    }
    else {
        UIBarButtonItem *preItem = [leftBarButtonItems_ objectAtIndex:leftBarButtonItems_.count-1];
        NSArray *tempArray = [leftBarButtonItems_ arrayByAddingObject:item];
        leftBarButtonItems_ = nil;
        leftBarButtonItems_ = tempArray;
        //添加CustomeView内容
        if (!item.customView) {
            [item setCustomView:[BaseNavigationBar createButtonWithBarButtonItem:item]];
        }
        //没有个性化位置的，规范位置坐标
        if (0 == item.customView.frame.origin.x && 0 == item.customView.frame.origin.y) {
            [item.customView setFrame:CGRectMake(preItem.customView.frame.origin.x+preItem.customView.bounds.size.width+kNavigationBarHorizonGap, (self.bounds.size.height-item.customView.bounds.size.height)/2.0, item.customView.bounds.size.width, item.customView.bounds.size.height)];
        }
        
        [self addSubview:item.customView];
    }
}

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    if (leftBarButtonItem_) {
        [leftBarButtonItem_.customView removeFromSuperview];
        leftBarButtonItem_ = nil;
    }
    else if (backBarButtonItem_ && leftBarButtonItem) {
        [backBarButtonItem_.customView removeFromSuperview];
        backBarButtonItem_ = nil;
    }
    
    if (!leftBarButtonItem) {//传入nil值，相当于删除第一个左按钮。会影响其他左按钮列表位置
        
        if (leftBarButtonItems_.count > 0) {//左按钮列表非空
            NSArray *tempArray = [leftBarButtonItems_ subarrayWithRange:NSMakeRange(1, leftBarButtonItems_.count-1)];
            leftBarButtonItems_ = nil;
            leftBarButtonItems_ = tempArray;
            if (leftBarButtonItems_.count > 0) {
                leftBarButtonItem_ = [leftBarButtonItems_ objectAtIndex:0];
            }
            else {//左按钮列表为空
                return;
            }
        }
        else {//左按钮列表为空
            return;
        }
        
        for (unsigned int i = 0; i < leftBarButtonItems_.count; i++) {
            UIBarButtonItem *item = [leftBarButtonItems_ objectAtIndex:i];
            
            if (0 == i) {
                [item.customView setFrame:CGRectMake(kNavigationBarLeftGap, item.customView.frame.origin.y, item.customView.bounds.size.width, item.customView.bounds.size.height)];
            }
            else {
                UIBarButtonItem *preItem = [leftBarButtonItems_ objectAtIndex:i-1];
                [item.customView setFrame:CGRectMake(preItem.customView.frame.origin.x+preItem.customView.bounds.size.width+kNavigationBarHorizonGap, item.customView.frame.origin.y, item.customView.bounds.size.width, item.customView.bounds.size.height)];
            }
        }
    }
    else {//传入非空值，相当于替换左按钮列表的第一个。不影响其他左按钮列表位置
        leftBarButtonItem_ = leftBarButtonItem;
        
        if (0 == leftBarButtonItems_.count) {//左按钮列表为空时，添加新按钮
            NSArray *tempItems = [leftBarButtonItems_ arrayByAddingObject:leftBarButtonItem_];
            leftBarButtonItems_ = nil;
            leftBarButtonItems_ = tempItems;
        }
        else {//左按钮列表非空时，替换左按钮列表的第一个
            if (leftBarButtonItem_ != [leftBarButtonItems_ objectAtIndex:0]) {
                NSArray *tempItems = [NSArray arrayWithObjects:leftBarButtonItem_, nil];
                tempItems = [tempItems arrayByAddingObjectsFromArray:[leftBarButtonItems_ subarrayWithRange:NSMakeRange(1, leftBarButtonItems_.count-1)]];
                leftBarButtonItems_ = nil;
                leftBarButtonItems_ = tempItems;
            }
        }
        
        //添加CustomeView内容
        if (!leftBarButtonItem_.customView) {
            [leftBarButtonItem_ setCustomView:[BaseNavigationBar createButtonWithBarButtonItem:leftBarButtonItem_]];
        }
        //没有个性化位置的，规范位置坐标
        if (0 == leftBarButtonItem_.customView.frame.origin.x && 0 == leftBarButtonItem_.customView.frame.origin.y) {
            [leftBarButtonItem_.customView setFrame:CGRectMake(kNavigationBarLeftGap, (self.bounds.size.height-leftBarButtonItem_.customView.bounds.size.height)/2.0, leftBarButtonItem_.customView.bounds.size.width, leftBarButtonItem_.customView.bounds.size.height)];
        }
        
        [self addSubview:leftBarButtonItem_.customView];
    }
}

- (void)setBackBarButtonItem:(UIBarButtonItem *)backBarButtonItem
{
    if (!backBarButtonItem) {//不支持空输入
        return;
    }

    if (self.leftBarButtonItems.count > 0) {//如果左按钮列表有值，不添加返回按钮
        return;
    }
    if (backBarButtonItem_) {
        [backBarButtonItem_.customView removeFromSuperview];
        backBarButtonItem_ = nil;
    }

    backBarButtonItem_ = backBarButtonItem;

    if (!backBarButtonItem_.customView) {
        [backBarButtonItem_ setCustomView:[BaseNavigationBar createButtonWithBarButtonItem:leftBarButtonItem_]];
    }

    UIButton *customeButton = (UIButton *)backBarButtonItem.customView;
    if ([customeButton isKindOfClass:[UIButton class]]) {
        NSString *buttonTitle = [customeButton.titleLabel text];
        if (buttonTitle.length > 0) {
            [backBarButtonItem_.customView setFrame:CGRectMake(kNavigationBarLeftGap, (self.bounds.size.height-backBarButtonItem_.customView.bounds.size.height)/2.0, backBarButtonItem_.customView.bounds.size.width, backBarButtonItem_.customView.bounds.size.height)];
        }
    }
    else
    {
        [backBarButtonItem_.customView setFrame:CGRectMake(kNavigationBarLeftGap, (self.bounds.size.height-backBarButtonItem_.customView.bounds.size.height)/2.0, backBarButtonItem_.customView.bounds.size.width, backBarButtonItem_.customView.bounds.size.height)];
    }

    [self addSubview:backBarButtonItem_.customView];
}

#pragma mark 添加右按钮
- (void)addRightSubmitButton:(id)target action:(SEL)selector//添加右按钮
{
    UIImage *normalImage;//btn_phone.png
    UIImage *highlightImage;//btn_phone_down.png
    
    normalImage = [UIImage imageNamed:@"btn_submit.png"];
    highlightImage = [UIImage imageNamed:@"btn_submit_focus.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    [button setFrame:CGRectMake(self.frame.size.width - normalImage.size.width, 0, normalImage.size.width, normalImage.size.height)];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    [self addRightBarButtonItem:[BaseNavigationBar createBarButtonItemWithCustomView:button]];
}

- (void)setRightAdd:(id)target action:(SEL)selector
{
    UIImage *normalImage;//btn_house.png
    UIImage *highlightImage;//btn_house_down.png
    
    normalImage = [UIImage imageNamed:@"btn_add.png"];
    highlightImage = [UIImage imageNamed:@"btn_add_focus.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    [button setFrame:CGRectMake(self.frame.size.width - normalImage.size.width, 0, normalImage.size.width, normalImage.size.height)];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    [self addRightBarButtonItem:[BaseNavigationBar createBarButtonItemWithCustomView:button]];
}

- (void)setRightSend:(id)target action:(SEL)selector
{
    UIImage *normalImage;//btn_house.png
    UIImage *highlightImage;//btn_house_down.png
    
    normalImage = [UIImage imageNamed:@"btn_fabu.png"];
    highlightImage = [UIImage imageNamed:@"btn_fabu_focus.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    [button setFrame:CGRectMake(self.frame.size.width - normalImage.size.width, 0, normalImage.size.width, normalImage.size.height)];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    [self addRightBarButtonItem:[BaseNavigationBar createBarButtonItemWithCustomView:button]];
}

- (void)setRightSearch:(id)target action:(SEL)selector
{
    UIImage *normalImage;//btn_house.png
    UIImage *highlightImage;//btn_house_down.png
    
    normalImage = [UIImage imageNamed:@"btn_search.png"];
    highlightImage = [UIImage imageNamed:@"btn_search_focus.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    [button setFrame:CGRectMake(self.frame.size.width - normalImage.size.width, 0, normalImage.size.width, normalImage.size.height)];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    [self addRightBarButtonItem:[BaseNavigationBar createBarButtonItemWithCustomView:button]];
}

/**
 增加切换按钮
 @param target 消息绑定目标
 @param selector 消息绑定方法
 */
- (void)setRightDownload:(id)target action:(SEL)selector
{
    UIImage *normalImage;//btn_house.png
    UIImage *highlightImage;//btn_house_down.png
    
    normalImage = [UIImage imageNamed:@"btn_showGameLib.png"];
    highlightImage = [UIImage imageNamed:@"btn_showGameLib_focus.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    [button setFrame:CGRectMake(self.frame.size.width - normalImage.size.width, 0, normalImage.size.width, normalImage.size.height)];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    [self addRightBarButtonItem:[BaseNavigationBar createBarButtonItemWithCustomView:button]];
}

//- (void)addRightSearchButtonWithTarget:(id)target action:(SEL)selector
//{
//    UIImage *normalImage;//btn_house.png
//    UIImage *highlightImage;//btn_house_down.png
//    
//    normalImage = [UIImage imageNamed:@"icon_phone.png"];
//    highlightImage = [UIImage imageNamed:@"icon_phone_focus.png"];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setImage:normalImage forState:UIControlStateNormal];
//    [button setImage:highlightImage forState:UIControlStateHighlighted];
//    [button setFrame:CGRectMake(0, -3, normalImage.size.width+30, 48)];
//    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
//    
//    [self addRightBarButtonItem:[BaseNavigationBar createBarButtonItemWithCustomView:button]];
//}

- (void)addRightDoneButtonWithTarget:(id)target action:(SEL)selector
{
    UIImage *normalImage;//btn_house.png
    UIImage *highlightImage;//btn_house_down.png
    
    normalImage = [UIImage imageNamed:@"btn_done.png"];
    highlightImage = [UIImage imageNamed:@"btn_done_focus.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    [button setFrame:CGRectMake(self.frame.size.width - normalImage.size.width, 0, normalImage.size.width, normalImage.size.height)];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    [self addRightBarButtonItem:[BaseNavigationBar createBarButtonItemWithCustomView:button]];
}

- (void)addRightReFreshButtonWithTarget:(id)target action:(SEL)selector
{
    UIImage *normalImage;//btn_house.png
    UIImage *highlightImage;//btn_house_down.png
    
    normalImage = [UIImage imageNamed:@"btn_refresh.png"];
    highlightImage = [UIImage imageNamed:@"btn_refresh_focus.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    [button setFrame:CGRectMake(self.frame.size.width - normalImage.size.width, 0, normalImage.size.width, normalImage.size.height)];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    [self addRightBarButtonItem:[BaseNavigationBar createBarButtonItemWithCustomView:button]];
}

- (void)addRightBarButtonItem:(UIBarButtonItem *)item
{
    if (!item || [rightBarButtonItems_ containsObject:item]) {
        return;
    }
    
    rightBarButtonItem_ = nil;
    
    if (!rightBarButtonItem_) {
        [self setRightBarButtonItem:item animated:NO];
    }
    
    UIBarButtonItem *preItem = [rightBarButtonItems_ objectAtIndex:rightBarButtonItems_.count-1];
    NSArray *tempArray = [rightBarButtonItems_ arrayByAddingObject:item];
    rightBarButtonItems_ = nil;
    rightBarButtonItems_ = tempArray;
    //添加CustomeView内容
    if (!item.customView) {
        [item setCustomView:[BaseNavigationBar createButtonWithBarButtonItem:item]];
    }
    //没有个性化位置的，规范位置坐标
    if (0 == item.customView.frame.origin.x && 0 == item.customView.frame.origin.y) {
        [item.customView setFrame:CGRectMake(preItem.customView.frame.origin.x-kNavigationBarHorizonGap-item.customView.bounds.size.width, (self.bounds.size.height-item.customView.bounds.size.height)/2.0, item.customView.bounds.size.width, item.customView.bounds.size.height)];
    }
    
    [self addSubview:item.customView];

    [item.customView setAlpha:0];
    
    [UIView animateWithDuration:.3f animations:^{
        [item.customView setAlpha:1.0];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem animated:(BOOL)animated
{
    if (rightBarButtonItem_) {
        [rightBarButtonItem_.customView removeFromSuperview];
        rightBarButtonItem_ = nil;
    }
    
    if (!rightBarButtonItem) {//传入nil值，相当于删除第一个右按钮。会影响其他右按钮列表位置
        
        if (rightBarButtonItems_.count > 0) {//右按钮列表非空 所有按钮往右移 次右变成最右
            NSArray *tempArray = [rightBarButtonItems_ subarrayWithRange:NSMakeRange(1, rightBarButtonItems_.count-1)];
            rightBarButtonItems_ = nil;
            rightBarButtonItems_ = tempArray;
            if (rightBarButtonItems_.count > 0) {
                rightBarButtonItem_ = [rightBarButtonItems_ objectAtIndex:0];
            }
            else {//右按钮列表为空
                return;
            }
        }
        else {//右按钮列表为空
            return;
        }
        
        for (unsigned int i = 0; i < rightBarButtonItems_.count; i++) {
            UIBarButtonItem *item = [rightBarButtonItems_ objectAtIndex:i];
            
            if (animated) {//渐隐动画+移动动画
                [item.customView setAlpha:0];
                [UIView animateWithDuration:.3f animations:^{
                    if (0 == i) {
                        [item.customView setFrame:CGRectMake(self.bounds.size.width-item.customView.bounds.size.width-kNavigationBarRightGap, item.customView.frame.origin.y, item.customView.bounds.size.width, item.customView.bounds.size.height)];
                    }
                    else {
                        UIBarButtonItem *preItem = [leftBarButtonItems_ objectAtIndex:i-1];
                        [item.customView setFrame:CGRectMake(preItem.customView.frame.origin.x-kNavigationBarHorizonGap-item.customView.bounds.size.width, item.customView.frame.origin.y, item.customView.bounds.size.width, item.customView.bounds.size.height)];
                    }
                    [item.customView setAlpha:1.0];
                } completion:^(BOOL finished) {
                    
                }];
            }
            else { //无动画+移动视图
                if (0 == i) {
                    [item.customView setFrame:CGRectMake(self.bounds.size.width-item.customView.bounds.size.width-kNavigationBarRightGap, item.customView.frame.origin.y, item.customView.bounds.size.width, item.customView.bounds.size.height)];
                }
                else {
                    UIBarButtonItem *preItem = [leftBarButtonItems_ objectAtIndex:i-1];
                    [item.customView setFrame:CGRectMake(preItem.customView.frame.origin.x-kNavigationBarHorizonGap-item.customView.bounds.size.width, item.customView.frame.origin.y, item.customView.bounds.size.width, item.customView.bounds.size.height)];
                }
            }
        }
    }
    else {//传入非空值，相当于替换右按钮列表的第一个。不影响其他右按钮列表位置
        rightBarButtonItem_ = rightBarButtonItem;
        
        if (0 == rightBarButtonItems_.count) {//右按钮列表为空时，添加新按钮
            NSArray *tempItems = [rightBarButtonItems_ arrayByAddingObject:rightBarButtonItem_];
            rightBarButtonItems_ = nil;
            rightBarButtonItems_ = tempItems;
        }
        else {//右按钮列表非空时，替换右按钮列表的第一个
            if (rightBarButtonItem_ != [rightBarButtonItems_ objectAtIndex:0]) {
                NSArray *tempItems = [NSArray arrayWithObjects:rightBarButtonItem_, nil];
                tempItems = [tempItems arrayByAddingObjectsFromArray:[rightBarButtonItems_ subarrayWithRange:NSMakeRange(1, rightBarButtonItems_.count-1)]];
                rightBarButtonItems_ = nil;
                rightBarButtonItems_ = tempItems;
            }
        }
        
        //添加CustomeView内容
        if (!rightBarButtonItem_.customView) {
            [rightBarButtonItem_ setCustomView:[BaseNavigationBar createButtonWithBarButtonItem:rightBarButtonItem_]];
        }
        //没有个性化位置的，规范位置坐标
        if (0 == rightBarButtonItem_.customView.frame.origin.x && 0 == rightBarButtonItem_.customView.frame.origin.y) {
            [rightBarButtonItem_.customView setFrame:CGRectMake(self.bounds.size.width-rightBarButtonItem_.customView.bounds.size.width-kNavigationBarRightGap, (self.bounds.size.height-rightBarButtonItem_.customView.bounds.size.height)/2.0, rightBarButtonItem_.customView.bounds.size.width, rightBarButtonItem_.customView.bounds.size.height)];
        }
        
        [self addSubview:rightBarButtonItem_.customView];
        
//        if (animated) {
//            [rightBarButtonItem_.customView setAlpha:0];
//            [UIView animateWithDuration:.3f animations:^{
//                [rightBarButtonItem_.customView setAlpha:1.0];
//            } completion:^(BOOL finished) {
//                
//            }];
//        }
    }
}

//- (void)addRightTelephoneWithTarget:(id)rTarget action:(SEL)rSelector AndHomePageButtonWithTarget:(id)lTarget action:(SEL)lSelector
//{
//    //btn_titel_home&phone1_normal.png btn_titel_home&phone1_phonepressed.png
//    //btn_titel_home&phone_normal.png btn_titel_home&phone_homepressed.png
//    UIImage *normalImage;
//    UIImage *highlightImage;
//    UIView *contentView = [[UIView alloc] init];
//    [contentView setBackgroundColor:[UIColor clearColor]];
//
//    normalImage = [UIImage imageNamed:@"icon_phone.png"];
//    highlightImage = [UIImage imageNamed:@"icon_phone_focus.png"];
//    UIButton *btnTelephone = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnTelephone setImage:normalImage forState:UIControlStateNormal];
//    [btnTelephone setImage:highlightImage forState:UIControlStateHighlighted];
//    [btnTelephone setFrame:CGRectMake(5, 0, normalImage.size.width+15, 48)];
//    [btnTelephone addTarget:rTarget action:rSelector forControlEvents:UIControlEventTouchUpInside];
//    [contentView addSubview:btnTelephone];
//
//    normalImage = [UIImage imageNamed:@"icon_home.png"];
//    highlightImage = [UIImage imageNamed:@"icon_home_focus.png"];
//    UIButton *btnHomePage = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnHomePage setImage:normalImage forState:UIControlStateNormal];
//    [btnHomePage setImage:highlightImage forState:UIControlStateHighlighted];
//    [btnHomePage setFrame:CGRectMake(btnTelephone.frame.origin.x+btnTelephone.bounds.size.width, 0, normalImage.size.width+15, 48)];
//    [btnHomePage addTarget:lTarget action:lSelector forControlEvents:UIControlEventTouchUpInside];
//    [contentView addSubview:btnHomePage];
//
//    [contentView setFrame:CGRectMake(0, 0, 10+btnTelephone.bounds.size.width+btnHomePage.bounds.size.width, btnTelephone.bounds.size.height)];
//
//
//    [self addRightBarButtonItem:[BaseNavigationBar createBarButtonItemWithCustomView:contentView]];
//}


@end
