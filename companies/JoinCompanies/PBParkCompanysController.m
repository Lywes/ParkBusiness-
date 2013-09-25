//
//  PBParkCompanysController.m
//  ParkBusiness
//
//  Created by QDS on 13-5-22.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBParkCompanysController.h"
#import "PBUserModel.h"
#import "StarEntrepreneursCell.h"
#import "PBStarEntrepreneursDetail.h"

#define kTRADEURLSTRING [NSString stringWithFormat:@"%@/admin/index/tradekinds",HOST]
#define kPARKCOMPANYURLSTRING [NSString stringWithFormat:@"%@/admin/index/searchuser",HOST]

@interface PBParkCompanysController ()

@end

@implementation PBParkCompanysController
@synthesize tradekinds;
@synthesize sortkinds;
@synthesize parkNoString;

- (id)init
{
    self = [super init];
    if (self) {
        self.tradekinds = [[NSMutableArray alloc]init];
        self.sortkinds = [[NSMutableArray alloc]initWithObjects:@"最新企业家",@"最近上线企业家", @"明星企业家", nil];
        tradeNo = @"";
        sortNo = @"";
        // Custom initialization
    }
    return self;
}

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
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(7, 7, 25, 30);
        [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(popPreView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = item;
        [item release];
    }
    return self;
}

- (void) popPreView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"园区企业家";
    sortImageName = [[NSArray alloc]initWithObjects:@"sortdrop1.png", @"sortdrop2.png", @"starcompany.png", nil];
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
    manage1 = [[PBWeiboDataConnect alloc]init];
    manage1.delegate = self;
    manage1.indicator = pullController.indicator;
    manage2 = [[PBWeiboDataConnect alloc]init];
    manage2.delegate = self;
    manage2.indicator = pullController.indicator;
    //获取行业数据
    [manage2 getXMLDataFromUrl:kTRADEURLSTRING postValuesAndKeys:nil];
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
    [self getXmlData:@"1" trade:tradeNo sort:sortNo];
}

-(void)viewWillDisappear:(BOOL)animated{
    [dropDown1 hideDropDown:tradebtn];
    [dropDown2 hideDropDown:lastestbtn];
    dropDown1 = nil;
    dropDown2 = nil;
}

//设置下拉列表button
-(UIButton*)setSelectButton:(CGRect)frame{
    UIButton *btnSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSelect.backgroundColor = [UIColor clearColor];
    btnSelect.frame = frame;
    return btnSelect;
}


//设置下拉列表图片布局及显示内容
-(void)setSelectView:(PBCustomDropView*)view title:(NSString*)title image:(NSString*)image{
    view.imageView2.image = [UIImage imageNamed:@"dropselect.png"];
    view.imageView1.image = [UIImage imageNamed:image];
    view.customlb.text = title;
}

-(void)getXmlData:(NSString*)page trade:(NSString*)trade sort:(NSString*)sort{
    [pullController.indicator startAnimating];
    if ([page isEqualToString:@"1"]) {
        [pullController.allData removeAllObjects];
    }
    
    NSString *userNoStr = USERNO;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:page, @"pageno", trade, @"trade", sort, @"sort", @"2", @"kind", userNoStr, @"no", parkNoString, @"parkno", nil];
    [manage1 getXMLDataFromUrl:kPARKCOMPANYURLSTRING postValuesAndKeys:dic];
    [dic release];
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
    } else {
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
        dropDown2 = [[PBDropDown alloc] showDropDown:sender height:&f arr:self.sortkinds imageView:sortImageName];
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

//选择行业信息
- (void) pbDropDownDelegateMethod: (PBDropDown *) sender {
    [pullController.indicator startAnimating];
    if(sender==dropDown1){
        
        [self setSelectView:tradeView title:[sender.title isEqualToString:@"全部"]?@"行业分类":sender.title image:[tradeImageName objectAtIndex:[sender.rowno intValue]]];
        tradeNo = [sender.title isEqualToString:@"全部"] ? @"" : sender.rowno;
        [self getXmlData:@"1" trade:tradeNo sort:sortNo];
    }else if (sender==dropDown2) {
        [self setSelectView:lastestView title:sender.title image:[sortImageName objectAtIndex:[sender.rowno intValue]]];
        //排序编号要在原来的基础上加1
        sortNo = [[NSString stringWithFormat:@"%d", [sender.rowno intValue] + 1] copy];
        [self getXmlData:@"1" trade:tradeNo sort:sortNo];
    }
    dropDown1 = nil;
    dropDown2 = nil;
}

//成功获取xml数据
- (void) sucessParseXMLData:(PBWeiboDataConnect *)weiboDatas
{
    if (manage2 == weiboDatas) {
        //成功从后台获取行业分类数据，可换成才本地取
        for(NSMutableDictionary* dic in manage2.parseData){
            [tradekinds addObject:[dic objectForKey:@"name"]];
        }
        //获取行业图片
        tradeImageName = [[NSMutableArray alloc] initWithObjects:@"tradedrop.png", nil];
        for (int i=1; i<=[tradekinds count]; i++) {
            [tradeImageName addObject:[NSString stringWithFormat:@"industry%d.png",i]];
        }
    } else {
        [pullController successGetXmlData:pullController withData:manage1.parseData withNumber:10];
    }
}


#pragma mark
#pragma mark UITableViewDataSourceMethod
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
        cell.companyJobLabel.text = [arrToDic objectForKey:@"companyjob"];
        cell.starBossLoginTimeLabel.text = [arrToDic objectForKey:@"logintime"];
        cell.starCompanyNameLabel.text = [arrToDic objectForKey:@"companyname"];
        cell.companyInParkLabel.text = [arrToDic objectForKey:@"park"];
        cell.starTradeLabel.text = [arrToDic objectForKey:@"trade"];
    }
    return cell;
}

#pragma mark
#pragma mark UITableViewDelegateMethod
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PBStarEntrepreneursDetail *controller = [[PBStarEntrepreneursDetail alloc] init];
    controller.dataDictionary = [pullController.allData objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload
{
    [self setParkNoString:nil];
    [self setSortkinds:nil];
    [self setTradekinds:nil];
    [super viewDidUnload];
}

- (void) dealloc
{
    [pullController release];
    [dropDown1      release];
    [dropDown2      release];
    [parkNoString   release];
    [manage1        release];
    [manage2        release];
    [tradeView      release];
    [lastestView    release];
    [tradeImageName release];
    [sortImageName  release];
    [tradekinds     release];
    [sortkinds      release];
    [tradeNo release];
    [sortNo release];
    [super dealloc];
}

@end
