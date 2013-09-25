    //
    //  PBSearchProjectsViewCOntroller.m
    //  ParkBusiness
    //
    //  Created by  on 13-4-19.
    //  Copyright (c) 2013年 wangzhigang. All rights reserved.
    //

#import "PBSearchsProjectsViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "CommonCell.h"


#define SEARCH_PROJECTS_URL [NSString stringWithFormat:@"%@admin/index/projectlist",HOST]

@implementation PBSearchsProjectsViewController
@synthesize searchBar;
@synthesize parkManager;
@synthesize pullController;
@synthesize str;
@synthesize projectinfonoStr;
@synthesize projectname;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(6, 6, 25, 30);
        [btn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(popBackgoView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = backBarBtn;
        [backBarBtn release];
    }
    return self;
}

-(void)popBackgoView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)finishBtn
{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"nav_btn_wc", nil)style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];
    
}

-(void)finish
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    
}

    //解码字符串
- (NSString *)decodeFromPercentEscapeString:(NSString *)string {
    NSMutableString* outputStr = [NSMutableString stringWithString:string];
    [outputStr replaceOccurrencesOfString:@"+" withString:@" " options:NSLiteralSearch range:NSMakeRange(0,outputStr.length)];
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
}

-(void)serachBar
{
    if (isPad()) {
        self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 768.0f, 44.0f)] autorelease];
        
    }else{
        self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)] autorelease];
    }
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.searchBar.keyboardType = UIKeyboardTypeDefault;
    self.searchBar.backgroundColor=[UIColor clearColor];
    self.searchBar.translucent=YES;
	self.searchBar.placeholder=@"请输入项目名称";
	self.searchBar.delegate = self;
	self.searchBar.barStyle=UIBarStyleDefault;
    [self.view addSubview:self.searchBar];
    
    [[[self.searchBar subviews] objectAtIndex:0] removeFromSuperview];  
    UIImage *img = [[UIImage imageNamed:@"sousuolan.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];  
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];  
    imgView.frame= self.searchBar.frame;  
    [self.searchBar insertSubview:imgView atIndex:0]; 
    
}

    //自定义UITableView
- (void)tableViewInit {
    
    CGFloat viewWidth = isPad() ? 768 : 320;
    CGFloat viewHeight = (isPad() ? 1024 : (isPhone5() ? 568 :480)) - KTabBarHeight - KNavigationBarHeight - 44.0f;
    pullController = [[PBPullTableViewController alloc]initWithFrame:CGRectMake(0.0f, 44.0f, viewWidth, viewHeight)];
        
    pullController.delegate =self;
    pullController.tableViews.delegate = self;
    pullController.tableViews.dataSource = self;
    
  	pullController.tableViews.backgroundColor=[UIColor clearColor];
	[self.view addSubview:pullController.tableViews];
}

-(void)requestData:(NSString *)pageno
{
    if ([pageno isEqualToString:@"1"]) {
        [pullController.allData removeAllObjects];
    }
    [pullController.indicator startAnimating];
    parkManager = [[PBParkManager alloc] init];
    parkManager.delegate = self;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:pageno, @"pageno",searchBar.text, @"search",nil];
    [parkManager getRequestData:SEARCH_PROJECTS_URL forValueAndKey:dic];
    [dic release];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self finishBtn];
    [self tableViewInit];
    [self serachBar];
    self.title = @"选择项目";
//    indicator = [[PBActivityIndicatorView alloc]initWithFrame:isPad()?CGRectMake(0, 0, 768, 1024+49) : CGRectMake(0, 0, 320, 480-KTabBarHeight-KNavigationBarHeight)];
//    [self.view addSubview:indicator];
    [self.view addSubview:pullController.indicator];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

    //实现下拉更新操作
-(void)getDataSource:(EGORefreshTableHeaderView *)view{
    [self requestData:@"1"];
}
    //点击查看更多按钮
-(void)getMoreButtonDidPush:(EGORefreshTableHeaderView *)view{
    [self requestData:[NSString stringWithFormat:@"%d",pullController.pageno]];
}

    //拖动时调用方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[pullController._refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [searchBar resignFirstResponder];
}
    //完成拖动时调用方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[pullController._refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


-(void)keyboardDown
{
        //我添加的代码，此代码可以让keyboard消失
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [searchBar resignFirstResponder];
}

#pragma mark-
#pragma mark-   PBParkManagerDelegate
-(void)refreshData
{
    [pullController.indicator stopAnimating];
    nodesMutableArr = [[NSArray arrayWithArray:parkManager.itemNodes] retain];
    [pullController successGetXmlData:pullController withData:nodesMutableArr withNumber:10];
    
}

#pragma mark-
#pragma mark-   UITableViewDataSource

    //返回多少行
- (NSInteger)tableView:(UITableView *)tableView_ numberOfRowsInSection:(NSInteger)section
{
    return [pullController.allData count];
    
}

    //单元格重用(用的cell是自己定制的)
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CommonCellIdentifier";
    //cell不能为空
    static BOOL nibsRegisted = NO;
    CommonCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        nibsRegisted = NO;
    }
    if (!nibsRegisted) {
        NSString *nibName = isPad() ? @"CommonCell_iPad" : @"CommonCell";
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:identifier];
        nibsRegisted = YES;
    }
    if (cell==nil) {
        cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
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
    if (indexPath.row == oldIndexpath.row && oldIndexpath != nil) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int oldRow = (oldIndexpath == nil)?-1:oldIndexpath.row;
    int currentRow = indexPath.row;
    if (currentRow != oldRow) {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexpath]; 
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        oldIndexpath = [indexPath retain];
    }
    str = [[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"userno"];
    projectinfonoStr = [[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"no"];
    projectname = [[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"proname"];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1
{
    [pullController.indicator startAnimating];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:searchBar.text, @"search", @"1", @"pageno", nil];
    parkManager = [[PBParkManager alloc] init];
    parkManager.delegate = self;
    [pullController.allData removeAllObjects];
    [parkManager getRequestData:SEARCH_PROJECTS_URL forValueAndKey:dic];
    [dic release];
    
    [searchBar resignFirstResponder];
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
        //搜索条输入文字修改时触发
    if([searchText length]==0)
        {
            //如果无文字输入
        [pullController.allData removeAllObjects];
        [pullController.tableViews reloadData];
        return;
        }

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
