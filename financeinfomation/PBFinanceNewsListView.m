//
//  PBFinancalPolicyController.m
//  ParkBusiness
//
//  Created by QDS on 13-5-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBFinanceNewsListView.h"
#import "AskSquareCell.h"
#import "PBQuestionListController.h"
#import "PBFinancePolicyDetailView.h"
#define kINSTITUTEURLSTRING [NSString stringWithFormat:@"%@admin/index/searchfinancinginstitution", HOST]
#define kNEWSURLSTRING [NSString stringWithFormat:@"%@admin/index/searchfinancingnews", HOST]

@interface PBFinanceNewsListView ()

@end


@implementation PBFinanceNewsListView
@synthesize pullController;
@synthesize manager1;
@synthesize manager2;

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
        financeArr = [[NSMutableArray alloc]init];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"金融新闻";
    //设置下拉按钮
    manager1 = [[PBWeiboDataConnect alloc]init];
    manager1.delegate = self;
    manager1.indicator = pullController.indicator;
    manager2 = [[PBWeiboDataConnect alloc]init];
    manager2.delegate = self;
    manager2.indicator = pullController.indicator;
    //获取行业数据
    [manager2 getXMLDataFromUrl:kINSTITUTEURLSTRING postValuesAndKeys:nil];
    //下拉显示
    pullController = [[PBPullTableViewController alloc]initWithFrame:self.view.frame];
    pullController.delegate =self;
    pullController.tableViews.delegate = self;
    pullController.tableViews.dataSource = self;
    [self.view addSubview:pullController.tableViews];
    [self.view addSubview:pullController.indicator];
    [pullController.indicator startAnimating];
    pullController.pageno = 1;
    [self getXmlData:@"1"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"refreshNewsData" object:nil];
}
-(void)refreshData:(NSNotification*)notification{
    [self getXmlData:@"1"];
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


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
//
-(void)viewWillDisappear:(BOOL)animated{

}

-(void)getXmlData:(NSString*)page{
    [pullController.indicator startAnimating];
    if ([page isEqualToString:@"1"]) {
        [pullController.allData removeAllObjects];
    }
    NSArray* arr1 = [NSArray arrayWithObjects:page,[NSString stringWithFormat:@"%d", [PBUserModel getUserId]],nil];
    NSArray* arr2 = [NSArray arrayWithObjects:@"pageno", @"userno",nil];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
    [manager1 getXMLDataFromUrl:kNEWSURLSTRING postValuesAndKeys:dic];
    [dic release];
}

//成功获取xml数据
- (void) sucessParseXMLData:(PBWeiboDataConnect *)weiboDatas
{
    [pullController successGetXmlData:pullController withData:manager1.parseData withNumber:10];
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
        cell.financenameLabel.text = [dic objectForKey:@"fromname"];
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
    AskSquareCell *cell = (AskSquareCell*)[tableView cellForRowAtIndexPath:indexPath];
    PBFinancePolicyDetailView *controller = [[PBFinancePolicyDetailView alloc] initWithNibName:isPad()?@"PBFinancePolicyDetailView_ipad":@"PBFinancePolicyDetailView" bundle:nil];
    NSMutableDictionary* dic = [pullController.allData objectAtIndex:indexPath.row];
    [dic setObject:[dic objectForKey:@"fromname"] forKey:@"financename"];
    controller.remarktype = @"2";
    controller.dataDic = dic;
    controller.image = cell.policyImageView.imageView.image;
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
    [self setManager1:nil];
    [self setManager2:nil];
    [self setPullController:nil];
    [super viewDidUnload];
}

- (void) dealloc {
    [manager1       release];
    [manager2       release];
    [pullController release];
    [sortImageName  release];
    [tradeImageName release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
