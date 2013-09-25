//
//  PBSectoralEntrepreneurs.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-7.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBManager.h"
#import "PBActivityIndicatorView.h"

@interface PBSectoralEntrepreneurs : UIViewController <UITableViewDataSource, UITableViewDelegate, ParseDataDelegate>

@property (nonatomic, retain) PBActivityIndicatorView *indicator;
@property (nonatomic, retain) PBManager *sectoralManager;
@property (nonatomic, retain) NSArray *sectoralDataArray;
@property (retain, nonatomic) IBOutlet UITableView *sectoralTableView;


@end
