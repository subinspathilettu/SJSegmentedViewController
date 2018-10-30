//
//  SJSegmentedViewController.m
//  Hike
//
//  Created by Pavan Goyal on 01/05/18.
//  Copyright © 2018 Hike Pvt. Ltd. All rights reserved.
//

#import "SJSegmentedViewController.h"
#import "SJUtil.h"

@interface SJSegmentedViewController ()

@end

@implementation SJSegmentedViewController

- (instancetype)initWithHeaderViewController:(UIViewController *)headerViewController segmentControllers:(NSArray<UIViewController *> *)segmentControllers {
    self = [super init];
    if (self) {
        _headerViewHeight = 0.0;
        _segmentViewHeight = 40.0;
        _headerViewOffsetHeight = 0.0;
        _selectedSegmentViewColor = [UIColor lightGrayColor];
        _selectedSegmentViewHeight = 5.0;
        _segmentTitleColor = [UIColor blackColor];
        _segmentBackgroundColor = [UIColor whiteColor];
        _segmentTitleFont = [UIFont systemFontOfSize:14];
        _segmentBounces = YES;
        _headerViewController = headerViewController;
        _segmentControllers = segmentControllers;
        _segmentedScrollViewColor = [UIColor whiteColor];
        _showsVerticalScrollIndicator = YES;
        _showsHorizontalScrollIndicator = YES;
        _disableScrollOnContentView = NO;
        _segmentedScrollView = [[SJSegmentedScrollView alloc] initWithFrame:CGRectZero];
        [self setDefaultValuesToSegmentedScrollView];
    }
    return self;
}

- (void)setHeaderViewHeight:(CGFloat)headerViewHeight {
    _headerViewHeight = headerViewHeight;
    self.segmentedScrollView.headerViewHeight = headerViewHeight;
}

- (void)setSegmentViewHeight:(CGFloat)segmentViewHeight {
    _segmentViewHeight = segmentViewHeight;
    self.segmentedScrollView.segmentViewHeight = segmentViewHeight;
}

- (void)setHeaderViewOffsetHeight:(CGFloat)headerViewOffsetHeight {
    _headerViewOffsetHeight = headerViewOffsetHeight;
    self.segmentedScrollView.headerViewOffsetHeight = headerViewOffsetHeight;
}

- (void)setSelectedSegmentViewColor:(UIColor *)selectedSegmentViewColor {
    _selectedSegmentViewColor = selectedSegmentViewColor;
    self.segmentedScrollView.selectedSegmentViewColor = selectedSegmentViewColor;
}

- (void)setSelectedSegmentViewHeight:(CGFloat)selectedSegmentViewHeight {
    _selectedSegmentViewHeight = selectedSegmentViewHeight;
    self.segmentedScrollView.selectedSegmentViewHeight = selectedSegmentViewHeight;
}

- (void)setSegmentTitleColor:(UIColor *)segmentTitleColor {
    _segmentTitleColor = segmentTitleColor;
    self.segmentedScrollView.segmentTitleColor = segmentTitleColor;
}

- (void)setSegmentBackgroundColor:(UIColor *)segmentBackgroundColor {
    _segmentBackgroundColor = segmentBackgroundColor;
    self.segmentedScrollView.segmentBackgroundColor = segmentBackgroundColor;
}

- (void)setSegmentTitleFont:(UIFont *)segmentTitleFont {
    _segmentTitleFont = segmentTitleFont;
    self.segmentedScrollView.segmentTitleFont = segmentTitleFont;
}

- (void)setSegmentBounces:(BOOL)segmentBounces {
    _segmentBounces = segmentBounces;
    self.segmentedScrollView.segmentBounces = segmentBounces;
}

- (void)setHeaderViewController:(UIViewController *)headerViewController {
    _headerViewController = headerViewController;
    [self setDefaultValuesToSegmentedScrollView];
}

- (void)setSegmentControllers:(NSArray<UIViewController *> *)segmentControllers {
    _segmentControllers = segmentControllers;
    [self setDefaultValuesToSegmentedScrollView];
}

- (NSArray<SJSegmentTab *> *)segments {
    NSArray *tabs = self.segmentedScrollView.segmentView.segments;
    if ([tabs isKindOfClass:[NSArray class]]) {
        return tabs;
    } else {
        return [[NSArray alloc] init];
    }
}

- (void)setSegmentedScrollViewColor:(UIColor *)segmentedScrollViewColor {
    _segmentedScrollViewColor = segmentedScrollViewColor;
    self.segmentedScrollView.backgroundColor = segmentedScrollViewColor;
}

- (void)setShowsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator {
    _showsVerticalScrollIndicator = showsVerticalScrollIndicator;
    self.segmentedScrollView.sjShowsVerticalScrollIndicator = showsVerticalScrollIndicator;
}

- (void)setShowsHorizontalScrollIndicator:(BOOL)showsHorizontalScrollIndicator {
    _showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
    self.segmentedScrollView.sjShowsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
}

- (void)setDisableScrollOnContentView:(BOOL)disableScrollOnContentView {
    _disableScrollOnContentView = disableScrollOnContentView;
    self.segmentedScrollView.sjDisableScrollOnContentView = disableScrollOnContentView;
}

- (void)loadView {
    [super loadView];
    [self addSegmentedScrollView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadControllers];
    if (@available(iOS 11, *)) {
        self.segmentedScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat topSpacing = [SJUtil getTopSpacing:self];
    self.segmentedScrollView.topSpacing = topSpacing;
    self.segmentedScrollView.bottomSpacing = [SJUtil getBottomSpacing:self];
    self.segmentScrollViewTopConstraint.constant = topSpacing;
    [self.segmentedScrollView updateSubviewsFrame:self.view.bounds];
}

- (void)setSelectedSegmentAt:(NSInteger)index animated:(BOOL)animated {
    if (index >= 0 && index < self.segmentControllers.count) {
        if (self.segmentedScrollView.segmentView.didSelectSegmentAtIndex) {
            self.segmentedScrollView.segmentView.didSelectSegmentAtIndex(self.segments[index], index, animated);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DidChangeSegmentIndex" object:@(index)];
    }
}

- (void)setDefaultValuesToSegmentedScrollView {
    self.segmentedScrollView.selectedSegmentViewColor     = self.selectedSegmentViewColor;
    self.segmentedScrollView.selectedSegmentViewHeight    = self.selectedSegmentViewHeight;
    self.segmentedScrollView.segmentTitleColor            = self.segmentTitleColor;
    self.segmentedScrollView.segmentBackgroundColor       = self.segmentBackgroundColor;
    self.segmentedScrollView.segmentTitleFont             = self.segmentTitleFont;
    self.segmentedScrollView.segmentBounces               = self.segmentBounces;
    self.segmentedScrollView.headerViewHeight             = self.headerViewHeight;
    self.segmentedScrollView.headerViewOffsetHeight       = self.headerViewOffsetHeight;
    self.segmentedScrollView.segmentViewHeight            = self.segmentViewHeight;
    self.segmentedScrollView.backgroundColor              = self.segmentedScrollViewColor;
    self.segmentedScrollView.sjDisableScrollOnContentView = self.disableScrollOnContentView;
}

- (void)addSegmentedScrollView {
    CGFloat topSpacing = [SJUtil getTopSpacing:self];
    self.segmentedScrollView.topSpacing = topSpacing;
    CGFloat bottomSpacing = [SJUtil getBottomSpacing:self];
    self.segmentedScrollView.bottomSpacing = bottomSpacing;
    [self.view addSubview:self.segmentedScrollView];
    NSArray<NSLayoutConstraint *> *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[scrollView]-0-|" options:0 metrics:nil views:@{@"scrollView": self.segmentedScrollView}];
    [self.view addConstraints:horizontalConstraints];
    NSArray<NSLayoutConstraint *> *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[scrollView]-bp-|" options:0 metrics:@{@"tp": @(topSpacing), @"bp": @(bottomSpacing)} views:@{@"scrollView": self.segmentedScrollView}];
    [self.view addConstraints:verticalConstraints];
    self.segmentScrollViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.segmentedScrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:topSpacing];
    [self.view addConstraint:self.segmentScrollViewTopConstraint];
    [self.segmentedScrollView setContentView];
    __weak typeof(self) weakSelf = self;
    self.segmentedScrollView.didSelectSegmentAtIndex = ^(SJSegmentTab *segmentTab, NSInteger index, BOOL animated) {
        UIViewController *selectedController = weakSelf.segmentControllers[index];
        if ([weakSelf.delegate respondsToSelector:@selector(didMoveToPage:segment:index:)]) {
            [weakSelf.delegate didMoveToPage:selectedController segment:segmentTab index:index];
        }
    };
}

- (void)addHeaderViewController:(UIViewController *)headerViewController {
    [self addChildViewController:headerViewController];
    [self.segmentedScrollView addHeaderView:headerViewController.view];
    [headerViewController didMoveToParentViewController:self];
}

- (void)addContentControllers:(NSArray<UIViewController *> *)contentControllers {
    [self.segmentedScrollView addSegmentView:contentControllers frame:self.view.bounds];
    NSInteger index = 0;
    for (UIViewController *controller in contentControllers) {
        [self addChildViewController:controller];
        [self.segmentedScrollView addContentView:controller.view frame:self.view.bounds];
        [controller didMoveToParentViewController:self];
        UIView *observeView = controller.view;
        if ([controller isKindOfClass:[UICollectionViewController class]]) {
            observeView = [(UICollectionViewController *)controller collectionView];
        }
        id<SJSegmentedViewControllerViewSource> delegate = (id<SJSegmentedViewControllerViewSource>)controller;
        if ([delegate respondsToSelector:@selector(viewForSegmentControllerToObserveContentOffsetChange)]) {
            observeView = [delegate viewForSegmentControllerToObserveContentOffsetChange];
        }
        [self.segmentedScrollView addObserverForView:observeView];
        index += 1;
    }
    self.segmentedScrollView.segmentView.contentView = self.segmentedScrollView.contentView;
}

- (void)loadControllers {
    if (self.headerViewController == nil) {
        self.headerViewController = [[UIViewController alloc] init];
        self.headerViewHeight = 0.0;
    }
    [self addHeaderViewController:self.headerViewController];
    [self addContentControllers:self.segmentControllers];
    SJSegmentTab *segment = nil;
    if (self.segments.count > 0) {
        segment = self.segments[0];
    }
    if ([self.delegate respondsToSelector:@selector(didMoveToPage:segment:index:)]) {
        [self.delegate didMoveToPage:self.segmentControllers[0] segment:segment index:0];
    }
}

@end
