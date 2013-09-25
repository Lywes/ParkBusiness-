//
//  PBParkMicroblogViewController.h
//  ParkBusiness
//
//  Created by  on 13-3-4.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBParkManager.h"
#import "PBPersonalBlogViewController.h"
#import "PBPullTableViewController.h"


@interface PBParkMicroblogViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,PBParkManagerDelegate,PBPullTableViewDelegete> {
    
    NSMutableArray      *nodesMutableArr;
    
    PBPersonalBlogViewController *personalBlogVC;
    PBPullTableViewController* pullController;
}

@property (nonatomic,strong) PBParkManager *parkManager;

-(void)requestData:(NSString *)value;


@end
