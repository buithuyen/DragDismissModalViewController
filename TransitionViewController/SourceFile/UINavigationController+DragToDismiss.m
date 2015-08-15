//
//  UINavigationController+DragToDismiss.m
//  TransitionViewController
//
//  Created by ThuyenBV on 8/5/15.
//  Copyright (c) 2015 ThuyenBV. All rights reserved.
//

#import "UINavigationController+DragToDismiss.h"

#import "TransitionObject.h"
#import <objc/runtime.h>

NSString const *keyNavigationObjectTransition = @"keyObjectTransition";
NSString const *keyNavigationPanGesture       = @"keyPanGesture";

@implementation UINavigationController (DragToDismiss)
@dynamic objTransition,panGesture;

#pragma mark - ObjTransiton

- (void)setObjTransition:(TransitionObject *)objTransition {
    objc_setAssociatedObject(self, &keyNavigationObjectTransition, objTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TransitionObject *)objTransition {
    return objc_getAssociatedObject(self, &keyNavigationObjectTransition);
}

#pragma mark - PanGesture

- (void)setPanGesture:(DetectScrollPanGesture *)panGesture {
    objc_setAssociatedObject(self, &keyNavigationPanGesture, panGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DetectScrollPanGesture *)panGesture {
    return objc_getAssociatedObject(self, &keyNavigationPanGesture);
}

#pragma mark - Public Method

- (void)setUpTransition {
    self.objTransition = [[TransitionObject alloc] init];
    
    self.modalPresentationStyle = UIModalPresentationCustom;
    
    self.transitioningDelegate = self.objTransition;
    self.modalPresentationCapturesStatusBarAppearance = YES;
}

- (void)didPanWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self dismissInteraction:YES animation:YES];
    }
    else {
        [self.objTransition didPanWithPanGestureRecognizer:panGestureRecognizer
                                                 viewToPan:self.view
                                               anchorPoint:self.boundsCenterPoint];
    }
}

- (void)dismissInteraction:(BOOL)isInteraction animation:(BOOL)animated {
    self.objTransition.isInteraction = isInteraction;
    [self dismissViewControllerAnimated:animated completion: ^{
    }];
}

#pragma mark - Private Method

- (CGPoint)boundsCenterPoint {
    return CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
