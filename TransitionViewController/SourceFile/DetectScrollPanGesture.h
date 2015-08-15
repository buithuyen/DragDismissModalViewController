//
//  DetectScrollPanGesture.h
//  TransitionViewController
//
//  Created by ThuyenBV on 8/15/15.
//  Copyright (c) 2015 ThuyenBV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetectScrollPanGesture : UIPanGestureRecognizer

@property (nonatomic, weak) UIScrollView *scrollview;
@property (nonatomic, strong) NSNumber *isFail;


@end
