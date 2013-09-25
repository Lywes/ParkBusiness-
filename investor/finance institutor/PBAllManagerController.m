//
//  PBAllManagerController.m
//  ParkBusiness
//
//  Created by QDS on 13-5-24.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBAllManagerController.h"
#import "InvestorCell.h"
#import "PBManagerDetailInfoController.h"

#define kURLSTRING [NSString stringWithFormat:@"%@admin/index/searchallhandles", HOST]

@interface PBAllManagerController ()

@end

@implementation PBAllManagerController
@synthesize fnoString, manager, pullController;

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

- (void) popPreView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"全部经理人";
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat viewWidth = isPad() ? 768 : 320;
    CGFloat viewHeight = (isPad() ? 1024 : (isPhone5() ? 568 :480)) - KTabBarHeight - KNavigationBarHeight;
    
    pullController = [[PBPullTableViewController alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    pullController.delegate =self;
    pullController.tableViews.delegate = self;
    pullController.tableViews.dataSource = self;
    [self.view addSubview:pullController.tableViews];
    [self.view addSubview:pullController.indicator];
    manager.acIndicator = pullController.indicator;

    manager = [[PBManager alloc] init];
    manager.delegate = self;
    [self requestData:@"1"];
}

- (void) requestData:(NSString*)page
{
    [pullController.indicator startAnimating];
    NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:page, @"pageno", fnoString, @"fno", nil];
    [manager requestBackgroundXMLData:kURLSTRING forValueAndKey:dataDic];
}

#pragma mark -
#pragma mark ParseDataDelegateMethod
- (void) sucessParseXMLData {
    [pullController successGetXmlData:pullController withData:manager.parseData withNumber:20];
}

#pragma mark -
#pragma mark TableViewDataSourse
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [pullController.allData count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
        cell.customCellBossName.text = [dic objectForKey:@"name"];
        //加载boss头像应该用异步方式
        NSString *bossPhotoURLStr = [NSString stringWithFormat:@"%@%@", HOST, [dic objectForKey:@"imagepath"]];
        CGFloat originX = isPad() ? 10 : 3;
        cell.customCellBossPhoto = [[CustomImageView alloc]initWithFrame:CGRectMake(originX, 6, 76, 76)];
        [[cell contentView] addSubview:cell.customCellBossPhoto];
        [cell.customCellBossPhoto.imageView loadImage: bossPhotoURLStr];
        cell.jobOrCategoryImageView.image = [UIImage imageNamed:@"companyjob.png"];
        cell.customCellSImpleIntroduce.text = [dic objectForKey:@"signature"];
        cell.customCellLastRegistTime.text = [dic objectForKey:@"logintime"];
        //这里显示职务
        cell.customCellCompanyType.text = [dic objectForKey:@"companyjob"];
    }
    return cell;
}


#pragma mark -
#pragma mark TableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PBManagerDetailInfoController *controller = [[PBManagerDetailInfoController alloc] init];
    controller.dataDictionary = [pullController.allData objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload {
    [self setManager:nil];
    [self setPullController:nil];
    [self setFnoString:nil];
    [super viewDidUnload];
}

- (void) dealloc {
    [manager release];
    [pullController release];
    [fnoString release];
    [super dealloc];
}

@end
