//
//  LeftCell.m
//  ParkBusiness
//
//  Created by China on 13-8-21.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "LeftCell.h"

@implementation LeftCell
@synthesize titleimage,titlestr,cellLine,accstory,detail_lb,unreadmessage;
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
