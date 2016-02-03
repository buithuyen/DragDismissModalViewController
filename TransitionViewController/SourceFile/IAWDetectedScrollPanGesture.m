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

- (void)dealloc {
//    [self removeObseverContentOffsetScrollView];
}

- (void)setScrollview:(UIScrollView*)scrollview {
    _scrollview = scrollview;

//    [self addObserverContentOffsetScrollView];
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

    if (self.isDisableGusture) {
        if (self.isDisableGusture.boolValue) {
            self.state = UIGestureRecognizerStateFailed;
        }
        return;
    }

    CGFloat topVerticalOffset       = -self.scrollview.contentInset.top;
    CGFloat scrollViewHeight        = self.scrollview.frame.size.height;
    CGFloat scrollContentSizeHeight = self.scrollview.contentSize.height;
    CGFloat bottomVerticalOffset    = scrollContentSizeHeight - scrollViewHeight;
    CGFloat scrollOffset            = self.scrollview.contentOffset.y;

    if (nowPoint.y >= prevPoint.y && scrollOffset <= topVerticalOffset) {
        /* Dismiss - Scroll khi dang o Top */
        self.isDisableGusture = @NO;
    } else if (nowPoint.y <= prevPoint.y && scrollOffset + scrollViewHeight >= scrollContentSizeHeight) {
        /* Dismiss - Scroll khi dang o Bottom */
        self.isDisableGusture = @NO;
    } else if (scrollOffset + 10 > topVerticalOffset && scrollOffset + 10 < bottomVerticalOffset) { /* +10 de fix bug sai so bottomOffset */
        /* Scroll Continue */
        self.state            = UIGestureRecognizerStateFailed;
        self.isDisableGusture = @YES;
    } else if (nowPoint.y >= prevPoint.y && scrollOffset > topVerticalOffset) {
        /* Scroll Continue */
        self.state            = UIGestureRecognizerStateFailed;
        self.isDisableGusture = @YES;
    } else {
        /* Dismiss */
        self.isDisableGusture = @NO;
    }
}

#pragma mark - add / remove obsever for page scrollView

- (void)addObserverContentOffsetScrollView {
    if (self.scrollview != nil) {
        [self.scrollview addObserver:self
                          forKeyPath:NSStringFromSelector(@selector(contentOffset))
                             options:NSKeyValueObservingOptionNew
                             context:&CONTENTOFFSET_SCROLLVIEW];
    }
}

- (void)removeObseverContentOffsetScrollView {
    if (self.scrollview != nil) {
        @try {
            [self.scrollview removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
        }@catch (NSException* exception) {
            NSLog(@"exception is %@", exception);
        } @finally {
        }
    }
}

#pragma mark - obsever delegate methods

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    if (context == CONTENTOFFSET_SCROLLVIEW) {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];

        NSLog(@"OFFSET: %@", NSStringFromCGPoint(offset));
    }
}

@end
