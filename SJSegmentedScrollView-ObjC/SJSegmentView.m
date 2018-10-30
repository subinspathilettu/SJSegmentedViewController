//
//  SJSegmentView.m
//  Hike
//
//  Created by Pavan Goyal on 02/05/18.
//  Copyright © 2018 Hike Pvt. Ltd. All rights reserved.
//

#import "SJSegmentView.h"
#import "SJUtil.h"

@interface SJSegmentView ()

@end

@implementation SJSegmentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _kSegmentViewTagOffset = 100;
        _segmentViewOffsetWidth = 10.0;
        _segments = [[NSMutableArray alloc] init];
        _contentSubViewWidthConstraints = [[NSMutableArray alloc] init];
        _controllers = [[NSArray alloc] init];
        _segmentViewHeight = 53.0;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeSegmentIndex:) name:@"DidChangeSegmentIndex" object:nil];
    }
    return self;
}

- (void)setSelectedSegmentViewColor:(UIColor *)selectedSegmentViewColor {
    _selectedSegmentViewColor = selectedSegmentViewColor;
    self.selectedSegmentView.backgroundColor = selectedSegmentViewColor;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    for (SJSegmentTab *segment in self.segments) {
        [segment titleColor:titleColor];
    }
}

- (void)setSegmentBackgroundColor:(UIColor *)segmentBackgroundColor {
    _segmentBackgroundColor = segmentBackgroundColor;
    for (SJSegmentTab *segment in self.segments) {
        [segment setBackgroundColor:segmentBackgroundColor];
    }
}

- (void)setContentView:(SJContentView *)contentView {
    _contentView = contentView;
    [contentView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)didChangeSegmentIndex:(NSNotification *)notification {
    for (SJSegmentTab *button in self.segments) {
        button.isSelected = NO;
    }
    NSNumber *index = notification.object;
    if (index.integerValue < self.segments.count) {
        SJSegmentTab *button = self.segments[index.integerValue];
        button.isSelected = YES;
    }
}

- (void)dealloc {
    [self.contentView removeObserver:self forKeyPath:@"contentOffset" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DidChangeSegmentIndex" object:nil];
}

- (void)setSegmentsView:(CGRect)frame {
    CGFloat segmentWidth = [self widthForSegment:frame];
    [self createSegmentContentView:segmentWidth];
    NSInteger index = 0;
    for (UIViewController *controller in self.controllers) {
        [self createSegmentForController:controller width:segmentWidth index:index];
        index += 1;
    }
    [self createSelectedSegmentView:segmentWidth];
    SJSegmentTab *button = self.segments.firstObject;
    button.isSelected = YES;
}

- (void)createSegmentContentView:(CGFloat)titleWidth {
    self.segmentContentView = [[UIView alloc] initWithFrame:CGRectZero];
    self.segmentContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.segmentContentView];
    CGFloat contentViewWidth = titleWidth * self.controllers.count;
    NSArray<NSLayoutConstraint *> *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:@{@"contentView": self.segmentContentView, @"mainView": self}];
    [self addConstraints:horizontalConstraints];
    self.contentViewWidthConstraint = [NSLayoutConstraint constraintWithItem:self.segmentContentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:contentViewWidth];
    [self addConstraint:self.contentViewWidthConstraint];
    NSArray<NSLayoutConstraint *> *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView(==mainView)]|" options:0 metrics:nil views:@{@"contentView": self.segmentContentView, @"mainView": self}];
    [self addConstraints:verticalConstraints];
}

- (void)createSegmentForController:(UIViewController *)controller width:(CGFloat)width index:(NSInteger)index {
    SJSegmentTab *segmentTab = [self getSegmentTabForController:controller];
    segmentTab.tag = (index + self.kSegmentViewTagOffset);
    segmentTab.translatesAutoresizingMaskIntoConstraints = NO;
    [self.segmentContentView addSubview:segmentTab];
    if (self.segments.count == 0) {
        NSArray<NSLayoutConstraint *> *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]" options:0 metrics:nil views:@{@"view": segmentTab}];
        [self.segmentContentView addConstraints:horizontalConstraints];
    } else {
        SJSegmentTab *previousView = self.segments.lastObject;
        NSArray<NSLayoutConstraint *> *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousView]-0-[view]" options:0 metrics:nil views:@{@"view": segmentTab, @"previousView": previousView}];
        [self.segmentContentView addConstraints:horizontalConstraints];
    }
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:segmentTab attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
    [self.segmentContentView addConstraint:widthConstraint];
    [self.contentSubViewWidthConstraints addObject:widthConstraint];
    NSArray<NSLayoutConstraint *> *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]-1-|" options:0 metrics:nil views:@{@"view": segmentTab}];
    [self.segmentContentView addConstraints:verticalConstraints];
    [self.segments addObject:segmentTab];
}

- (void)createSelectedSegmentView:(CGFloat)width {
    UIView *segmentView = [[UIView alloc] init];
    segmentView.backgroundColor = self.selectedSegmentViewColor;
    segmentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.segmentContentView addSubview:segmentView];
    self.selectedSegmentView = segmentView;
    self.xPosConstraints = [NSLayoutConstraint constraintWithItem:segmentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.segmentContentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
    [self.segmentContentView addConstraint:self.xPosConstraints];
    SJSegmentTab *segment = self.segments.firstObject;
    NSArray<NSLayoutConstraint *> *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(==segment)]" options:0 metrics:nil views:@{@"view": segmentView, @"segment": segment}];
    [self.segmentContentView addConstraints:horizontalConstraints];
    NSArray<NSLayoutConstraint *> *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(height)]|" options:0 metrics:@{@"height": @(self.selectedSegmentViewHeight)} views:@{@"view": segmentView}];
    [self.segmentContentView addConstraints:verticalConstraints];
}

- (SJSegmentTab *)getSegmentTabForController:(UIViewController *)controller {
    SJSegmentTab *segmentTab = nil;
    if (controller.navigationItem.titleView != nil) {
        segmentTab = [[SJSegmentTab alloc] initWithView:controller.navigationItem.titleView];
    } else {
        if (controller.title) {
            segmentTab = [[SJSegmentTab alloc] initWithTitle:controller.title];
        } else {
            segmentTab = [[SJSegmentTab alloc] initWithTitle:@""];
        }
        segmentTab.backgroundColor = self.segmentBackgroundColor;
        [segmentTab titleColor:self.titleColor];
        [segmentTab titleFont:self.font];
    }
    segmentTab.didSelectSegmentAtIndex = self.didSelectSegmentAtIndex;
    segmentTab.translatesAutoresizingMaskIntoConstraints = NO;
    [segmentTab.heightAnchor constraintEqualToConstant:(self.segmentViewHeight-1)].active = YES;
    return segmentTab;
}

- (CGFloat)widthForSegment:(CGRect)frame {
    CGFloat maxWidth = 0;
    for (UIViewController *controller in self.controllers) {
        CGFloat width = 0.0;
        UIView *view = controller.navigationItem.titleView;
        NSString *title = controller.title;
        if (view) {
            width = view.bounds.size.width;
        } else if (title) {
            width = [SJUtil widthForString:title withConstrainedWidth:CGFLOAT_MAX font:self.font];
        }
        if (width > maxWidth) {
            maxWidth = width;
        }
    }
    CGFloat width = maxWidth + self.segmentViewOffsetWidth;
    CGFloat totalWidth = width * self.controllers.count;
    if (totalWidth < frame.size.width)  {
        maxWidth = frame.size.width / (CGFloat)self.controllers.count;
    } else {
        maxWidth = (CGFloat)width;
    }
    return maxWidth;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([change isKindOfClass:[NSDictionary class]]) {
        id old = change[NSKeyValueChangeOldKey];
        id new = change[NSKeyValueChangeNewKey];
        if (old && new) {
            if (![old isEqual:new]) {
                if ([object isKindOfClass:[UIScrollView class]]) {
                    UIScrollView *scrollView = object;
                    CGFloat changeOffset = scrollView.contentSize.width / self.contentSize.width;
                    CGFloat value = scrollView.contentOffset.x / changeOffset;
                    if (!isnan(value)) {
                        CGRect frame = self.selectedSegmentView.frame;
                        frame.origin.x = scrollView.contentOffset.x / changeOffset;
                        self.selectedSegmentView.frame = frame;
                    }
                    CGFloat segmentScrollWidth = self.contentSize.width - self.bounds.size.width;
                    CGFloat contentScrollWidth = scrollView.contentSize.width - scrollView.bounds.size.width;
                    changeOffset = segmentScrollWidth / contentScrollWidth;
                    CGFloat x = scrollView.contentOffset.x * changeOffset;
                    CGFloat y = self.contentOffset.y;
                    self.contentOffset = CGPointMake(x, y);
                }
            }
        }
    }
}

- (void)didChangeParentViewFrame:(CGRect)frame {
    CGFloat segmentWidth = [self widthForSegment:frame];
    CGFloat contentViewWidth = segmentWidth * self.controllers.count;
    self.contentViewWidthConstraint.constant = contentViewWidth;
    for (NSLayoutConstraint *constraint in self.contentSubViewWidthConstraints) {
        constraint.constant = segmentWidth;
    }
    CGFloat changeOffset = self.contentView.contentSize.width / self.contentSize.width;
    CGFloat value = self.contentView.contentOffset.x / changeOffset;
    if (!isnan(value)) {
        self.xPosConstraints.constant = self.selectedSegmentView.frame.origin.x;
        [self layoutIfNeeded];
    }
}

@end
