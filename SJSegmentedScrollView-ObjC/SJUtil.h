//
//  SJUtil.h
//  Hike
//
//  Created by Pavan Goyal on 30/04/18.
//  Copyright © 2018 Hike Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SJUtil : NSObject

+ (CGFloat)getTopSpacing:(UIViewController *)viewController;
+ (CGFloat)getBottomSpacing:(UIViewController *)viewController;
+ (CGFloat)widthForString:(NSString *)string withConstrainedWidth:(CGFloat)width font:(UIFont *)font;

@end
