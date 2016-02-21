//
//  ViewController.m
//  SWMemberSelector
//
//  Created by SylenthWave on 2/11/16.
//  Copyright © 2016 SylenthWave. All rights reserved.
//

#import "ViewController.h"
#import "SWMemberSelectorController.h"

@interface SWNavigationContoller : UINavigationController

@end

@implementation SWNavigationContoller

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end

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
    SWNavigationContoller *nav = [[SWNavigationContoller alloc] initWithRootViewController:memberSelectorController];
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [self presentViewController:nav animated:YES completion:nil];
    
    [memberSelectorController didSelectedMemeberWithBlock:^(NSArray *members) {
        NSLog(@"tapped confirm button\nselected %ld members",members.count);
    }];
    
}


@end
