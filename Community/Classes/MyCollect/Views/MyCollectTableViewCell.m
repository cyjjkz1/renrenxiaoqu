//
//  MyCollectTableViewCell.m
//  CATransform3D
//
//  Created by mac1 on 15/6/18.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//


#import "MyCollectTableViewCell.h"


@implementation LCUtilityButtonView

- (id)initWithUtilityButtons:(NSArray *)utilityButtons parentCell:(MyCollectTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector
{
    if (self = [super init])
    {
        self.utilityButtons = utilityButtons;
        self.utilityButtonWidth = [self calculateUtilityButtonWidth];
        self.parentCell = parentCell;
        self.utilityButtonSelector = utilityButtonSelector;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame utilityButtons:(NSArray *)utilityButtons parentCell:(MyCollectTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector
{
    if (self = [super init])
    {
        self.utilityButtons = utilityButtons;
        self.utilityButtonWidth = [self calculateUtilityButtonWidth];
        self.parentCell = parentCell;
        self.utilityButtonSelector = utilityButtonSelector;
    }
    return self;
}

//计算button宽
- (CGFloat)calculateUtilityButtonWidth
{
    CGFloat buttonWidth = kUtilityButtonWidthDefault;
    if (buttonWidth * _utilityButtons.count > kUtilityButtonsWidthMax) {
        CGFloat buffer = (buttonWidth * _utilityButtons.count) - kUtilityButtonsWidthMax;
        buttonWidth -= (buffer / _utilityButtons.count);
    }
    return buttonWidth;
}

- (CGFloat)utilityButtonsWidth
{
    return (_utilityButtons.count * _utilityButtonWidth);
}

- (void)populateUtilityButtons {
    NSUInteger utilityButtonsCounter = 0;
    for (UIButton *utilityButton in _utilityButtons) {
        CGFloat utilityButtonXCord = 0;
        if (utilityButtonsCounter >= 1) utilityButtonXCord = _utilityButtonWidth * utilityButtonsCounter;
        [utilityButton setFrame:CGRectMake(utilityButtonXCord, 0, _utilityButtonWidth, CGRectGetHeight(self.bounds))];
        [utilityButton setTag:utilityButtonsCounter];
        [utilityButton addTarget:_parentCell action:_utilityButtonSelector forControlEvents:UIControlEventTouchDown];
        [self addSubview: utilityButton];
        utilityButtonsCounter++;
    }
}


@end


//*********************************************MyCollectTableViewCell*****************************************************
@interface MyCollectTableViewCell ()<UIScrollViewDelegate>
{
    MyCellState _state;
}
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic) UIScrollView *cellScrollView;


@property (nonatomic) UIView *scrollViewContentView;
@property (nonatomic) LCUtilityButtonView *leftView;
@property (nonatomic) LCUtilityButtonView *rightView;


@property (nonatomic, weak) UIView *grayPoint;
@property (nonatomic, weak) UIImageView *selectFlag;
@property (nonatomic, weak) UILabel *desLbl;
@property (nonatomic, weak) UILabel *typeLbl;
@property (nonatomic, weak) UILabel *dateLbl;


@end

@implementation MyCollectTableViewCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftButtons:(NSArray *)leftButtons rightButtons:(NSArray *)rightButtons
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.rightButtons = rightButtons;
        self.leftButtons = leftButtons;
        self.cellHeight = containingTableView.rowHeight;
        self.tableView = containingTableView;
        self.highlighted = NO;
        [self setupLoadViews];
    }
    
    
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setupLoadViews];
    }
    
    return self;
}

- (id)init {
    self = [super init];
    
    if (self) {
        [self setupLoadViews];
    }
    
    return self;
}

- (void)setupLoadViews
{
    CGFloat pointW = 9*BILI_WIDTH;
    UIView *grayPoint = [[UIView alloc] initWithFrame:CGRectMake(14 * BILI_WIDTH, (64*BILI_WIDTH - pointW) * 0.5, pointW, pointW)];
    grayPoint.backgroundColor = UIColorFromRGB(0xf6f6f6);
    grayPoint.layer.cornerRadius = pointW * 0.5;
    grayPoint.layer.masksToBounds = YES;
    [self.contentView addSubview:grayPoint];
    _grayPoint = grayPoint;
    
    CGFloat imgW = 15*BILI_WIDTH;
    UIImageView *selectFlag = [[UIImageView alloc] initWithFrame:CGRectMake(14 * BILI_WIDTH, (64*BILI_WIDTH - imgW) * 0.5, imgW, imgW)];
    selectFlag.image = [UIImage imageNamed:@"select_all"];
    selectFlag.hidden = YES;
    [self.contentView addSubview:selectFlag];
    _selectFlag = selectFlag;
    
    UILabel *desLbl = [[UILabel alloc] initWithFrame:CGRectMake(35 * BILI_WIDTH, 8*BILI_WIDTH, SCREEN_WIDTH - 35*BILI_WIDTH, 13*BILI_WIDTH)];
    desLbl.numberOfLines = 1;
    desLbl.textColor = [UIColor blackColor];
    desLbl.text = @"五大花园精装修，家具家电齐全，优质小区";
    desLbl.font = [UIFont systemFontOfSize:13*BILI_WIDTH];
    [self.contentView addSubview:desLbl];
    _desLbl = desLbl;
    
    UILabel *type = [[UILabel alloc] initWithFrame:CGRectMake(desLbl.x, desLbl.maxY + 7*BILI_WIDTH, SCREEN_WIDTH - desLbl.x, 11 * BILI_WIDTH)];
    type.textColor = UIColorFromRGB(0xb6bec1);
//    type.backgroundColor = [UIColor redColor];
    type.text = @"租房";
    type.font = [UIFont systemFontOfSize:11*BILI_WIDTH];
    [self.contentView addSubview:type];
    _typeLbl = type;
    
    UILabel *dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(desLbl.x, type.maxY + 7*BILI_WIDTH, 300, 11 * BILI_WIDTH)];
    dateLbl.textColor = UIColorFromRGB(0xb6bec1);
    dateLbl.text = @"16/06/22 15:38";
    dateLbl.font = [UIFont systemFontOfSize:11*BILI_WIDTH];
    [self.contentView addSubview:dateLbl];
    _dateLbl = dateLbl;

    
    self.cellScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), _cellHeight)];
    _cellScrollView.contentSize = CGSizeMake(500, _cellHeight);
    _cellScrollView.contentOffset = CGPointMake(0, _cellHeight);
    _cellScrollView.delegate = self;
    _cellScrollView.showsHorizontalScrollIndicator = NO;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewPressed:)];
    [_cellScrollView addGestureRecognizer:tapGestureRecognizer];
    
    self.leftView = [[LCUtilityButtonView alloc] initWithUtilityButtons:_leftButtons parentCell:self utilityButtonSelector:@selector(leftButtonHandler:)];
    [_leftView setFrame:CGRectMake([self leftUtilityButtonsWidth], 0, [self leftUtilityButtonsWidth], _cellHeight)];
    [_cellScrollView addSubview:_leftView];
    
    self.rightView = [[LCUtilityButtonView alloc] initWithUtilityButtons:_rightButtons parentCell:self utilityButtonSelector:@selector(rightButtonHandler:)];
    [_rightView setFrame:CGRectMake(CGRectGetWidth(self.bounds), 0, [self rightUtilityButtonsWidth], _cellHeight)];
    [_cellScrollView addSubview:_rightView];
    
    [_leftView populateUtilityButtons];
    [_rightView populateUtilityButtons];
    
    self.scrollViewContentView = [[UIView alloc] initWithFrame:CGRectMake([self leftUtilityButtonsWidth], 0, CGRectGetWidth(self.bounds), _cellHeight)];
    _scrollViewContentView.backgroundColor = [UIColor redColor];
    [_cellScrollView addSubview:_scrollViewContentView];
   
    
    // Add the cell scroll view to the cell
    UIView *contentViewParent = self;
    if (![NSStringFromClass([[self.subviews objectAtIndex:0] class]) isEqualToString:kTableViewCellContentView]) {
        // iOS 7
        contentViewParent = [self.subviews objectAtIndex:0];
    }
    
    NSArray *cellSubviews = [contentViewParent subviews];
    [self insertSubview:_cellScrollView atIndex:0];
    for (UIView *subview in cellSubviews) {
        [_scrollViewContentView addSubview:subview];
    }
}

- (void)setAllSelected:(BOOL)allSelected
{
    _allSelected = allSelected;
    if (allSelected) {
        _selectFlag.hidden = NO;
        _grayPoint.hidden = YES;
    }else{
        _selectFlag.hidden = YES;
        _grayPoint.hidden = NO;
    }
}

- (void)setInfoModel:(RentInfoModel *)infoModel
{
    _infoModel = infoModel;
    _desLbl.text = infoModel.type;
    _typeLbl.text = infoModel.theDescription;
    _dateLbl.text = infoModel.date;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.cellScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), _cellHeight);
    self.cellScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + [self utilityButtonsPadding], _cellHeight);
    self.cellScrollView.contentOffset = CGPointMake([self leftUtilityButtonsWidth], 0);
    self.leftView.frame = CGRectMake([self leftUtilityButtonsWidth], 0, [self leftUtilityButtonsWidth], _cellHeight);
    self.rightView.frame = CGRectMake(CGRectGetWidth(self.bounds), 0, [self rightUtilityButtonsWidth], _cellHeight);
    self.scrollViewContentView.frame = CGRectMake([self leftUtilityButtonsWidth], 0, CGRectGetWidth(self.bounds), _cellHeight);
}


//手势方法点击scrollView
- (void)scrollViewPressed:(UIScrollView *)scrollView
{
    if(_state == kCellStateCenter)
    {
//        NSArray * array = [[self.tableView.subviews firstObject] subviews];
//        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            MyCollectTableViewCell *cell = obj;
//            [cell hideButtonsAnimated:YES];
//        }];

        // Selection hack
        if ([self.tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
        {
            NSIndexPath *cellIndexPath = [_tableView indexPathForCell:self];
            [self.tableView.delegate tableView:_tableView didSelectRowAtIndexPath:cellIndexPath];
        }
        // Highlight hack
        if (!self.highlighted)
        {
            self.leftView.hidden = YES;
            self.rightView.hidden = YES;
            NSTimer *endHighlightTimer = [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(timerEndCellHighlight:) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:endHighlightTimer forMode:NSRunLoopCommonModes];
            [self setHighlighted:YES];
        }
    }
    else
    {
        // Scroll back to center
        [self hideButtonsAnimated:YES];
    }

}


//左边按钮处理
- (void)leftButtonHandler:(id)sender
{
    UIButton *utilityButton = (UIButton *)sender;
    NSInteger utilityButtonTag = [utilityButton tag];
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:didTriggerLeftUtilityButtonWithIndex:)]) {
        [_delegate swippableTableViewCell:self didTriggerLeftUtilityButtonWithIndex:utilityButtonTag];
    }

}

//右边按钮处理
- (void)rightButtonHandler:(id)sender
{
    UIButton *utilityButton = (UIButton *)sender;
    NSInteger utilityButtonTag = [utilityButton tag];
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:didTriggerRightUtilityButtonWithIndex:)]) {
        [_delegate swippableTableViewCell:self didTriggerRightUtilityButtonWithIndex:utilityButtonTag];
    }

}

- (void)timerEndCellHighlight:(id)sender
{
    if (self.highlighted) {
        self.leftView.hidden = NO;
        self.rightView.hidden = NO;
        [self setHighlighted:NO];
    }
}


- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.scrollViewContentView.backgroundColor = backgroundColor;
}

//隐藏方法
- (void)hideButtonsAnimated:(BOOL)animated
{
    [self.cellScrollView setContentOffset:CGPointMake([self leftUtilityButtonsWidth], 0) animated:animated];
    _state = kCellStateCenter;
    
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:scrollingToState:)]) {
        [_delegate swippableTableViewCell:self scrollingToState:kCellStateCenter];
    }

}



#pragma mark 计算各种宽度
- (CGFloat)leftUtilityButtonsWidth {
    return [_leftView utilityButtonsWidth];
}

- (CGFloat)rightUtilityButtonsWidth {
    return [_rightView utilityButtonsWidth];
}

- (CGFloat)utilityButtonsPadding {
    return ([_leftView utilityButtonsWidth] + [_rightView utilityButtonsWidth]);
}

- (CGPoint)scrollViewContentOffset {
    return CGPointMake([_leftView utilityButtonsWidth], 0);
}

#pragma mark UIScrollView helpers

- (void)scrollToRight:(inout CGPoint *)targetContentOffset{
    targetContentOffset->x = [self utilityButtonsPadding];
    _state = kCellStateRight;
    
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:scrollingToState:)]) {
        [_delegate swippableTableViewCell:self scrollingToState:kCellStateRight];
    }
}

- (void)scrollToCenter:(inout CGPoint *)targetContentOffset {
    targetContentOffset->x = [self leftUtilityButtonsWidth];
    _state = kCellStateCenter;
    
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:scrollingToState:)]) {
        [_delegate swippableTableViewCell:self scrollingToState:kCellStateCenter];
    }
}

- (void)scrollToLeft:(inout CGPoint *)targetContentOffset{
    targetContentOffset->x = 0;
    _state = kCellStateLeft;
    
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:scrollingToState:)]) {
        [_delegate swippableTableViewCell:self scrollingToState:kCellStateLeft];
    }
}


#pragma mark UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    switch (_state) {
        case kCellStateCenter:
            if (velocity.x >= 0.5f) {
                [self scrollToRight:targetContentOffset];
            } else if (velocity.x <= -0.5f) {
                [self scrollToLeft:targetContentOffset];
            } else {
                CGFloat rightThreshold = [self utilityButtonsPadding] - ([self rightUtilityButtonsWidth] / 2);
                CGFloat leftThreshold = [self leftUtilityButtonsWidth] / 2;
                if (targetContentOffset->x > rightThreshold)
                    [self scrollToRight:targetContentOffset];
                else if (targetContentOffset->x < leftThreshold)
                    [self scrollToLeft:targetContentOffset];
                else
                    [self scrollToCenter:targetContentOffset];
            }
            break;
        case kCellStateLeft:
            if (velocity.x >= 0.5f) {
                [self scrollToCenter:targetContentOffset];
            } else if (velocity.x <= -0.5f) {
                // No-op
            } else {
                if (targetContentOffset->x >= ([self utilityButtonsPadding] - [self rightUtilityButtonsWidth] / 2))
                    [self scrollToRight:targetContentOffset];
                else if (targetContentOffset->x > [self leftUtilityButtonsWidth] / 2)
                    [self scrollToCenter:targetContentOffset];
                else
                    [self scrollToLeft:targetContentOffset];
            }
            break;
        case kCellStateRight:
            if (velocity.x >= 0.5f) {
                // No-op
            } else if (velocity.x <= -0.5f) {
                [self scrollToCenter:targetContentOffset];
            } else {
                if (targetContentOffset->x <= [self leftUtilityButtonsWidth] / 2)
                    [self scrollToLeft:targetContentOffset];
                else if (targetContentOffset->x < ([self utilityButtonsPadding] - [self rightUtilityButtonsWidth] / 2))
                    [self scrollToCenter:targetContentOffset];
                else
                    [self scrollToRight:targetContentOffset];
            }
            break;
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x > [self leftUtilityButtonsWidth])
    {
        //滑动scorllView 找到所有的cell 先隐藏两边所有的按钮，再让滑动的cell开启。
//        NSArray * array = [[self.tableView.subviews firstObject] subviews];
//        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            MyCollectTableViewCell *cell = obj;
//            // 解除删除cell时崩溃的bug
//            if (cell != self && [cell isKindOfClass:[MyCollectTableViewCell class]])
//            {
//                [cell hideButtonsAnimated:NO];
//            }
//        }];
        self.rightView.frame = CGRectMake(scrollView.contentOffset.x + (CGRectGetWidth(self.bounds) - [self rightUtilityButtonsWidth]), 0.0f, [self rightUtilityButtonsWidth], _cellHeight);
    }
    else
    {
//        NSArray * array = [[self.tableView.subviews firstObject] subviews];
//        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            MyCollectTableViewCell *cell = obj;
//            if (cell != self && [cell isKindOfClass:[MyCollectTableViewCell class]])
//            {
//                [cell hideButtonsAnimated:NO];
//            }
//        }];
        self.leftView.frame = CGRectMake(scrollView.contentOffset.x, 0.0f, [self leftUtilityButtonsWidth], _cellHeight);
    }
}



@end
