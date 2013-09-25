//
//  FinanceHistoryCell.h
//  ParkBusiness
//
//  Created by QDS on 13-3-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinanceHistoryCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *financeDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *financeAmountLabel;

@property (retain, nonatomic) IBOutlet UILabel *financeStageLabel;

@end
