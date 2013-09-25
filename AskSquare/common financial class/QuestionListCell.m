//
//  QuestionListCell.m
//  ParkBusiness
//
//  Created by QDS on 13-5-28.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "QuestionListCell.h"

@implementation QuestionListCell
@synthesize questionAskNameLabel, questionLabel, questionLogoImageView, questionTimeLabel,starImage;

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
    [questionLogoImageView release];
    [questionAskNameLabel release];
    [questionTimeLabel release];
    [questionLabel release];
    [super dealloc];
}
@end
