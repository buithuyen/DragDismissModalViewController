//
//  UINavigationController+DragToDismiss.h
//  TransitionViewController
//
//  Created by ThuyenBV on 8/5/15.
//  Copyright (c) 2015 ThuyenBV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IAWTransitionObject.h"
#import "IAWDetectedScrollPanGesture.h"

@interface UINavigationController (DragToDismiss) <UIGestureRecognizerDelegate>

@property (nonatomic, strong) IAWTransitionObject* objTransition;
@property (strong, nonatomic) IAWDetectedScrollPanGesture* panGesture;

- (void)setUpTransition;
- (void)dismissInteraction:(BOOL)isInteraction animation:(BOOL)animated;
- (void)didPanWithGestureRecognizer:(UIPanGestureRecognizer*)panGestureRecognizer;


@end
