//
//  MyCollectTableViewCell.h
//  CATransform3D
//
//  Created by mac1 on 15/6/18.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kUtilityButtonsWidthMax 260
#define kUtilityButtonWidthDefault 90

static NSString * const kTableViewCellContentView = @"UITableViewCellContentView";

@class MyCollectTableViewCell;

#pragma mark - LCUtilityButtonView

@interface LCUtilityButtonView : UIView

@property (nonatomic, strong) NSArray *utilityButtons;
@property (nonatomic) CGFloat utilityButtonWidth;
@property (nonatomic, weak) MyCollectTableViewCell *parentCell;
@property (nonatomic) SEL utilityButtonSelector;

- (id)initWithUtilityButtons:(NSArray *)utilityButtons parentCell:(MyCollectTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector;

- (id)initWithFrame:(CGRect)frame utilityButtons:(NSArray *)utilityButtons parentCell:(MyCollectTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector;

@end



typedef enum{
    kCellStateCenter,
    kCellStateLeft,
    kCellStateRight
} MyCellState;

@protocol MyCollectTableViewCellDelegate <NSObject>

@optional
- (void)swippableTableViewCell:(MyCollectTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index;
- (void)swippableTableViewCell:(MyCollectTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index;
- (void)swippableTableViewCell:(MyCollectTableViewCell *)cell scrollingToState:(MyCellState)state;

@end





@interface MyCollectTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *leftButtons;
@property (nonatomic, strong) NSArray *rightButtons;
@property (nonatomic) id <MyCollectTableViewCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftButtons:(NSArray *)leftButtons rightButtons:(NSArray *)rightButtons;

- (void)setBackgroundColor:(UIColor *)backgroundColor;
- (void)hideButtonsAnimated:(BOOL)animated;


@property (nonatomic, strong) RentInfoModel *infoModel;
@property (nonatomic, assign) BOOL allSelected;


@end
