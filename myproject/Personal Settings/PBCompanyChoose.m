//
//  PBCompanyChoose.m
//  ParkBusiness
//
//  Created by QDS on 13-5-15.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBCompanyChoose.h"
#import "PBAddCompanyView.h"
#import "PBUserModel.h"
#import "PBWeiboCell.h"
#import "PBpersonerInfo.h"
#define URL [NSString stringWithFormat:@"%@/admin/index/searchcompanyinfo",HOST]
#define SAVEURL [NSString stringWithFormat:@"%@/admin/index/updatecompanyno",HOST]
@interface PBCompanyChoose ()

@end

@implementation PBCompanyChoose
@synthesize popController;
@synthesize LoginOrSeting;
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
-(void)dealloc{
    [super dealloc];
    [searchBar release];
    [allData release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self backButton];
    NSString *bartitle;
    CGFloat height = 0.0f;
    if ([self.LoginOrSeting isEqualToString:@"login"]) {
        bartitle = @"下一步";
//        UILabel *addcompanylb = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 44)];
//        addcompanylb.text = @"+  追加新公司（点击追加）";
//        addcompanylb.textAlignment = UITextAlignmentCenter;
//        addcompanylb.clipsToBounds = NO;
//        [addcompanylb.layer setShadowOpacity: 0.5];
//        [addcompanylb.layer setShadowRadius:10.0];
//        [addcompanylb.layer setShadowColor:[UIColor blackColor].CGColor];
//        [addcompanylb.layer setShadowOffset:CGSizeMake(5, 5)];
//        addcompanylb.userInteractionEnabled = YES;
//        UITapGestureRecognizer *event = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addcompanylbTouch)];
//        [addcompanylb addGestureRecognizer:event];
//        [self.view addSubview:addcompanylb];
        
//        [event release];
//        [addcompanylb release];
//        height += addcompanylb.frame.size.height;
    }
    else
        bartitle = NSLocalizedString(@"nav_btn_zj", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:bartitle style:UIBarButtonItemStylePlain target:self action:@selector(nextDidPush)];
    allData = [[NSMutableArray alloc]initWithObjects:@"111",@"222", nil];
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 40)];
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入公司名称";
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
    CGFloat viewHeight = (isPad() ? 1024 : (isPhone5() ? 568 :480)) - KNavigationBarHeight-height-10-searchBar.frame.size.height;
    if (![self.LoginOrSeting isEqualToString:@"login"]) {
        viewHeight -= KTabBarHeight;
    }
    //下拉显示
    pullController = [[PBPullTableViewController alloc]initWithFrame:CGRectMake(0, height+searchBar.frame.size.height, viewWidth, viewHeight)];
    pullController.delegate =self;
    pullController.tableViews.delegate = self;
    pullController.tableViews.dataSource = self;
    [self.view addSubview:pullController.tableViews];
    [self.view addSubview:pullController.indicator];
    companyData = [[PBWeiboDataConnect alloc]init];
    companyData.delegate = self;
    [self requestData:@"1"];

    
}
#pragma mark - 追加新公司Function
-(void)addcompanylbTouch
{
    PBAddCompanyView* view = [[PBAddCompanyView alloc]initWithStyle:UITableViewStyleGrouped];
    [view navigatorRightButtonType:WANCHEN];
    view.title = @"追加新公司";
    view.popController = self.popController;
    view.choose = self;
    view.ProjectStyle = @"login";
    PBNavigationController *nav = [[PBNavigationController alloc]initWithRootViewController:view];
    [view release];
    
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"topnavigation.png"] forBarMetrics:UIBarMetricsDefault];
    [nav.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self presentModalViewController:nav animated:YES];
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
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:searchStr, @"name", pageno, @"pageno", nil];
    [companyData getXMLDataFromUrl:URL postValuesAndKeys:dic];
}

-(void)sucessParseXMLData:(PBWeiboDataConnect *)weiboDatas{
    [pullController successGetXmlData:pullController withData:companyData.parseData withNumber:10];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


-(void)nextDidPush{
    if ([self.LoginOrSeting isEqualToString:@"login"]) {
        if (myblock) {
            myblock();
        }
    }else{
        PBAddCompanyView* view = [[PBAddCompanyView alloc]initWithStyle:UITableViewStyleGrouped];
        [view navigatorRightButtonType:WANCHEN];
        PBNavigationController *nav = [[PBNavigationController alloc]initWithRootViewController:view];
        view.title = @"追加新公司";
        view.popController = self.popController;
        view.choose = self;
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"topnavigation.png"] forBarMetrics:UIBarMetricsDefault];
        [nav.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
        [self presentModalViewController:nav animated:YES];
    }
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
    if (![self.LoginOrSeting isEqualToString:@"login"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    // Configure the cell...
    if ([pullController.allData count]>0) {
        NSMutableDictionary* dic = [pullController.allData objectAtIndex:indexPath.row];
        //设置cell位置及大小
        cell.customlabel1.font = [UIFont boldSystemFontOfSize:16];//设置姓名大小
        cell.customlabel1.frame = CGRectMake(85, 10, 200, 40);
        cell.customlabel2.font = [UIFont systemFontOfSize:isPad()?PadContentFontSize:ContentFontSize];//设置ID大小
        cell.customlabel2.textColor = [UIColor grayColor];
        cell.customlabel2.frame = CGRectMake(85, 45, 200, 30);
        cell.customlabel1.text = [dic objectForKey:@"name"];//姓名
        cell.customlabel1.numberOfLines = 0;
        cell.customlabel2.text = [dic objectForKey:@"park"];//园区
        //加载boss头像应该用异步方式
         NSString *imgStr = [NSString stringWithFormat:@"%@%@", HOST, [dic objectForKey:@"imagepath"]];
        cell.imageViews = [[CustomImageView alloc]initWithFrame:CGRectMake(5, 5, 65 , 65)];
        [[cell contentView] addSubview:cell.imageViews];
        [cell.imageViews.imageView loadImage:imgStr];
    }
    if (indexPath.row == oldint.row && oldint != nil) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    myblock = [^(void)
    {
        [pullController.indicator startAnimating];
        NSMutableDictionary* data = [pullController.allData objectAtIndex:indexPath.row];
        PBWeiboCell* cell = (PBWeiboCell*)[pullController.tableViews cellForRowAtIndexPath:indexPath];
        // Navigation logic may go here. Create and push another view controller.
        [self saveCompanyData:data withImage:cell.imageViews.imageView.image];//保存本地数据
        [PBUserModel updateCompanyno:[[data objectForKey:@"no"] intValue]];
        NSArray *a1 = [[NSArray alloc]initWithObjects:@"companyno",@"no", nil];
        NSArray *a2 = [[NSArray alloc]initWithObjects:[data objectForKey:@"no"],
                       USERNO,
                       nil];
        [companyData submitDataFromUrl:SAVEURL postValuesAndKeys:[[NSMutableDictionary alloc]initWithObjects:a2 forKeys:a1]];
        NSMutableDictionary* dic = self.popController.dic;
        [dic setObject:[data objectForKey:@"name"] forKey:@"公司:"];
        [dic setObject:[data objectForKey:@"no"] forKey:@"companyno"];
        self.popController.dic = dic;
    } copy];
    if ([self.LoginOrSeting isEqualToString:@"login"]) {
        int oldRow = (oldint == nil)?-1:oldint.row;
        int currentRow = indexPath.row;
        if (currentRow != oldRow) {
            UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldint];
            oldCell.accessoryType = UITableViewCellAccessoryNone;
            oldint = [indexPath retain];
        }

    }
    else
    {
        myblock();
    }
}

-(void)sucessSendPostData:(PBWeiboDataConnect *)weiboDatas{
    
    [pullController.indicator stopAnimating];
    if ([self.LoginOrSeting isEqualToString:@"login"]) {
        PBpersonerInfo *personal = [[PBpersonerInfo alloc]initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:personal animated:YES];
        [personal release];
    }   
    else
        [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveCompanyData:(NSMutableDictionary*)dic withImage:(UIImage*)image{
    PBCompanyData *data = [[PBCompanyData alloc]init];
    data.parkno = [PBUserModel getParkNo];
    data.no = [[dic objectForKey:@"no"] intValue];
    data.image = image;
    data.taxregistry = [dic objectForKey:@"taxregistry"];
    data.name = [dic objectForKey:@"name"];
    data.organizingcode = [dic objectForKey:@"organizingcode"];
    data.representative = [dic objectForKey:@"representative"];
    data.bank = [dic objectForKey:@"bank"];
    data.companyaccount = [dic objectForKey:@"companyaccount"];
    data.accountname = [dic objectForKey:@"accountname"];
    data.telephone = [dic objectForKey:@"telephone"];
    data.address = [dic objectForKey:@"address"];
    [data saveRecord];
}
@end
