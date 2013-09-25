//
//  PBBlogreplyCell.h
//  ParkBusiness
//
//  Created by  on 13-4-12.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomImageView.h"
@interface PBBlogreplyCell : UITableViewCell
-(void)initCellFrame;
@property(nonatomic,readwrite,retain)IBOutlet CustomImageView* imageViews;
@property (retain, nonatomic) IBOutlet UIImageView *renqiImg;
@property (retain, nonatomic) IBOutlet UIImageView *dateimg;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* customlabel1;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* customlabel2;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* customlabel3;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* customlabel4;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* customlabel5;
@property(nonatomic,readwrite,retain)IBOutlet UIButton* custombutton1;
@property(nonatomic,readwrite,retain)IBOutlet UIButton* custombutton2;
@property(nonatomic,readwrite,retain)IBOutlet UIButton* custombutton3;
@end
