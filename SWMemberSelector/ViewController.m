//
//  ViewController.m
//  SWMemberSelector
//
//  Created by SylenthWave on 2/11/16.
//  Copyright © 2016 SylenthWave. All rights reserved.
//

#import "ViewController.h"
#import "SWMemberSelectorController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)buttonTapped:(id)sender {
    
    NSArray *members = [NSArray array];
    SWMemberSelectorController *memberSelectorController = [[SWMemberSelectorController alloc] initWithMembers:members];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:memberSelectorController];
    [[UINavigationBar appearance] setBarTintColor:[UIColor orangeColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [self presentViewController:nav animated:YES completion:nil];
    
}

@end
