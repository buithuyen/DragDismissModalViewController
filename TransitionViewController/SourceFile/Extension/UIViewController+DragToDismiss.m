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

@implementation UIViewController (DragToDismiss)

#pragma mark - ObjTransiton

- (void)setObjTransition:(IAWTransitionObject*)objTransition {
    objc_setAssociatedObject(self, &keyNavigationObjectTransition, objTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (IAWTransitionObject*)objTransition {
    return objc_getAssociatedObject(self, &keyNavigationObjectTransition);
}

#pragma mark - Public Method

- (void)setUpTransition:(UIScrollView*)scrollView {
    self.objTransition = [IAWTransitionObject initWithScrollView:scrollView panView:self];

//    self.modalPresentationStyle = UIModalPresentationFormSheet;
//    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.transitioningDelegate                        = self.objTransition;
    self.modalPresentationStyle = UIModalPresentationCustom;
    
//    CGSize size = self.view.frame.size;
//    size.height = size.height - 100.0;
//
//    self.preferredContentSize = size;

    self.modalPresentationCapturesStatusBarAppearance = YES;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer {
    return YES;
}

@end
