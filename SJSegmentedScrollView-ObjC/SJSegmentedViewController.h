//
//  SJSegmentedViewController.h
//  Hike
//
//  Created by Pavan Goyal on 01/05/18.
//  Copyright © 2018 Hike Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJSegmentTab.h"
#import "SJSegmentedScrollView.h"

@protocol SJSegmentedViewControllerDelegate <NSObject>

@optional
- (void)didMoveToPage:(UIViewController *)controller segment:(SJSegmentTab *)segment index:(NSInteger)index;

@end

@protocol SJSegmentedViewControllerViewSource <NSObject>

@optional
- (UIView *)viewForSegmentControllerToObserveContentOffsetChange;
@end

@interface SJSegmentedViewController : UIViewController

@property (nonatomic, assign) CGFloat headerViewHeight;
@property (nonatomic, assign) CGFloat segmentViewHeight;
@property (nonatomic, assign) CGFloat headerViewOffsetHeight;
@property (nonatomic, strong) SJSegmentedScrollView *segmentedScrollView;
@property (nonatomic, strong) UIColor *selectedSegmentViewColor;
@property (nonatomic, assign) CGFloat selectedSegmentViewHeight;
@property (nonatomic, strong) UIColor *segmentTitleColor;
@property (nonatomic, strong) UIColor *segmentBackgroundColor;
@property (nonatomic, strong) UIFont *segmentTitleFont;
@property (nonatomic, assign) BOOL segmentBounces;
@property (nonatomic, strong) UIViewController *headerViewController;
@property (nonatomic, strong) NSArray<UIViewController *> *segmentControllers;
@property (nonatomic, strong) NSArray<SJSegmentTab *> *segments;
@property (nonatomic, strong) UIColor *segmentedScrollViewColor;
@property (nonatomic, assign) BOOL showsVerticalScrollIndicator;
@property (nonatomic, assign) BOOL showsHorizontalScrollIndicator;
@property (nonatomic, assign) BOOL disableScrollOnContentView;
@property (nonatomic, strong) NSLayoutConstraint *segmentScrollViewTopConstraint;
@property (nonatomic, weak) id<SJSegmentedViewControllerDelegate> delegate;

- (instancetype)initWithHeaderViewController:(UIViewController *)headerViewController segmentControllers:(NSArray<UIViewController *> *)segmentControllers;

@end
