//
//  PBFinanceProductCell.h
//  ParkBusiness
//
//  Created by 上海 on 13-5-30.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomImageView.h"
@interface PBFinanceProductCell : UITableViewCell
@property(nonatomic,readwrite,retain)IBOutlet CustomImageView* productimage;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* productname;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* briefintro;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* enddate;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* nownumber;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* originalprice;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* currentprice;
@property(nonatomic,readwrite,retain)IBOutlet UIButton* buybutton;
@end
