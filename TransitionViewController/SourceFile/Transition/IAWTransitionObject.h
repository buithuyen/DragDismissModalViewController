//
//  TransitionObject.h
//  TransitionViewController
//
//  Created by ThuyenBV on 7/26/15.
//  Copyright (c) 2015 ThuyenBV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IAWTransitionObject : NSObject <
UIViewControllerTransitioningDelegate,
UIViewControllerInteractiveTransitioning,
UIAdaptivePresentationControllerDelegate>

+ (instancetype)initWithScrollView:(UIScrollView*)scrollView
                           panView:(UIViewController*)viewController;

@end
