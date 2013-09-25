//
//  PBAllInvestorController.m
//  ParkBusiness
//
//  Created by QDS on 13-5-23.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBAllInvestorController.h"
#import "InvestorCell.h"
#import "PBInvestorDetail.h"

#define kURLSTRING [NSString stringWithFormat:@"%@admin/index/searchinvestuser", HOST]
#define kTRADEURLSTRING [NSString stringWithFormat:@"%@/admin/index/tradekinds",HOST]

@interface PBAllInvestorController ()

@end

@implementation PBAllInvestorController
@synthesize tradekinds;
@synthesize tradeNo;
@synthesize sortkinds;
@synthesize sortNo;
@synthesize pullController;
@synthesize manager1;
@synthesize manager2;

//实现下拉更新操作
-(void)getDataSource:(PBPullTableViewController *)view
{
    [self getXmlData:@"1" trade:tradeNo sort:sortNo];
}

//点击查看更多按钮
-(void)getMoreButtonDidPush:(PBRefreshTableHeaderView *)view
{
    [self getXmlData:[NSString stringWithFormat:@"%d",pullController.pageno] trade:tradeNo sort:sortNo];
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
        self.tradekinds = [[NSMutableArray alloc]init];
        self.sortkinds = [[NSMutableArray alloc]initWithObjects:@"时间",@"基金规模", nil];
        self.tradeNo = @"";
        self.sortNo = @"0";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"投资人";
    sortImageName = [[NSArray alloc]initWithObjects:@"sortdrop2.png", @"capitalscale.png", nil];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    CGFloat width = headView.frame.size.width/2;
    //设置下拉按钮
    tradebtn = [self setSelectButton:CGRectMake(0, 0, width, headView.frame.size.height)];
    [tradebtn addTarget:self action:@selector(tradeSelectClicked:) forControlEvents:UIControlEventTouchUpInside];
    lastestbtn = [self setSelectButton:CGRectMake(width,0 , width, headView.frame.size.height)];
    [lastestbtn addTarget:self action:@selector(lastSelectClicked:) forControlEvents:UIControlEventTouchUpInside];
    //设置下拉图片
    tradeView = [[PBCustomDropView alloc]initWithFrame:CGRectMake(0, 0, width, headView.frame.size.height)];
    lastestView = [[PBCustomDropView alloc]initWithFrame:CGRectMake(width,0 , width, headView.frame.size.height)];
    [self setSelectView:tradeView title:@"行业分类" image:@"tradedrop.png"];
    [self setSelectView:lastestView title:@"默认排序" image:@"sortdrop.png"];
    [headView addSubview:tradeView];
    [headView addSubview:lastestView];
    [headView addSubview:tradebtn];
    [headView addSubview:lastestbtn];
    manager1 = [[PBWeiboDataConnect alloc]init];
    manager1.delegate = self;
    manager1.indicator = pullController.indicator;
    manager2 = [[PBWeiboDataConnect alloc]init];
    manager2.delegate = self;
    manager2.indicator = pullController.indicator;
    //获取行业数据
    [manager2 getXMLDataFromUrl:kTRADEURLSTRING postValuesAndKeys:nil];
    //下拉显示
    CGFloat height = self.view.frame.size.height-KTabBarHeight-KNavigationBarHeight-headView.frame.size.height;
    pullController = [[PBPullTableViewController alloc]initWithFrame:CGRectMake(0, headView.frame.size.height, self.view.frame.size.width, height)];
    pullController.delegate =self;
    pullController.tableViews.delegate = self;
    pullController.tableViews.dataSource = self;
    [self.view addSubview:headView];
    [headView release];
    [self.view addSubview:pullController.tableViews];
    [self.view addSubview:pullController.indicator];
    [pullController.indicator startAnimating];
    pullController.pageno = 1;
    [self getXmlData:@"1" trade:self.tradeNo sort:self.sortNo];
}

//设置下拉列表图片布局及显示内容
-(void)setSelectView:(PBCustomDropView*)view title:(NSString*)title image:(NSString*)image{
    view.imageView2.image = [UIImage imageNamed:@"dropselect.png"];
    view.imageView1.image = [UIImage imageNamed:image];
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
        dropDown1 = [[PBDropDown alloc]showDropDown:sender height:&f arr:arr imageView:tradeImageName];
        dropDown1.delegate = self;
        tradebtn.imageView.image = [UIImage imageNamed:@"user.png"];
        [dropDown2 hideDropDown:lastestbtn];
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
        dropDown2 = [[PBDropDown alloc]showDropDown:sender height:&f arr:self.sortkinds imageView:sortImageName];
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
    [dropDown1 hideDropDown:tradebtn];
    [dropDown2 hideDropDown:lastestbtn];
    dropDown1 = nil;
    dropDown2 = nil;
}

-(void)getXmlData:(NSString*)page trade:(NSString*)trade sort:(NSString*)sort{
    [pullController.indicator startAnimating];
    if ([page isEqualToString:@"1"]) {
        [pullController.allData removeAllObjects];
    }
    NSArray* arr1 = [NSArray arrayWithObjects:page,trade,sort,nil];
    NSArray* arr2 = [NSArray arrayWithObjects:@"pageno", @"investtrade", @"sort", nil];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
    [manager1 getXMLDataFromUrl:kURLSTRING postValuesAndKeys:dic];
    [dic release];
}

//成功获取xml数据
- (void) sucessParseXMLData:(PBWeiboDataConnect *)weiboDatas
{
    if (manager2 == weiboDatas) {
        //成功从后台获取行业分类数据，可换成从本地取
        for(NSMutableDictionary* dic in manager2.parseData){
            [tradekinds addObject:[dic objectForKey:@"name"]];
        }
        //获取行业图片
        tradeImageName = [[NSMutableArray alloc] initWithObjects:@"tradedrop.png", nil];
        for (int i=1; i<=[tradekinds count]; i++) {
            [tradeImageName addObject:[NSString stringWithFormat:@"industry%d.png",i]];
        }
    } else {
        [pullController successGetXmlData:pullController withData:manager1.parseData withNumber:20];
    }
}

//选择行业信息
- (void) pbDropDownDelegateMethod: (PBDropDown *) sender {
    [pullController.indicator startAnimating];
    if(sender==dropDown1){
        [self setSelectView:tradeView title:[sender.title isEqualToString:@"全部"]?@"行业分类":sender.title image:[tradeImageName objectAtIndex:[sender.rowno intValue]]];
        tradeNo = [sender.title isEqualToString:@"全部"] ? @"" : sender.title;
        [self getXmlData:@"1" trade:tradeNo sort:sortNo];
    }else if (sender==dropDown2) {
        [self setSelectView:lastestView title:sender.title image:[sortImageName objectAtIndex:[sender.rowno intValue]]];
        //排序编号要在原来的基础上加1
        sortNo = sender.rowno;
        [self getXmlData:@"1" trade:tradeNo sort:sortNo];
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
    static NSString *identifier = @"CellIdentifier";
    //cell不能为空
    static BOOL nibsRegisted = NO;
    InvestorCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        nibsRegisted = NO;
    }
    
    if (!nibsRegisted) {
        NSString *nibName = isPad() ? @"InvestorCell_iPad" : @"InvestorCell";
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        nibsRegisted = YES;
    }
    if (cell==nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    } else {
        [cell.customCellBossPhoto removeFromSuperview];
    }
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    [imageView setImage:[[UIImage imageNamed:@"fillcell.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
    cell.backgroundView = imageView;
    [imageView release];
    
    if([pullController.allData count]>0) {
        NSDictionary *dic = [pullController.allData objectAtIndex:indexPath.row];
        cell.customCellBossName.text = [dic objectForKey:@"myname"];
        //加载boss头像应该用异步方式
        NSString *bossPhotoURLStr = [NSString stringWithFormat:@"%@%@", HOST, [dic objectForKey:@"imagepath"]];
        CGFloat originX = isPad() ? 10 : 3;
        cell.customCellBossPhoto = [[CustomImageView alloc]initWithFrame:CGRectMake(originX, 6, 76, 76)];
        [cell.contentView addSubview:cell.customCellBossPhoto];
        [cell.customCellBossPhoto.imageView loadImage: bossPhotoURLStr];
        cell.customCellSImpleIntroduce.text = [dic objectForKey:@"signature"];
        cell.customCellLastRegistTime.text = [dic objectForKey:@"logintime"];
        cell.customCellCompanyType.text = [dic objectForKey:@"investtrade"];
    }
    return cell;
}

#pragma mark
#pragma mark UITableViewDelegateMethod
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //当前点击的是那个cell，必须有数据的传递
    
    PBInvestorDetail *detailController = [[PBInvestorDetail alloc] init];
    detailController.investorNo = [[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"no"];
    [self.navigationController pushViewController:detailController animated:YES];
    [detailController release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload {
    [self setPullController:nil];
    [self setManager1:nil];
    [self setManager2:nil];
    [self setPullController:nil];
    [self setTradekinds:nil];
    [self setTradeNo:nil];
    [self setSortkinds:nil];
    [self setSortNo:nil];
    [super viewDidUnload];
}

- (void) dealloc {
    [dropDown1      release];
    [dropDown2      release];
    [tradeView      release];
    [lastestView    release];
    [manager1       release];
    [manager2       release];
    [pullController release];
    [sortImageName  release];
    [tradeImageName release];
    [tradekinds     release];
    [tradeNo        release];
    [sortkinds      release];
    [sortNo         release];
    [super dealloc];
}

@end
