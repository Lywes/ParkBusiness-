//
//  PBPublicTrainingVC.h
//  ParkBusiness
//
//  Created by QDS on 13-7-1.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "UITbavleViewControllerModel.h"
#import "PBdataClass.h"
#import "PBRefreshTableHeaderView.h"

@interface PBPublicTrainingVC : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,PBdataClassDelegate,PBRefreshTableHeaderDelegate>
{
    UISearchBar *searchBar;
    UIActivityIndicatorView* getMoreIndicator;
    UIView* _refreshFooterView;
    UILabel *getMoreLabel;
    int pageno;
    PBActivityIndicatorView *ac;
}
@property(nonatomic,retain)UITableView *tableview;
@property(nonatomic,retain)PBdataClass *dataclass;
@property(nonatomic,retain)NSMutableArray *dataArr;
@property(nonatomic,retain)UIButton *getMoreButton;
//下拉刷新实现的属性及方法
@property (strong, nonatomic) PBRefreshTableHeaderView *refreshHeaderView;
@property (assign, nonatomic)BOOL reloading;
- (void)initRefreshView;
-(void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
-(UIView*)setTableViewForFooter:(NSUInteger)count withNumber:(NSUInteger)max;
@end

