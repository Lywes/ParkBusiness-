//
//  PBParkQACell.m
//  ParkBusiness
//
//  Created by  on 13-3-13.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBParkQACell.h"

@implementation PBParkQACell
@synthesize labelView;
@synthesize labelView2;


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

    [labelView release];
    [labelView2 release];
    [super dealloc];
}
@end
