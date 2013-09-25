//
//  MainCategoryCell.m
//  ParkBusiness
//
//  Created by QDS on 13-4-2.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "MainCategoryCell.h"

@implementation MainCategoryCell
@synthesize mainCategoryImageView;
@synthesize mainCategoryLabel;

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
    [mainCategoryImageView release];
    [mainCategoryLabel release];
    [super dealloc];
}
@end
