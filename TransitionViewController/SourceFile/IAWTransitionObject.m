//
//  TransitionObject.m
//  TransitionViewController
//
//  Created by ThuyenBV on 7/26/15.
//  Copyright (c) 2015 ThuyenBV. All rights reserved.
//

#import "IAWTransitionObject.h"

static const CGFloat InteractionControllerPanDismissDistanceRatio              = 50.0 / 667.0;
static const CGFloat InteractionControllerPanDismissMaximumDuration            = 0.45;
static const CGFloat InteractionControllerReturnToCenterVelocityAnimationRatio = 0.00007;
//static const CGRect ScreenBounds = UIScreen.mainScreen.bounds;

@interface IAWTransitionObject ()

@property (nonatomic) id <UIViewControllerContextTransitioning> transitionContext;

@end

@implementation IAWTransitionObject

- (void)didPanWithPanGestureRecognizer:(UIPanGestureRecognizer*)panGestureRecognizer
                             viewToPan:(UIView*)viewToPan
                           anchorPoint:(CGPoint)anchorPoint {
    UIView* fromView                  = [self fromViewForTransitionContext:self.transitionContext];
    CGPoint translatedPanGesturePoint = [panGestureRecognizer translationInView:fromView];
    CGPoint newCenterPoint            = CGPointMake(anchorPoint.x, anchorPoint.y + translatedPanGesturePoint.y);

    viewToPan.center = newCenterPoint;

    CGFloat verticalDelta = newCenterPoint.y - anchorPoint.y;

    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self finishPanWithPanGestureRecognizer:panGestureRecognizer verticalDelta:verticalDelta viewToPan:viewToPan anchorPoint:anchorPoint];
    }
}

- (UIView*)fromViewForTransitionContext:(id <UIViewControllerContextTransitioning> )transitionContext {
    UIView* fromView;

    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    } else {
        fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    }

    return fromView;
}

- (UIView*)toViewForTransitionContext:(id <UIViewControllerContextTransitioning> )transitionContext {
    UIView* toView;

    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    }

    return toView;
}

- (CGRect)finalFrameForToViewControllerWithTransitionContext:(id <UIViewControllerContextTransitioning> )transitionContext {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        return [transitionContext finalFrameForViewController:toViewController];
    }

    return transitionContext.containerView.bounds;
}

- (void)finishPanWithPanGestureRecognizer:(UIPanGestureRecognizer*)panGestureRecognizer verticalDelta:(CGFloat)verticalDelta viewToPan:(UIView*)viewToPan anchorPoint:(CGPoint)anchorPoint {
    UIView* fromView = [self fromViewForTransitionContext:self.transitionContext];

    CGFloat velocityY = [panGestureRecognizer velocityInView:panGestureRecognizer.view].y;

    CGFloat animationDuration        = (ABS(velocityY) * InteractionControllerReturnToCenterVelocityAnimationRatio) + 0.2;
    CGFloat animationCurve           = UIViewAnimationOptionCurveEaseOut;
    CGPoint finalPageViewCenterPoint = anchorPoint;

    CGFloat dismissDistance = InteractionControllerPanDismissDistanceRatio * CGRectGetHeight(fromView.bounds);
    BOOL isDismissing       = ABS(verticalDelta) > dismissDistance;

    if (isDismissing) {
        BOOL isPositiveDelta = verticalDelta >= 0;

        CGFloat modifier     = isPositiveDelta ? 1 : -1;
        CGFloat finalCenterY = CGRectGetMidY(fromView.bounds) + modifier * CGRectGetHeight(fromView.bounds);
        finalPageViewCenterPoint = CGPointMake(fromView.center.x, finalCenterY);

        animationDuration = ABS(finalPageViewCenterPoint.y - viewToPan.center.y) / ABS(velocityY);
        animationDuration = MIN(animationDuration, InteractionControllerPanDismissMaximumDuration);

        animationCurve = UIViewAnimationOptionCurveEaseOut;
    }

    [UIView animateWithDuration:animationDuration delay:0 options:animationCurve animations:^{
        viewToPan.center = finalPageViewCenterPoint;
    } completion:^(BOOL finished) {
        if (isDismissing) {
            [self.transitionContext finishInteractiveTransition];
        } else {
            [self.transitionContext cancelInteractiveTransition];
        }

        [self.transitionContext completeTransition:isDismissing && !self.transitionContext.transitionWasCancelled];
    }];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning> )animationControllerForPresentedController:(UIViewController*)presented
                                                                    presentingController:(UIViewController*)presenting
                                                                        sourceController:(UIViewController*)source {
    self.isDismissing = NO;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning> )animationControllerForDismissedController:(UIViewController*)dismissed {
    self.isDismissing = YES;
    return self;
}

- (id <UIViewControllerInteractiveTransitioning> )interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning> )animator {
    if (self.isInteraction) {
        return self;
    }

    return nil;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning> )transitionContext {
    return 1.0;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning> )transitionContext {
    UIView* fromView = [self fromViewForTransitionContext:transitionContext];
    UIView* toView   = [self toViewForTransitionContext:transitionContext];
    
    UIViewController* toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    toView.frame = [self finalFrameForToViewControllerWithTransitionContext:transitionContext];

    if (![toView isDescendantOfView:transitionContext.containerView]) {
        [transitionContext.containerView addSubview:toView];
    }

    if (self.isDismissing) {
        [transitionContext.containerView bringSubviewToFront:fromView];
    }

    UIView* viewToFade     = toView;
    CGFloat beginningAlpha = 0.0;
    CGFloat endingAlpha    = 1.0;
    
//    CGRect startFrame = CGRectMake(0, ScreenBounds.size.height, ScreenBounds.size.width, ScreenBounds.size.height);


    if (self.isDismissing) {
        viewToFade     = fromView;
        beginningAlpha = 1.0;
        endingAlpha    = 0.0;
    }
    
    viewToFade.alpha = beginningAlpha;

    [toViewController beginAppearanceTransition:YES animated:YES];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        viewToFade.alpha = endingAlpha;
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

#pragma mark - UIViewControllerInteractiveTransitioning

- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning> )transitionContext {
    self.transitionContext = transitionContext;
}

@end
