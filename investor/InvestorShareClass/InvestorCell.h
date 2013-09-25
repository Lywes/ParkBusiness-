//
//  InvestorCell.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-6.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

//定制投资的cell
#import <UIKit/UIKit.h>
#import "CustomImageView.h"
@interface InvestorCell : UITableViewCell
@property (retain, nonatomic)CustomImageView *customCellBossPhoto;
@property (retain, nonatomic) IBOutlet UILabel *customCellBossName;
@property (retain, nonatomic) IBOutlet UILabel *customCellLastRegistTime;
@property (retain, nonatomic) IBOutlet UILabel *customCellSImpleIntroduce;
@property (retain, nonatomic) IBOutlet UILabel *customCellCompanyType;
@property (retain, nonatomic) IBOutlet UIImageView *jobOrCategoryImageView;
@end
