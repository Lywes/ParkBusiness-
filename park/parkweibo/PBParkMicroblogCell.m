//
//  PBParkMicroblogCell.m
//  ParkBusiness
//
//  Created by  on 13-3-13.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBParkMicroblogCell.h"

@implementation PBParkMicroblogCell
@synthesize blogPhotoImageView;
@synthesize dateLabelView;
@synthesize renQiLabelView;
@synthesize themeLabelView;
@synthesize dateImgView;
@synthesize renQiImgView;
@synthesize imageViews;

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
    [blogPhotoImageView release];
    [dateLabelView release];
    [renQiLabelView release];
    [themeLabelView release];
    [dateImgView release];
    [renQiImgView release];
    [super dealloc];
}
@end
