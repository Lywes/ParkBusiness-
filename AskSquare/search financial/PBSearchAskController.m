//
//  PBSearchAskController.m
//  ParkBusiness
//
//  Created by QDS on 13-5-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBSearchAskController.h"
#import "QuestionListCell.h"
#import "PBQuestionDetailController.h"
#define kURLSTRING [NSString stringWithFormat:@"%@admin/index/searchquestioninfobyno", HOST]

@interface PBSearchAskController ()

@end

@implementation PBSearchAskController
@synthesize manager;
@synthesize _searchBar;
@synthesize pullController;

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
	[_searchBar resignFirstResponder];
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
    // Do any additional setup after loading the view from its nib.
    _searchBar=[[UISearchBar alloc] init];
    _searchBar.frame=CGRectMake(0, 0, self.view.bounds.size.width, 40);
    _searchBar.delegate=self;
    [_searchBar sizeToFit];
    _searchBar.placeholder = @"首字符匹配搜索";
    _searchBar.backgroundColor=[UIColor clearColor];
    [[_searchBar.subviews objectAtIndex:0]removeFromSuperview];
    for (UIView *subview in _searchBar.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
            break;
        }
    }
    [self.view addSubview:_searchBar];
    
    CGFloat viewWidth = isPad() ? 768 : 320;
    CGFloat viewHeight = (isPad() ? 1024 : (isPhone5() ? 568 :480)) - KTabBarHeight - KNavigationBarHeight;
    
    //下拉显示
    pullController = [[PBPullTableViewController alloc]initWithFrame:CGRectMake(0, 44, viewWidth, viewHeight - 40)];
    pullController.delegate =self;
    pullController.tableViews.delegate = self;
    pullController.tableViews.dataSource = self;
    [self.view addSubview:pullController.tableViews];
    [self.view addSubview:pullController.indicator];
    
    self.title = @"搜索";
    manager = [[PBManager alloc] init];
    manager.delegate = self;
    manager.acIndicator = pullController.indicator;
    
//    [self requestData:@"1"];
}

#pragma mark -
#pragma mark ParseDataDelegateMethod
- (void) sucessParseXMLData
{
    [pullController successGetXmlData:pullController withData:manager.parseData withNumber:10];
}

#pragma mark -
#pragma mark UISearchBarDelegateMethod
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [pullController.allData removeAllObjects];
    [searchBar resignFirstResponder];
    [self requestData:@"1"];
}

- (void) requestData: (NSString *) pageno
{    
    [pullController.indicator startAnimating];
    NSDictionary *searchDic = [NSDictionary dictionaryWithObjectsAndKeys:pageno, @"pageno", _searchBar.text, @"content", nil];
    [manager requestBackgroundXMLData:kURLSTRING forValueAndKey:searchDic];
}

#pragma mark -
#pragma mark TabelViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [pullController.allData count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"QuestionListCell";
    //cell不能为空
    static BOOL nibsRegisted = NO;
    QuestionListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        nibsRegisted = NO;
    }
    
    if (!nibsRegisted) {
        NSString *nibName = isPad() ? @"QuestionListCell_iPad" : @"QuestionListCell";
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        nibsRegisted = YES;
    }
    if (cell==nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    } else {
        [cell.questionLogoImageView removeFromSuperview];
    }
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    [imageView setImage:[[UIImage imageNamed:@"fillcell.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
    cell.backgroundView = imageView;
    [imageView release];
    
    if([pullController.allData count]>0) {
        NSDictionary *dic = [pullController.allData objectAtIndex:indexPath.row];
        cell.questionAskNameLabel.text = [dic objectForKey:@"userno"];
        
        //问题的LOGO已固定从。。以后更改
        NSString *logoURLStr = [NSString stringWithFormat:@"%@upd/usermasterimage/default.jpg", HOST];
        CGFloat originX = isPad() ? 10 : 1;
        cell.questionLogoImageView = [[CustomImageView alloc]initWithFrame:CGRectMake(originX, 1, 64, 64)];
        [[cell contentView] addSubview:cell.questionLogoImageView];
        [cell.questionLogoImageView.imageView loadImage: logoURLStr];
        cell.questionTimeLabel.text = [dic objectForKey:@"cdate"];
        //这里显示职务
        cell.questionLabel.text = [dic objectForKey:@"question"];
    }
    return cell;
}


#pragma mark -
#pragma mark TableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PBQuestionDetailController *controller = [[PBQuestionDetailController alloc] init];
    controller.noString = [[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"no"];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)dealloc {
    [pullController release];
    [manager release];
    [_searchBar release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setManager:nil];
    [self setPullController:nil];
    [self set_searchBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
