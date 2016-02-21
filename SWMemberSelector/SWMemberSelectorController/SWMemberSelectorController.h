//
//  SWMemberSelectorController.h
//  SWMemberSelector
//
//  Created by SylenthWave on 2/11/16.
//  Copyright © 2016 SylenthWave. All rights reserved.
//

#import <UIKit/UIKit.h>

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

// UI
#define kMemberSearchBarIconImage [UIImage imageNamed:@"search_icon"]
#define kMemberSelectorCellUnSelectImage [UIImage imageNamed:@"unselect_img"]
#define kMemberSelectorCellSelectingImage [UIImage imageNamed:@"selecting_img"]
#define kMemberSelectorCellSelectedImage [UIImage imageNamed:@"selected_img"]

// UIColor
#define kMemberSelectorHeaderColor [UIColor colorWithRed:0.93 green:0.93 blue:0.96 alpha:1.0]
#define kMemberSelectorSectionIndexColor [UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1.0]
#define kMemberSearchBarTintColor [UIColor colorWithRed:0.13 green:0.76 blue:0.56 alpha:1.0]

@interface SWMemberSelectorController : UIViewController<UITableViewDataSource,UITableViewDelegate>

/*!
 @discussion main table view
 */
@property (nonatomic, strong, readonly) UITableView *tableView;

/*!
 @discussion initialize ABMemberSelectViewController
 @param members array must be SWMember object
 */
- (instancetype)initWithMembers:(NSArray *)members;

/*!
 @discussion Confirm button tapped callback, return selected members array
 @param return members array
 */
- (void)didSelectedMemeberWithBlock:(void(^)(NSArray *members))block;


@end
