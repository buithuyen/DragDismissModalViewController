//
//  DetectScrollPanGesture.m
//  TransitionViewController
//
//  Created by ThuyenBV on 8/15/15.
//  Copyright (c) 2015 ThuyenBV. All rights reserved.
//

#import "DetectScrollPanGesture.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

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
