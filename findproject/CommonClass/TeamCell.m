//
//  TeamCell.m
//  ParkBusiness
//
//  Created by QDS on 13-3-21.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "TeamCell.h"

@implementation TeamCell
@synthesize teamJobYearLabel;
@synthesize teamJobLabel;
@synthesize teamNameLabel;
@synthesize teamMarryLabel;
@synthesize teamExperienceLabel;


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
    [teamJobYearLabel release];
    [teamNameLabel release];
    [teamJobLabel release];
    [teamMarryLabel release];
    [teamExperienceLabel release];
    [super dealloc];
}
@end
