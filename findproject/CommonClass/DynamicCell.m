//
//  DynamicCell.m
//  ParkBusiness
//
//  Created by QDS on 13-3-21.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "DynamicCell.h"

@implementation DynamicCell
@synthesize dynamicLabel;
@synthesize dynamicTimeLabel;

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

- (void)dealloc {
    [dynamicTimeLabel release];
    [dynamicLabel release];
    [super dealloc];
}
@end
