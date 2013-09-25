//
//  PBFinancalPolicyController.m
//  ParkBusiness
//
//  Created by QDS on 13-5-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBFinancalPolicyController.h"
#import "AskSquareCell.h"
#import "PBQuestionListController.h"
#import "PBFinancePolicyDetailView.h"
#import "PBKbnMasterModel.h"
#define kINSTITUTEURLSTRING [NSString stringWithFormat:@"%@admin/index/searchfinancinginstitution", HOST]
#define kPOLICYURLSTRING [NSString stringWithFormat:@"%@admin/index/searchfinancingpolicyqa", HOST]
#define POLICYURLSTRING [NSString stringWithFormat:@"%@admin/index/searchfinancingpolicy", HOST]
@interface PBFinancalPolicyController ()

@end


@implementation PBFinancalPolicyController
@synthesize tradekinds;
@synthesize instituteNo;
@synthesize sortkinds;
@synthesize sorttime;
@synthesize pullController;
@synthesize manager1;
@synthesize manager2;
@synthesize flag;

//实现下拉更新操作
-(void)getDataSource:(PBPullTableViewController *)view
{
    [self getXmlData:@"1" institute:instituteNo sort:sorttime];
}

//点击查看更多按钮
-(void)getMoreButtonDidPush:(PBRefreshTableHeaderView *)view
{
    [self getXmlData:[NSString stringWithFormat:@"%d",pullController.pageno] institute:instituteNo sort:sorttime];
}

//拖动tableView时实现
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[pullController._refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [self dropWillHidden:nil];
    [searchBar resignFirstResponder];
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
        tradeImageName = [[NSMutableArray alloc]initWithObjects:@"tradedrop.png", nil];
        self.sortkinds = [[NSMutableArray alloc] initWithObjects:@"时间降序", @"时间升序", nil];
        self.instituteNo = @"";
        self.sorttime = @"DESC";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"金融政策";
    NSArray* arr = [PBKbnMasterModel getKbnInfoByKind:@"policytype"];
    for (PBKbnMasterModel* model in arr) {
        [self.tradekinds addObject:model.name];
    }
    tradeImageName = [[NSMutableArray alloc]initWithObjects:@"tradedrop.png", nil];
    for (int i=1; i<8; i++) {
        [tradeImageName addObject:[NSString stringWithFormat:@"projecttype%d.png",i]];
    }
    sortImageName = [[NSArray alloc]initWithObjects:@"chat_icon_popup_dismiss.png", @"chat_icon_popup.png", nil];
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
    [self setSelectView:tradeView title:@"政策类型" image:[UIImage imageNamed:@"tradedrop.png"]];
    [self setSelectView:lastestView title:@"默认排序" image:[UIImage imageNamed:@"sortdrop.png"]];
    [headView addSubview:tradeView];
    [headView addSubview:lastestView];
    [headView addSubview:tradebtn];
    [headView addSubview:lastestbtn];
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
    CGFloat height = self.view.frame.size.height-KTabBarHeight-KNavigationBarHeight-headView.frame.size.height-40;
    pullController = [[PBPullTableViewController alloc]initWithFrame:CGRectMake(0, headView.frame.size.height+40, self.view.frame.size.width, height)];
    pullController.delegate =self;
    pullController.tableViews.delegate = self;
    pullController.tableViews.dataSource = self;
    manager1 = [[PBWeiboDataConnect alloc]init];
    manager1.delegate = self;
    manager1.indicator = pullController.indicator;
    manager2 = [[PBWeiboDataConnect alloc]init];
    manager2.delegate = self;
    manager2.indicator = pullController.indicator;
    //获取行业数据
    [manager2 getXMLDataFromUrl:kINSTITUTEURLSTRING postValuesAndKeys:nil];
    [self.view addSubview:headView];
    [headView release];
    [self.view addSubview:pullController.tableViews];
    [self.view addSubview:pullController.indicator];
    [pullController.indicator startAnimating];
    pullController.pageno = 1;
    [self getXmlData:@"1" institute:self.instituteNo sort:self.sorttime];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"refreshPolicyData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(dropWillHidden:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}
-(void)refreshData:(NSNotification*)notification{
    [self getXmlData:@"1" institute:self.instituteNo sort:self.sorttime];
}
-(void)dropWillHidden:(NSNotification*)notification{
    tradeView.imageView2.image = [UIImage imageNamed:@"dropselect.png"];
    lastestView.imageView2.image = [UIImage imageNamed:@"dropselect.png"];
    [dropDown1 hideDropDown:tradebtn];
    [dropDown2 hideDropDown:lastestbtn];
    dropDown1 = nil;
    dropDown2 = nil;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self getXmlData:@"1" institute:self.instituteNo sort:self.sorttime];
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
    [self viewTapped:nil];
    NSMutableArray * arr = [[NSMutableArray alloc] initWithObjects:@"全部", nil];
    [arr addObjectsFromArray:self.tradekinds];
    lastestView.imageView2.image = [UIImage imageNamed:@"dropselect.png"];
    if(dropDown1 == nil) {
        tradeView.imageView2.image = [UIImage imageNamed:@"dropselected.png"];
        CGFloat f = isPad()?440:200;
        dropDown1 = [[PBDropManage alloc]showDropDown:sender height:&f arr:arr imageView:tradeImageName isAsync:NO];
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
    [self viewTapped:nil];
    tradeView.imageView2.image = [UIImage imageNamed:@"dropselect.png"];
    if(dropDown2 == nil) {
        lastestView.imageView2.image = [UIImage imageNamed:@"dropselected.png"];
        CGFloat f = isPad()?440:200;
        dropDown2 = [[PBDropManage alloc]showDropDown:sender height:&f arr:self.sortkinds imageView:sortImageName isAsync:NO];
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
    [self dropWillHidden:nil];
}

-(void)getXmlData:(NSString*)page institute:(NSString*)institute sort:(NSString*)sort{
    [pullController.indicator startAnimating];
    if ([page isEqualToString:@"1"]) {
        [pullController.allData removeAllObjects];
    }
    NSArray* arr1 = [NSArray arrayWithObjects:page,institute,sort,[NSString stringWithFormat:@"%d", [PBUserModel getUserId]],searchBar.text?searchBar.text:@"",nil];
    NSArray* arr2 = [NSArray arrayWithObjects:@"pageno", @"fno", @"paixu",@"userno",@"name", nil];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
    [manager1 getXMLDataFromUrl:self.flag==1?POLICYURLSTRING:kPOLICYURLSTRING postValuesAndKeys:dic];
    [dic release];
}

//成功获取xml数据
- (void) sucessParseXMLData:(PBWeiboDataConnect *)weiboDatas
{
    if (manager2 == weiboDatas) {
        
        //成功从后台获取行业分类数据，可换成从本地数据库获取
    } else {
        [pullController successGetXmlData:pullController withData:manager1.parseData withNumber:10];
    }
}

//选择行业信息
- (void) dropDelegateMethod: (PBDropManage *) sender {
    [pullController.indicator startAnimating];
    if(sender==dropDown1){
        [self setSelectView:tradeView title:[sender.title isEqualToString:@"全部"]?@"金融机构":sender.title image:sender.image];
        
        instituteNo = [sender.title isEqualToString:@"全部"] ? @"" :sender.rowno;
        [self getXmlData:@"1" institute:instituteNo sort:sorttime];
    }else if (sender==dropDown2) {
        [self setSelectView:lastestView title:sender.title image:sender.image];
        sorttime = (sender.row == 0) ? @"DESC" : @"ASC";
        [self getXmlData:@"1" institute:instituteNo sort:sorttime];
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
        NSString *nibName = isPad() ? @"AskSquareCell_iPad" : @"AskSquareCell";
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        nibsRegisted = YES;
    }
    if (cell==nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    } else {
        [cell.policyImageView removeFromSuperview];
    }
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    [imageView setImage:[[UIImage imageNamed:@"fillcell.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
    cell.backgroundView = imageView;
    [imageView release];
    
    if([pullController.allData count]>0) {
        NSDictionary *dic = [pullController.allData objectAtIndex:indexPath.row];
        cell.policyNameLabel.text = [dic objectForKey:@"name"];
        //加载boss头像应该用异步方式
        NSString *bossPhotoURLStr = [NSString stringWithFormat:@"%@%@", HOST, [dic objectForKey:@"imagepath"]];
        CGFloat originX = isPad() ? 10 : 1;
        CGFloat width = isPad() ? 56 : 64;
        cell.policyImageView = [[CustomImageView alloc]initWithFrame:CGRectMake(originX, 1, width, width)];
        [cell.contentView addSubview:cell.policyImageView];
        [cell.policyImageView.imageView loadImage: bossPhotoURLStr];
        cell.policyQuesCountLabel.text = [dic objectForKey:@"count"];
        cell.policyTimeLabel.text = [dic objectForKey:@"cdate"];
        cell.financenameLabel.text = [dic objectForKey:@"financename"];
    }
    return cell;
}

#pragma mark
#pragma mark UITableViewDelegateMethod
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return isPad() ? 60 :70;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //当前点击的是那个cell，必须有数据的传递
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.flag==1) {
        AskSquareCell *cell = (AskSquareCell*)[tableView cellForRowAtIndexPath:indexPath];
        PBFinancePolicyDetailView *controller = [[PBFinancePolicyDetailView alloc] initWithNibName:isPad()?@"PBFinancePolicyDetailView_ipad":@"PBFinancePolicyDetailView" bundle:nil];
        NSMutableDictionary* dic = [pullController.allData objectAtIndex:indexPath.row];
        [dic setObject:@"1" forKey:@"type"];
        controller.dataDic = dic;
        controller.remarktype = @"1";
        controller.image = cell.policyImageView.imageView.image;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }else{
        PBQuestionListController *controller = [[PBQuestionListController alloc] init];
        controller.qaNoString = [[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"no"];
        controller.typeString = @"1";
        controller.titleString = [[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"name"];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    
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
    [self setInstituteNo:nil];
    [self setSortkinds:nil];
    [self setSorttime:nil];
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
    [instituteNo        release];
    [sortkinds      release];
    [sorttime         release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
