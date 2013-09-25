    //
    //  PBSearchProjectsViewCOntroller.h
    //  ParkBusiness
    //
    //  Created by  on 13-4-19.
    //  Copyright (c) 2013年 wangzhigang. All rights reserved.
    //

#import <UIKit/UIKit.h>
#import "PBPullTableViewController.h"
#import "PBParkManager.h"

@interface PBSearchsProjectsViewController : UIViewController<UISearchBarDelegate,PBPullTableViewDelegete,PBParkManagerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UISearchBar *searchBar;
    PBPullTableViewController* pullController;
    NSMutableArray      *nodesMutableArr;//放节点
    NSIndexPath *oldIndexpath;
    UIButton *Btn;
    

    
}

@property (nonatomic,retain)PBPullTableViewController* pullController;
@property (nonatomic,retain) PBParkManager *parkManager;

@property (nonatomic,retain) UISearchBar *searchBar;
@property (nonatomic,retain) NSString *str;
@property (nonatomic,retain) NSString *projectinfonoStr;
@property (nonatomic,retain) NSString *projectname;

@end
