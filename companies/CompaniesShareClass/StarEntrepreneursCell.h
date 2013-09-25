//
//  StarEntrepreneursCell.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-8.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomImageView.h"

@interface StarEntrepreneursCell : UITableViewCell

@property (retain, nonatomic) CustomImageView *starBossPhotoImageView;
@property (retain, nonatomic) IBOutlet UILabel *starBossNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *starBossLoginTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *starCompanyNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *starTradeLabel;
@property (retain, nonatomic) IBOutlet UILabel *companyJobLabel;
@property (retain, nonatomic) IBOutlet UILabel *companyInParkLabel;

@end
