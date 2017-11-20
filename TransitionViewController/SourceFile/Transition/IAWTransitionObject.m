//
//  TransitionObject.m
//  TransitionViewController
//
//  Created by ThuyenBV on 7/26/15.
//  Copyright (c) 2015 ThuyenBV. All rights reserved.
//

#import "IAWTransitionObject.h"
#import "IAWDetectedScrollPanGesture.h"
#import "UIViewControllerAnimatedTransition.h"
#import "IAWPresentationController.h"
#import "UIViewController+DragToDismiss.h"

static const CGFloat InteractionControllerPanDismissDistanceRatio              = 50.0 / 667.0;
static const CGFloat InteractionControllerPanDismissMaximumDuration            = 0.45;
static const CGFloat InteractionControllerReturnToCenterVelocityAnimationRatio = 0.00007;

@interface IAWTransitionObject ()

@property (nonatomic) id <UIViewControllerContextTransitioning> transitionContext;
@property (strong, nonatomic) IAWDetectedScrollPanGesture* panGesture;
@property (strong, nonatomic) UIViewController *viewController;

@end

@implementation IAWTransitionObject

+ (instancetype)initWithScrollView:(UIScrollView*)scrollView panView:(UIViewController*)viewController {
    IAWTransitionObject *transition = [[IAWTransitionObject alloc] init];

    transition.viewController = viewController;
    transition.panGesture = [[IAWDetectedScrollPanGesture alloc] initWithTarget:transition
                                                                         action:@selector(didPanWithGestureRecognizer:)];
    transition.panGesture.delegate = transition.viewController;
    transition.panGesture.scrollview = scrollView;
    [transition.viewController.view addGestureRecognizer:transition.panGesture];

    return transition;
}

#pragma mark - Private Method

- (void)didPanWithGestureRecognizer:(UIPanGestureRecognizer*)panGestureRecognizer {
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self.viewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        
        UIView *viewToPan = self.viewController.view;
        UIView* fromView                  = [self.transitionContext viewForKey:UITransitionContextFromViewKey];

        CGPoint anchorPoint = CGPointMake(CGRectGetMidX(viewToPan.bounds), CGRectGetMidY(viewToPan.bounds));
        CGPoint translatedPanGesturePoint = [panGestureRecognizer translationInView:fromView];
        CGPoint newCenterPoint            = CGPointMake(anchorPoint.x, anchorPoint.y + translatedPanGesturePoint.y);
        CGFloat verticalDelta             = newCenterPoint.y - anchorPoint.y;
        
        viewToPan.center = newCenterPoint;
        
        if (viewToPan.frame.origin.y < 0) {
            CGRect newFrame = viewToPan.frame;
            newFrame.origin.y = 0;
            viewToPan.frame = newFrame;
            
            self.panGesture.isDisableGusture = @YES;
        } else {
            if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
                [self finishPanWithPanGestureRecognizer:panGestureRecognizer
                                          verticalDelta:verticalDelta
                                              viewToPan:viewToPan
                                            anchorPoint:anchorPoint];
            }
        }
    }
}

- (void)finishPanWithPanGestureRecognizer:(UIPanGestureRecognizer*)panGestureRecognizer
                            verticalDelta:(CGFloat)verticalDelta
                                viewToPan:(UIView*)viewToPan
                              anchorPoint:(CGPoint)anchorPoint {
    UIView* fromView = [self.transitionContext viewForKey:UITransitionContextFromViewKey];

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
    return [UIViewControllerAnimatedTransition initWithDismissState:NO];
}

- (id <UIViewControllerAnimatedTransitioning> )animationControllerForDismissedController:(UIViewController*)dismissed {
    return [UIViewControllerAnimatedTransition initWithDismissState:NO];
}

- (id <UIViewControllerInteractiveTransitioning> )interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning> )animator {
    return self;
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                      presentingViewController:(UIViewController *)presenting
                                                          sourceViewController:(UIViewController *)source {
    IAWPresentationController *presentation = [[IAWPresentationController alloc] initWithPresentedViewController:presented
                                                                                        presentingViewController:presenting];
    presentation.delegate = self;
    
    return presentation;
}

#pragma mark - UIViewControllerInteractiveTransitioning

- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning> )transitionContext {
    self.transitionContext = transitionContext;
}

#pragma mark - UIAdaptivePresentationControllerDelegate

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
                                                               traitCollection:(UITraitCollection *)traitCollection {
    return UIModalPresentationOverFullScreen;
}

- (UIViewController *)presentationController:(UIPresentationController *)controller viewControllerForAdaptivePresentationStyle:(UIModalPresentationStyle)style {
    return self.viewController;
}

@end
