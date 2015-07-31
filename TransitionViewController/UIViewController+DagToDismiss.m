//
//  UIViewController+DagToDismiss.m
//  TransitionViewController
//
//  Created by ThuyenBV on 7/31/15.
//  Copyright (c) 2015 ThuyenBV. All rights reserved.
//

#import "UIViewController+DagToDismiss.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

#import "TransitionObject.h"
#import <objc/runtime.h>

NSString const *keyObjectTransition = @"keyObjectTransition";
NSString const *keyPanGesture       = @"keyPanGesture";

@implementation UIViewController (DagToDismiss)
@dynamic objTransition,panGesture;

#pragma mark - ObjTransiton

- (void)setObjTransition:(TransitionObject *)objTransition {
    objc_setAssociatedObject(self, &keyObjectTransition, objTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TransitionObject *)objTransition {
    return objc_getAssociatedObject(self, &keyObjectTransition);
}

#pragma mark - PanGesture

- (void)setPanGesture:(DetectScrollPanGesture *)panGesture {
    objc_setAssociatedObject(self, &keyPanGesture, panGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DetectScrollPanGesture *)panGesture {
    return objc_getAssociatedObject(self, &keyPanGesture);
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

@end

@implementation DetectScrollPanGesture

- (void)reset {
    [super reset];
    self.isFail = nil;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    if (!self.scrollview) {
        return;
    }
    
    if (self.state == UIGestureRecognizerStateFailed) {
        return;
    }
    CGPoint nowPoint = [touches.anyObject locationInView:self.view];
    CGPoint prevPoint = [touches.anyObject previousLocationInView:self.view];
    
    if (self.isFail) {
        if (self.isFail.boolValue) {
            self.state = UIGestureRecognizerStateFailed;
        }
        return;
    }
    
    CGFloat topVerticalOffset = -self.scrollview.contentInset.top;
    CGFloat scrollViewHeight = self.scrollview.frame.size.height;
    CGFloat scrollContentSizeHeight = self.scrollview.contentSize.height;
    CGFloat scrollOffset = self.scrollview.contentOffset.y;
    
    if (nowPoint.y > prevPoint.y && scrollOffset <= topVerticalOffset) {
        self.isFail = @NO;
    }
    else if (nowPoint.y < prevPoint.y && scrollOffset + scrollViewHeight >= scrollContentSizeHeight) {
        self.isFail = @NO;
    }
    else if (scrollOffset >= topVerticalOffset  && scrollOffset <= scrollContentSizeHeight - scrollViewHeight) {
        self.state = UIGestureRecognizerStateFailed;
        self.isFail = @YES;
    }
    else {
        self.isFail = @NO;
    }
}


@end
