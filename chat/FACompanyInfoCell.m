//
//  FACompanyInfoCell.m
//  ParkBusiness
//
//  Created by QDS on 13-4-24.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "FACompanyInfoCell.h"

@implementation FACompanyInfoCell
@synthesize imageViews,customlabel1,customlabel2,customlabel3,customlabel4,customlabel5,customlabel6;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)initCellFrame{
    self.customlabel1.frame = CGRectMake(0,0,0,0);
    self.customlabel2.frame = CGRectMake(0,0,0,0);
    self.customlabel3.frame = CGRectMake(0,0,0,0);
    self.customlabel4.frame = CGRectMake(0,0,0,0);
    self.customlabel5.frame = CGRectMake(0,0,0,0);
    self.customlabel6.frame = CGRectMake(0,0,0,0);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
