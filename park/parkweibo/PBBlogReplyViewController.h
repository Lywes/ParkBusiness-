//
//  PBBlogReplyViewController.h
//  ParkBusiness
//
//  Created by  on 13-3-15.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBParkManager.h"
#import "UIInputToolbar.h"
#import "PBBlogTitleView.h"
#import "PBPullTableViewController.h"

@interface PBBlogReplyViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,PBParkManagerDelegate,UIInputToolbarDelegate,PBPullTableViewDelegete>
{
    BOOL niceFlg;
    BOOL badFlg;
    NSMutableArray *nodesMutableArr;
    PBBlogTitleView *titleView;
    PBParkManager *parkManager;
    
    PBPullTableViewController* pullController;
    
}

@property(nonatomic,readwrite,retain)NSMutableDictionary* data;
@property (nonatomic, retain) UIInputToolbar *inputToolbar;
@property (nonatomic, retain) UITableView *tableViews;
-(void)getXmlData:(NSString *)pageno;
-(void)niceWeibo:(id)sender;
-(void)badWeibo:(id)sender;
-(void)setTitleView;
-(CGFloat)tableView:(UITableView *)tableView heightForRow:(NSString*)content;

@end
