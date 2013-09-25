//
//  PBIndustryOpportunityList.m
//  ParkBusiness
//
//  Created by 上海 on 13-6-30.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBIndustryOpportunityList.h"
#import "AskSquareCell.h"
#import "PBQuestionListController.h"
#import "PBInvestorCaseDetail.h"
#import "PBIndustryOpportunityDetail.h"
#import "PBPublishOpportunity.h"
#define Joininapply_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/joininapply",HOST]]
#define URL [NSString stringWithFormat:@"%@admin/index/searchindustryopportunity", HOST]
@interface PBIndustryOpportunityList ()

@end

@implementation PBIndustryOpportunityList
@synthesize tradekinds;
@synthesize trade;
@synthesize type;
@synthesize typekinds;
@synthesize pullController;
@synthesize rootController;
//实现下拉更新操作
-(void)getDataSource:(PBPullTableViewController *)view
{
    [self getXmlData:@"1"];
}

//点击查看更多按钮
-(void)getMoreButtonDidPush:(PBRefreshTableHeaderView *)view
{
    [self getXmlData:[NSString stringWithFormat:@"%d",pullController.pageno]];
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
        
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        tradeImageName = [[NSMutableArray alloc] initWithObjects:@"tradedrop.png",nil];
        type = @"";
        trade = @"";
        // Custom initialization
    }
    return self;
}

//进入发布页面
- (void)willPublish:(id)sender
{
    if ([PBUserModel getPasswordAndKind].kind >0) {
        PBPublishOpportunity* publish = [[PBPublishOpportunity alloc]initWithStyle:UITableViewStyleGrouped];
        [publish navigatorRightButtonType:WANCHEN];
        publish.rootController = self.rootController;
        publish.title = NSLocalizedString(@"PBIndustryOpportunityList_wyfb", nil);
        [self.navigationController pushViewController:publish animated:YES];
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您必须成为融商正式会员后才能使用此功能！" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) otherButtonTitles:@"申请正式加盟", nil];
        [alert show];
        [alert release];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"APPLYJOININ" object:nil];
//        PBdataClass *dataclass = [[PBdataClass alloc] init];
//        dataclass.delegate = self;
//        [dataclass dataResponse:Joininapply_URL postDic:[NSDictionary dictionaryWithObjectsAndKeys:USERNO,@"userno",[PBUserModel getTel],@"tel", nil] searchOrSave:NO];
    }
    
}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString *)intvalue{
    if ([intvalue integerValue] ==  1) {
        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"申请成功" message:@"申请加盟成功,稍后有服务人员与你联系" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alt show];
        [alt release];
        [self performSelector:@selector(dismissAlt:) withObject:alt afterDelay:2.0];
    }
    [dataclass release];
}

-(void)searchFilad{
    UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络不流畅" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alt show];
    [alt release];
}
-(void)dismissAlt:(UIAlertView *)alt{
    [alt dismissWithClickedButtonIndex:0 animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.tag = 101;
    btn1.frame = CGRectMake(3, 1.5, 40, 40);
    [btn1 addTarget:self action:@selector(backHomeView:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"right_back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *barButton1 = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    if ([PBUserModel getPasswordAndKind].kind != 3) {
        UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"PBIndustryOpportunityList_wyfb", nil) style:UIBarButtonItemStylePlain target:self action:@selector(willPublish:)];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:barButton1,rightbtn, nil];
        [rightbtn release];
    }else{
        self.navigationItem.rightBarButtonItem = barButton1;
    }
    [barButton1 release];
    
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"Left_mainTable_QYGQ", nil);
    self.tradekinds = [[NSMutableArray alloc] init];
    self.typekinds = [[NSMutableArray alloc] initWithObjects:@"全部", nil];
    NSArray* arr = [PBKbnMasterModel getKbnInfoByKind:@"industry"];
    for (PBKbnMasterModel* model in arr) {
        [self.tradekinds addObject:model.name];
    }
    arr = [PBKbnMasterModel getKbnInfoByKind:@"opportunitytype"];
    for (PBKbnMasterModel* model in arr) {
        [self.typekinds addObject:model.name];
    }
    sortImageName = [[NSMutableArray alloc]initWithObjects:@"tradedrop.png", nil];
    for (int i=1; i<7; i++) {
        [sortImageName addObject:[NSString stringWithFormat:@"projecttype%d.png",i]];
    }
    //获取行业图片
    tradeImageName = [[NSMutableArray alloc] initWithObjects:@"tradedrop.png", nil];
    for (int i=1; i<=[tradekinds count]; i++) {
        [tradeImageName addObject:[NSString stringWithFormat:@"industry%d.png",i]];
    }
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    CGFloat width = headView.frame.size.width/2;
    //设置下拉按钮
    lastestView = [[PBCustomDropView alloc]initWithFrame:CGRectMake(0, 0, width, headView.frame.size.height)];
    tradeView = [[PBCustomDropView alloc]initWithFrame:CGRectMake(width,0 , width, headView.frame.size.height)];
    tradebtn = [self setSelectButton:tradeView.frame];
    [tradebtn addTarget:self action:@selector(tradeSelectClicked:) forControlEvents:UIControlEventTouchUpInside];
    typebtn = [self setSelectButton:lastestView.frame];
    [typebtn addTarget:self action:@selector(lastSelectClicked:) forControlEvents:UIControlEventTouchUpInside];
    //设置下拉图片
    [self setSelectView:tradeView title:@"行业分类" image:[UIImage imageNamed:@"tradedrop.png"]];
    [self setSelectView:lastestView title:@"类型" image:[UIImage imageNamed:@"tradedrop.png"]];
    [headView addSubview:tradeView];
    [headView addSubview:lastestView];
    [headView addSubview:tradebtn];
    [headView addSubview:typebtn];
    //点击事件
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    //搜索条
    searchBar=[[UISearchBar alloc] init];
    searchBar.frame=CGRectMake(0, headView.frame.size.height, self.view.bounds.size.width, 40);
    searchBar.delegate=self;
    [searchBar sizeToFit];
    searchBar.placeholder = @"首字符匹配搜索";
    searchBar.backgroundColor=[UIColor clearColor];
    [[searchBar.subviews objectAtIndex:0]removeFromSuperview];
    for (UIView *subview in searchBar.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
            break;
        }
    }
    [self.view addSubview:searchBar];
    //下拉显示
    CGFloat height = self.view.frame.size.height-KNavigationBarHeight-headView.frame.size.height-searchBar.frame.size.height;
    pullController = [[PBPullTableViewController alloc]initWithFrame:CGRectMake(0, headView.frame.size.height+searchBar.frame.size.height, self.view.frame.size.width, height)];
    pullController.delegate =self;
    pullController.tableViews.delegate = self;
    pullController.tableViews.dataSource = self;
    pullController.tableViews.backgroundColor = [UIColor clearColor];
//    self.view.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
    [self.view addSubview:headView];
    [headView release];
    [self.view addSubview:pullController.tableViews];
    [self.view addSubview:pullController.indicator];
    [pullController.indicator startAnimating];
    pullController.pageno = 1;
    [self getXmlData:@"1"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"refreshOpportunityData" object:nil];
}
-(void)refreshData:(NSNotification*)notification{
    [self getXmlData:@"1"];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self getXmlData:@"1"];
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [searchBar resignFirstResponder];
}
//设置下拉列表图片布局及显示内容
-(void)setSelectView:(PBCustomDropView*)view title:(NSString*)title image:(UIImage*)image{
    view.imageView2.image = [UIImage imageNamed:@"dropselect.png"];
    view.imageView1.image = image;
    view.customlb.text = title;
}

//设置下拉列表button
-(UIButton*)setSelectButton:(CGRect)frame{
    UIButton *btnSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSelect.backgroundColor = [UIColor clearColor];
    btnSelect.frame = frame;
    return btnSelect;
}

//行业分类下拉列表选项
- (void)tradeSelectClicked:(id)sender {
    NSMutableArray * arr = [[NSMutableArray alloc] initWithObjects:@"全部", nil];
    [arr addObjectsFromArray:self.tradekinds];
    lastestView.imageView2.image = [UIImage imageNamed:@"dropselect.png"];
    if(dropDown1 == nil) {
        tradeView.imageView2.image = [UIImage imageNamed:@"dropselected.png"];
        CGFloat f = isPad()?440:200;
        dropDown1 = [[PBDropManage alloc]showDropDown:sender height:&f arr:arr imageView:tradeImageName isAsync:NO];
        dropDown1.delegate = self;
        tradebtn.imageView.image = [UIImage imageNamed:@"user.png"];
        [dropDown2 hideDropDown:typebtn];
        dropDown2 = nil;
        [arr release];
    }
    else {
        tradeView.imageView2.image = [UIImage imageNamed:@"dropselect.png"];
        [dropDown1 hideDropDown:sender];
        dropDown1 = nil;
    }
}
//最新下拉列表选项
- (void)lastSelectClicked:(id)sender {
    tradeView.imageView2.image = [UIImage imageNamed:@"dropselect.png"];
    if(dropDown2 == nil) {
        lastestView.imageView2.image = [UIImage imageNamed:@"dropselected.png"];
        CGFloat f = isPad()?440:200;;
        dropDown2 = [[PBDropManage alloc]showDropDown:sender height:&f arr:self.typekinds imageView:sortImageName isAsync:NO];
        dropDown2.delegate = self;
        [dropDown1 hideDropDown:tradebtn];
        dropDown1 = nil;
    }
    else {
        lastestView.imageView2.image = [UIImage imageNamed:@"dropselect.png"];
        [dropDown2 hideDropDown:sender];
        dropDown2 = nil;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
//
-(void)viewWillDisappear:(BOOL)animated{
    tradeView.imageView2.image = [UIImage imageNamed:@"dropselect.png"];
    lastestView.imageView2.image = [UIImage imageNamed:@"dropselect.png"];
    [dropDown1 hideDropDown:tradebtn];
    [dropDown2 hideDropDown:typebtn];
    dropDown1 = nil;
    dropDown2 = nil;
}

-(void)getXmlData:(NSString*)page{
    [pullController.indicator startAnimating];
    if ([page isEqualToString:@"1"]) {
        [pullController.allData removeAllObjects];
    }
    NSString* name = searchBar.text?searchBar.text:@"";
    NSArray* arr1 = [NSArray arrayWithObjects:page,name,trade,type,USERNO,nil];
    NSArray* arr2 = [NSArray arrayWithObjects:@"pageno",@"name",@"trade",@"type",@"personno",nil];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
    PBWeiboDataConnect* connect = [[PBWeiboDataConnect alloc]init];
    connect.delegate = self;
    connect.indicator = pullController.indicator;
    [connect getXMLDataFromUrl:URL postValuesAndKeys:dic];
    [dic release];
}

//成功获取xml数据
- (void) sucessParseXMLData:(PBWeiboDataConnect *)weiboDatas
{
    [pullController successGetXmlData:pullController withData:weiboDatas.parseData withNumber:20];
}

//选择行业信息
- (void) dropDelegateMethod: (PBDropManage *) sender {
    [pullController.indicator startAnimating];
    if(sender==dropDown1){
        [self setSelectView:tradeView title:(sender.row==0)?@"行业分类":sender.title image:sender.image];
        trade = (sender.row==0)? @"" : sender.rowno;
        [self getXmlData:@"1"];
    }else if (sender==dropDown2) {
        [self setSelectView:lastestView title:(sender.row==0)?@"类型":sender.title image:sender.image];
        type = (sender.row==0) ? @"" : sender.rowno;
        [self getXmlData:@"1"];
    }
    dropDown1 = nil;
    dropDown2 = nil;
}

#pragma mark
#pragma mark UITableViewDataSourceMethod
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [pullController.allData count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"AskSquareCell";
    //cell不能为空
    static BOOL nibsRegisted = NO;
    AskSquareCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        nibsRegisted = NO;
    }
    
    if (!nibsRegisted) {
        NSString *nibName = isPad() ? @"PBIndustryOpportunityCell_ipad" : @"PBIndustryOpportunityCell";
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        nibsRegisted = YES;
    }
    if (cell==nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jrcs_cellselect.png"]];
        cell.selectedBackgroundView = imageView;
        [imageView release];
    } else {
        [cell.policyImageView removeFromSuperview];
    }
    if([pullController.allData count]>0) {
        NSDictionary *dic = [pullController.allData objectAtIndex:indexPath.row];
        cell.policyNameLabel.text = [dic objectForKey:@"name"];
        cell.policyQuesCountLabel.text = [dic objectForKey:@"type"];
        cell.policyTimeLabel.text = [dic objectForKey:@"udate"];
        cell.financenameLabel.text = [dic objectForKey:@"trade"];
    }
    return cell;
}

#pragma mark
#pragma mark UITableViewDelegateMethod
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return isPad() ? 80 :70;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PBIndustryOpportunityDetail *controller = [[PBIndustryOpportunityDetail alloc] initWithStyle:UITableViewStyleGrouped];
    controller.rootController = self.rootController;
    controller.dataDictionary = [pullController.allData objectAtIndex:indexPath.row];
    controller.flag = [[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"flag"];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload {
    [self setPullController:nil];
    [self setPullController:nil];
    [self setTradekinds:nil];
    [super viewDidUnload];
}

- (void) dealloc {
    [dropDown1      release];
    [dropDown2      release];
    [tradeView      release];
    [lastestView    release];
    [pullController release];
    [sortImageName  release];
    [tradeImageName release];
    [tradekinds     release];
    [typebtn    release];
    [typekinds      release];
    [type       release];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}


@end
