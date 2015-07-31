//
//  ViewController.m
//  TransitionViewController
//
//  Created by ThuyenBV on 7/26/15.
//  Copyright (c) 2015 ThuyenBV. All rights reserved.
//

#import "ViewController.h"
#import "ChirldrenViewController.h"

@interface ViewController ()

@property (nonatomic) NSArray *photos;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnPresentPressed:(id)sender {
    ChirldrenViewController *chirldrenViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ChirldrenViewController class])];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        chirldrenViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        chirldrenViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    else {
        [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    }
    [self presentViewController:chirldrenViewController animated:YES completion:nil];
}

@end
