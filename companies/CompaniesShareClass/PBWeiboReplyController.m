//
//  PBWeiboReplyController.m
//  ParkBusiness
//
//  Created by QDS on 13-5-23.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBWeiboReplyController.h"
#import "ReviewCell.h"

#define kURLSTRING [NSString stringWithFormat:@"%@admin/index/searchweibodynamic", HOST]

@interface PBWeiboReplyController ()

@end

@implementation PBWeiboReplyController
@synthesize userNoString, manager, pullController;

static CGFloat labelHeight = 21.0;


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

//根据设备的不同得到不同的字体大小
- (UIFont *) getTextFont
{
    return [UIFont systemFontOfSize:(isPad() ? PadContentFontSize : ContentFontSize)];
}

//返回label自适应后的高度
- (CGFloat) getAdaptLabelHeight:(NSString *) str :(CGFloat) width
{
    CGFloat height = 21.0f;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    label.numberOfLines = 0;
    CGSize labelSize = [str sizeWithFont:[self getTextFont] constrainedToSize:CGSizeMake(width, 2000) lineBreakMode:UILineBreakModeCharacterWrap];
    height = MAX(21.0, labelSize.height) ;
    return  height;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGFloat viewWidth = isPad() ? 768 : 320;
    CGFloat viewHeight = (isPad() ? 1024 : (isPhone5() ? 568 :480)) - KTabBarHeight - KNavigationBarHeight;
    //下拉显示
    pullController = [[PBPullTableViewController alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    pullController.delegate =self;
    pullController.tableViews.delegate = self;
    pullController.tableViews.dataSource = self;
    [self.view addSubview:pullController.tableViews];
    [self.view addSubview:pullController.indicator];
    manager.acIndicator = pullController.indicator;
    
    self.title = @"全部微博";
    manager = [[PBManager alloc] init];
    manager.delegate = self;
    
    [self requestData:@"1"];
}

- (void) requestData:(NSString *)pageno
{
    [pullController.indicator startAnimating];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:pageno, @"pageno", userNoString, @"userno", nil];
    [manager requestBackgroundXMLData:kURLSTRING forValueAndKey:dic];
}

- (void) sucessParseXMLData
{
    [pullController successGetXmlData:pullController withData:manager.parseData withNumber:10];
}

#pragma mark -
#pragma mark TavleViewDataSourceMethod
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [pullController.allData count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *EntrepreneursCell = @"ReviewCell";
    static BOOL nibsRegisted = NO;
    ReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:EntrepreneursCell];
    if (cell == nil) {
        nibsRegisted = NO;
    }
    
    if (!nibsRegisted) {
        NSString *nibName = isPad() ? @"ReviewCell_iPad" : @"ReviewCell";
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:EntrepreneursCell];
        nibsRegisted = YES;
    }
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:EntrepreneursCell];
    }
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    [imageView setImage:[[UIImage imageNamed:@"fillcell.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
    cell.backgroundView = imageView;
    [imageView release];
    
    if ([pullController.allData count] > 0) {
        NSDictionary *arrToDic = [pullController.allData objectAtIndex:indexPath.row];
        NSString *content = [arrToDic objectForKey:@"content"];
        CGFloat originX = isPad() ? 35 : 10;
        CGFloat width = isPad() ? 700 :300;
        labelHeight =  [self getAdaptLabelHeight:content :width];
        cell.reviewContentLabel.frame = CGRectMake(originX, 9, width, labelHeight);
        cell.reviewContentLabel.numberOfLines = 0;
        cell.reviewContentLabel.text = content;
        cell.reviewTimeLabel.frame = CGRectMake(originX, 16 + labelHeight, width, 21);
        cell.reviewTimeLabel.text = [arrToDic objectForKey:@"cdates"];
    }
    return cell;
}

#pragma mark -
#pragma mark TavleViewDelegateMethod
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *content = [[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"content"];
    return 39 + [self getAdaptLabelHeight:content :(isPad() ? 700 : 300)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload {
    [self setManager:nil];
    [self setPullController:nil];
    [self setUserNoString:nil];
    [super viewDidUnload];
}

- (void) dealloc {
    [manager release];
    [pullController release];
    [userNoString release];
    [super dealloc];
}

@end
