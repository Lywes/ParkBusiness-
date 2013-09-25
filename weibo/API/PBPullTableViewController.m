//
//  PBPullTableViewController.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-26.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBPullTableViewController.h"
#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
@interface PBPullTableViewController ()

@end

@implementation PBPullTableViewController
@synthesize pageno;
@synthesize allData;
@synthesize getMoreButton;
@synthesize tableViews;
@synthesize _refreshHeaderView;
@synthesize delegate;
@synthesize indicator;
@synthesize _viewController;
- (id)initWithFrame:(CGRect)frame
{
    if (self) {
        self.pageno = 1;
        // Custom initialization
         self.tableViews = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        if (self._refreshHeaderView == nil) {
            PBRefreshTableHeaderView *view = [[PBRefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - frame.size.height, frame.size.width, frame.size.height)];
            view.delegate = self;
            [self.tableViews addSubview:view];
            self.tableViews.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.view addSubview:self.tableViews];
            self._refreshHeaderView = view;
            [view release];
        }
        self.indicator = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
        self.allData = [[NSMutableArray alloc]init];
        //  update the last update date
        [self._refreshHeaderView refreshLastUpdatedDate];
    }
    return self;
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
        label.textColor = TEXT_COLOR;
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
    self.pageno+=1;
    [delegate getMoreButtonDidPush:_refreshHeaderView];
}

/*获取数据数目判断是否全部加载
count 数据数
 num 单页总数
 */
//点击查看更多按钮成功后回调方法
-(void)successGetXmlData:(PBPullTableViewController*)pullTableView withData:(NSArray*)data withNumber:(NSUInteger)max{
    max = 20;
    pullTableView.tableViews.tableFooterView = [self setTableViewForFooter:[data count]withNumber:max];
    [pullTableView.allData addObjectsFromArray:data];
    if([data count]>0){
        pullTableView.tableViews.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
         pullTableView.tableViews.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    [pullTableView.tableViews reloadData];
    //数据加载完毕
    [self doneLoadingTableViewData];
    [pullTableView.indicator stopAnimating];
}
//设置是否显示查看更多按钮
-(UIView*)setTableViewForFooter:(NSUInteger)count withNumber:(NSUInteger)max{
    hasData = count==max? YES:NO;
    [self initMoreButton];
    if (hasData) {
        return _refreshFooterView;  
    }
    return nil;
}
//自定义文本显示高度
-(CGFloat)tableView:(UITableView *)tableView heightForRow:(NSString*)content defaultHeight:(CGFloat)height{
    CGFloat contentWidth = tableView.frame.size.width-80;
    UIFont *font = [UIFont systemFontOfSize:isPad()?PadContentFontSmallSize:ContentFontSmallSize];
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:UILineBreakModeWordWrap];
    return MAX(size.height, height);
}
//自定义文本字体大小
-(void)customLabelFontWithView:(UIView*)view{
    for (id subViews in [view subviews]) {
        if([subViews isKindOfClass:[UILabel class]]){
            UILabel* label = (UILabel*)subViews;
            label.font = [UIFont systemFontOfSize:isPad()?PadContentFontSmallSize:ContentFontSmallSize];
        }
    }
}

//设置返回按钮
- (void) customButtomItem:(UIViewController *) viewController
{
    _viewController = viewController;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(7, 7, 25, 30);
    [btn addTarget:self action:@selector(backHomeView:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    viewController.navigationItem.leftBarButtonItem = barButton;
}
//设置返回按钮相应事件
- (void) backHomeView:(UIViewController*)viewController {
    [_viewController.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.indicator = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    [self.tableViews addSubview:self.indicator];
    self.tableViews.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
//	
//	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//	
//	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
//}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
//开始加载数据
- (void)reloadTableViewDataSource{
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    self.pageno = 1;
    [self.allData removeAllObjects];
    [delegate getDataSource:self];
    
}
//数据加载完毕
- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
//	_reloading = NO;
//	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [_refreshHeaderView egoRefreshScrollViewDoneLoadingTableViewData:self.tableViews];
}


- (void)getDataSource:(PBRefreshTableHeaderView*)view{
    
}
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegateMethods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(PBRefreshTableHeaderView*)view{
	[self reloadTableViewDataSource];
	_reloading = NO;
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(PBRefreshTableHeaderView*)view{
	return _reloading;
}

//刷新更新时间
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(PBRefreshTableHeaderView*)view{
	return [NSDate date];	
}

#pragma mark -
#pragma mark Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
	_refreshHeaderView = nil;
    _refreshFooterView = nil;
    getMoreIndicator = nil;
    _refreshFooterView = nil;
    getMoreLabel = nil;
    getMoreButton = nil;
    [super dealloc];
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
