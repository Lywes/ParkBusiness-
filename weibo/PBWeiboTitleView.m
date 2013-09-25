//
//  PBWeiboTitleView.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-22.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBWeiboTitleView.h"

@implementation PBWeiboTitleView
@synthesize customlb1,customlb2,customlb3,custombtn1,custombtn2,imageView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        customlb1 = [[UILabel alloc]initWithFrame:CGRectMake(130,10,100,20)] ;
        customlb2 = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width-90,10,80,20)] ;
        customlb3 = [[UILabel alloc]initWithFrame:CGRectMake(100,40,frame.size.width-100,80)] ;
        customlb1.backgroundColor = [UIColor clearColor];
        customlb2.backgroundColor = [UIColor clearColor];
        customlb3.backgroundColor = [UIColor clearColor];
        customlb1.font = [UIFont systemFontOfSize:isPad()?14:12];
        customlb2.font = [UIFont systemFontOfSize:isPad()?14:12];
        customlb3.font = [UIFont systemFontOfSize:isPad()?14:12];
        custombtn1 = [UIButton buttonWithType:UIButtonTypeCustom] ;
        custombtn2 = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [custombtn1 setBackgroundImage:[UIImage imageNamed:@"zan.png"] forState:UIControlStateNormal];
        [custombtn2 setBackgroundImage:[UIImage imageNamed:@"cai.png"] forState:UIControlStateNormal];
        imageView = [[CustomImageView alloc]initWithFrame:CGRectMake(10, 10, 65, 65)];
        [self addSubview:customlb1];
        [self addSubview:customlb2];
        [self addSubview:customlb3];
        [self addSubview:custombtn1];
        [self addSubview:custombtn2];
        [self addSubview:imageView];
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
