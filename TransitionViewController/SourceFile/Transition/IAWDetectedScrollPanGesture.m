//
//  DetectScrollPanGesture.m
//  TransitionViewController
//
//  Created by ThuyenBV on 8/5/15.
//  Copyright (c) 2015 ThuyenBV. All rights reserved.
//

#import "IAWDetectedScrollPanGesture.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

const void* CONTENTOFFSET_SCROLLVIEW = &CONTENTOFFSET_SCROLLVIEW;

@implementation IAWDetectedScrollPanGesture

- (void)reset {
    [super reset];
    self.isDisableGusture = nil;
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    [super touchesMoved:touches withEvent:event];

    if (!self.scrollview) {
        return;
    }

    if (self.state == UIGestureRecognizerStateFailed) {
        return;
    }
    
    CGPoint nowPoint  = [touches.anyObject locationInView:self.view];
    CGPoint prevPoint = [touches.anyObject previousLocationInView:self.view];

    if (self.isDisableGusture.boolValue) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }

    CGFloat topVerticalOffset       = -self.scrollview.contentInset.top;
    CGFloat scrollViewHeight        = self.scrollview.frame.size.height;
    CGFloat scrollContentSizeHeight = self.scrollview.contentSize.height;
    CGFloat scrollOffset            = self.scrollview.contentOffset.y;
    CGFloat bottomVerticalOffset    = scrollContentSizeHeight - scrollViewHeight;

    if (nowPoint.y >= prevPoint.y && scrollOffset <= topVerticalOffset) {
        /* Dismiss - Scroll khi dang o Top */
        self.isDisableGusture = @NO;
    }
//    else if (nowPoint.y <= prevPoint.y && scrollOffset + scrollViewHeight >= scrollContentSizeHeight) {
//        /* Dismiss - Scroll khi dang o Bottom */
//        self.isDisableGusture = @NO;
//    }
    else if (scrollOffset > topVerticalOffset && scrollOffset < bottomVerticalOffset) { /* +10 de fix bug sai so bottomOffset */
        /* Scroll Continue */
        self.state            = UIGestureRecognizerStateFailed;
        self.isDisableGusture = @YES;
    } else if (nowPoint.y >= prevPoint.y && scrollOffset > topVerticalOffset) {
        /* Scroll Continue */
        self.state            = UIGestureRecognizerStateFailed;
        self.isDisableGusture = @YES;
    } else {
        self.state            = UIGestureRecognizerStateFailed;
        /* Dismiss */
        self.isDisableGusture = @YES;
    }
}

@end
