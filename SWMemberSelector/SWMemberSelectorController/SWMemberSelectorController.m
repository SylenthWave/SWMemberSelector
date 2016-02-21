//
//  SWMemberSelectorController.m
//  SWMemberSelector
//
//  Created by SylenthWave on 2/11/16.
//  Copyright © 2016 SylenthWave. All rights reserved.
//

#import "SWMemberSelectorController.h"
#import "PinYin4Objc.h"

#pragma mark - NSString+PinyinFormat
///-------------------------------------------
/// NSString+PinyinFormat class
///-------------------------------------------

@interface NSString(pinyinFormat)

- (NSString *)conversionFirstCharacterToPinyin;

@end

@implementation NSString(PinYinFormat)

- (NSString *)conversionFirstCharacterToPinyin {
    if (![self isEqualToString:@""]) {
        NSString *firstChar = [self substringWithRange:NSMakeRange(0, 1)];
        NSString *outputString;
        const char *c = [firstChar UTF8String];
        if (strlen(c) == 3) {
            outputString = [NSString stringWithFormat:@"%c",pinyinFirstLetter([firstChar characterAtIndex:0])];
        } else {
            outputString = firstChar;
        }
        return outputString;
    } else {
        return @"";
    }
}

+ (NSString *)conversionStringToPinyinString:(NSString *)formatterString {
    
    NSString *chineseName = formatterString;
    NSString *chineseNameNoEmpty = [chineseName stringByReplacingOccurrencesOfString:@" " withString:@""];
    formatterString = [formatterString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *sourecText = formatterString;
    HanyuPinyinOutputFormat *hanyupinyin = [[HanyuPinyinOutputFormat alloc] init];
    [hanyupinyin setToneType:ToneTypeWithoutTone];
    [hanyupinyin setVCharType:VCharTypeWithV];
    [hanyupinyin setCaseType:CaseTypeLowercase];
    
    NSString *outputPinyin = [PinyinHelper toHanyuPinyinStringWithNSString:sourecText withHanyuPinyinOutputFormat:hanyupinyin withNSString:@""];
    
    NSString *firstCharacterName;
    if ([outputPinyin isEqualToString:formatterString]) {
        
        NSArray *items = [chineseName componentsSeparatedByString:@" "];
        NSMutableString *mutableString = [[NSMutableString alloc] init];
        
        for (NSString *string in items) {
            if (string.length > 0) {
                [mutableString appendString:[string substringToIndex:1]];
            }
        }
        firstCharacterName = (NSString *)mutableString;
        
    } else {
        
        NSString * outputString = @"";
        for (int i =0; i<[chineseNameNoEmpty length]; i++) {
            outputString = [NSString stringWithFormat:@"%@%c",outputString,pinyinFirstLetter([chineseNameNoEmpty characterAtIndex:i])];
            
        }
        firstCharacterName = outputString;
        
    }
    
    NSString *allNameString = [NSString stringWithFormat:@"%@ %@ %@ %@",chineseName, chineseNameNoEmpty, outputPinyin, firstCharacterName];
    
    return allNameString;
}

@end

#pragma mark - SWMember
///-------------------------------------------
/// SWMember class
///-------------------------------------------
@interface SWMember()

@property (nonatomic, copy, readwrite) NSString *nickname;
@property (nonatomic, copy, readwrite) NSString *userId;
@property (nonatomic, copy, readwrite) UIImage *headerImage;

@end

@implementation SWMember

- (instancetype)initWithNickname:(NSString *)nickname
                             uid:(NSString *)uid
                          headerImage:(UIImage *)headerImage
                          status:(SWMemberSelectorStatus)status{
    self = [super init];
    if (self) {
        _nickname = nickname;
        _userId = uid;
        _headerImage = headerImage;
        _status = status;
    }
    return self;
}

@end

#pragma mark - SWMemberSelectorCell
///-------------------------------------------
/// SWMemberSelectorCell class
///------------------------------------------

@interface SWMemberSelectorCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIImageView *selectorImageView;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UIView *lineView;

- (void)setupWithSWMemebr:(SWMember *)member;
@end

@implementation SWMemberSelectorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headerImageView = ({
            UIImageView *headerView = [UIImageView new];
            headerView.translatesAutoresizingMaskIntoConstraints = NO;
            headerView;
        });
        
        _selectorImageView = ({
            UIImageView *selectorImageView = [UIImageView new];
            selectorImageView.translatesAutoresizingMaskIntoConstraints = NO;
            selectorImageView;
        });
        
        _nicknameLabel = ({
            UILabel *nicknameLabel = [UILabel new];
            nicknameLabel.translatesAutoresizingMaskIntoConstraints = NO;
            nicknameLabel;
        });
        
        _lineView = ({
            UIView *l = [UIView new];
            l.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
            l.translatesAutoresizingMaskIntoConstraints = NO;
            l;
        });
        
        [self addSubview:_headerImageView];
        [self addSubview:_selectorImageView];
        [self addSubview:_nicknameLabel];
        [self addSubview:_lineView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // _selectorImageView layout
    NSDictionary *viewDic = NSDictionaryOfVariableBindings(_selectorImageView,_headerImageView,_nicknameLabel);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[_selectorImageView(==25)]-7-[_headerImageView(==35)]-7-[_nicknameLabel]" options:0 metrics:nil views:viewDic]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_selectorImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
     [self addConstraint:[NSLayoutConstraint constraintWithItem:_selectorImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:25.0]];
    
    // headerImageView layout
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_headerImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_selectorImageView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_headerImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:35.0]];
    
    // nicknameLabel layout
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nicknameLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:35.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nicknameLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_headerImageView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    // lineView layout
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_lineView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_lineView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_lineView(==0.5)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_lineView)]];
    
}

- (void)setupWithSWMemebr:(SWMember *)member {
    self.nicknameLabel.text = member.nickname;
    self.headerImageView.image = member.headerImage;
    switch (member.status) {
        case SWMemberSelectorStatusUnSelect:
            self.selectorImageView.image = kMemberSelectorCellUnSelectImage;
            break;
        case SWMemberSelectorStatusSelected:
            self.selectorImageView.image = kMemberSelectorCellSelectedImage;
            break;
        case SWMemberSelectorStatusSelecting:
            self.selectorImageView.image = kMemberSelectorCellSelectingImage;
            break;
        default:
            break;
    }
}

@end

#pragma mark - SWMemberCollectionViewCell
///-------------------------------------------
/// SWMemberCollectionViewCell class
///------------------------------------------

@interface SWMemberCollectionViewCell  : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
- (void)setupCollectionCellWithImage:(UIImage *)image;

@end

@implementation SWMemberCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            imageView;
        });
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setupCollectionCellWithImage:(UIImage *)image {
    self.imageView.image = image;
}

@end

#pragma mark - SWMemberSelectedTextField
///-------------------------------------------
/// SWMemberSelectedTextField class
///-------------------------------------------

@interface SWMemberSelectedTextField: UITextField

- (void)deleteWhitespaceWithBlock:(void(^)(void))block;

@end

@interface SWMemberSelectedTextField ()
@property (nonatomic, copy) void(^whiteSpaceDeleteBlock)(void);
@end

@implementation SWMemberSelectedTextField

- (void)deleteBackward {
    if ([self.text isEqualToString:@""]) {
        if(self.whiteSpaceDeleteBlock) {
            self.whiteSpaceDeleteBlock();
        }
    }
    [super deleteBackward];
}

- (void)deleteWhitespaceWithBlock:(void (^)(void))block {
    self.whiteSpaceDeleteBlock = block;
}

@end

#pragma mark - SWMemberSearchView
///-------------------------------------------
/// SWMemberSearchView class
///------------------------------------------
@class SWMemberSearchBar;
@protocol SWMemberSearchBarDelegate <NSObject>

@optional
- (void)memberSearchBardoubleTappedBackwardButton;
- (void)memberSearchBarDidBeginEdit:(SWMemberSearchBar *)searchBar;
- (BOOL)memberSearchBar:(SWMemberSearchBar *)memberSearchBar shouldChangeCharacterInRange:(NSRange)range replacmentString:(NSString *)string;
@end

@interface SWMemberSearchBar : UIView

@property (nonatomic, weak) id<SWMemberSearchBarDelegate>delegate;

@property (nonatomic, strong) UIImageView *searchIcon;
@property (nonatomic, strong) SWMemberSelectedTextField *textField;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *memberArray;

- (instancetype)initWithFrame:(CGRect)frame members:(NSArray *)members;
- (void)addMember:(SWMember *)member;
- (void)removeMember:(SWMember *)member isResignFirstResponder:(BOOL)isResignFirstResponder;
- (void)didSelectedHeaderCellWithBlock:(void(^)(SWMember *member))block;

@end

static const CGFloat kMemberCollectionCellWidthAndHeight = 35;
static const CGFloat kMemberCollectionCellPadding = 5;
static const CGFloat kIconTextFieldMargin = 25;

typedef void(^SWMemberSearchBarSelectedCellBlock)(SWMember *member);

@interface SWMemberSearchBar ()<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) CAShapeLayer *lineLayer;
@property (nonatomic, copy) SWMemberSearchBarSelectedCellBlock selectedCellBlock;
@property (nonatomic, assign) CGFloat collectionViewOriginalWidth;
@property (nonatomic, assign) BOOL isSecondBackward;
@property (nonatomic, strong) UIView *grayView;
@end

@implementation SWMemberSearchBar

#pragma mark -- LifeCycle

- (instancetype)initWithFrame:(CGRect)frame members:(NSArray *)members {
    self = [super initWithFrame:frame];
    if (self) {
        
        _memberArray = [members mutableCopy];
        
        _searchIcon = ({
            UIImageView *searchIcon = [[UIImageView alloc] init];
            searchIcon.image = kMemberSearchBarIconImage;
            searchIcon;
        });
        
        _collectionView = ({
            UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                                  collectionViewLayout:layout];
            collectionView.delegate = self;
            collectionView.dataSource = self;
            collectionView.backgroundColor = [UIColor whiteColor];
            [collectionView registerClass:[SWMemberCollectionViewCell class]
               forCellWithReuseIdentifier:@"Cell"];
            collectionView.translatesAutoresizingMaskIntoConstraints = NO;
            collectionView;
        });
        
        _textField = ({
            SWMemberSelectedTextField *textField = [SWMemberSelectedTextField new];
            textField.font = [UIFont systemFontOfSize:14];
            textField.tintColor = kMemberSearchBarTintColor;
            textField.placeholder = NSLocalizedString(@"搜索", nil);
            textField.delegate = self;
            textField.translatesAutoresizingMaskIntoConstraints = NO;
            
            __weak __typeof(self)weakSelf = self;
            [textField deleteWhitespaceWithBlock:^{
                
                SWMemberCollectionViewCell *cell = (SWMemberCollectionViewCell *)[weakSelf.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:weakSelf.memberArray.count-1 inSection:0]];
                
                if (weakSelf.isSecondBackward) {
                    
                    if (self.memberArray.count > 0) {
                        if ([weakSelf.delegate respondsToSelector:@selector(memberSearchBardoubleTappedBackwardButton)]) {
                            [weakSelf.delegate memberSearchBardoubleTappedBackwardButton];
                        }
                    }
                    weakSelf.isSecondBackward = NO;
                    [_grayView removeFromSuperview];
                    
                } else {
                    _grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)];
                    _grayView.backgroundColor = [UIColor grayColor];
                    _grayView.alpha = 0.4;
                    [cell addSubview:_grayView];
                    weakSelf.isSecondBackward = YES;
                }
            }];
            
            textField;
        });
        
        
        _lineLayer = ({
            CAShapeLayer *lineLayer = [CAShapeLayer new];
            lineLayer.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2].CGColor;
            lineLayer;
        });
        
        [self addSubview:_collectionView];
        [self addSubview:_searchIcon];
        [self addSubview:_textField];
        [self.layer addSublayer:_lineLayer];
        [self layoutMemberSearchBarViews];
    }
    return self;
}

- (void)layoutMemberSearchBarViews {
    
    // CollectionView/searchIcon/textField layout
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-10-[_collectionView(==%.0f)]-2-[_textField]-10-|",self.collectionViewOriginalWidth] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView,_textField)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0.0 constant:35.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_textField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0.0 constant:40.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    self.lineLayer.frame = CGRectMake(0, self.bounds.size.height-0.5, self.bounds.size.width, 0.5);
    self.searchIcon.frame = CGRectMake(0, 0, 23, 23);
    self.searchIcon.center = CGPointMake(kIconTextFieldMargin - 3, self.frame.size.height/2);
    
}

- (NSMutableArray *)memberArray {
    return _memberArray = _memberArray ?: @[].mutableCopy;
}

- (CGFloat)collectionViewOriginalWidth {
    if (self.memberArray.count > 0) {
        self.searchIcon.hidden = YES;
        CGFloat collectionWidth = self.memberArray.count * (kMemberCollectionCellPadding + kMemberCollectionCellWidthAndHeight);
        if (collectionWidth > self.frame.size.width - 100) {
            collectionWidth = self.frame.size.width - 100;
        }
        return collectionWidth;
    } else {
        return 25;
    }
}


#pragma mark -- Actions

- (void)addMember:(SWMember *)member {
    
    // if tapped backward
    // remove the grayView from SWMemberCollectionViewCell
    if (self.isSecondBackward) {
        self.isSecondBackward = NO;
        [self.grayView removeFromSuperview];
    }
    
    
    [self.memberArray addObject:member];
    [self addCollectionViewWidth];
    
    if (![self.textField.text isEqualToString:@""]) {
        self.textField.text = @"";
    }
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
}

- (void)removeMember:(SWMember *)member isResignFirstResponder:(BOOL)isResignFirstResponder {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.memberArray indexOfObject:member] inSection:0];
    [self.memberArray removeObject:member];
    [self reduceCollectionViewWidth];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    
    if (![self.textField.text isEqualToString:@""]) {
        self.textField.text = @"";
    }
    if (isResignFirstResponder) {
        [self.textField resignFirstResponder];
    }
}

- (void)didSelectedHeaderCellWithBlock:(void (^)(SWMember *))block {
    self.selectedCellBlock = block;
}

- (void)addCollectionViewWidth {
    self.searchIcon.hidden = YES;
    self.collectionView.hidden = NO;
    
    NSLayoutConstraint *collectionWidth;
    for(NSLayoutConstraint *constraint in [self.collectionView constraintsAffectingLayoutForAxis:UILayoutConstraintAxisHorizontal]) {
        if (constraint.firstAttribute == NSLayoutAttributeWidth) {
            collectionWidth = constraint;
        }
    }
    
    if (collectionWidth.constant < self.frame.size.width - 100) {
        
        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionFade;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.fillMode = kCAFillModeForwards;
        transition.duration = 0.5;
        
        NSIndexPath *indexPathOfInsertedCell = [NSIndexPath indexPathForItem:self.memberArray.count-1 inSection:0];
        [[self.collectionView layer] addAnimation:transition forKey:@"UICollectionViewInsertRowAnimationKey"];
        [self.collectionView insertItemsAtIndexPaths:@[ indexPathOfInsertedCell ]];
        collectionWidth.constant = (kMemberCollectionCellWidthAndHeight + kMemberCollectionCellPadding ) * self.memberArray.count;
        
    } else {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.memberArray.count-1 inSection:0];
        [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

- (void)reduceCollectionViewWidth {
    self.searchIcon.hidden = YES;
    self.collectionView.hidden = NO;
    
    NSLayoutConstraint *collectionWidth;
    for(NSLayoutConstraint *constraint in [self.collectionView constraintsAffectingLayoutForAxis:UILayoutConstraintAxisHorizontal]) {
        if (constraint.firstAttribute == NSLayoutAttributeWidth) {
            collectionWidth = constraint;
        }
    }
    if (self.collectionView.contentSize.width <= self.collectionView.frame.size.width) {
        
        if (self.memberArray.count != 0) {
            
            [self layoutIfNeeded];
            [UIView animateWithDuration:0.1 animations:^{
                collectionWidth.constant = (kMemberCollectionCellPadding + kMemberCollectionCellWidthAndHeight) * self.memberArray.count;
                [self layoutIfNeeded];
            }];
            
        } else {
            self.searchIcon.hidden = NO;
            collectionWidth.constant = kIconTextFieldMargin;
            if ([self.textField isFirstResponder]) {
                [self.textField resignFirstResponder];
            }
        }
    }
}

- (void)changeCollectionViewConstraintsToOrigin:(BOOL)isChangeOrigin {
    self.collectionView.hidden = YES;
    self.searchIcon.hidden = !isChangeOrigin;
    NSLayoutConstraint *collectionWidth;
    for(NSLayoutConstraint *constraint in [self.collectionView constraintsAffectingLayoutForAxis:UILayoutConstraintAxisHorizontal]) {
        if (constraint.firstAttribute == NSLayoutAttributeWidth) {
            collectionWidth = constraint;
        }
    }
    collectionWidth.constant = isChangeOrigin ? kIconTextFieldMargin : 0.0f;
}

#pragma mark -- TextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.memberArray.count == 0) {
        //if member array count == 0 and begin editing
        //change collection view position to (0,0)
        [self changeCollectionViewConstraintsToOrigin:NO];
    }
    
    if ([self.delegate respondsToSelector:@selector(memberSearchBarDidBeginEdit:)]) {
        [self.delegate memberSearchBarDidBeginEdit:self];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.memberArray.count == 0) {
        //when textField resigned the first responder
        //and member array count is empty
        //change collection view position to origin
        [self changeCollectionViewConstraintsToOrigin:YES];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self.delegate respondsToSelector:@selector(memberSearchBar:shouldChangeCharacterInRange:replacmentString:)]) {
        return [self.delegate memberSearchBar:self shouldChangeCharacterInRange:range replacmentString:string];
    } else {
        return YES;
    }
}

#pragma mark -- Collection delegate and datasource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImage *headerImage = [self.memberArray[indexPath.row] valueForKey:@"headerImage"];
    SWMemberCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell setupCollectionCellWithImage:headerImage];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SWMember *member = self.memberArray[indexPath.row];
    if (member.status == SWMemberSelectorStatusSelected) return;
    [self removeMember:member isResignFirstResponder:YES];
    
    if (self.selectedCellBlock) {
        self.selectedCellBlock(member);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.memberArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kMemberCollectionCellWidthAndHeight, kMemberCollectionCellWidthAndHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kMemberCollectionCellPadding;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

@end

#pragma mark - SWMemberSearchResultViewController
///-------------------------------------------
/// SWMemberSearchResultViewController class
///------------------------------------------

static const NSInteger SWMemberSelectTableViewOffset = 50;
@class SWMemberSearchResultViewController;

@protocol SWMemberSearchResultViewControllerDelegate <NSObject>

@optional

- (void)memberSearchResultViewControllerWillBeginSearch:(SWMemberSearchResultViewController *)memberSearchViewController;
- (void)memberSearchResultViewController:(SWMemberSearchResultViewController *)resultViewController didShowMemberSearchResultTable:(UITableView *)tableView;
- (void)memberSearchResultViewController:(SWMemberSearchResultViewController *)resultViewController didHideMemberSearchResultTable:(UITableView *)tableView;
- (void)memberSearchResultViewController:(SWMemberSearchResultViewController *)resultViewController willShowMemberSearchResultTable:(UITableView *)tableView;
- (void)memberSearchResultViewController:(SWMemberSearchResultViewController *)resultViewController willHideMemberSearchResultTable:(UITableView *)tableView;
- (BOOL)memberSearchResultViewController:(SWMemberSearchResultViewController *)resultViewController sholudReloadTableForSearchString:(NSString *)string;
- (void)doubleTappedBackwardButton;

@end

@interface SWMemberSearchResultViewController : UITableViewController

- (instancetype)initWithMemberSearchBar:(SWMemberSearchBar *)memberSearchBar
                 contentsViewController:(UIViewController *)viewController;

@property (nonatomic, weak) id<SWMemberSearchResultViewControllerDelegate> delegate;
@property (readonly, nonatomic, weak) SWMemberSearchBar *memberSearchBar;
@property (readonly, nonatomic, weak) UIViewController *memberSearchContentsController;
@property (nonatomic, assign) id<UITableViewDelegate> memberSearchResultDelegate;
@property (nonatomic, assign) id<UITableViewDataSource> memberSearchResultDatasource;

// Remove from super view & view controller
- (void)removeViewAndControllerFromContainerViewController;

@end

@interface SWMemberSearchResultViewController ()<SWMemberSearchBarDelegate>
@property (readwrite, nonatomic, weak) SWMemberSearchBar *memberSearchBar;
@property (readwrite, nonatomic, weak) UIViewController *memberSearchContentsController;
@end

@implementation SWMemberSearchResultViewController

#pragma mark -- LifeCycle

- (instancetype)initWithMemberSearchBar:(SWMemberSearchBar *)memberSearchBar
                 contentsViewController:(UIViewController *)viewController {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _memberSearchBar = memberSearchBar;
        _memberSearchBar.delegate = self;
        _memberSearchContentsController = viewController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)addViewAndControllerToContainerViewController {
    if (![[self.memberSearchContentsController.view subviews] containsObject:self.view]) {
        
        if ([self.delegate respondsToSelector:@selector(memberSearchResultViewController:willShowMemberSearchResultTable:)]) {
            [self.delegate memberSearchResultViewController:self willShowMemberSearchResultTable:self.tableView];
        }
        
        [self.memberSearchContentsController.view addSubview:self.view];
        [self.memberSearchContentsController addChildViewController:self];
        self.tableView.frame = CGRectMake(0, SWMemberSelectTableViewOffset, self.memberSearchContentsController.view.frame.size.width, self.memberSearchContentsController.view.frame.size.height - SWMemberSelectTableViewOffset);
        
        if ([self.delegate respondsToSelector:@selector(memberSearchResultViewController:didShowMemberSearchResultTable:)]) {
            [self.delegate memberSearchResultViewController:self didShowMemberSearchResultTable:self.tableView];
        }
    }
}

- (void)removeViewAndControllerFromContainerViewController {
    
    if ([self.delegate respondsToSelector:@selector(memberSearchResultViewController:willHideMemberSearchResultTable:)]) {
        [self.delegate memberSearchResultViewController:self willHideMemberSearchResultTable:self.tableView];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.view.alpha = 1.0;
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
    }];
    
    if ([self.delegate respondsToSelector:@selector(memberSearchResultViewController:didHideMemberSearchResultTable:)]) {
        [self.delegate memberSearchResultViewController:self didHideMemberSearchResultTable:self.tableView];
    }
}

#pragma mark -- Getter & Setter

- (void)setMemberSearchResultDelegate:(id<UITableViewDelegate>)memberSearchResultDelegate {
    _memberSearchResultDelegate = memberSearchResultDelegate;
    self.tableView.delegate = _memberSearchResultDelegate;
}

- (void)setMemberSearchResultDatasource:(id<UITableViewDataSource>)memberSearchResultDatasource {
    _memberSearchResultDatasource = memberSearchResultDatasource;
    self.tableView.dataSource = _memberSearchResultDatasource;
}

#pragma mark -- SWMemberSearchBar delegate

- (void)memberSearchBarDidBeginEdit:(SWMemberSearchBar *)searchBar {
    if ([self.delegate respondsToSelector:@selector(memberSearchResultViewControllerWillBeginSearch:)]) {
        [self.delegate memberSearchResultViewControllerWillBeginSearch:self];
    }
}

- (BOOL)memberSearchBar:(SWMemberSearchBar *)memberSearchBar shouldChangeCharacterInRange:(NSRange)range replacmentString:(NSString *)string {
    
    //Remove or Insert self
    if (range.length == 1 && memberSearchBar.textField.text.length == 1) {
        //remove to the last character
        //remove self from super view & super view controller
        [self removeViewAndControllerFromContainerViewController];
    } else {
        //if insert text to textField
        //add self to container view controller
        [self addViewAndControllerToContainerViewController];
    }
    
    NSString *searchString;
    if (range.length == 1 && [string isEqualToString:@""]) {
        searchString = [memberSearchBar.textField.text stringByReplacingCharactersInRange:range withString:string];
    } else {
        searchString = [memberSearchBar.textField.text stringByAppendingString:string];
    }
    
    if ([self.delegate respondsToSelector:@selector(memberSearchResultViewController:sholudReloadTableForSearchString:)]) {
        if ([self.delegate memberSearchResultViewController:self sholudReloadTableForSearchString:searchString]) {
            [self.tableView reloadData];
        }
    }
    
    return YES;
}

- (void)memberSearchBardoubleTappedBackwardButton {
    if ([self.delegate respondsToSelector:@selector(doubleTappedBackwardButton)]) {
        [self.delegate doubleTappedBackwardButton];
    }
}

@end

#pragma mark - SWMemberSelectorController
///-------------------------------------------
/// SWMemberSelectorController class
///-------------------------------------------

static NSString * const SWMemberSelectorCellID = @"CellIdentifier";
static NSString * const SWMemberSearchResultCellID = @"ResultTableViewCellIdentifier";

@interface SWMemberSelectorController ()<SWMemberSearchResultViewControllerDelegate, SWMemberSearchBarDelegate>

@property (nonatomic, strong) NSArray *originMembers;
@property (nonatomic, strong) NSArray *sectionMembers;
@property (nonatomic, strong) NSMutableArray *selectingMembers;
@property (nonatomic, strong) NSMutableArray *selectedMembers;
@property (nonatomic, strong) NSMutableArray *filtredMembers;

@property (nonatomic, strong, readwrite) UITableView *tableView;
@property (nonatomic, strong, readwrite) SWMemberSearchBar *memberSearchBar;
@property (nonatomic, strong, readwrite) SWMemberSearchResultViewController *resultViewController;

@property (nonatomic, copy) void(^leftBarButtonBlock)(void);
@property (nonatomic, copy) void(^selectedMembersBlock)(NSArray *selectedMembers);

@end

@implementation SWMemberSelectorController

#pragma mark -- LifeCycle

- (instancetype)initWithMembers:(NSArray *)members {
    self = [super initWithNibName:nil bundle:nil];
    if (!self) return nil;
    _originMembers = members;
    
    _selectingMembers = [NSMutableArray array];
    _selectedMembers = [NSMutableArray array];
    _filtredMembers = [NSMutableArray array];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupNavigationBar];
    [self setupMemberSearchBar];
    [self setupMembers];
    [self setupTableView];
    [self setupResultViewController];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = CGRectMake(0, SWMemberSelectTableViewOffset, self.view.frame.size.width, self.view.frame.size.height - SWMemberSelectTableViewOffset);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"SWMemberSelectorController dealloced");
}

#pragma mark -- Setup

- (void)setupMembers {
    self.sectionMembers = [self sectionForSourceArray:self.originMembers];
    [self.originMembers enumerateObjectsUsingBlock:^(SWMember *member, NSUInteger idx, BOOL * _Nonnull stop) {
        if (member.status == SWMemberSelectorStatusSelecting) {
            [self.selectingMembers addObject:member];
        }
        if (member.status == SWMemberSelectorStatusSelected) {
            [self.selectedMembers addObject:member];
        }
    }];
}

- (void)setupMemberSearchBar {
    self.memberSearchBar = [[SWMemberSearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SWMemberSelectTableViewOffset) members:self.selectingMembers];
    self.memberSearchBar.backgroundColor = [UIColor whiteColor];
    //selected search bar collection cell call back
    __weak __typeof(self)weakSelf = self;
    [self.memberSearchBar didSelectedHeaderCellWithBlock:^(SWMember *member) {
        member.status = SWMemberSelectorStatusUnSelect;
        [weakSelf.selectingMembers removeObject:member];
        [weakSelf.tableView reloadData];
        [weakSelf changeConfirmButtonNumber];
    }];
    [self.view addSubview:self.memberSearchBar];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.sectionIndexColor = kMemberSelectorSectionIndexColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[SWMemberSelectorCell class] forCellReuseIdentifier:SWMemberSelectorCellID];
    
    self.tableView.tableFooterView = ({
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - 12, 0.5)];
        topLineView.backgroundColor =[UIColor colorWithWhite:0.8 alpha:1.0];
        UILabel *textLabel = [UILabel new];
        textLabel.font = [UIFont systemFontOfSize:16];
        textLabel.textColor = [UIColor grayColor];
        textLabel.text = [NSString stringWithFormat:@"%ld位联系人",self.originMembers.count];
        [textLabel sizeToFit];
        textLabel.center = footerView.center;
        [footerView addSubview:textLabel];
        [footerView addSubview:topLineView];
        footerView;
    });
    
    [self.view addSubview:self.tableView];
}

- (void)setupResultViewController {
    self.resultViewController =  [[SWMemberSearchResultViewController alloc] initWithMemberSearchBar:self.memberSearchBar contentsViewController:self];
    self.resultViewController.memberSearchResultDelegate = self;
    self.resultViewController.memberSearchResultDatasource  = self;
    self.resultViewController.delegate = self;
    [self.resultViewController.tableView registerClass:[SWMemberSelectorCell class] forCellReuseIdentifier:SWMemberSearchResultCellID];
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"选择联系人";
    UIBarButtonItem *confirmBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"确定", nil) style:UIBarButtonItemStyleDone target:self action:@selector(tapConfirmButton:)];
    confirmBarButton.tintColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    confirmBarButton.enabled = NO;
    [self.navigationItem setRightBarButtonItem:confirmBarButton animated:NO];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil) style:UIBarButtonItemStyleDone target:self action:@selector(tapLeftBarButton)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

#pragma mark -- Actions

- (void)didSelectedMemeberWithBlock:(void (^)(NSArray *))block {
    self.selectedMembersBlock = block;
}

- (void)tapConfirmButton:(id)sender {
    if (self.selectedMembersBlock) {
        if ([self isModal]) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        self.selectedMembersBlock(self.selectingMembers);
   }
}

- (void)tapLeftBarButton {
    if ([self isModal]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -- Privacy Method

- (BOOL)isModal {
    if([self presentingViewController])
        return YES;
    if([[self presentingViewController] presentedViewController] == self)
        return YES;
    if([[[self navigationController] presentingViewController] presentedViewController] == [self navigationController])
        return YES;
    if([[[self tabBarController] presentingViewController] isKindOfClass:[UITabBarController class]])
        return YES;
    
    return NO;
}

- (NSArray *)sectionForSourceArray:(NSArray *)sourceArray {
    
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    NSMutableArray *unsortedSections = [[NSMutableArray alloc] initWithCapacity:[[collation sectionTitles] count]];
    for (NSUInteger i = 0; i < [[collation sectionTitles] count]; i++) {
        [unsortedSections addObject:[NSMutableArray array]];
    }
    
    for (SWMember *member in sourceArray) {
        NSInteger index = [collation sectionForObject:[member.nickname conversionFirstCharacterToPinyin] collationStringSelector:@selector(description)];
        [[unsortedSections objectAtIndex:index] addObject:member];
    }
    return unsortedSections;
}

- (void)changeConfirmButtonNumber {
    NSString *titleString;
    if (self.selectingMembers.count > 0) {
        titleString = [NSString stringWithFormat:NSLocalizedString(@"确定(%ld)", nil),self.selectingMembers.count];
    } else {
        titleString = NSLocalizedString(@"确定", nil);
    }
    
    UIBarButtonItem *confirmBarButton = [[UIBarButtonItem alloc] initWithTitle:titleString style:UIBarButtonItemStyleDone target:self action:@selector(tapConfirmButton:)];
    self.navigationItem.rightBarButtonItem = nil;
    if (self.selectingMembers.count > 0) {
        confirmBarButton.tintColor = [UIColor whiteColor];
    } else {
        confirmBarButton.tintColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        confirmBarButton.enabled = NO;
    }
    
    [self.navigationItem setRightBarButtonItem:confirmBarButton animated:NO];
}

#pragma mark -- UITableView datasource and delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        SWMember *member = self.sectionMembers[indexPath.section][indexPath.row];
        SWMemberSelectorCell *cell = [tableView dequeueReusableCellWithIdentifier:SWMemberSelectorCellID];
        [cell setupWithSWMemebr:member];
        if ([self.sectionMembers[indexPath.section] count] == indexPath.row + 1) {
            cell.lineView.hidden = YES;
       } else {
            cell.lineView.hidden = NO;
        }
        return cell;
    } else {
        SWMemberSelectorCell *cell = [self.resultViewController.tableView dequeueReusableCellWithIdentifier:SWMemberSearchResultCellID];
        SWMember *member = self.filtredMembers[indexPath.row];
        [cell setupWithSWMemebr:member];
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return self.sectionMembers.count;
    } else {
        return 1;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        NSMutableArray *sectionMembersInSection = self.sectionMembers[section];
        return sectionMembersInSection.count;
    } else {
        return self.filtredMembers.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        NSArray *members = self.sectionMembers[section];
        if (members.count > 0) {
            return 20;
        } else {
            return 0;
        }    
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.tableView ) {
        
        SWMemberSelectorCell *cell = (SWMemberSelectorCell *)[tableView cellForRowAtIndexPath:indexPath];
        SWMember *member = self.sectionMembers[indexPath.section][indexPath.row];
        
        if (member.status != SWMemberSelectorStatusSelected) {
            BOOL isContains = [self.selectingMembers containsObject:member];
            if (!isContains) {
                // add
                member.status = SWMemberSelectorStatusSelecting;
                [self.memberSearchBar addMember:member];
                [self.selectingMembers addObject:member];
                cell.headerImageView.image = [UIImage imageNamed:@"selecting_img"];
            } else {
                // remove
                member.status = SWMemberSelectorStatusUnSelect;
                [self.memberSearchBar removeMember:member isResignFirstResponder:YES];
                [self.selectingMembers removeObject:member];
                cell.headerImageView.image = [UIImage imageNamed:@"unselect_img"];
            }
        }
    } else {
        
        //Did select result cell
        SWMember *member = self.filtredMembers[indexPath.row];
        if (member.status == SWMemberSelectorStatusUnSelect) {
            
            if (![self.selectingMembers containsObject:member]) {
                member.status = SWMemberSelectorStatusSelecting;
                [self.selectingMembers addObject:member];
                [self.memberSearchBar addMember:member];
            }
            
        } else if (member.status == SWMemberSelectorStatusSelecting) {
            
            if ([self.selectingMembers containsObject:member]) {
                member.status = SWMemberSelectorStatusUnSelect;
                [self.selectingMembers removeObject:member];
                [self.memberSearchBar removeMember:member isResignFirstResponder:YES];
            }
        }
        [self.resultViewController removeViewAndControllerFromContainerViewController];
    }
    
    [self.tableView reloadData];
    [self changeConfirmButtonNumber];
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerview = (UITableViewHeaderFooterView *)view;
    headerview.contentView.backgroundColor = kMemberSelectorHeaderColor;
    headerview.textLabel.font = [UIFont systemFontOfSize:14];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        if ([self.sectionMembers[section] count] > 0) {
            return [[UILocalizedIndexedCollation currentCollation] sectionTitles][section];
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == self.tableView && self.originMembers.count > 0) {
        return  [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (tableView == self.tableView) {
        if ([title isEqualToString:UITableViewIndexSearch]) {
            return NSNotFound;
        } else {
            return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index] - 1;
        }
    } else {
        return 0;
    }
}


#pragma mark -- UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.memberSearchBar.textField isFirstResponder]) {
        [self.memberSearchBar.textField resignFirstResponder];
    }
}

#pragma mark -- SWMemberSearchResultViewController delegate

- (void)doubleTappedBackwardButton {
    SWMember *member = self.selectingMembers.lastObject;
    member.status = SWMemberSelectorStatusUnSelect;
    [self.memberSearchBar removeMember:member isResignFirstResponder:NO];
    [self.selectingMembers removeObject:member];
    [self.tableView reloadData];
    [self changeConfirmButtonNumber];
}

- (void)memberSearchResultViewController:(SWMemberSearchResultViewController *)resultViewController didShowMemberSearchResultTable:(UITableView *)tableView {
    NSLog(@"begin search");
}

- (void)memberSearchResultViewController:(SWMemberSearchResultViewController *)resultViewController didHideMemberSearchResultTable:(UITableView *)tableView {
    [self.filtredMembers removeAllObjects];
}

- (BOOL)memberSearchResultViewController:(SWMemberSearchResultViewController *)resultViewController sholudReloadTableForSearchString:(NSString *)string {
    
    [self.filtredMembers removeAllObjects];
    for (SWMember *member in self.originMembers) {
        NSString *pinyinString = [NSString conversionStringToPinyinString:member.nickname];
        if ([self searchResult:pinyinString searchText:string]) {
            if (![self.filtredMembers containsObject:member]) {
                [self.filtredMembers addObject:member];
            }
        } else {
            if ([self searchResult:member.nickname searchText:string]) {
                if (![self.filtredMembers containsObject:member]) {
                    [self.filtredMembers addObject:member];
                }
            }
        }
    }
    return YES;
}

- (BOOL)searchResult:(NSString *)contactName searchText:(NSString *)searchT{
    if (contactName==nil || searchT == nil || [contactName isEqualToString:@"(null)"]==YES) {
        return NO;
    }
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    NSRange productNameRange = NSMakeRange(0, contactName.length);
    NSRange foundRange = [contactName rangeOfString:searchT options:searchOptions range:productNameRange];
    if (foundRange.length > 0)
        return YES;
    else
        return NO;
}

@end

