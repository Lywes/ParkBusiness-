//
//  JoinCompanyCell.m
//  ParkBusiness
//
//  Created by QDS on 13-5-21.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "JoinCompanyCell.h"

@implementation JoinCompanyCell
@synthesize parkLOGOImageView, parkNameLabel;

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
    [parkLOGOImageView release];
    [parkNameLabel release];
    [super dealloc];
}
@end
