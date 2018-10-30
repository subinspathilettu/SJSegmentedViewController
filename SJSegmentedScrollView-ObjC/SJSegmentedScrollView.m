//
//  SJSegmentedScrollView.m
//  Hike
//
//  Created by Pavan Goyal on 02/05/18.
//  Copyright © 2018 Hike Pvt. Ltd. All rights reserved.
//

#import "SJSegmentedScrollView.h"

@interface SJSegmentedScrollView ()

@end

@implementation SJSegmentedScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _headerViewHeight = 0.0;
        _segmentViewHeight = 0.0;
        _headerViewOffsetHeight = 0.0;
        _selectedSegmentViewColor = [UIColor redColor];
        _selectedSegmentViewHeight = 0.0;
        _segmentBounces = NO;
        _segmentTitleColor = [UIColor redColor];
        _segmentViewBackgroundColor = [UIColor grayColor];
        _segmentTitleFont = [UIFont systemFontOfSize:12];
        _topSpacing = 0.0;
        _bottomSpacing = 0.0;
        _observing = YES;
        _contentControllers = [[NSMutableArray alloc] init];
        _contentViews = [[NSMutableArray alloc] init];
        _sjShowsVerticalScrollIndicator = NO;
        _sjShowsHorizontalScrollIndicator = NO;
        _viewObservers = [[NSMutableArray alloc] init];
        _sjDisableScrollOnContentView = NO;
        [self sizeToFit];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.bounces = NO;
        [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)setSjShowsVerticalScrollIndicator:(BOOL)sjShowsVerticalScrollIndicator {
    _sjShowsVerticalScrollIndicator = sjShowsVerticalScrollIndicator;
    self.showsVerticalScrollIndicator = sjShowsVerticalScrollIndicator;
    self.contentView.showsVerticalScrollIndicator = sjShowsVerticalScrollIndicator;
}

- (void)setSjShowsHorizontalScrollIndicator:(BOOL)sjShowsHorizontalScrollIndicator {
    _sjShowsHorizontalScrollIndicator = sjShowsHorizontalScrollIndicator;
    self.showsHorizontalScrollIndicator = sjShowsHorizontalScrollIndicator;
    self.contentView.showsHorizontalScrollIndicator = sjShowsHorizontalScrollIndicator;
}

- (void)setSjDisableScrollOnContentView:(BOOL)sjDisableScrollOnContentView {
    _sjDisableScrollOnContentView = sjDisableScrollOnContentView;
    [self.contentView setScrollEnabled:!sjDisableScrollOnContentView];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"contentOffset" context:nil];
    for (UIView *view in self.viewObservers) {
        [view removeObserver:self forKeyPath:@"contentOffset" context:nil];
    }
}

- (void)setContentView {
    if (self.scrollContentView == nil) {
        self.scrollContentView = [[UIView alloc] init];
        self.scrollContentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.scrollContentView];
        NSArray<NSLayoutConstraint *> *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView(==mainView)]|" options:0 metrics:nil views:@{@"contentView": self.scrollContentView, @"mainView": self}];
        [self addConstraints:horizontalConstraints];
        CGFloat contentHeight = [self getContentHeight];
        NSArray<NSLayoutConstraint *> *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:nil views:@{@"contentView": self.scrollContentView}];
        [self addConstraints:verticalConstraints];
        self.contentViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.scrollContentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:contentHeight];
        [self addConstraint:self.contentViewHeightConstraint];
    }
}

- (void)addHeaderView:(UIView *)headerView {
    if (headerView != nil) {
        self.headerView = headerView;
        headerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.scrollContentView addSubview:headerView];
        NSArray<NSLayoutConstraint *> *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[headerView]-0-|" options:0 metrics:nil views:@{@"headerView": headerView}];
        [self.scrollContentView addConstraints:horizontalConstraints];
        NSArray<NSLayoutConstraint *> *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[headerView(headerViewHeight)]" options:0 metrics:@{@"headerViewHeight": @(self.headerViewHeight)} views:@{@"headerView": headerView}];
        [self.scrollContentView addConstraints:verticalConstraints];
    } else {
        self.headerViewHeight = self.headerViewOffsetHeight;
    }
}

- (void)addObserverForView:(UIView *)view {
    [self.viewObservers addObject:view];
    [view addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)addContentView:(UIView *)contentView frame:(CGRect)frame {
    if (self.contentView == nil) {
        self.contentView = [self createContentView];
    }
    [self.contentViews addObject:contentView];
    [self.contentView addContentView:contentView frame:frame];
    __weak typeof(self) weakSelf = self;
    self.contentView.didSelectSegmentAtIndex = ^(SJSegmentTab *segmentTab, NSInteger index, BOOL animated) {
        SJSegmentTab *newSegmentTab = [weakSelf.segmentView.segments objectAtIndex:index];
        if ([newSegmentTab isKindOfClass:[SJSegmentTab class]]) {
            if (weakSelf.didSelectSegmentAtIndex) {
                weakSelf.didSelectSegmentAtIndex(newSegmentTab, index, animated);
            }
        }
    };
}

- (void)updateSubviewsFrame:(CGRect)frame {
    self.contentViewHeightConstraint.constant = [self getContentHeight];
    [self.contentView layoutIfNeeded];
    [self.segmentView didChangeParentViewFrame:frame];
    [self.contentView updateContentControllersFrame:frame];
}

- (CGFloat)getContentHeight {
    CGFloat contentHeight = self.superview.bounds.size.height + self.headerViewHeight;
    contentHeight -= (self.topSpacing + self.bottomSpacing + self.headerViewOffsetHeight);
    return contentHeight;
}

- (void)addSegmentView:(NSArray<UIViewController *> *)controllers frame:(CGRect)frame {
    if (controllers.count > 1) {
        self.segmentView = [[SJSegmentView alloc] initWithFrame:CGRectZero];
        self.segmentView.backgroundColor = self.segmentViewBackgroundColor;
        self.segmentView.controllers     = controllers;
        self.segmentView.selectedSegmentViewColor        = self.selectedSegmentViewColor;
        self.segmentView.selectedSegmentViewHeight       = self.selectedSegmentViewHeight;
        self.segmentView.titleColor                      = self.segmentTitleColor;
        self.segmentView.segmentBackgroundColor          = self.segmentBackgroundColor;
        self.segmentView.font                            = self.segmentTitleFont;
        self.segmentView.font                            = self.segmentTitleFont;
        self.segmentView.segmentViewHeight               = self.segmentViewHeight;
        self.segmentView.bounces                         = NO;
        self.segmentView.translatesAutoresizingMaskIntoConstraints = NO;
        __weak typeof(self) weakSelf = self;
        self.segmentView.didSelectSegmentAtIndex = ^(SJSegmentTab *segmentTab, NSInteger index, BOOL animated) {
            [weakSelf.contentView movePageToIndex:index animated:animated];
            if (weakSelf.didSelectSegmentAtIndex) {
                weakSelf.didSelectSegmentAtIndex(segmentTab, index, animated);
            }
        };
        [self.segmentView setSegmentsView:frame];
        [self addSubview:self.segmentView];
        NSArray<NSLayoutConstraint *> *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[segmentView]-0-|" options:0 metrics:nil views:@{@"segmentView": self.segmentView}];
        [self addConstraints:horizontalConstraints];
        UIView *view = self.headerView == nil ? self : self.headerView;
        NSArray<NSLayoutConstraint *> *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[headerView]-0-[segmentView(segmentViewHeight)]" options:0 metrics:@{@"segmentViewHeight" : @(self.segmentViewHeight)} views:@{@"headerView": view, @"segmentView": self.segmentView}];
        [self addConstraints:verticalConstraints];
    } else {
        self.segmentViewHeight = 0.0;
    }
}

- (void)addSegmentsForContentViews:(NSArray<NSString *> *)titles {
    CGRect frame = CGRectMake(0, self.headerViewHeight, self.bounds.size.width, self.segmentViewHeight);
    self.segmentView = [[SJSegmentView alloc] initWithFrame:frame];
    __weak typeof(self) weakSelf = self;
    self.segmentView.didSelectSegmentAtIndex = ^(SJSegmentTab *segmentTab, NSInteger index, BOOL animated) {
        [weakSelf.contentView movePageToIndex:index animated:animated];
    };
    [self addSubview:self.segmentView];
}

- (SJContentView *)createContentView {
    SJContentView *contentView = [[SJContentView alloc] initWithFrame:CGRectZero];
    contentView.showsVerticalScrollIndicator = self.sjShowsVerticalScrollIndicator;
    contentView.showsHorizontalScrollIndicator = self.sjShowsHorizontalScrollIndicator;
    [contentView setScrollEnabled:!self.sjDisableScrollOnContentView];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.bounces = self.segmentBounces;
    [self.scrollContentView addSubview:contentView];
    NSArray<NSLayoutConstraint *> *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[contentView]-0-|" options:0 metrics:nil views:@{@"contentView": contentView}];
    [self.scrollContentView addConstraints:horizontalConstraints];
    NSArray<NSLayoutConstraint *> *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[headerView]-segmentViewHeight-[contentView]-0-|" options:0 metrics:@{@"segmentViewHeight": @(self.segmentViewHeight)} views:@{@"headerView": self.headerView, @"contentView": contentView}];
    [self.scrollContentView addConstraints:verticalConstraints];
    return contentView;
}

- (void)handleScrollUp:(UIScrollView *)scrollView change:(CGFloat)change oldPosition:(CGPoint)oldPosition {
    if (self.headerViewHeight != 0.0 && self.contentOffset.y != 0.0) {
        if (scrollView.contentOffset.y < 0.0) {
            if (self.contentOffset.y >= 0.0) {
                CGFloat yPos = self.contentOffset.y - change;
                yPos = (yPos < 0) ? 0 : yPos;
                CGPoint updatedPos = CGPointMake(self.contentOffset.x, yPos);
                [self setContentOffset:self point:updatedPos];
                [self setContentOffset:scrollView point:oldPosition];
            }
        }
    }
}

- (void)handleScrollDown:(UIScrollView *)scrollView change:(CGFloat)change oldPosition:(CGPoint)oldPosition {
    CGFloat offset = (self.headerViewHeight - self.headerViewOffsetHeight);
    if (self.contentOffset.y < offset) {
        if (scrollView.contentOffset.y >= 0.0) {
            CGFloat yPos = self.contentOffset.y - change;
            yPos = (yPos > offset) ? offset : yPos;
            CGPoint updatedPos = CGPointMake(self.contentOffset.x, yPos);
            [self setContentOffset:self point:updatedPos];
            [self setContentOffset:scrollView point:oldPosition];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (!self.observing) {
        return;
    }
    if (![object isKindOfClass:[UIScrollView class]]) {
        return;
    }
    UIScrollView *scrollView = object;
    if (scrollView == self) {
        return;
    }
    NSValue *newValue = [change valueForKey:NSKeyValueChangeNewKey];
    NSValue *oldValue = [change valueForKey:NSKeyValueChangeOldKey];
    if ([newValue isKindOfClass:[NSValue class]] && [oldValue isKindOfClass:[NSValue class]]) {
        CGPoint new = [newValue CGPointValue];
        CGPoint old = [oldValue CGPointValue];
        CGFloat diff = old.y - new.y;
        if (diff > 0.0) {
            [self handleScrollUp:scrollView change:diff oldPosition:old];
        } else {
            [self handleScrollDown:scrollView change:diff oldPosition:old];
        }
    }
}

- (void)setContentOffset:(UIScrollView *)scrollView point:(CGPoint) point {
    self.observing = NO;
    scrollView.contentOffset = point;
    self.observing = YES;
}

@end

