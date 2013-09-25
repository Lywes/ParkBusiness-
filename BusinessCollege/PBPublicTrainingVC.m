//
//  PBPublicTrainingVC.m
//  ParkBusiness
//
//  Created by QDS on 13-7-1.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define GONGYIPEIXUN_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/welfaretraining",HOST]]
#import "PBPublicTrainingVC.h"
#import "PBApplyClassVC.h"
#import "PBPublicTrainingDetail.h"
#import "NSObject+CellLine.m"
@interface PBPublicTrainingVC ()
-(void)initSearchBar;
-(void)initTableView;
-(void)initLeftNavBar;
-(void)initdata;
-(void)currentNotifation;//本页面的消息通知
@end

@implementation PBPublicTrainingVC
@synthesize tableview;
@synthesize dataclass;
@synthesize dataArr;
@synthesize refreshHeaderView;
@synthesize reloading;
@synthesize getMoreButton;
-(void)dealloc
{
    RB_SAFE_RELEASE(dataclass);
    RB_SAFE_RELEASE(dataArr);
    RB_SAFE_RELEASE(tableview);
    RB_SAFE_RELEASE(refreshHeaderView);
    RB_SAFE_RELEASE(getMoreIndicator);
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"_GONGYIPEIXUN_RELOAD" object:nil];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"公益培训";
        self.dataArr = [NSMutableArray new];
        pageno = 1;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [searchBar resignFirstResponder];
}
-(void)initdata
{
//    [ac startAnimating];
    PBdataClass *dataclass1 = [[PBdataClass alloc]init];
    dataclass1.delegate = self;
    self.dataclass = dataclass1;
    [dataclass1 release];
    if (pageno == 1) {
        [self.dataArr removeAllObjects];
    }
    NSDictionary *dic= [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageno],@"pageno",USERNO,@"userno", nil];
    [self.dataclass dataResponse:GONGYIPEIXUN_URL postDic:dic searchOrSave:YES];
    [dic release];
    
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    [ac stopAnimating];
    [self.dataArr addObjectsFromArray:datas];
    self.tableview.tableFooterView = [self setTableViewForFooter:[datas count] withNumber:20];
    [self.tableview reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSearchBar];
    [self initTableView];
    ac = [[PBActivityIndicatorView alloc]initWithFrame:self.tableview.frame];
    [self.view addSubview:ac];
    [self initLeftNavBar];
    [self initRefreshView];
    [self initdata];
    [self currentNotifation];
//    [self.tableview setContentOffset:CGPointMake(0, -150) animated:YES];
//    [refreshHeaderView egoRefreshScrollViewDidEndDragging:self.tableview];
    
//    [self.tableview setContentOffset:CGPointMake(0, 200) animated:YES];
    [self InvestTableview];
    [self setExtraCellLineHidden:self.tableview];
    
}
-(void)initTableView
{
    UITableView *tab = [[UITableView alloc]initWithFrame:CGRectMake(0, searchBar.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-searchBar.frame.size.height*3) style:UITableViewStylePlain];
    tab.delegate = self;
    tab.dataSource = self;
    self.tableview = tab;
    [self.view addSubview:self.tableview];
    [tab release];
   
}
//隐藏tableview没有内容下面的cell线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [view release];
}
-(void)InvestTableview
{
//    self.tableview.separatorColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    self.tableview.backgroundColor = [UIColor clearColor];
}
-(void)initSearchBar
{
    searchBar=[[UISearchBar alloc] init];
    searchBar.frame=CGRectMake(0, 0, self.view.bounds.size.width, 40);
    searchBar.delegate=self;
    [searchBar sizeToFit];
    searchBar.placeholder = @"首字符匹配搜索";
    searchBar.backgroundColor=[UIColor clearColor];
    [self.view addSubview:searchBar];
    [[searchBar.subviews objectAtIndex:0]removeFromSuperview];
    [searchBar release];
}
-(void)initLeftNavBar
{
    /*
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [button addTarget:self action:@selector(rightBarButtonItemPress:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"申请开课" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    UIBarButtonItem *rightbutton = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightbutton;
     */
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithTitle:@"申请开课" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemPress:)];
    self.navigationItem.rightBarButtonItem = bar;
    [bar release];

}
-(void)rightBarButtonItemPress:(id)sender
{
    PBApplyClassVC *applyclass = [[PBApplyClassVC alloc]initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:applyclass animated:YES];
    [applyclass release];
}
#pragma mark –搜索框
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1
{
    NSDictionary *dic= [[[NSDictionary alloc]initWithObjectsAndKeys:searchBar1.text,@"name",USERNO,@"userno", nil]autorelease];
    [self.dataclass dataResponse:GONGYIPEIXUN_URL postDic:dic searchOrSave:YES];
    [dic release];
    [searchBar resignFirstResponder];
}
#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PBPublicTrainingDetail *detail = [[PBPublicTrainingDetail alloc]initWithStyle:UITableViewStyleGrouped];
    detail.DataDic = [self.dataArr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
       /*
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(isPad()?50:20, 10, isPad()?300:150, 20)];
        UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(isPad()?50:20, 30, isPad()?300:150, 20)];
        UILabel *adress = [[UILabel alloc]initWithFrame:CGRectMake(isPad()?50:20, 50, isPad()?300:150, 30)];
        UILabel *organization = [[UILabel alloc]initWithFrame:CGRectMake(isPad()?500:170, 10, isPad()?250:100, 50)];
        
        name.textAlignment = UITextAlignmentLeft;
        time.textAlignment = UITextAlignmentLeft;
        adress.textAlignment = UITextAlignmentLeft;
        organization.textAlignment = UITextAlignmentLeft;
        
        name.font = [UIFont systemFontOfSize:15];
        time.font = [UIFont systemFontOfSize:15];
        adress.font = [UIFont systemFontOfSize:15];
        organization.font = [UIFont systemFontOfSize:15];
        
        name.backgroundColor = [UIColor clearColor];
        time.backgroundColor = [UIColor clearColor];
        adress.backgroundColor = [UIColor clearColor];
        organization.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview:name];
        [cell.contentView addSubview:time];
        [cell.contentView addSubview:adress];
        [cell.contentView addSubview:organization];
        
        [name release];
        [time release];
        [adress release];
        [organization release];
        
        adress.numberOfLines = 3;
        organization.numberOfLines = 3;
        if (self.dataArr.count>0) {
            NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row];
            name.text = [dic objectForKey:@"name"];
            time.text = [dic objectForKey:@"plandate"];
            adress.text =[dic objectForKey:@"address"];
            organization.text = [NSString stringWithFormat:@"举办单位:\n%@",[dic objectForKey:@"maincompany"]];
            [time sizeToFit];
            [name sizeToFit];
            [adress sizeToFit];
            [organization sizeToFit];
        }
        */
        if (self.dataArr.count>0) {
            NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"PublicTrainingVC.png"];
            cell.textLabel.highlightedTextColor = [UIColor blackColor];
            cell.detailTextLabel.highlightedTextColor = [UIColor blackColor];
            cell.textLabel.text = [dic objectForKey:@"name"];
            cell.detailTextLabel.text = [dic objectForKey:@"plandate"];
        }
      
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.dataArr.count>0) {
        return self.dataArr.count;
    }
    else
        return 0;
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [searchBar resignFirstResponder];
}
#pragma mark –下拉刷新方法
-(void)reloadTableViewDataSource
{
    NSLog(@"==开始加载数据");
    self.reloading = YES;
    pageno = 1;
    [self initdata];
    
}
- (void)doneLoadingTableViewData{
    
    NSLog(@"===加载完数据");
    self.reloading  = NO;
    [self.refreshHeaderView egoRefreshScrollViewDoneLoadingTableViewData:self.tableview];
}
#pragma mark –EGORefreshTableHeader
- (void)initRefreshView
{
    if(self.refreshHeaderView == nil)
    {
        PBRefreshTableHeaderView *view = [[PBRefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableview.bounds.size.height, self.tableview.frame.size.width, self.tableview.bounds.size.height)];
        
        view.delegate = self;
        [self.tableview addSubview:view];
        self.refreshHeaderView = view;
        [view release];
    }
    [self.refreshHeaderView refreshLastUpdatedDate];
}
-(void)didClickMoreButton{
    CGRect frame = getMoreLabel.frame;
    getMoreLabel.frame = frame;
    getMoreLabel.text = @"加载中⋯⋯";
    [getMoreIndicator startAnimating];
    getMoreButton.enabled = NO;
}
-(void)initMoreButton{
    if(_refreshFooterView == nil){
        _refreshFooterView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0, self.view.frame.size.width,40.0f)];
        _refreshFooterView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _refreshFooterView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f, _refreshFooterView.frame.size.width, 30.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0];
        label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        label.shadowOffset = CGSizeMake(0.0f, 1.0f);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [_refreshFooterView addSubview:label];
        getMoreLabel=label;
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(addMoreData) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor clearColor]];
        [_refreshFooterView addSubview:btn];
        btn.frame = _refreshFooterView.frame;
        getMoreButton = btn;
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(_refreshFooterView.frame.size.width-60.0f, 10.0f, 20.0f, 20.0f);
		[_refreshFooterView addSubview:view];
		getMoreIndicator = view;
		[view release];
    }
    getMoreLabel.text = @"点击查看更多";
    getMoreButton.enabled = YES;
    [getMoreIndicator stopAnimating];
    
    
}
-(void)addMoreData{
    [self didClickMoreButton];
    pageno+=1;
    [self initdata];
}
//设置是否显示查看更多按钮
-(UIView*)setTableViewForFooter:(NSUInteger)count withNumber:(NSUInteger)max{
    BOOL hasData = count==max? YES:NO;
    [self initMoreButton];
    if (hasData) {
        return _refreshFooterView;
    }
    return nil;
}
- (void)begainreloadTableViewDataSource
{
    
}
- (void)finishdoneLoadingTableViewData
{
    
}
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(PBRefreshTableHeaderView*)view{
    
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
    
    
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(PBRefreshTableHeaderView*)view{
    
    return self.reloading; // should return if data source model is reloading
    
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(PBRefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}
#pragma mark - tableviewreload
-(void)currentNotifation{
    [[NSNotificationCenter defaultCenter] addObserverForName:@"_GONGYIPEIXUN_RELOAD" object:self queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
       [self initdata];
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
