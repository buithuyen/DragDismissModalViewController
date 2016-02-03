//
//  TransitionObject.h
//  TransitionViewController
//
//  Created by ThuyenBV on 7/26/15.
//  Copyright (c) 2015 ThuyenBV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IAWTransitionObject : NSObject <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning>

@property (nonatomic, assign) BOOL isInteraction;
@property (nonatomic, assign) BOOL isDismissing;

- (void)didPanWithPanGestureRecognizer:(UIPanGestureRecognizer*)panGestureRecognizer
                             viewToPan:(UIView*)viewToPan
                           anchorPoint:(CGPoint)anchorPoint;

@end
