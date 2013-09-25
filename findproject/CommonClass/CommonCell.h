//
//  CommonCell.h
//  ParkBusiness
//
//  Created by QDS on 13-3-18.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomImageView.h"

@interface CommonCell : UITableViewCell

@property (retain, nonatomic) CustomImageView *projectImageView;
@property (retain, nonatomic) IBOutlet UIImageView *companyscaleView;
@property (retain, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *projectTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *projectTypeLabel;
@property (retain, nonatomic) IBOutlet UILabel *companyScaleLabel;
@property (retain, nonatomic) IBOutlet UILabel *projectCategoryLabel;
@end
