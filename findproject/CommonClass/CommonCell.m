//
//  CommonCell.m
//  ParkBusiness
//
//  Created by QDS on 13-3-18.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "CommonCell.h"

@implementation CommonCell  
@synthesize projectImageView;
@synthesize projectNameLabel;
@synthesize projectTimeLabel;
@synthesize projectTypeLabel;
@synthesize companyScaleLabel;
@synthesize projectCategoryLabel;
@synthesize companyscaleView;
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
    [projectImageView release];
    [projectNameLabel release];
    [projectTimeLabel release];
    [projectCategoryLabel release];
    [super dealloc];
}
@end
