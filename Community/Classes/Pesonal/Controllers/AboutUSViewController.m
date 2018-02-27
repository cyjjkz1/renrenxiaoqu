//
//  AboutUSViewController.m
//  Community
//
//  Created by mac1 on 16/6/28.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "AboutUSViewController.h"
#import "UMFeedback.h"
#import "AboutCell.h"
#import "cc_macro.h"
@interface AboutUSViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *datas;

@end

@implementation AboutUSViewController

- (NSArray *)datas
{
    if (!_datas) {
        _datas = @[@{@"title":@"意见反馈"}];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"关于我们";
    [self setupSubViews];
}

- (void)setupSubViews
{
//    [self setupLoadedView];
    self.view.backgroundColor = UIColor_Gray_BG;
    UIView *tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    tableHeadView.backgroundColor = UIColor_Gray_BG;
    
    CGFloat imgW = 56 * BILI_WIDTH;
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - imgW) * 0.5, 28 * BILI_WIDTH, imgW, imgW)];
    iconImageView.layer.cornerRadius = imgW * 0.5;
    iconImageView.layer.masksToBounds = YES;
    iconImageView.image = [UIImage imageNamed:@"login_iocn"];
    [tableHeadView addSubview:iconImageView];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.maxY + 17 * BILI_WIDTH, SCREEN_WIDTH, 16*BILI_WIDTH)];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:16 * BILI_WIDTH];
    nameLabel.textAlignment = 1;
    nameLabel.text = app_Name;
    [tableHeadView addSubview:nameLabel];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nameLabel.maxY+10, SCREEN_WIDTH, 24)];
    versionLabel.textColor = UIColorFromRGB(0x727272);
    versionLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:13 six:15 sixPlus:17]];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString* thisVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: kBundleKey];
    if (thisVersion.length > 0) {
        thisVersion = [NSString stringWithFormat:@"版本号：V%@", thisVersion];
    }
    NSMutableAttributedString *mAtts = [[NSMutableAttributedString alloc] initWithString:thisVersion attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    [mAtts setAttributes:@{NSForegroundColorAttributeName:UIColor_Gray_Text} range:NSMakeRange(0, 3)];
    [mAtts setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:228/255.0 green:0 blue:0 alpha:1.f]} range:NSMakeRange(4, thisVersion.length - 4)];
    versionLabel.attributedText = mAtts;
    [tableHeadView addSubview:versionLabel];
    tableHeadView.h = versionLabel.maxY + 30;
    
    
    
 
    
    UILabel *copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 70 * BILI_WIDTH, SCREEN_WIDTH, 50 * BILI_WIDTH)];
    copyrightLabel.textColor = UIColorFromRGB(0xCDCDCD);
    copyrightLabel.font = [UIFont systemFontOfSize:12 * BILI_WIDTH];
    copyrightLabel.textAlignment = 1;
    copyrightLabel.numberOfLines = 0;
    [self.view addSubview:copyrightLabel];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy";
    NSString *year = [formatter stringFromDate:[NSDate date]];
    copyrightLabel.text = [NSString stringWithFormat:@"成都青山物业管理有限责任公司\nCopyright©%@",year];
    
   
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NaviHeight - 70 * BILI_WIDTH)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 50;
    tableView.backgroundColor = UIColor_Gray_BG;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.tableHeaderView = tableHeadView;
    [tableView registerClass:[AboutCell class] forCellReuseIdentifier:@"about_cell"];
    
//     NSString *text = @"物业管理员指按照物业管理服务合同约定，通过对房屋建筑及与之相配套的设备、设施和场地进行专业化维修养护管理以及维护相关区域内环境卫生和公共秩序，为业主、使用人提供服务的人员。 物业管理员是指投入使用的房屋及其附属设备与配套设施进行经营性管理，并向物业产权人、使用人提供多方面、综合有偿服务的人员。物业管理员须具备高中以上学历，具有一定的观察能力及较强的表达和计算能力，是实行就业准入的职业之一。";
//    
//    UILabel *desLbl = [[UILabel alloc] initWithFrame:CGRectMake(19 * BILI_WIDTH, nameLabel.maxY + 25 * BILI_WIDTH, SCREEN_WIDTH - 33, 1000)];
//    desLbl.textColor = [UIColor blackColor];
//    desLbl.font = [UIFont systemFontOfSize:13 * BILI_WIDTH];
//    desLbl.numberOfLines = 0;
//    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:text];
//    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:10];
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
//    desLbl.attributedText = attributedString;
//    [desLbl sizeToFit];
//    [self.baseScrollView addSubview:desLbl];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AboutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"about_cell" forIndexPath:indexPath];
    [cell setupCellWithDic:self.datas[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            //友盟反馈
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            [self pushViewController:[UMFeedback feedbackViewController]
                            animated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
