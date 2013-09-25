//
//  FACompanyInfoCell.h
//  ParkBusiness
//
//  Created by QDS on 13-4-24.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomImageView.h"
@interface FACompanyInfoCell : UITableViewCell
-(void)initCellFrame;
@property(nonatomic,readwrite,retain)IBOutlet CustomImageView* imageViews;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* customlabel1;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* customlabel2;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* customlabel3;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* customlabel4;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* customlabel5;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* customlabel6;
@end
