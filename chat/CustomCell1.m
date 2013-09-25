//
//  CustomCell1.m
//  QQUITableView
//
//  Created by agis on 3/12/12.
//  Copyright (c) 2012 agis. All rights reserved.
//

#import "CustomCell1.h"

@implementation CustomCell1
@synthesize profileIcon,nickName,signature;
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
    
    [super dealloc];
}
@end
