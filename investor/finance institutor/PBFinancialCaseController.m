//
//  PBFinancialCaseController.m
//  ParkBusiness
//
//  Created by QDS on 13-5-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBFinancialCaseController.h"
#import "JoinCompanyCell.h"
#import "PBFinancialCaseDetailController.h"
#define kURLSTRING [NSString stringWithFormat:@"%@admin/index/searchbankfinancingcase", HOST]

@interface PBFinancialCaseController ()

@end

@implementation PBFinancialCaseController
@synthesize fnoString;
@synthesize pnoString;
@synthesize _searchBar;
@synthesize manager;
@synthesize pullController;

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
        fnoString = @"";
        pnoString = @"";
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(7, 7, 25, 30);
        [btn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(popBackAgoView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = backBarBtn;
        [backBarBtn release];
    }
    return self;
}

- (void) popBackAgoView
{
    if ([pnoString intValue]>0) {
        [self dismissModalViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"_title_cpfwxxxx", nil);
    self.view.backgroundColor = [UIColor whiteColor];
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
    CGFloat viewHeight = (isPad() ? 1024 : (isPhone5() ? 568 :480)) - KNavigationBarHeight;
    
    //下拉显示
    pullController = [[PBPullTableViewController alloc]initWithFrame:CGRectMake(0, 44, viewWidth, viewHeight - 40)];
    pullController.delegate =self;
    pullController.tableViews.delegate = self;
    pullController.tableViews.dataSource = self;
    [self.view addSubview:pullController.tableViews];
    [self.view addSubview:pullController.indicator];
    
    manager = [[PBManager alloc] init];
    manager.delegate = self;
    manager.acIndicator = pullController.indicator;
    
    [self requestData:@"1"];
}
#pragma mark -
#pragma mark ParseDataDelegateMethod
- (void) sucessParseXMLData
{
    [pullController successGetXmlData:pullController withData:manager.parseData withNumber:20];
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
    NSDictionary *searchDic = [NSDictionary dictionaryWithObjectsAndKeys:pageno, @"pageno", _searchBar.text?_searchBar.text:@"", @"name",fnoString,@"fno",pnoString,@"pno",USERNO,@"personno", nil];
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
    PBFinancialCaseDetailController *controller = [[PBFinancialCaseDetailController alloc] init];
    controller.dataDictionary = [pullController.allData objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload {
    [self setManager:nil];
    [self set_searchBar:nil];
    [self setPullController:nil];
    [self setFnoString:nil];
    [super viewDidUnload];
}

- (void) dealloc {
    [manager release];
    [_searchBar release];
    [pullController release];
    [fnoString release];
    [super dealloc];
}
@end
