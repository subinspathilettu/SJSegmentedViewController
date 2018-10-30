//
//  SJSegmentTab.h
//  Hike
//
//  Created by Pavan Goyal on 30/04/18.
//  Copyright © 2018 Hike Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class SJSegmentTab;

typedef void (^DidSelectSegmentAtIndex)(SJSegmentTab *segmentTab, NSInteger index, BOOL animated);

@interface SJSegmentTab : UIView

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) DidSelectSegmentAtIndex didSelectSegmentAtIndex;

- (instancetype)initWithTitle:(NSString *)title;
- (instancetype)initWithView:(UIView *)view;
- (void)setTitle:(NSString *)title;
- (void)titleColor:(UIColor *)color;
- (void)titleFont:(UIFont *)font;
- (void)addConstraintsToView:(UIView *)view;

@end
