//
//  ReviewCell.m
//  ParkBusiness
//
//  Created by QDS on 13-5-30.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "ReviewCell.h"

@implementation ReviewCell
@synthesize reviewContentLabel, reviewTimeLabel;

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
    [reviewContentLabel release];
    [reviewTimeLabel release];
    [super dealloc];
}
@end
