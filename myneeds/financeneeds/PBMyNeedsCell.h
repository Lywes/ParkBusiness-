//
//  PBMyNeedsCell.h
//  ParkBusiness
//
//  Created by wangzhigang on 13-7-12.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBMyNeedsCell : UITableViewCell
@property(nonatomic,readwrite,retain)IBOutlet UILabel* fundused;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* difficulty;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* availablefund;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* timeperiod;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* expectreturn;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* type;
@property(nonatomic,readwrite,retain)IBOutlet UIButton* unreadmessage;
@end
