//
//  PBParkMicroblogCell.h
//  ParkBusiness
//
//  Created by  on 13-3-13.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomImageView.h"
@interface PBParkMicroblogCell : UITableViewCell
@property(nonatomic,readwrite,retain)IBOutlet CustomImageView* imageViews;
@property (retain, nonatomic) IBOutlet UIImageView *blogPhotoImageView;
@property (retain, nonatomic) IBOutlet UILabel *dateLabelView;
@property (retain, nonatomic) IBOutlet UILabel *renQiLabelView;
@property (retain, nonatomic) IBOutlet UILabel *themeLabelView;
@property (retain, nonatomic) IBOutlet UIImageView *dateImgView;
@property (retain, nonatomic) IBOutlet UIImageView *renQiImgView;
@end
