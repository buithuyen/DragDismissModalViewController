//
//  DetectScrollPanGesture.h
//  TransitionViewController
//
//  Created by ThuyenBV on 8/5/15.
//  Copyright (c) 2015 ThuyenBV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IAWDetectedScrollPanGesture : UIPanGestureRecognizer

@property (nonatomic, strong) UIScrollView* scrollview;
@property (nonatomic, strong) NSNumber* isDisableGusture;

@end
