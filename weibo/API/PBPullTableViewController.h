//
//  PBPullTableViewController.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-26.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBRefreshTableHeaderView.h"
#import "PBActivityIndicatorView.h"
@protocol PBPullTableViewDelegete;
@interface PBPullTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PBRefreshTableHeaderDelegate>{
    UIActivityIndicatorView* getMoreIndicator;
    UIView* _refreshFooterView;
    UILabel *getMoreLabel;
	BOOL _reloading;
    BOOL hasData;
}
- (void) customButtomItem:(UIViewController *) viewController;
- (id)initWithFrame:(CGRect)frame;
-(CGFloat)tableView:(UITableView *)tableView heightForRow:(NSString*)content defaultHeight:(CGFloat)height;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
-(void)initMoreButton;
-(void)successGetXmlData:(PBPullTableViewController*)pullTableView withData:(NSArray*)data withNumber:(NSUInteger)max;
-(void)customLabelFontWithView:(UIView*)view;
@property(nonatomic,assign) id <PBPullTableViewDelegete> delegate;
@property(nonatomic,readwrite)NSUInteger pageno;
@property(nonatomic,retain)NSMutableArray* allData;
@property(nonatomic,retain)UIButton *getMoreButton;
@property(nonatomic,retain)UITableView* tableViews;
@property(nonatomic,retain)UIViewController* _viewController;
@property(nonatomic,retain)PBActivityIndicatorView* indicator;
@property(nonatomic,retain)PBRefreshTableHeaderView *_refreshHeaderView;;
@end
@protocol PBPullTableViewDelegete
- (void)getDataSource:(PBPullTableViewController*)view;
- (void)getMoreButtonDidPush:(PBRefreshTableHeaderView*)view;
@end