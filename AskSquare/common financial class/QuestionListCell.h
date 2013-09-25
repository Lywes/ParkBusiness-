//
//  QuestionListCell.h
//  ParkBusiness
//
//  Created by QDS on 13-5-28.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomImageView.h"

@interface QuestionListCell : UITableViewCell

@property (retain, nonatomic) CustomImageView *questionLogoImageView;
@property (retain, nonatomic)IBOutlet UIImageView *starImage;
@property (retain, nonatomic) IBOutlet UILabel *questionAskNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *questionTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *questionLabel;
@end
