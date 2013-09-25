//
//  PBRecommendProjectViewController.m
//  ParkBusiness
//
//  Created by QDS on 13-3-18.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBRecommendProjectViewController.h"
#import "CommonCell.h"
#import "CommonProjectDetailController.h"
#import "PBAddCompanyBand.h"
#import "PBAddFinanceAssure.h"
#import "PBAddFinanceLease.h"
#import "PBAddInsureInfo.h"
#define kURLSTRING [NSString stringWithFormat:@"%@admin/index/projectlist", HOST]

/****************************************
 pageno               必须传的参数
 flag=1/else or null  查询推荐项目/全部
 trade (int)          所属行业
 search（string）      搜索框传回来的字段，只能按项目名模糊查询
 ****************************************/

@interface PBRecommendProjectViewController ()

@end

@implementation PBRecommendProjectViewController
@synthesize manager;
@synthesize dataArray;
@synthesize pullController;
@synthesize send;
@synthesize typeno;
@synthesize sortno;
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
    self.typeno = @"";
    self.sortno = @"";
    // Do any additional setup after loading the view from its nib.
    typekinds = [[NSMutableArray alloc]init];
    NSMutableArray* arr = [PBKbnMasterModel getKbnInfoByKind:@"projecttype"];
    for (PBKbnMasterModel* model in arr) {
        [typekinds addObject:model.name];
    }
    sortkinds = [[NSMutableArray alloc]initWithObjects:@"提交时间",@"企业规模", nil];
    leftImageName = [[NSMutableArray alloc]initWithObjects:@"tradedrop.png", nil];
    for (int i=1; i<7; i++) {
        [leftImageName addObject:[NSString stringWithFormat:@"projecttype%d.png",i]];
    }
    sortImageName = [[NSArray alloc]initWithObjects:@"time.png",@"companyscale1.png", nil];
    //设置下拉
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    CGFloat width = headView.frame.size.width/2;
    leftbtn = [self setSelectButton:CGRectMake(0, 0, width, headView.frame.size.height)withTag:1];
    rightbtn = [self setSelectButton:CGRectMake(width,0 , width, headView.frame.size.height) withTag:2];
    //设置下拉图片
    leftView = [[PBCustomDropView alloc]initWithFrame:CGRectMake(0, 0, width, headView.frame.size.height)];
    rightView = [[PBCustomDropView alloc]initWithFrame:CGRectMake(width,0 , width, headView.frame.size.height)];
    [leftView setSelectViewWithTitle:@"项目类型" image:[UIImage imageNamed:@"tradedrop.png"]];
    [rightView setSelectViewWithTitle:@"默认排序" image:[UIImage imageNamed:@"sortdrop.png"]];
    [headView addSubview:leftView];
    [headView addSubview:rightView];
    [headView addSubview:leftbtn];
    [headView addSubview:rightbtn];
    [self.view addSubview:headView];
    CGFloat viewWidth = isPad() ? 768 : 320;
    CGFloat viewHeight = (isPad() ? 1024 : (isPhone5() ? 568 :480)) - KTabBarHeight - KNavigationBarHeight-headView.frame.size.height;
    
    //下拉显示
    pullController = [[PBPullTableViewController alloc]initWithFrame:CGRectMake(0, headView.frame.size.height, viewWidth, viewHeight)];
    pullController.delegate =self;
    pullController.tableViews.delegate = self;
    pullController.tableViews.dataSource = self;
    [self.view addSubview:pullController.tableViews];
    [self.view addSubview:pullController.indicator];
    self.title = @"推荐项目";
    manager = [[PBManager alloc] init];
    manager.delegate = self;
    
    manager.acIndicator = pullController.indicator;
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tapGr.cancelsTouchesInView = NO;
    [self.pullController.tableViews addGestureRecognizer:tapGr];
}

-(void)viewTapped{
    if (dropDown1.tag==1) {
        [dropDown1 hideDropDown:leftbtn];
        leftView.imageView2.image = [UIImage imageNamed:@"dropselect.png"];
    }else{
        rightView.imageView2.image = [UIImage imageNamed:@"dropselect.png"];
        [dropDown1 hideDropDown:rightbtn];
    }
    dropDown1 = nil;
}
//设置下拉列表button
-(UIButton*)setSelectButton:(CGRect)frame withTag:(int)tag{
    UIButton *btnSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSelect.backgroundColor = [UIColor clearColor];
    btnSelect.frame = frame;
    btnSelect.tag = tag;
    [btnSelect addTarget:self action:@selector(selectClicked:) forControlEvents:UIControlEventTouchUpInside];
    return btnSelect;
}

-(void)selectClicked:(UIButton*)sender{
    BOOL Left = sender.tag == 1?YES:NO;
    NSMutableArray * arr = [[NSMutableArray alloc] initWithObjects:@"全部", nil];
    if (Left){
        [arr addObjectsFromArray:typekinds];
    }else{
        arr = [NSMutableArray arrayWithArray:sortkinds];
    }
    
    CGFloat f = isPad()?440:200;
    rightView.imageView2.image = [UIImage imageNamed:@"dropselect.png"];
    if(dropDown1 == nil) {
        if (Left) {
            leftView.imageView2.image = [UIImage imageNamed:@"dropselected.png"];
            dropDown1 = [[PBDropDown alloc]showDropDown:sender height:&f arr:arr imageView:leftImageName];
        }else{
            rightView.imageView2.image = [UIImage imageNamed:@"dropselected.png"];
            dropDown1 = [[PBDropDown alloc]showDropDown:sender height:&f arr:arr imageView:sortImageName];
        }
        dropDown1.tag = sender.tag;
        dropDown1.delegate = self;
    }
    else {
        if (dropDown1.tag==sender.tag) {
            if (Left) {
                leftView.imageView2.image = [UIImage imageNamed:@"dropselect.png"];
            }else{
                rightView.imageView2.image = [UIImage imageNamed:@"dropselect.png"];
            }
            [dropDown1 hideDropDown:sender];
            dropDown1 = nil;
        }else{
            if (Left) {
                leftView.imageView2.image = [UIImage imageNamed:@"dropselected.png"];
                rightView.imageView2.image = [UIImage imageNamed:@"dropselect.png"];
                [dropDown1 hideDropDown:rightbtn];
                dropDown1 = [[PBDropDown alloc]showDropDown:sender height:&f arr:arr imageView:leftImageName];
            }else{
                rightView.imageView2.image = [UIImage imageNamed:@"dropselected.png"];
                leftView.imageView2.image = [UIImage imageNamed:@"dropselect.png"];
                [dropDown1 hideDropDown:leftbtn];
                dropDown1 = [[PBDropDown alloc]showDropDown:sender height:&f arr:arr imageView:sortImageName];
            }
            
            
            dropDown1.tag = sender.tag;
            dropDown1.delegate = self;
        }
        
    }
    
}

//选择行业信息
- (void) pbDropDownDelegateMethod: (PBDropDown *) sender {
    [pullController.indicator startAnimating];
    if(sender.tag==1){
        [leftView setSelectViewWithTitle:[sender.title isEqualToString:@"全部"]?@"行业分类":sender.title image:sender.image];
        self.typeno = sender.row==0?@"":sender.rowno;
        [self requestData:@"1"];
    }else if (sender.tag==2) {
        [rightView setSelectViewWithTitle:sender.title image:sender.image];
        self.sortno = sender.rowno;
        [self requestData:@"1"];
    }
    dropDown1 = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData:@"1"];
}

- (void) requestData:(NSString *)pageno
{
    if ([pageno isEqualToString:@"1"]) {
        [pullController.allData removeAllObjects];
    }
    [pullController.indicator startAnimating];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:pageno, @"pageno", @"1", @"flag",USERNO,@"userno",self.sortno,@"sort",self.typeno,@"type", nil];//flag是否推荐
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
#pragma mark TableViewDataSource
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
#pragma mark TableViewDelegateMethod
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
    [super dealloc];
}

- (void)viewDidUnload {
    [self setSend:nil];
    [self setPullController:nil];
    [self setDataArray:nil];
    [self setManager:nil];
    [super viewDidUnload];
}
@end
