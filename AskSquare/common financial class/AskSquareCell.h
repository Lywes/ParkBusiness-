//
//  AskSquareCell.h
//  ParkBusiness
//
//  Created by QDS on 13-5-28.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomImageView.h"

@interface AskSquareCell : UITableViewCell

@property (retain, nonatomic) CustomImageView  *policyImageView;
@property (retain, nonatomic) IBOutlet UILabel *policyNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *policyTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *financenameLabel;
@property (retain, nonatomic) IBOutlet UILabel *policyQuesCountLabel;
@property (retain, nonatomic) IBOutlet UIImageView *score;
@end
