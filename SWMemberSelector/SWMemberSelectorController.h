//
//  SWMemberSelectorController.h
//  SWMemberSelector
//
//  Created by SylenthWave on 2/11/16.
//  Copyright © 2016 SylenthWave. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SWMemberSearchBar;
@class SWMemberSearchResultViewController;

#pragma mark - SWMember
///-------------------------------------------
/// SWMember class
///------------------------------------------

typedef NS_ENUM(NSUInteger, SWMemberSelectorStatus) {
    SWMemberSelectorStatusUnSelect = 0,
    SWMemberSelectorStatusSelecting,
    SWMemberSelectorStatusSelected,
};

@interface SWMember : NSObject

@property (nonatomic, copy, readonly) NSString *nickname;
@property (nonatomic, copy, readonly) NSString *userId;
@property (nonatomic, copy, readonly) UIImage *headerImage;
@property (nonatomic, assign) SWMemberSelectorStatus status;

- (instancetype)initWithNickname:(NSString *)nickname
                             uid:(NSString *)uid
                          headerImage:(UIImage *)headerImage
                          status:(SWMemberSelectorStatus)status;

@end

#pragma mark - ABMemberSelectViewController
///-------------------------------------------
/// ABMemberSelectViewController class
///------------------------------------------

@interface SWMemberSelectorController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) SWMemberSearchBar *memberSearchBar;
@property (nonatomic, strong, readonly) SWMemberSearchResultViewController *resultViewController;

/*!
 @discussion initialize ABMemberSelectViewController
 @param members array must be ABMember objects
 */
- (instancetype)initWithMembers:(NSArray *)members;

/*!
 @discussion Confirm button tapped callback, return selected members array
 @param return members array
 */
- (void)didSelectedMemeberWithBlock:(void(^)(NSArray *members))block;


@end
