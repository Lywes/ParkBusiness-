//
//  PBFinancInstitutController.m
//  ParkBusiness
//
//  Created by QDS on 13-5-23.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBFinancInstitutController.h"
#import "JoinCompanyCell.h"
#import "PBFinancInstitutDetailController.h"

#define kURLSTRING [NSString stringWithFormat:@"%@admin/index/searchfinancinginstitution", HOST]

@interface PBFinancInstitutController ()

@end

@implementation PBFinancInstitutController
@synthesize manager;
@synthesize _searchBar;
@synthesize pullController;
@synthesize rootController;
//实现下拉更新操作
-(void)getDataSource:(PBPullTableViewController *)view
{
    [self requestData:@"1"];
}

//点击查看更多按钮
-(void)getMoreButtonDidPush:(PBRefreshTableHeaderView *)view
{
    [self requestData:[NSString stringWithFormat:@"%d",pullController.pageno]];
}

//拖动tableView时实现
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[_searchBar resignFirstResponder];
	[pullController._refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

//停止拖动时
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[pullController._refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _searchBar=[[UISearchBar alloc] init];
    _searchBar.frame=CGRectMake(0, 0, self.view.bounds.size.width, 40);
    _searchBar.delegate=self;
    [_searchBar sizeToFit];
    _searchBar.placeholder = @"首字符匹配搜索";
    _searchBar.backgroundColor=[UIColor clearColor];
    [[_searchBar.subviews objectAtIndex:0]removeFromSuperview];
    for (UIView *subview in _searchBar.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
            break;
        }
    }
    [self.view addSubview:_searchBar];
    
    CGFloat viewWidth = isPad() ? 768 : 320;
    CGFloat viewHeight = (isPad() ? 1024 : (isPhone5() ? 568 :480)) - KTabBarHeight - KNavigationBarHeight;
    
    //下拉显示
    pullController = [[PBPullTableViewController alloc]initWithFrame:CGRectMake(0, 44, viewWidth, viewHeight - 40)];
    pullController.delegate =self;
    pullController.tableViews.delegate = self;
    pullController.tableViews.dataSource = self;
    [self.view addSubview:pullController.tableViews];
    [self.view addSubview:pullController.indicator];
    
    self.title = @"金融机构";
    manager = [[PBManager alloc] init];
    manager.delegate = self;
    manager.acIndicator = pullController.indicator;
    
    [self requestData:@"1"];
}

#pragma mark -
#pragma mark ParseDataDelegateMethod
- (void) sucessParseXMLData
{
    [pullController successGetXmlData:pullController withData:manager.parseData withNumber:10];
}

#pragma mark -
#pragma mark UISearchBarDelegateMethod
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [pullController.allData removeAllObjects];
    [searchBar resignFirstResponder];
    [self requestData:@"1"];
}

- (void) requestData: (NSString *) pageno
{
    [pullController.indicator startAnimating];
    NSDictionary *searchDic = [NSDictionary dictionaryWithObjectsAndKeys:pageno, @"pageno", _searchBar.text, @"name", nil];
    [manager requestBackgroundXMLData:kURLSTRING forValueAndKey:searchDic];
}

#pragma mark -
#pragma mark TabelViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [pullController.allData count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    static BOOL nibsRegisted = NO;
    JoinCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        nibsRegisted = NO;
    }
    
    if (!nibsRegisted) {
        NSString *nibName = isPad() ? @"JoinCompanyCell_iPad" : @"JoinCompanyCell";
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegisted = YES;
    }
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    } else {
        [cell.parkLOGOImageView removeFromSuperview];
    }
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    [imageView setImage:[[UIImage imageNamed:@"fillcell.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
    cell.backgroundView = imageView;
    [imageView release];
    
    if ([pullController.allData count] > 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSDictionary *arrToDic = [pullController.allData objectAtIndex:indexPath.row];
        CGFloat originX = isPad() ? 8 : 3;
        
        cell.parkLOGOImageView = [[CustomImageView alloc] initWithFrame:CGRectMake(originX, 3, 48, 48)];
        [cell.contentView addSubview:cell.parkLOGOImageView];
        [cell.parkLOGOImageView.imageView loadImage:[NSString stringWithFormat:@"%@%@", HOST, [arrToDic objectForKey:@"imagepath"]]];
        cell.parkNameLabel.text = [arrToDic objectForKey:@"name"];
        
    }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PBFinancInstitutDetailController *controller = [[PBFinancInstitutDetailController alloc] init];
    controller.rootController = self.rootController;
    controller.dataDictionary = [pullController.allData objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)dealloc {
    [pullController release];
    [manager release];
    [_searchBar release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setManager:nil];
    [self setPullController:nil];
    [self set_searchBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
