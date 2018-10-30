//
//  SJSegmentTab.m
//  Hike
//
//  Created by Pavan Goyal on 30/04/18.
//  Copyright © 2018 Hike Pvt. Ltd. All rights reserved.
//

#import "SJSegmentTab.h"

@interface SJSegmentTab ()

@property(nonatomic, strong) UIButton *button;

@end

@implementation SJSegmentTab

- (instancetype)initWithTitle:(NSString *)title {
    self = [self initWithFrame:CGRectZero];
    [self setTitle:title];
    return self;
}

- (instancetype)initWithView:(UIView *)view {
    self = [self initWithFrame:CGRectZero];
    [self insertSubview:view atIndex:0];
    [view removeConstraints:view.constraints];
    [self addConstraintsToView:view];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = self.bounds;
        [self.button setSelected:NO];
        [self.button addTarget:self action:@selector(onSegmentButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button];
        [self addConstraintsToView:self.button];
    }
    return self;
}

- (void)addConstraintsToView:(UIView *)view {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray<NSLayoutConstraint *> *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": view}];
    NSArray<NSLayoutConstraint *> *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": view}];
    [self addConstraints:verticalConstraints];
    [self addConstraints:horizontalConstraints];
}

- (void)setTitle:(NSString *)title {
    [self.button setTitle:title forState:UIControlStateNormal];
}

- (void)titleColor:(UIColor *)color {
    [self.button setTitleColor:color forState:UIControlStateNormal];
}

- (void)titleFont:(UIFont *)font {
    self.button.titleLabel.font = font;
}

- (void)setIsSelected:(BOOL)isSelected {
    [self.button setSelected:isSelected];
}

- (void)onSegmentButtonPress:(id)sender {
    NSInteger index = self.tag - 100;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidChangeSegmentIndex" object:@(index)];
    if (self.didSelectSegmentAtIndex) {
        self.didSelectSegmentAtIndex(self, index, YES);
    }
}

@end
