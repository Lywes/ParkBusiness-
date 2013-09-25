//
//  PBPageControl.m
//  ParkBusiness
//
//  Created by 上海 on 13-8-14.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBPageControl.h"

@implementation PBPageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
//        UIImageView* dot = (UIImageView*)[self.subviews objectAtIndex:i];
//        if (i == self.currentPage) dot.image = [UIImage imageNamed:@"WhitePoint.png"];
//        else dot.image = [UIImage imageNamed:@"GreyPoint.png"];

    }
}

-(void)setCurrentPage:(NSInteger)currentPage
{
    [super setCurrentPage:currentPage];
    [self updateDots];
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
