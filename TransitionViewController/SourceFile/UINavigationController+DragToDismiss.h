//
//  UINavigationController+DragToDismiss.h
//  TransitionViewController
//
//  Created by ThuyenBV on 8/5/15.
//  Copyright (c) 2015 ThuyenBV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionObject.h"
#import "DetectScrollPanGesture.h"

@interface UINavigationController (DragToDismiss) <UIGestureRecognizerDelegate>

@property (nonatomic, strong) TransitionObject *objTransition;
@property (strong, nonatomic) DetectScrollPanGesture *panGesture;

- (void)setUpTransition;
- (void)dismissInteraction:(BOOL)isInteraction animation:(BOOL)animated;
- (void)didPanWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer;


@end
