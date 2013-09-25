//
//  PBCustomDropView.m
//  ParkBusiness
//
//  Created by QDS on 13-4-15.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBCustomDropView.h"

@implementation PBCustomDropView
@synthesize customlb,imageView1,imageView2,backGroundView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        customlb = [[UILabel alloc]initWithFrame:CGRectMake(40, isPad()?10:0, frame.size.width-80, isPad()?20:35)];
        customlb.numberOfLines = 0;
        customlb.font = [UIFont systemFontOfSize:isPad()?16:12];
        customlb.backgroundColor = [UIColor clearColor];
//        customlb.textColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
        customlb.textColor = [UIColor blackColor];
        backGroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isPad()?@"dropstyle_ipad":@"dropstyle.png"]];
        imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
        imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-30, 10, 15, 15)];
        [self addSubview:backGroundView];
        [self addSubview:customlb];
        [self addSubview:imageView1];
        [self addSubview:imageView2];
    }
    return self;
}

//设置下拉列表图片布局及显示内容
-(void)setSelectViewWithTitle:(NSString*)title image:(UIImage*)image{
    self.imageView2.image = [UIImage imageNamed:@"dropselect.png"];
    self.imageView1.image = image;
    self.customlb.text = title;
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
