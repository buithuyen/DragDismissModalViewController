//
//  ViewController.m
//  TransitionViewController
//
//  Created by ThuyenBV on 7/26/15.
//  Copyright (c) 2015 ThuyenBV. All rights reserved.
//

#import "ViewController.h"
#import "ChirldrenViewController.h"
#import "UINavigationController+DragToDismiss.h"

@interface ViewController ()

@property (nonatomic) NSArray *photos;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)btnPresentPressed:(id)sender {
    ChirldrenViewController *chirldrenViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ChirldrenViewController class])];
    
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:chirldrenViewController];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        navigation.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        navigation.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    else {
        [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    }
    
    [self presentViewController:navigation animated:YES completion:nil];
}

@end
