//
//  UIViewControllerAnimatedTransitioning.h
//  TransitionViewController
//
//  Created by ThuyenBV on 11/5/17.
//  Copyright © 2017 ThuyenBV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIViewControllerAnimatedTransition : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)initWithDismissState:(BOOL)isDismiss;

@end
