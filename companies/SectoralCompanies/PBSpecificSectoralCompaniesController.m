//
//  PBSpecificSectoralCompaniesController.m
//  ParkBusiness
//
//  Created by QDS on 13-3-19.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBSpecificSectoralCompaniesController.h"
#import "StarEntrepreneursCell.h"
#import "PBStarEntrepreneursDetail.h"

#define kURLSTRING [NSString stringWithFormat:@"%@admin/index/searchuser", HOST]


@interface PBSpecificSectoralCompaniesController ()

@end

@implementation PBSpecificSectoralCompaniesController
@synthesize tradeID;
@synthesize manager;
@synthesize dataArray;
@synthesize titleString;
@synthesize pullController;
@synthesize send;

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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGFloat viewWidth = isPad() ? 768 : 320;
    CGFloat viewHeight = (isPad() ? 1024 : (isPhone5() ? 568 :480)) - KTabBarHeight - KNavigationBarHeight;
    //下拉显示
    pullController = [[PBPullTableViewController alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    pullController.delegate =self;
    pullController.tableViews.delegate = self;
    pullController.tableViews.dataSource = self;
    [self.view addSubview:pullController.tableViews];
    [self.view addSubview:pullController.indicator];
    
    self.title = titleString;
    manager = [[PBManager alloc] init];
    manager.delegate = self;
    [self requestData:@"1"];
    
    manager.acIndicator = pullController.indicator;
}

- (void) requestData:(NSString *) pageno
{
    /****************************************
     页数：pageno
     企业编号：no
     园区编号：parkno
     行业分类：trade
     ****************************************/
    [pullController.indicator startAnimating];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:pageno, @"pageno", USERNO, @"no", @"2", @"kind", tradeID, @"trade", nil];
    [manager requestBackgroundXMLData:kURLSTRING forValueAndKey:dic];
}

#pragma mark -
#pragma mark ParseDataDelegateMethod
- (void) sucessParseXMLData
{
    dataArray = [[NSArray arrayWithArray:manager.parseData] retain];
    [pullController successGetXmlData:pullController withData:dataArray withNumber:10];
}

#pragma mark -
#pragma mark TavleViewDataSourceMethod
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [pullController.allData count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *EntrepreneursCell = @"StarEntrepreneursCell";
    static BOOL nibsRegisted = NO;
    StarEntrepreneursCell *cell = [tableView dequeueReusableCellWithIdentifier:EntrepreneursCell];
    if (cell == nil) {
        nibsRegisted = NO;
    }
    
    if (!nibsRegisted) {
        NSString *nibName = isPad() ? @"StarEntrepreneursCell_iPad" : @"StarEntrepreneursCell";
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:EntrepreneursCell];
        nibsRegisted = YES;
    }
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:EntrepreneursCell];
    } else {
        [cell.starBossPhotoImageView removeFromSuperview];
    }
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    [imageView setImage:[[UIImage imageNamed:@"fillcell.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
    cell.backgroundView = imageView;
    [imageView release];
    
    if ([pullController.allData count] > 0) {
        NSDictionary *arrToDic = [pullController.allData objectAtIndex:indexPath.row];
        CGFloat originX = isPad() ? 10 : 3;
        cell.starBossPhotoImageView = [[CustomImageView alloc] initWithFrame:CGRectMake(originX, 6, 76, 76)];
        [cell.contentView addSubview:cell.starBossPhotoImageView];
        [cell.starBossPhotoImageView.imageView loadImage:[NSString stringWithFormat:@"%@%@", HOST, [arrToDic objectForKey:@"imagepath"]]];
        cell.starBossNameLabel.text = [arrToDic objectForKey:@"name"];
        cell.starBossLoginTimeLabel.text = [arrToDic objectForKey:@"logintime"];
        cell.companyJobLabel.text = [arrToDic objectForKey:@"companyjob"];
        cell.starCompanyNameLabel.text = [arrToDic objectForKey:@"companyname"];
        cell.companyInParkLabel.text = [arrToDic objectForKey:@"park"];
        cell.starTradeLabel.text = [arrToDic objectForKey:@"trade"];
    }
    return cell;
}


#pragma mark -
#pragma mark TavleViewDelegateMethod
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    send = [[PBSendData alloc] init];
    NSString *userNoStr = [[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"no"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userNoStr, @"userno", [NSString stringWithFormat:@"%d", [PBUserModel getUserId]], @"suserno", nil];
    [send sendDataWithURL:kATTENTIONURLSTRING andValueAndKeyDic:dic];
    
    PBStarEntrepreneursDetail *controller = [[PBStarEntrepreneursDetail alloc] init];
    controller.dataDictionary = [pullController.allData objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
}

- (void) dealloc
{
    [send release];
    [pullController release];
    [titleString release];
    [dataArray release];
    [tradeID release];
    [manager release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSend:nil];
    [self setPullController:nil];
    [self setTitleString:nil];
    [self setDataArray:nil];
    [self setManager:nil];
    [self setTradeID:nil];
    [super viewDidUnload];
}
@end
