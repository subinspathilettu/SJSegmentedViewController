//
//  SJSegmentedScrollView.h
//  Hike
//
//  Created by Pavan Goyal on 02/05/18.
//  Copyright © 2018 Hike Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJSegmentView.h"
#import "SJContentView.h"

@interface SJSegmentedScrollView : UIScrollView

@property (nonatomic, strong) SJSegmentView *segmentView;
@property (nonatomic, assign) CGFloat headerViewHeight;
@property (nonatomic, assign) CGFloat segmentViewHeight;
@property (nonatomic, assign) CGFloat headerViewOffsetHeight;
@property (nonatomic, strong) UIColor *selectedSegmentViewColor;
@property (nonatomic, assign) CGFloat selectedSegmentViewHeight;
@property (nonatomic, assign) BOOL segmentBounces;
@property (nonatomic, strong) UIColor *segmentTitleColor;
@property (nonatomic, strong) UIColor *selectedSegmentTitleColor;
@property (nonatomic, strong) UIColor *segmentBackgroundColor;
@property (nonatomic, strong) UIColor *segmentViewBackgroundColor;
@property (nonatomic, strong) UIFont *segmentTitleFont;
@property (nonatomic, assign) CGFloat topSpacing;
@property (nonatomic, assign) CGFloat bottomSpacing;
@property (nonatomic, assign) BOOL observing;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSMutableArray<UIViewController *> *contentControllers;
@property (nonatomic, strong) NSMutableArray<UIView *> *contentViews;
@property (nonatomic, strong) SJContentView *contentView;
@property (nonatomic, strong) UIView *scrollContentView;
@property (nonatomic, strong) NSLayoutConstraint *contentViewHeightConstraint;
@property (nonatomic, copy) DidSelectSegmentAtIndex didSelectSegmentAtIndex;
@property (nonatomic, assign) BOOL sjShowsVerticalScrollIndicator;
@property (nonatomic, assign) BOOL sjShowsHorizontalScrollIndicator;
@property (nonatomic, strong) NSMutableArray<UIView *> *viewObservers;
@property (nonatomic, assign) BOOL sjDisableScrollOnContentView;

- (void)updateSubviewsFrame:(CGRect)frame;
- (void)addContentView:(UIView *)contentView frame:(CGRect)frame;
- (void)addObserverForView:(UIView *)view;
- (void)addHeaderView:(UIView *)headerView;
- (void)setContentView;
- (void)addSegmentView:(NSArray<UIViewController *> *)controllers frame:(CGRect)frame;

@end
