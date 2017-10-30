//
//  UINavigationController+DragToDismiss.m
//  TransitionViewController
//
//  Created by ThuyenBV on 8/5/15.
//  Copyright (c) 2015 ThuyenBV. All rights reserved.
//

#import "UIViewController+DragToDismiss.h"

#import "IAWTransitionObject.h"
#import <objc/runtime.h>

NSString const* keyNavigationObjectTransition = @"keyObjectTransition";
NSString const* keyNavigationPanGesture       = @"keyPanGesture";

@implementation UIViewController (DragToDismiss)
//@dynamic objTransition, panGesture;

#pragma mark - ObjTransiton

- (void)setObjTransition:(IAWTransitionObject*)objTransition {
    objc_setAssociatedObject(self, &keyNavigationObjectTransition, objTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (IAWTransitionObject*)objTransition {
    return objc_getAssociatedObject(self, &keyNavigationObjectTransition);
}

#pragma mark - PanGesture

- (void)setPanGesture:(IAWDetectedScrollPanGesture*)panGesture {
    objc_setAssociatedObject(self, &keyNavigationPanGesture, panGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (IAWDetectedScrollPanGesture*)panGesture {
    return objc_getAssociatedObject(self, &keyNavigationPanGesture);
}

#pragma mark - Public Method

- (void)setUpTransition:(UIScrollView*)scrollView {
    self.objTransition = [[IAWTransitionObject alloc] init];

    self.modalPresentationStyle                       = UIModalPresentationCustom;
    self.transitioningDelegate                        = self.objTransition;
    self.modalPresentationCapturesStatusBarAppearance = YES;
    
    self.panGesture = [[IAWDetectedScrollPanGesture alloc] initWithTarget:self
                                                                   action:@selector(didPanWithGestureRecognizer:)];
    self.panGesture.delegate = self;
    self.panGesture.scrollview = scrollView;
    [self.view addGestureRecognizer:self.panGesture];
}

- (void)didPanWithGestureRecognizer:(UIPanGestureRecognizer*)panGestureRecognizer {
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self dismissInteraction:YES animation:YES];
    } else {
        [self.objTransition didPanWithPanGestureRecognizer:panGestureRecognizer
                                                 viewToPan:self.view
                                               anchorPoint:self.boundsCenterPoint];
    }
}

- (void)dismissInteraction:(BOOL)isInteraction animation:(BOOL)animated {
    self.objTransition.isInteraction = isInteraction;

    __weak __typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:animated completion:^{
        BOOL isStillOnscreen = weakSelf.view.window != nil;
        weakSelf.objTransition.isDismissing = !isStillOnscreen;
    }];
}

#pragma mark - Private Method

- (CGPoint)boundsCenterPoint {
    return CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer {
    return YES;
}

@end
