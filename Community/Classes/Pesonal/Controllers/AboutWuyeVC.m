//
//  AboutWuyeVC.m
//  Community
//
//  Created by mac1 on 16/7/26.
//  Copyright © 2016年 boen. All rights reserved.
//

#import "AboutWuyeVC.h"

@interface AboutWuyeVC ()

@end

@implementation AboutWuyeVC

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    self.navigationTitle = @"关于物管";
    [self setupLoadedView];
}

- (void)setupLoadedView
{
    [super setupLoadedView];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 196*BILI_WIDTH)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:@"about_wuye"];
    [self.baseScrollView addSubview:imageView];
    
    NSString *text = @"成都青山物业管理有限责任公司成立于2004年，为物业服务企业耳机资质。公司按《公司法》规范运作，建立了较为完善的法人治理结构，制度健全，管理规范。公司拥有一支专业化高素质的经营管理团队和员工队伍，现有员工230人，物业管理经营专业技术人员30人，高级职称4人，中级职称20人，公司内部管理机构设置为行政管理部、财务管理部、物业管理部、工程管理部、品质管理部。公司资金、管理人才实力雄厚。公司自成立以来，以超前的物管意识，创品牌企业为目标，着眼于高起点、高标准、全方位的物业管理服务，在引入国内外先进管理经验的同时，通过自身不断实践和努力探索，建立了具有“青山物业”管理特色的物业管理模式，形成了规范的物业管理体制和体系。公司物业管理范围遍布全川，已成功管理了四川省达州市通州商夏（商住楼5万㎡），丰吾堂（商用大厦3万㎡），重庆嘉联华（高层电梯住宅10万㎡），阳光城别墅小区（2万㎡）等。都江堰灾后重建工程（多层住宅23万㎡）公司在业界取得备受瞩目的成绩，受到业主的好评和省市行业主管门的表扬。 公司的服务理念和座右铭是“做一个项目，树一个品牌”，用我们的辛勤和微笑，营造温馨“青山物业”，通过优质、高效和规范的管理服务，为广大业主提供一个“整洁，优美，安全，温馨”的工作生活环境和高尚的文化氛围，提现和创造“青山物业”有实质内涵的物业管理和良好的物业品牌。";
    
    UILabel *desLbl = [[UILabel alloc] initWithFrame:CGRectMake(19 * BILI_WIDTH, imageView.maxY + 17 * BILI_WIDTH, SCREEN_WIDTH - 33, 1000)];
    desLbl.textColor = [UIColor blackColor];
    desLbl.font = [UIFont systemFontOfSize:13 * BILI_WIDTH];
    desLbl.numberOfLines = 0;
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    desLbl.attributedText = attributedString;
    [desLbl sizeToFit];
    [self.baseScrollView addSubview:desLbl];
    
    if (desLbl.maxY > self.baseScrollView.h) {
        self.baseScrollView.contentSize = CGSizeMake(0, desLbl.maxY);
    }
}


@end
