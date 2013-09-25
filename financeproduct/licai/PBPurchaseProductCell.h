//
//  PBPurchaseProductCell.h
//  ParkBusiness
//
//  Created by 上海 on 13-6-2.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBPurchaseProductCell : UITableViewCell
@property(nonatomic,readwrite,retain)IBOutlet UIImageView* productimage;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* productname;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* introduce;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* enddate;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* nownumber;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* limitnumber;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* originalprice;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* currentprice;
@property(nonatomic,readwrite,retain)IBOutlet UIButton* buybutton;
@property(nonatomic,readwrite,retain)IBOutlet UIButton* scbutton;
@property(nonatomic,readwrite,retain)IBOutlet UIButton* zanbutton;
@end
