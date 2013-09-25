//
//  FinanceHistoryCell.m
//  ParkBusiness
//
//  Created by QDS on 13-3-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "FinanceHistoryCell.h"

@implementation FinanceHistoryCell

@synthesize financeDateLabel;
@synthesize financeStageLabel;
@synthesize financeAmountLabel;

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
    [financeDateLabel release];
    [financeStageLabel release];
    [financeAmountLabel release];
    [super dealloc];
}
@end
