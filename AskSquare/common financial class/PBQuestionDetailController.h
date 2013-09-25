//
//  PBQuestionDetailController.h
//  ParkBusiness
//
//  Created by QDS on 13-5-29.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBManager.h"
#import "PBActivityIndicatorView.h"

@interface PBQuestionDetailController : UIViewController<UITableViewDataSource, UITableViewDelegate, ParseDataDelegate>

@property (retain, nonatomic) PBActivityIndicatorView *indicator;

@property (retain, nonatomic) NSString *noString;
@property (retain, nonatomic) PBManager *manager;
@property (retain, nonatomic) NSDictionary *dataDictionary;

@property (retain, nonatomic) IBOutlet UITableView *detailTableView;
@end
