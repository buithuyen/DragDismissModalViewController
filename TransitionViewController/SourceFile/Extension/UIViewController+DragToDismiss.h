//
//  UINavigationController+DragToDismiss.h
//  TransitionViewController
//
//  Created by ThuyenBV on 8/5/15.
//  Copyright (c) 2015 ThuyenBV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IAWTransitionObject.h"

@interface UIViewController (DragToDismiss) <UIGestureRecognizerDelegate>

- (void)setUpTransition:(UIScrollView*)scrollView;

@end
