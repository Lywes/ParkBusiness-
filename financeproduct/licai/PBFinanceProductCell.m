//
//  PBFinanceProductCell.m
//  ParkBusiness
//
//  Created by 上海 on 13-5-30.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBFinanceProductCell.h"

@implementation PBFinanceProductCell
@synthesize productname;
@synthesize briefintro;
@synthesize originalprice;
@synthesize currentprice;
@synthesize nownumber;
@synthesize enddate;
@synthesize buybutton;
@synthesize productimage;
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

@end
