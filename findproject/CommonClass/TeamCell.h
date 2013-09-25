//
//  TeamCell.h
//  ParkBusiness
//
//  Created by QDS on 13-3-21.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *teamJobLabel;

@property (retain, nonatomic) IBOutlet UILabel *teamJobYearLabel;
@property (retain, nonatomic) IBOutlet UILabel *teamMarryLabel;
@property (retain, nonatomic) IBOutlet UILabel *teamExperienceLabel;


@end
