//
//  IAWPresentationController.m
//  TransitionViewController
//
//  Created by ThuyenBV on 11/8/17.
//  Copyright © 2017 ThuyenBV. All rights reserved.
//

#import "IAWPresentationController.h"

@interface IAWPresentationController()

@property (nonatomic, strong) UIView *dimmingView;

@end

@implementation IAWPresentationController

- (UIView *)dimmingView {
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.0];
    
    return view;
}

- (CGRect)frameOfPresentedViewInContainerView {
    return CGRectMake(0, 100, self.containerView.frame.size.width, self.containerView.frame.size.height - 100);
}

- (void)presentationTransitionWillBegin {
    if (self.containerView == nil) {
        return;
    }
    
    [self.containerView addSubview:self.dimmingView];
    
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.dimmingView.alpha = 1.0;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
}

- (void)dismissalTransitionWillBegin {
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.dimmingView.alpha = 0.0;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
}

- (void)containerViewWillLayoutSubviews {
    self.presentedView.frame = CGRectMake(0, 100, self.containerView.frame.size.width, self.containerView.frame.size.height - 100);
}

@end
