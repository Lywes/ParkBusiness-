//
//  PBGongqiufabucell.m
//  ParkBusiness
//
//  Created by China on 13-7-11.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBGongqiufabucell.h"

@implementation PBGongqiufabucell
@synthesize name;
@synthesize cdate;
@synthesize trade;
@synthesize ldate;
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
