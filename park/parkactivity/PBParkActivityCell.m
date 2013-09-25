//
//  PBParkActivityCell.m
//  ParkBusiness
//
//  Created by  on 13-3-13.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBParkActivityCell.h"

@implementation PBParkActivityCell
@synthesize labelView;
@synthesize customLabel;
@synthesize hgbtn;
@synthesize customView;
@synthesize amountLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        customLabel.font=[UIFont systemFontOfSize:15];
        
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
    [customLabel release];
    [super dealloc];
}
@end
