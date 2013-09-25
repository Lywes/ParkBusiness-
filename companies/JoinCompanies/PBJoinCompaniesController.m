//
//  PBJoinCompaniesController.m
//  ParkBusiness
//
//  Created by QDS on 13-5-21.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBJoinCompaniesController.h"
#import "JoinCompanyCell.h"
#import "PBParkIntroduceController.h"
#import "PBParkQAViewController.h"
#define kURLSTRING [NSString stringWithFormat:@"%@admin/index/searchpark", HOST]

@interface PBJoinCompaniesController ()
@end

@implementation PBJoinCompaniesController
@synthesize dataArray;
@synthesize manager;
@synthesize pullController;
@synthesize flag;
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
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
    
    CGFloat viewWidth = isPad() ? 768 : 320;
    CGFloat viewHeight = (isPad() ? 1024 : (isPhone5() ? 568 :480)) - KTabBarHeight - KNavigationBarHeight;
    //下拉显示
    pullController = [[PBPullTableViewController alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    pullController.delegate =self;
    pullController.tableViews.delegate = self;
    pullController.tableViews.dataSource = self;
    [self.view addSubview:pullController.tableViews];
    [self.view addSubview:pullController.indicator];

    self.title = flag==1?@"园区列表": @"加盟园区";
    
    manager = [[PBManager alloc] init];
    manager.delegate = self;
    [self requestData:@"1"];
    manager.acIndicator = pullController.indicator;
}

- (void) requestData:(NSString *)pageno
{
    [pullController.indicator startAnimating];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:pageno, @"pageno",  nil];
    [manager requestBackgroundXMLData:kURLSTRING forValueAndKey:dic];
}

#pragma mark
#pragma mark ParseDataDelegateMethod
- (void) sucessParseXMLData
{
    dataArray = [[NSArray arrayWithArray:manager.parseData] retain];
    [pullController successGetXmlData:pullController withData:dataArray withNumber:10];
}

#pragma mark
#pragma mark UITableViewDataSoourceMethode
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

#pragma mark
#pragma mark UITableViewDelegateMethod
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (flag==1) {
        PBParkQAViewController *qaController = [[PBParkQAViewController alloc] initWithNibName:isPad()?@"PBParkQAViewController_pad":@"PBParkQAViewController" bundle:nil];
        qaController.parkNoString = [[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"no"];
        [self.navigationController pushViewController:qaController animated:YES];
        [qaController release];
    }else{
        PBParkIntroduceController *controller = [[PBParkIntroduceController alloc] init];
        controller.dataDictionary = [pullController.allData objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [dataArray release];
    [manager release];
    [pullController release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setDataArray:nil];
    [self setManager:nil];
    [self setPullController:nil];
    [super viewDidUnload];
}

@end
