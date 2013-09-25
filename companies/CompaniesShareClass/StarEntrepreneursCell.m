//
//  StarEntrepreneursCell.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-8.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "StarEntrepreneursCell.h"

@implementation StarEntrepreneursCell
@synthesize starBossPhotoImageView;
@synthesize starBossNameLabel;
@synthesize starBossLoginTimeLabel;
@synthesize starCompanyNameLabel;
@synthesize starTradeLabel;
@synthesize companyJobLabel;
@synthesize companyInParkLabel;

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
    [starBossPhotoImageView release];
    [starBossNameLabel release];
    [starBossLoginTimeLabel release];
    [starCompanyNameLabel release];
    [starTradeLabel release];
    [companyJobLabel release];
    [companyInParkLabel release];
    [super dealloc];
}
@end
