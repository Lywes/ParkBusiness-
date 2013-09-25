//
//  PBWeiboCell.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-13.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBHuodongyugaoCell.h"
#import "QuartzCore/QuartzCore.h"
@implementation PBHuodongyugaoCell
@synthesize imageViews,customlabel1,customlabel2,customlabel3,customlabel4,customlabel5,textView,custombutton1,custombutton2,custombutton3,customImage1,customImage2;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

-(void)initCellFrame{
    self.customlabel1.frame = CGRectMake(0,0,0,0);
    self.customlabel2.frame = CGRectMake(0,0,0,0);
    self.customlabel3.frame = CGRectMake(0,0,0,0);
    self.customlabel4.frame = CGRectMake(0,0,0,0);
    self.customlabel5.frame = CGRectMake(0,0,0,0);
    self.custombutton1.frame = CGRectMake(0,0,0,0);
    self.custombutton2.frame = CGRectMake(0,0,0,0);
    self.custombutton3.frame = CGRectMake(0,0,0,0);
    self.imageViews.frame = CGRectMake(0,0,0,0);
    self.customImage1.frame = CGRectMake(0,0,0,0);
    self.customImage2.frame = CGRectMake(0,0,0,0);
    self.custombutton1.enabled = YES;
    self.custombutton2.enabled = YES;
    self.custombutton3.enabled = YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
