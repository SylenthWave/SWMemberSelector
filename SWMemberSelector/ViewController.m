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
    
    NSArray *avatars = @[@"avatar1",@"avatar2",@"avatar3",@"avatar4",@"avatar5",@"avatar6"];
    NSArray *nameArr = @[@"张三三",@"李思思",@"王五五",@"周溜溜",@"萌萌哒",@"Alton"];
    NSMutableArray *members = [NSMutableArray new];
    [avatars enumerateObjectsUsingBlock:^(NSString *avatar, NSUInteger idx, BOOL * _Nonnull stop) {
        SWMember *m = [[SWMember alloc] initWithNickname:nameArr[idx] uid:[NSString stringWithFormat:@"%ld",idx] headerImage:[UIImage imageNamed:avatar] status:SWMemberSelectorStatusUnSelect];
        [members addObject:m];
    }];
    
    
    SWMemberSelectorController *memberSelectorController = [[SWMemberSelectorController alloc] initWithMembers:members];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:memberSelectorController];
    [[UINavigationBar appearance] setBarTintColor:[UIColor orangeColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [self presentViewController:nav animated:YES completion:nil];
    
    
    
}

@end
