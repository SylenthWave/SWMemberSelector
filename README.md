# SWMemberSelector

SWMemberSelector is a contacts selector like WeChat

## Screenshots

![Cast](http://7o51ag.com1.z0.glb.clouddn.com/github_swmemberselector.gif)

## Requirements

* iOS7+
* XCode7+

## Usage

Declare an array of SWMember Object and save the status

```
    NSArray *avatars = @[@"avatar1",@"avatar2",@"avatar3",@"avatar4",@"avatar5",@"avatar6"];
    NSArray *nameArr = @[@"张三三",@"李思思",@"王五五",@"周溜溜",@"萌萌哒",@"Alton"];
    NSMutableArray *members = [NSMutableArray new];
    
    [avatars enumerateObjectsUsingBlock:^(NSString *avatar, NSUInteger idx, BOOL * _Nonnull stop) {
        SWMember *m = [[SWMember alloc] initWithNickname:nameArr[idx] 
                                                     uid:[NSString stringWithFormat:@"%ld",idx] 
                                             headerImage:[UIImage imageNamed:avatar] 
                                                  status:SWMemberSelectorStatusUnSelect];
        [members addObject:m];
    }];
```

Then pass the array to initializer

```
    SWMemberSelectorController *memberSelectorController = [[SWMemberSelectorController alloc] initWithMembers:members];
    SWNavigationContoller *nav = [[SWNavigationContoller alloc] initWithRootViewController:memberSelectorController];
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [self presentViewController:nav animated:YES completion:nil];
```

your can call `didSelectedMemeberWithBlock` to get selected members
```
 [memberSelectorController didSelectedMemeberWithBlock:^(NSArray *members) {
        NSLog(@"tapped confirm button\nselected %ld members",members.count);
    }];
```

## TODO
* cocopods
