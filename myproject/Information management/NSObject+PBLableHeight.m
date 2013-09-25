//
//  NSObject+PBLableHeight.m
//  ParkBusiness
//
//  Created by QDS on 13-6-20.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "NSObject+PBLableHeight.h"

@implementation NSObject (PBLableHeight)
-(CGFloat)HeightAStr:(NSString *)str
{
    UIFont *font = [UIFont systemFontOfSize:isPad()?PadContentFontSmallSize:ContentFontSmallSize];
    int a;
    if (isPad()) {
        a =600;
    }
    else
        a = 200;
    CGSize tag = [str sizeWithFont:font constrainedToSize:CGSizeMake(a, 800) lineBreakMode:NSLineBreakByWordWrapping];
    return MAX(44.0f, tag.height+20);
}
@end
