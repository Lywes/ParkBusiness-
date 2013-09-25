//
//  PBBlogTitleView.m
//  ParkBusiness
//
//  Created by  on 13-3-26.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBBlogTitleView.h"

@implementation PBBlogTitleView

@synthesize customlb1;
@synthesize customlb2;
@synthesize customlb3;
@synthesize custombtn1;
@synthesize custombtn2;
@synthesize imageView;
@synthesize introduceTextView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        customlb1 = [[UILabel alloc]initWithFrame:CGRectMake(100,10,100,20)];
        customlb2 = [[UILabel alloc]initWithFrame:CGRectMake(210,10,80,20)];
        customlb3 = [[UILabel alloc]initWithFrame:CGRectMake(80,40,220,80)];
        if (isPad()) {
            introduceTextView = [[UITextView alloc]initWithFrame:CGRectMake(80,25,620,75)];
        }else{
            introduceTextView = [[UITextView alloc]initWithFrame:CGRectMake(80,25,240,75)];
        }
        
        introduceTextView.backgroundColor = [UIColor clearColor];
        [introduceTextView setEditable:NO]; 
        custombtn1 = [UIButton buttonWithType:UIButtonTypeCustom] ;
        custombtn2 = [UIButton buttonWithType:UIButtonTypeCustom] ;
        imageView = [[CustomImageView alloc]initWithFrame:CGRectMake(5, 10, 65, 65)];
        [self addSubview:customlb1];
        [self addSubview:customlb2];
        [self addSubview:customlb3];
        [self addSubview:custombtn1];
        [self addSubview:custombtn2];
        [self addSubview:imageView];
        [self addSubview:introduceTextView];
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
