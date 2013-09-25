//
//  PBInvestorController.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-4.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBInvestorController.h"
#import "PBInvestorDetail.h"
#import "InvestorCell.h"

#define kURLSTRING [NSString stringWithFormat:@"%@admin/index/searchinvestuser", HOST]

@interface PBInvestorController ()
@end

@implementation PBInvestorController
@synthesize parseXMLManager;
@synthesize investorArray;
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
        //设置导航栏中字体的属性
//        [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor yellowColor], UITextAttributeTextColor, [UIFont fontWithName:@"ArialMT/" size:11.0], UITextAttributeFont,nil]];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat viewWidth = isPad() ? 768 : 320;
    CGFloat viewHeight = (isPad() ? 1024 : (isPhone5() ? 568 :480)) - KTabBarHeight - KNavigationBarHeight;

    pullController = [[PBPullTableViewController alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    pullController.delegate =self;
    pullController.tableViews.delegate = self;
    pullController.tableViews.dataSource = self;
    [self.view addSubview:pullController.tableViews];
    [self.view addSubview:pullController.indicator];
    
    self.title = @"推荐投资人";
    parseXMLManager = [[PBManager alloc] init];
    parseXMLManager.delegate = self;
    [self requestData:@"1"];
    
    parseXMLManager.acIndicator = pullController.indicator;
}

- (void) requestData:(NSString*)page
{
    [pullController.indicator startAnimating];
    NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:page, @"pageno", nil];
    [parseXMLManager requestBackgroundXMLData:kURLSTRING forValueAndKey:dataDic];
}

#pragma mark -
#pragma mark ParseDataDelegateMethod
- (void) sucessParseXMLData {
    investorArray = [[NSArray arrayWithArray: parseXMLManager.parseData] retain];
    [pullController successGetXmlData:pullController withData:investorArray withNumber:10];
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
        cell.customCellBossName.text = [dic objectForKey:@"myname"];
        //加载boss头像应该用异步方式
        NSString *bossPhotoURLStr = [NSString stringWithFormat:@"%@%@", HOST, [dic objectForKey:@"imagepath"]];
        CGFloat originX = isPad() ? 10 : 3;
        cell.customCellBossPhoto = [[CustomImageView alloc]initWithFrame:CGRectMake(originX, 6, 76, 76)];
        [[cell contentView] addSubview:cell.customCellBossPhoto];
        [cell.customCellBossPhoto.imageView loadImage: bossPhotoURLStr];
        cell.customCellSImpleIntroduce.text = [dic objectForKey:@"signature"];
        cell.customCellLastRegistTime.text = [dic objectForKey:@"logintime"];
        cell.customCellCompanyType.text = [dic objectForKey:@"investtrade"];
    }
    return cell;
}


#pragma mark -
#pragma mark TableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //当前点击的是那个cell，必须有数据的传递

    send = [[PBSendData alloc] init];
    NSString *userNoStr = [[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"no"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userNoStr, @"userno", [NSString stringWithFormat:@"%d", [PBUserModel getUserId]], @"suserno", nil];
    [send sendDataWithURL:kATTENTIONURLSTRING andValueAndKeyDic:dic];
    
    PBInvestorDetail *detailController = [[PBInvestorDetail alloc] init];
    detailController.investorNo = [[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"no"];
    [self.navigationController pushViewController:detailController animated:YES];
    [detailController release];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload
{
    [self setSend:nil];
    [self setPullController:nil];
    [self setInvestorArray:nil];
    [self setParseXMLManager:nil];
    [super viewDidUnload];
}

- (void)dealloc {
    [send release];
    [pullController release];
    [parseXMLManager release];
    [investorArray release];
    [super dealloc];
}

//尺寸的匹配
//-(void)resizeImage
//{
//    float scaleX = self.frame.size.width/self.image.size.width;
//    float scaleY = self.frame.size.height/self.image.size.height;
//    float scale = MIN(scaleX, scaleY);
//
//    if (scale > 1) {
//        scale = 1.0;
//    }
//    float width = scale*self.image.size.width;
//    float height = scale*self.image.size.height;
//    CGRect frame = CGRectMake(self.frame.origin.x + (self.frame.size.width - width)/2, self.frame.origin.y + (self.frame.size.height - height)/2, width, height);
//    self.frame = frame;
//}
@end