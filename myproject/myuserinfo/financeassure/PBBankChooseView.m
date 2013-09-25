//
//  PBBankChooseView.m
//  ParkBusiness
//
//  Created by 上海 on 13-5-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBBankChooseView.h"
#import "PBWeiboCell.h"
#define URL [NSString stringWithFormat:@"%@/admin/index/searchfinancinginstitution",HOST]
//#define SAVEURL [NSString stringWithFormat:@"%@/admin/index/updatecompanyno",HOST]
@interface PBBankChooseView ()

@end

@implementation PBBankChooseView
@synthesize popController;
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc{
    [super dealloc];
    [searchBar release];
    [allData release];
    [bankData release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self backButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_zj", nil) style:UIBarButtonItemStylePlain target:self action:@selector(nextDidPush)];
    allData = [[NSMutableArray alloc]initWithObjects:@"111",@"222", nil];
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 40)];
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入银行名称";
    searchBar.backgroundColor = [UIColor clearColor];
    [[searchBar.subviews objectAtIndex:0] removeFromSuperview];
    for (UIView *subview in searchBar.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
            break;
        }
    }
    [self.view addSubview:searchBar];
    CGFloat viewWidth = isPad() ? 768 : 320;
    CGFloat viewHeight = (isPad() ? 1024 : (isPhone5() ? 568 :480)) - KTabBarHeight - KNavigationBarHeight;
    //下拉显示
    pullController = [[PBPullTableViewController alloc]initWithFrame:CGRectMake(0, 50, viewWidth, viewHeight - 60)];
    pullController.delegate =self;
    pullController.tableViews.delegate = self;
    pullController.tableViews.dataSource = self;
    [self.view addSubview:pullController.tableViews];
    [self.view addSubview:pullController.indicator];
    bankData = [[PBWeiboDataConnect alloc]init];
    bankData.delegate = self;
    
    
}
-(void)backButton
{
    UIImage *image = [UIImage imageNamed:@"back.png"];
    UIButton *lefbt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [lefbt setBackgroundImage:image forState:UIControlStateNormal];
    [lefbt addTarget:self action:@selector(backUpView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbutton = [[[UIBarButtonItem alloc]initWithCustomView:lefbt]autorelease];
    self.navigationItem.leftBarButtonItem = leftbutton;
}
-(void)backUpView
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark SearchBarDelegateMethod
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBars
{
    [searchBars resignFirstResponder];
    [pullController.allData removeAllObjects];
    [self requestData:@"1"];
}
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
	[searchBar resignFirstResponder];
	[pullController._refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

//停止拖动时
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[pullController._refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}
- (void) requestData:(NSString *)pageno
{
    if ([pageno isEqualToString:@"1"]) {
        [pullController.allData removeAllObjects];
    }
    [pullController.indicator startAnimating];
    //下面这句代码为特例
    NSString* searchStr = searchBar.text?searchBar.text:@"";
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:searchStr, @"name", pageno, @"pageno",@"1",@"type" ,nil];
    [bankData getXMLDataFromUrl:URL postValuesAndKeys:dic];
}

-(void)sucessParseXMLData:(PBWeiboDataConnect *)weiboDatas{
    [pullController successGetXmlData:pullController withData:bankData.parseData withNumber:20];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


-(void)nextDidPush{
//    PBAddCompanyView* view = [[PBAddCompanyView alloc]initWithStyle:UITableViewStyleGrouped];
//    [view navigatorRightButtonType:WANCHEN];
//    PBNavigationController *nav = [[PBNavigationController alloc]initWithRootViewController:view];
//    view.title = @"追加新公司";
//    view.popController = self.popController;
//    view.choose = self;
//    
//    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"topnavigation.png"] forBarMetrics:UIBarMetricsDefault];
//    [nav.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
//    [self presentModalViewController:nav animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [pullController.allData count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PBWeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [tableView registerNib:[UINib nibWithNibName:isPad()?@"PBWeiboCell_ipad":@"PBWeiboCell" bundle:nil]forCellReuseIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }else {
        [cell.imageViews removeFromSuperview];
    }
    for (UIView* view in [[cell contentView] subviews]) {
        view.frame = CGRectZero;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell...
    if ([pullController.allData count]>0) {
        NSMutableDictionary* dic = [pullController.allData objectAtIndex:indexPath.row];
        //设置cell位置及大小
        cell.customlabel1.font = [UIFont boldSystemFontOfSize:16];//设置姓名大小
        cell.customlabel1.frame = CGRectMake(85, 15, 200, 30);
        cell.customlabel1.numberOfLines = 0;
        cell.customlabel2.font = [UIFont systemFontOfSize:isPad()?PadContentFontSize:ContentFontSize];//设置ID大小
        cell.customlabel2.textColor = [UIColor grayColor];
        cell.customlabel2.frame = CGRectMake(85, 45, 100, 30);
        cell.customlabel1.text = [dic objectForKey:@"name"];//姓名
        cell.customlabel2.text = [dic objectForKey:@"type"];//园区
        //加载boss头像应该用异步方式
        NSString *imgStr = [NSString stringWithFormat:@"%@%@", HOST, [dic objectForKey:@"imagepath"]];
        cell.imageViews = [[CustomImageView alloc]initWithFrame:CGRectMake(5, 5, 65 , 65)];
        [[cell contentView] addSubview:cell.imageViews];
        [cell.imageViews.imageView loadImage:imgStr];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [pullController.indicator startAnimating];
    NSMutableDictionary* data = [pullController.allData objectAtIndex:indexPath.row];
    self.popController.pbdata.loanbankname = [data objectForKey:@"name"];
    [pullController.indicator stopAnimating];
    [self.navigationController popViewControllerAnimated:YES];
}



@end
