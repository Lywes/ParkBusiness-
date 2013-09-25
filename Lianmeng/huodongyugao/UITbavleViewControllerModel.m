//
//  UITbavleViewControllerModel.m
//  PBBank
//
//  Created by lywes lee on 13-5-7.
//  Copyright (c) 2013年 shanghai. All rights reserved.
//

#import "UITbavleViewControllerModel.h"
#import "Reachability.h"

@interface UITbavleViewControllerModel ()

@end

@implementation UITbavleViewControllerModel
@synthesize headArr;
@synthesize DataArr;
@synthesize dataclass;
@synthesize stylename;
@synthesize activity;
@synthesize DataDic;
@synthesize refreshHeaderView;
@synthesize reloading;
-(void)editButtonPress:(id)sender{
    
}
//右导航键（官方样式）
-(void)navigatorRightButtonType:(RIGHTNAVBUTTON)type
{
    if (type == BAOMING) {
        UIBarButtonItem *rightbutton = [[[UIBarButtonItem alloc]initWithTitle:@"报名" style:UIBarButtonItemStylePlain target:self action:@selector(NvBtnPress:)]autorelease];
        self.navigationItem.rightBarButtonItem = rightbutton;
        rightbutton.tag = BAOMING+1000;
    }
    if (type == FASONG) {
        UIBarButtonItem *rightbutton = [[[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(NvBtnPress:)]autorelease];
        self.navigationItem.rightBarButtonItem = rightbutton;
        rightbutton.tag = FASONG+1000;
    }
    if (type == WANCHENG) {
        UIBarButtonItem *rightbutton = [[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_wc", nil) style:UIBarButtonItemStylePlain target:self action:@selector(NvBtnPress:)]autorelease];
        self.navigationItem.rightBarButtonItem = rightbutton;
        rightbutton.tag = WANCHENG+1000;
    }
}
-(void)NvBtnPress:(id)sender
{
    
}
-(void)navigatorRightButtonNme:(NSString *)name backimageName:(NSString *)imagename
{
    UIImage *image;
    UIButton *button;
    if (imagename) {
        image = [UIImage imageNamed:imagename];
        button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    }
    else
    {
        button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 50)];
    }
    [button addTarget:self action:@selector(rightBarButtonItemPress:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:name forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:10];
    UIBarButtonItem *rightbutton = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightbutton;
}
-(void)rightBarButtonItemPress:(id)sender
{
    
}
//返回按钮
-(void)backUpView
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topnavigation.png"] forBarMetrics:UIBarMetricsDefault];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(7, 7, 25, 30);
    [btn addTarget:self action:@selector(backHomeView) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barButton;
}

- (void) backHomeView {
    [self.navigationController popViewControllerAnimated:YES];
}
//cell上添加较短的按钮
-(UILabel *)addshortLable
{
    CGRect size;
    CGFloat font;
    if (isPad()) {
        size = CGRectMake(250, 0, 250, 44);
        font = PadContentFontSize;
    }
    else {
        size = CGRectMake(100, 0, 150, 44);
        font = ContentFontSize;
    }
    
    UILabel *lable = [[[UILabel alloc]initWithFrame:size]autorelease];
    lable.font = [UIFont systemFontOfSize:font];
    lable.backgroundColor = [UIColor clearColor];
    lable.lineBreakMode = UILineBreakModeMiddleTruncation;
    lable.numberOfLines = 3;
    return lable;
}
//cell上添加较长的按钮
-(UILabel *)addLongLable
{
    CGRect size;
    CGFloat font;
    if (isPad()) {
        size = CGRectMake(10, 0, 679, 44);
        font = PadContentFontSize;
    }
    else {
        size = CGRectMake(5, 0, 300, 44);
        font = ContentFontSize;
    }
    
    UILabel *lable = [[[UILabel alloc]initWithFrame:size]autorelease];
    lable.font = [UIFont systemFontOfSize:15];
    lable.backgroundColor = [UIColor clearColor];
    return lable;
}
//添加textfield
-(UITextField *)addtextfield
{
    UITextField *textField = [[UITextField alloc]init];
    CGFloat size;
    if (isPad()) {
        size = PadContentFontSize;
    }
    else {
        size = ContentFontSize;
    }
    textField.font = [UIFont systemFontOfSize:size];
    textField.textAlignment = UITextAlignmentLeft;
    textField.contentVerticalAlignment  = UIControlContentVerticalAlignmentCenter;
    textField.backgroundColor = [UIColor clearColor];
    
    textField.delegate = self;
    return textField;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location > 10) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}
//添加textview
-(UITextView *)addtextview
{
    UITextView *textview;
    if (isPad()) {
        textview = [[[UITextView alloc]initWithFrame:CGRectMake(0, 0, 679, 120)]autorelease];
        
    }
    else {

        textview = [[[UITextView alloc]initWithFrame:CGRectMake(0, 0, 300, 44)]autorelease];
    }
    CGFloat size;
    if (isPad()) {
        size = PadContentFontSize;
    }
    else {
        size = ContentFontSize;
    }
    textview.font = [UIFont systemFontOfSize:size];
    textview.textAlignment = UITextAlignmentLeft;
    textview.backgroundColor = [UIColor clearColor];
    [textview setEditable:NO];
    
    textview.delegate = self;
    return textview;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

//提示框;
-(void)showAlertViewWithMessage:(NSString *)message
{
    UIAlertView *view = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [view show];
    [view release];

}

//判断什么网络并且加载网络或者下载。
-(void)ExitenceNetwork:(NSString *)urlstr
{
    Reachability *r = [Reachability reachabilityWithHostName:urlstr];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            NSLog(@"没有网络");
            [self showAlertViewWithMessage:@"网络连接错误"];
            break;
        case ReachableViaWWAN:
            NSLog(@"正在使用3G网络");
             [self showAlertViewWithMessage:@"正在使用GPRS/3G网络,下载会产生很多的流量。\n你确定要下载？"];
            break;
        case ReachableViaWiFi:
            NSLog(@"正在使用wifi网络");
            break;
    }
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    return cell;
}
- (void)initRefreshView
{
    if(self.refreshHeaderView == nil)
    {
        PBRefreshTableHeaderView *view = [[PBRefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.tableView.frame.size.width, self.tableView.bounds.size.height)];
        
        view.delegate = self;
        [self.tableView addSubview:view];
        self.refreshHeaderView = view;
        [view release];
    }
    [self.refreshHeaderView refreshLastUpdatedDate];
}
-(void)reloadTableViewDataSource
{
    NSLog(@"==开始加载数据");
    self.reloading = YES;
    [self begainreloadTableViewDataSource];
    
}
- (void)doneLoadingTableViewData{
    
    NSLog(@"===加载完数据");
    [self finishdoneLoadingTableViewData];
    self.reloading  = NO;
    [self.refreshHeaderView egoRefreshScrollViewDoneLoadingTableViewData:self.tableView];
}
- (void)begainreloadTableViewDataSource
{
    
}
- (void)finishdoneLoadingTableViewData
{
    
}
#pragma mark –
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark –
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(PBRefreshTableHeaderView*)view{
    
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
    
    
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(PBRefreshTableHeaderView*)view{
    
    return self.reloading; // should return if data source model is reloading
    
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(PBRefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
-(void)dealloc
{
    RB_SAFE_RELEASE(dataclass);
    RB_SAFE_RELEASE(DataArr);
    RB_SAFE_RELEASE(headArr);
    [super dealloc];
}
@end
