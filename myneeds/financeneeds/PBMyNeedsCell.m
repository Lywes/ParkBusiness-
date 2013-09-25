//
//  PBMyNeedsCell.m
//  ParkBusiness
//
//  Created by wangzhigang on 13-7-12.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBMyNeedsCell.h"

@implementation PBMyNeedsCell
@synthesize fundused;
@synthesize difficulty;
@synthesize availablefund;
@synthesize timeperiod;
@synthesize expectreturn;
@synthesize unreadmessage;
@synthesize type;
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
