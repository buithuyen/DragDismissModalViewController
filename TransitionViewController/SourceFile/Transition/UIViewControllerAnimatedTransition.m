//
//  UIViewControllerAnimatedTransitioning.m
//  TransitionViewController
//
//  Created by ThuyenBV on 11/5/17.
//  Copyright © 2017 ThuyenBV. All rights reserved.
//

#import "UIViewControllerAnimatedTransition.h"

@interface UIViewControllerAnimatedTransition ()

@property (assign, nonatomic) BOOL isDismissing;

@end

@implementation UIViewControllerAnimatedTransition

+ (instancetype)initWithDismissState:(BOOL)isDismiss {
    UIViewControllerAnimatedTransition *animated = [[UIViewControllerAnimatedTransition alloc] init];
    animated.isDismissing = isDismiss;
    
    return animated;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning> )transitionContext {
    return 1.0;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning> )transitionContext {
//    UIView* fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
//    UIView* toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    UIViewController* toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //    toView.frame = [self finalFrameForToViewControllerWithTransitionContext:transitionContext];
    
    //    if (![toView isDescendantOfView:transitionContext.containerView]) {
    //        [transitionContext.containerView addSubview:toView];
    //    }
    
    //    if (self.isDismissing) {
    //        [transitionContext.containerView bringSubviewToFront:fromView];
    //    }
    
    //    UIView* viewToFade     = toView;
    //    CGFloat beginningAlpha = 0.0;
    //    CGFloat endingAlpha    = 1.0;
    
    //    CGRect startFrame = CGRectMake(0, ScreenBounds.size.height, ScreenBounds.size.width, ScreenBounds.size.height);
    
    
//    if (self.isDismissing) {
        //        viewToFade     = fromView;
        //        beginningAlpha = 1.0;
        //        endingAlpha    = 0.0;
//    }
    
    //    viewToFade.alpha = beginningAlpha;
    
    [toViewController beginAppearanceTransition:YES animated:YES];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        //        viewToFade.alpha = endingAlpha;
    } completion:^(BOOL finished) {
        if (transitionContext.isInteractive) {
            if (transitionContext.transitionWasCancelled) {
                [transitionContext cancelInteractiveTransition];
            } else {
                [transitionContext finishInteractiveTransition];
            }
        }
        
        [toViewController endAppearanceTransition];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}


@end
