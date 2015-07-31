//
//  ChirldrenViewController.m
//  TransitionViewController
//
//  Created by ThuyenBV on 7/26/15.
//  Copyright (c) 2015 ThuyenBV. All rights reserved.
//

#import "ChirldrenViewController.h"
#import "UIViewController+DagToDismiss.h"

@interface ChirldrenViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ChirldrenViewController

- (void)viewDidLoad {
    [self setUpTransition];
    self.panGesture = [[DetectScrollPanGesture alloc] initWithTarget:self
                                                              action:@selector(didPanWithGestureRecognizer:)];
    self.panGesture.delegate = self;
    self.panGesture.scrollview = self.collectionView;
    [self.view addGestureRecognizer:self.panGesture];
}

- (IBAction)btnDismiss:(id)sender {
    [self dismissInteraction:NO animation:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
