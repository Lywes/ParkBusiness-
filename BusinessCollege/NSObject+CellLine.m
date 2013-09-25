//
//  NSObject+CellLine.m
//  ParkBusiness
//
//  Created by China on 13-7-5.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "NSObject+CellLine.h"

@implementation NSObject (CellLine)
-(void)cellLine:(UITableViewCell *)cell
{
    
    UIImageView *imageview;
    if (isPad()) {
        imageview = [[UIImageView alloc]initWithFrame:CGRectMake(150, cell.frame.size.height, 400, 1)];
    }
    else
        imageview = [[UIImageView alloc]initWithFrame:CGRectMake(70, cell.frame.size.height, 200, 1)];
    imageview.image = [UIImage imageNamed:@"cell_line.png"];
    imageview.layer.shadowRadius = 5.0f;
    imageview.layer.masksToBounds = YES;
    [cell.contentView addSubview:imageview];
    [imageview release];
}
@end
