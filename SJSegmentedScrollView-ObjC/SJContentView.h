//
//  SJContentView.h
//  Hike
//
//  Created by Pavan Goyal on 02/05/18.
//  Copyright © 2018 Hike Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJSegmentTab.h"

@interface SJContentView : UIScrollView

@property (nonatomic, copy)   DidSelectSegmentAtIndex didSelectSegmentAtIndex;

- (void)addContentView:(UIView *)view frame:(CGRect)frame;
- (void)updateContentControllersFrame:(CGRect)frame;
- (void)movePageToIndex:(NSInteger)index animated:(BOOL)animated;

@end
