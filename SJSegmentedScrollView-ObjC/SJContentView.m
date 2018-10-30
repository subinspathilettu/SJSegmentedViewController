//
//  SJContentView.m
//  Hike
//
//  Created by Pavan Goyal on 02/05/18.
//  Copyright © 2018 Hike Pvt. Ltd. All rights reserved.
//

#import "SJContentView.h"

@interface SJContentView () <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray<UIView *> *contentViews;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSLayoutConstraint *contentViewWidthConstraint;
@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *contentSubViewWidthConstraints;
@property (nonatomic, assign) CGFloat animationDuration;

@end

@implementation SJContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _pageIndex = 0;
        _contentViews = [[NSMutableArray alloc] init];
        _animationDuration = 0.3;
        _contentSubViewWidthConstraints = [[NSMutableArray alloc] init];
        self.delegate = self;
        [self setPagingEnabled:YES];
        self.contentView = [[UIView alloc] init];
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.contentView];
        NSArray<NSLayoutConstraint *> *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:@{@"contentView": self.contentView, @"mainView": self}];
        [self addConstraints:horizontalConstraints];
        self.contentViewWidthConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
        [self addConstraint:self.contentViewWidthConstraint];
        NSArray<NSLayoutConstraint *> *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView(==mainView)]|" options:0 metrics:nil views:@{@"contentView": self.contentView, @"mainView": self}];
        [self addConstraints:verticalConstraints];
    }
    return self;
}

- (void)addContentView:(UIView *)view frame:(CGRect)frame {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:view];
    CGFloat width = frame.size.width;
    if (self.contentViews.count > 0) {
        UIView *previousView = self.contentViews.lastObject;
        NSArray<NSLayoutConstraint *> *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousView]-0-[view]" options:0 metrics:@{@"xPos": @(self.contentViews.count * width)} views:@{@"view": view, @"previousView": previousView}];
        [self.contentView addConstraints:horizontalConstraints];
    } else {
        NSArray<NSLayoutConstraint *> *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]" options:0 metrics:@{@"xPos": @(self.contentViews.count * width)} views:@{@"view": view}];
        [self.contentView addConstraints:horizontalConstraints];
    }
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
    [self.contentView addConstraint:widthConstraint];
    [self.contentSubViewWidthConstraints addObject:widthConstraint];
    NSArray<NSLayoutConstraint *> *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view": view}];
    [self.contentView addConstraints:verticalConstraints];
    [self.contentViews addObject:view];
    self.contentViewWidthConstraint.constant = self.contentViews.count * self.bounds.size.width;
}

- (void)updateContentControllersFrame:(CGRect)frame {
    CGFloat width = frame.size.width;
    self.contentViewWidthConstraint.constant = self.contentViews.count * width;
    for (NSLayoutConstraint *constraint in self.contentSubViewWidthConstraints) {
        constraint.constant = width;
    }
    [self layoutIfNeeded];
    CGPoint point = self.contentOffset;
    point.x = self.pageIndex * width;
    [self setContentOffset:point animated:YES];
}

- (void)movePageToIndex:(NSInteger)index animated:(BOOL)animated {
    self.pageIndex = index;
    CGPoint point = CGPointMake((index * self.bounds.size.width), 0);
    if (animated) {
        [UIView animateWithDuration:self.animationDuration animations:^{
            self.contentOffset = point;
        }];
    } else {
        self.contentOffset = point;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageIndex = self.contentOffset.x / self.bounds.size.width;
    if (self.didSelectSegmentAtIndex) {
        self.didSelectSegmentAtIndex(nil, self.pageIndex, YES);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidChangeSegmentIndex" object:@(self.pageIndex)];
}

@end
