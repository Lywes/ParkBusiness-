//
//  InvestorCell.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-6.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "InvestorCell.h"

@implementation InvestorCell
@synthesize customCellBossPhoto;            //老板的头像
@synthesize customCellBossName;             //老板的名字
@synthesize customCellLastRegistTime;       //最近一次登陆的时间
@synthesize customCellSImpleIntroduce;      //有关老板的简介
@synthesize customCellCompanyType;          //公司的类型
@synthesize jobOrCategoryImageView;         //需要改变的图标

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [customCellBossPhoto release];
    [customCellBossName release];
    [customCellLastRegistTime release];
    [customCellSImpleIntroduce release];
    [customCellCompanyType release];
    [jobOrCategoryImageView release];
    [super dealloc];
}
@end
