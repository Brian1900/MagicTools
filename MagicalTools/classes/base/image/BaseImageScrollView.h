//
//  BaseImageScrollView.h
//  LuShiHelper
//
//  Created by Brian on 13-11-8.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@protocol BaseImageScrollViewDelegate <NSObject>

- (void) didSelectImageViewIndex:(NSInteger)index;

@end

@interface BaseImageScrollView : BaseView<UIScrollViewDelegate>
{
    UIButton* currentPageButton;
    NSTimer* timer;
}

@property (assign,nonatomic) IBOutlet id<BaseImageScrollViewDelegate> delegate;
@property (strong,nonatomic) UIView* shadowView;
@property (strong,nonatomic) UILabel* labelView;
@property (strong,nonatomic) UIImageView* defaultImageView;
@property (strong,nonatomic) UIScrollView* scrollView;
//@property (strong,nonatomic) UIPageControl* pageControl;
@property (strong,nonatomic) NSArray* imageUrlsArray;
@property (strong,nonatomic) NSArray* labelArray;
@property (strong,nonatomic) UIImage* defaultImage;
@property (strong,nonatomic) NSMutableArray* imageViewArray;
@property (strong,nonatomic) NSMutableArray* pageButtonArray;
@property (strong,nonatomic) UIImage* normalPageButton;
@property (strong,nonatomic) UIImage* selectedPageButton;

- (void)nextPage;
- (void)setAutoNext:(BOOL)autoNext;

@end
