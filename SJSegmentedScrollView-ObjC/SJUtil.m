//
//  SJUtil.m
//  Hike
//
//  Created by Pavan Goyal on 30/04/18.
//  Copyright © 2018 Hike Pvt. Ltd. All rights reserved.
//

#import "SJUtil.h"

@implementation SJUtil

+ (CGFloat)getTopSpacing:(UIViewController *)viewController {
    if (viewController.splitViewController) {
        CGFloat topSpacing = 0;
        UINavigationController *navigationController = viewController.navigationController;
        if (navigationController.childViewControllers.lastObject == viewController) {
            if (!navigationController.isNavigationBarHidden) {
                topSpacing = [[UIApplication sharedApplication] statusBarFrame].size.height;
                if (!navigationController.navigationBar.isOpaque) {
                    topSpacing += navigationController.navigationBar.bounds.size.height;
                }
            }
        }
        return topSpacing;
    } else {
        return 0;
    }
}

+ (CGFloat)getBottomSpacing:(UIViewController *)viewController {
    CGFloat bottomSpacing = 0.0;
    UITabBarController *tabBarController = viewController.tabBarController;
    if (tabBarController) {
        if ((!tabBarController.tabBar.isHidden) && (!tabBarController.tabBar.isOpaque)) {
            bottomSpacing += tabBarController.tabBar.bounds.size.height;
        }
    }
    return bottomSpacing;
}

+ (CGFloat)widthForString:(NSString *)string withConstrainedWidth:(CGFloat)width font:(UIFont *)font {
    CGSize constraintRect = CGSizeMake(width, CGFLOAT_MAX);
    CGRect boundingBox = [string boundingRectWithSize:constraintRect options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil];
    return boundingBox.size.width;
}

@end
