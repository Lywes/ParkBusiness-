//
//  PBSearchProjectsCell.m
//  ParkBusiness
//
//  Created by  on 13-4-19.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBSearchProjectsCell.h"

@implementation PBSearchProjectsCell

@synthesize nameLabel;
@synthesize touxiangImg;
@synthesize dateLabel;
@synthesize hangyeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    
}

-(void)dealloc
{
    [super dealloc];
    [nameLabel release];
    [touxiangImg release];
}

@end
