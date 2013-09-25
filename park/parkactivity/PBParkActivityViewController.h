//
//  PBParkActivityViewController.h
//  ParkBusiness
//
//  Created by  on 13-3-4.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBParkManager.h"
#import "PBDetailActivityViewController.h"
#import "PBPullTableViewController.h"

@interface PBParkActivityViewController : UIViewController<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,PBParkManagerDelegate,PBPullTableViewDelegete> {
    PBPullTableViewController* pullController;
    NSMutableArray      *nodesMutableArr;//放节点
    
    PBDetailActivityViewController *detailActVC;
    
}

@property (nonatomic,retain) PBParkManager *parkManager;

@property (nonatomic,retain) UISearchBar *searchBar1;



-(void)requestData:(NSString *)pageno;
- (void)tableViewInit;
- (void)searchBarInit;
-(void)keyboardDown;
-(void)refreshData;

@end
