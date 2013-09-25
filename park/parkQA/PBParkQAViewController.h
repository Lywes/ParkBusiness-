//
//  PBParkQAViewController.h
//  ParkBusiness
//
//  Created by  on 13-3-4.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBParkManager.h"
#import "PBDetailQAViewController.h"
#import "UIInputToolbar.h"
#import "PBPullTableViewController.h"

@interface PBParkQAViewController : UIViewController<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,PBParkManagerDelegate,UIInputToolbarDelegate,PBPullTableViewDelegete> {
    
    NSMutableArray      *nodesMutableArr;
    
    PBDetailQAViewController *detailQAVC;
    NSString *str;
    
    PBPullTableViewController* pullController;
    
}

@property (nonatomic, retain) NSString *parkNoString;
@property (nonatomic,retain) NSString *questionStr;
@property (nonatomic, retain) UIInputToolbar *inputToolbar;
@property (nonatomic,retain) PBParkManager *parkManager;
@property (nonatomic,retain) UISearchBar *searchBar1;

-(void)requestData:(NSString *)value;
-(void)keyboardDown;
-(void)rightBarButton;
@end
