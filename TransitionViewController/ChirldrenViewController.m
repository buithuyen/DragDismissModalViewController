//
//  ChirldrenViewController.m
//  TransitionViewController
//
//  Created by ThuyenBV on 7/26/15.
//  Copyright (c) 2015 ThuyenBV. All rights reserved.
//

#import "ChirldrenViewController.h"
#import "UIViewController+DragToDismiss.h"

@interface ChirldrenViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ChirldrenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTransition:self.collectionView];
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

@end
