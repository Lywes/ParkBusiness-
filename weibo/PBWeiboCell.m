//
//  PBWeiboCell.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-13.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBWeiboCell.h"
#import "QuartzCore/QuartzCore.h"
@implementation PBWeiboCell
@synthesize imageViews,customlabel1,customlabel2,customlabel3,customlabel4,customlabel5,textView,custombutton1,custombutton2,custombutton3,customImage1,customImage2;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Initialization code
//        customlabel1 = [[UILabel alloc]init];
//        customlabel1.backgroundColor = [UIColor clearColor];
//        customlabel2 = [[UILabel alloc]init];
//        customlabel2.backgroundColor = [UIColor clearColor];
//        customlabel3 = [[UILabel alloc]init];
//        customlabel3.backgroundColor = [UIColor clearColor];
//        customlabel4 = [[UILabel alloc]init];
//        customlabel4.backgroundColor = [UIColor clearColor];
//        customlabel5 = [[UILabel alloc]init];
//        customlabel5.backgroundColor = [UIColor clearColor];
//        imageViews = [[CustomImageView alloc]initWithFrame:CGRectMake(8, 14, 62, 75)];
//        textView = [[UITextView alloc]init];
//        [[self contentView] addSubview:customlabel1];
//        [[self contentView] addSubview:customlabel2];
//        [[self contentView] addSubview:customlabel3];
//        [[self contentView] addSubview:customlabel4];
//        [[self contentView] addSubview:customlabel5];
//        [[self contentView] addSubview:imageViews];
//        [[self contentView] addSubview:textView];
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
