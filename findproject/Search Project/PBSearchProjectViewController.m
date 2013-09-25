//
//  PBSearchProjectViewController.m
//  ParkBusiness
//
//  Created by QDS on 13-3-18.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBSearchProjectViewController.h"
#import "CommonCell.h"
#import "CommonProjectDetailController.h"
#import "PBAddCompanyBand.h"
#import "PBAddFinanceAssure.h"
#import "PBAddFinanceLease.h"
#import "PBAddInsureInfo.h"
#define kURLSTRING [NSString stringWithFormat:@"%@admin/index/projectlist", HOST]

@interface PBSearchProjectViewController ()
@end

@implementation PBSearchProjectViewController
@synthesize manager;
@synthesize dataArray;
@synthesize searchSearchBar;
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
	[searchSearchBar resignFirstResponder];
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
    
    searchSearchBar=[[UISearchBar alloc] init];
    searchSearchBar.frame=CGRectMake(0, 0, self.view.bounds.size.width, 40);
    searchSearchBar.delegate=self;
    [searchSearchBar sizeToFit];
    searchSearchBar.placeholder = @"请输入项目名字";
    searchSearchBar.backgroundColor=[UIColor clearColor];
    [[searchSearchBar.subviews objectAtIndex:0]removeFromSuperview];
    for (UIView *subview in searchSearchBar.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
            break;
        }
    }
    [self.view addSubview:searchSearchBar];

    CGFloat viewWidth = isPad() ? 768 : 320;
    CGFloat viewHeight = (isPad() ? 1024 : (isPhone5() ? 568 :480)) - KTabBarHeight - KNavigationBarHeight;
    //下拉显示
    pullController = [[PBPullTableViewController alloc]initWithFrame:CGRectMake(0, 40, viewWidth, viewHeight - 40)];
    pullController.delegate =self;
    pullController.tableViews.delegate = self;
    pullController.tableViews.dataSource = self;
    [self.view addSubview:pullController.tableViews];
    [self.view addSubview:pullController.indicator];
    
    self.title = @"搜索项目";
    manager = [[PBManager alloc] init];
    manager.delegate = self;
    
    manager.acIndicator = pullController.indicator;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (searchSearchBar.text) {
        [self requestData:@"1"];
    }

    
}

#pragma mark -
#pragma mark SearchBarDelegateMethod
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchSearchBar resignFirstResponder];
    [pullController.allData removeAllObjects];
    [self requestData:@"1"];
}

- (void) requestData:(NSString *)pageno
{
    /****************************************
     页数：pageno
     企业编号：no
     园区编号：parkno
     园区企业家或公司名字：name	
     ****************************************/
    if ([pageno isEqualToString:@"1"]) {
        [pullController.allData removeAllObjects];
    }
    [pullController.indicator startAnimating];
    //下面这句代码为特例
    searchSearchBar.text = searchSearchBar.text==NULL?@"":searchSearchBar.text;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:searchSearchBar.text, @"search", pageno, @"pageno",USERNO,@"userno", nil];
    [manager requestBackgroundXMLData:kURLSTRING forValueAndKey:dic];
}

#pragma mark -
#pragma mark ParseDataDelegateMethod
- (void) sucessParseXMLData
{
    dataArray = [[NSArray arrayWithArray:manager.parseData] retain];
    [pullController successGetXmlData:pullController withData:dataArray withNumber:10];
//    NSLog(@"%@", dataArray);
}

#pragma mark -
#pragma mark TavleViewDataSourceMethod
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [pullController.allData count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CommonCellIdentifier";
    //cell不能为空
    static BOOL nibsRegisted = NO;
    CommonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        nibsRegisted = NO;
    }

    if (!nibsRegisted) {
        NSString *nibName = isPad() ? @"CommonCell_iPad" : @"CommonCell";
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        nibsRegisted = YES;
    }
    if (cell==nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    } else {
        [cell.projectImageView removeFromSuperview];
    }
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    [imageView setImage:[[UIImage imageNamed:@"fillcell.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
    cell.backgroundView = imageView;
    [imageView release];
    
    if ([pullController.allData count] > 0) {
        NSDictionary *dic = [pullController.allData objectAtIndex:indexPath.row];
        CGFloat originX = isPad() ? 20 : 5;
        cell.projectImageView = [[CustomImageView alloc] initWithFrame:CGRectMake(originX, 5, 75, 75)];
        [cell.contentView addSubview:cell.projectImageView];
        [cell.projectImageView.imageView loadImage:[NSString stringWithFormat:@"%@%@", HOST, [dic objectForKey:@"imagepath"]]];
        cell.projectNameLabel.text = [dic objectForKey:@"proname"];//项目名称
        cell.projectTypeLabel.text = [dic objectForKey:@"typename"];//项目类型
        cell.companyScaleLabel.text = [dic objectForKey:@"staffname"];//企业规模
        cell.projectTimeLabel.text = [dic objectForKey:@"cdate"];//提交时间
        cell.projectCategoryLabel.text = [dic objectForKey:@"trade"];//行业
        //企业规模图片
        cell.companyscaleView.image = [UIImage imageNamed:[NSString stringWithFormat:@"companyscale%@",[dic objectForKey:@"staff"]]];
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
    NSString *userNoStr = [[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"userno"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userNoStr, @"userno", [NSString stringWithFormat:@"%d", [PBUserModel getUserId]], @"suserno", nil];
    [send sendDataWithURL:kATTENTIONURLSTRING andValueAndKeyDic:dic];
    NSMutableDictionary* dic2 = [pullController.allData objectAtIndex:indexPath.row];
    int type = [[dic2 objectForKey:@"type"] intValue];
    if (type<3) {
        CommonProjectDetailController *controller = [[CommonProjectDetailController alloc] init];
        controller.dataDictionary = dic2;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    if(type==3){//企业债券
        PBAddCompanyBand* bond = [[PBAddCompanyBand alloc]initWithStyle:UITableViewStyleGrouped];
        bond.ProjectStyle = ELSEPROJECTINFO;
        bond.title = [dic2 objectForKey:@"proname"];
        bond.datadic = dic2;
        [self.navigationController pushViewController:bond animated:YES];
    }
    if(type==4){//金融担保
        PBAddFinanceAssure* assure = [[PBAddFinanceAssure alloc]initWithStyle:UITableViewStyleGrouped];
        assure.ProjectStyle = ELSEPROJECTINFO;
        assure.title = [dic2 objectForKey:@"proname"];
        assure.datadic = dic2;
        [self.navigationController pushViewController:assure animated:YES];
    }
    if(type==5){//金融租赁
        PBAddFinanceLease* lease = [[PBAddFinanceLease alloc]initWithStyle:UITableViewStyleGrouped];
        lease.ProjectStyle = ELSEPROJECTINFO;
        lease.title = [dic2 objectForKey:@"proname"];
        lease.datadic = dic2;
        [self.navigationController pushViewController:lease animated:YES];
    }
    if(type==6){//保险
        PBAddInsureInfo* insure = [[PBAddInsureInfo alloc]initWithStyle:UITableViewStyleGrouped];
        insure.ProjectStyle = ELSEPROJECTINFO;
        insure.title = [dic2 objectForKey:@"proname"];
        insure.datadic = dic2;
        [self.navigationController pushViewController:insure animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [send release];
    [pullController release];
    [dataArray release];
    [manager release];
    [searchSearchBar release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setSend:nil];
    [self setPullController:nil];
    [self setDataArray:nil];
    [self setManager:nil];
    [self setSearchSearchBar:nil];
    [super viewDidUnload];
}
@end