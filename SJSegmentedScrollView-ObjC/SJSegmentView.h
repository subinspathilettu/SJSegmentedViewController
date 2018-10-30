//
//  SJSegmentView.h
//  Hike
//
//  Created by Pavan Goyal on 02/05/18.
//  Copyright © 2018 Hike Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJSegmentTab.h"
#import "SJContentView.h"

@interface SJSegmentView : UIScrollView

@property (nonatomic, strong) NSMutableArray<SJSegmentTab *> *segments;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) CGFloat selectedSegmentViewHeight;
@property (nonatomic, assign) NSInteger kSegmentViewTagOffset;
@property (nonatomic, assign) CGFloat segmentViewOffsetWidth;
@property (nonatomic, strong) UIView *segmentContentView;
@property (nonatomic, copy) DidSelectSegmentAtIndex didSelectSegmentAtIndex;
@property (nonatomic, strong) UIView *selectedSegmentView;
@property (nonatomic, strong) NSLayoutConstraint *xPosConstraints;
@property (nonatomic, strong) NSLayoutConstraint *contentViewWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *selectedSegmentViewWidthConstraint;
@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *contentSubViewWidthConstraints;
@property (nonatomic, strong) NSArray<UIViewController *> *controllers;
@property (nonatomic, assign) CGFloat segmentViewHeight;
@property (nonatomic, strong) UIColor *selectedSegmentViewColor;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *segmentBackgroundColor;
@property (nonatomic, strong) SJContentView *contentView;

- (void)didChangeParentViewFrame:(CGRect)frame;
- (void)setSegmentsView:(CGRect)frame;

@end
