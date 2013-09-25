//
//  PBParkQAViewController.m
//  ParkBusiness
//
//  Created by  on 13-3-4.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBParkQAViewController.h"
#import "PBDetailQAViewController.h"
#import "PBParkQACell.h"
#import "EGORefreshTableHeaderView.h"
#import "PBUserModel.h"

#define kSCNavBarImageTag                   10
#define PARK_QA_URL [NSString stringWithFormat:@"%@admin/index/searchquestion",HOST]
#define INSERT_QUESTION_URL [NSString stringWithFormat:@"%@admin/index/insertquestion",HOST]


@implementation PBParkQAViewController
@synthesize parkNoString;
@synthesize parkManager;
@synthesize searchBar1;
@synthesize inputToolbar;
@synthesize questionStr;

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

- (void)didReceiveMemoryWarning
{
 
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.inputToolbar addObserverFromController:self];
}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [self.inputToolbar removeObserverFromController:self];
}
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [self.inputToolbar keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [self.inputToolbar keyboardWillShowHide:notification];
    [self.inputToolbar keyboardWillHide];
}
    //自定义UITableView
- (void)tableViewInit {
    CGFloat viewWidth = isPad() ? 768 : 320;
    CGFloat viewHeight = (isPad() ? 1024 : (isPhone5() ? 568 :480)) - KTabBarHeight - KNavigationBarHeight;
    
        //下拉显示
    pullController = [[PBPullTableViewController alloc]initWithFrame:CGRectMake(0, 44, viewWidth, viewHeight - 44)];
    pullController.delegate =self;
    pullController.tableViews.delegate = self;
    pullController.tableViews.dataSource = self;
	pullController.tableViews.backgroundColor=[UIColor clearColor];
	[self.view addSubview:pullController.tableViews];
}

    //自定义UISearchBar
- (void)searchBarInit {
   
    if (isPad()) {
       self.searchBar1 = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 768.0f, 44.0f)] autorelease];
        
    }else{
         self.searchBar1 = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)] autorelease];
    }
    self.searchBar1.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchBar1.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.searchBar1.keyboardType = UIKeyboardTypeDefault;
	self.searchBar1.backgroundColor=[UIColor clearColor];
	searchBar1.translucent=YES;
	self.searchBar1.placeholder=@"搜索";
	self.searchBar1.delegate = self;
	self.searchBar1.barStyle=UIBarStyleDefault;
    [self.view addSubview:searchBar1];
    
    [[[searchBar1 subviews] objectAtIndex:0] removeFromSuperview];  
    UIImage *img = [[UIImage imageNamed:@"sousuolan.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];  
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];  
    imgView.frame= searchBar1.frame;  
    [searchBar1 insertSubview:imgView atIndex:0]; 
   
}

-(void)navigationBarBackgroundImage
{
    UINavigationBar *navBar = self.navigationController.navigationBar;  
    
    
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])  
        {  
                //if iOS 5.0 and later  
            [navBar setBackgroundImage:[UIImage imageNamed:@"topnavigation.png"] forBarMetrics:UIBarMetricsDefault];  
        }  
    else  
        {  
            UIImageView *imageView = (UIImageView *)[navBar viewWithTag:kSCNavBarImageTag];  
            if (imageView == nil)  
                {  
                    imageView = [[UIImageView alloc] initWithImage:  
                                 [UIImage imageNamed:@"topnavigation.png"]];  
                    [imageView setTag:kSCNavBarImageTag];  
                    [navBar insertSubview:imageView atIndex:0];  
                    [imageView release];  
                }  
        }  
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"园区问答";
    
    [self navigationBarBackgroundImage];
    
    parkNoString = (parkNoString.length == 0) ? [NSString stringWithFormat:@"%d",[PBUserModel getParkNo]] : parkNoString;
        
    [self rightBarButton];
    [self tableViewInit];
    [self searchBarInit];
    [self keyboardDown];
    self.inputToolbar = [[UIInputToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40)];
    inputToolbar.delegate = self;
    inputToolbar.textView.placeholder = @"请输入提问";
    [self.view addSubview:self.inputToolbar];
    [self.view addSubview:pullController.indicator]; 
    [self requestData:@"1"];
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
}
    //完成拖动时调用方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[pullController._refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}



-(void)requestData:(NSString *)value
{
    if ([value isEqualToString:@"1"]) {
        [pullController.allData removeAllObjects];
    }
    [pullController.indicator startAnimating];
    parkManager = [[PBParkManager alloc] init];
    parkManager.delegate = self;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:parkNoString, @"parkno", value, @"pageno",nil];
    [parkManager getRequestData:PARK_QA_URL forValueAndKey:dic];
    [dic release];
    
}

    //此代码可以让keyboard消失
-(void)keyboardDown
{
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [searchBar1 resignFirstResponder];
   
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self.inputToolbar removeObserverFromController:self];
    return YES;
}
-(void)rightBarButton
{

    UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"nav_btn_tw", nil) style:UIBarButtonItemStylePlain target:self action:@selector(questionView:)];
    self.navigationItem.rightBarButtonItem = rightbtn;
    [rightbtn release];

}

#pragma mark-
#pragma mark-   PBParkManagerDelegate

-(void)refreshData
{
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

    //单元格重用
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static BOOL nibsRegisted = NO;
    static NSString *identifier = @"CellIdentifier";
    
    PBParkQACell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        nibsRegisted = NO;
    }
    if (!nibsRegisted) {
        NSString *nibName = isPad() ? @"PBIpadParkQACell" : @"PBParkQACell";
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:identifier];
        nibsRegisted = YES;
    }
    if (cell==nil) {
        cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    
    }
    cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;    

    if([pullController.allData count]>0){
        [pullController customLabelFontWithView:cell.labelView2];
        [pullController customLabelFontWithView:cell.labelView];
        cell.labelView2.text = [[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"question"];
        cell.labelView.text = [[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"myname"];
        cell.imageView.image = [UIImage imageNamed:@"QACell.png"];
    }
    
    return cell;
    
}

    //进入提问页面
- (void)questionView:(id)sender
{
    [self.inputToolbar addObserverFromController:self];
    [self.inputToolbar.textView becomeFirstResponder];
}

-(void)inputButtonPressed:(NSString *)inputText
{
    [pullController.allData removeAllObjects];
    
    NSArray *arr1 = [NSArray arrayWithObjects:parkNoString,inputText,USERNO, nil];
    NSArray *arr2 = [NSArray arrayWithObjects:@"parkno",@"question", @"personno",nil];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
    [parkManager submitDataFromUrl:INSERT_QUESTION_URL postValuesAndKeys:dic];
}

-(void)sucessSendPostData:(NSObject *)Data{
    [self requestData:@"1"];
    [pullController.tableViews reloadData];
   
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:searchBar1.text, @"searchstr", @"1", @"pageno",parkNoString, @"parkno", nil];
    parkManager = [[PBParkManager alloc] init];
    parkManager.delegate = self;
    [pullController.allData removeAllObjects];
    [parkManager getRequestData:PARK_QA_URL forValueAndKey:dic];
    [dic release];
    [searchBar1 resignFirstResponder];
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
        //搜索条输入文字修改时触发
    if([searchText length]==0)
        {
        //如果无文字输入,刷新表
        [self requestData:@"1"];
        return;
        }
    
}

    //进入问题详细页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!detailQAVC) {
        detailQAVC = [[PBDetailQAViewController alloc] init];
    }
    
    detailQAVC.data = [pullController.allData objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailQAVC animated:YES];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidUnload
{
    [self setParkNoString:nil];
    [super viewDidUnload];
}

- (void) dealloc {
    [parkNoString release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
