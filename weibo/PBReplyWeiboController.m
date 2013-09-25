//
//  PBReplyWeiboController.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-15.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBReplyWeiboController.h"
#import "PBWeiboCell.h"
#define URL [NSString stringWithFormat:@"%@/admin/index/searchtweibodetail",HOST]
#define REPLYURL [NSString stringWithFormat:@"%@/admin/index/replytweibo",HOST]
#define RECORDURL [NSString stringWithFormat:@"%@/admin/index/updaterecord",HOST]
@interface PBReplyWeiboController ()

@end

@implementation PBReplyWeiboController
@synthesize data,inputToolbar;
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        UIBarButtonItem* rightbtn = [[UIBarButtonItem alloc]initWithTitle:@"回复" style:UIBarButtonItemStylePlain target:self action:@selector(replyWeibo)];
        self.navigationItem.rightBarButtonItem = rightbtn;
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    [weiboData release];
    [pullController release];
    [titleView release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    niceFlg = NO;
    badFlg = NO;
    titleView = [[PBWeiboTitleView alloc]initWithFrame:CGRectMake(0, 0, 320, 120)];
    [self.view addSubview:titleView];
    weiboData = [[PBWeiboDataConnect alloc]init];
    weiboData.delegate = self;
    CGFloat height = self.view.frame.size.height-KNavigationBarHeight-KTabBarHeight-titleView.frame.size.height;
    //下拉显示
    pullController = [[PBPullTableViewController alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
    [pullController customButtomItem:self];//设置返回按钮
    pullController.delegate =self;
    pullController.tableViews.delegate = self;
    pullController.tableViews.dataSource = self;
    weiboData.indicator = pullController.indicator;
    [self.view addSubview:pullController.tableViews];
    self.inputToolbar = [[UIInputToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40)];
    [self.view addSubview:self.inputToolbar];
    inputToolbar.delegate = self;
    inputToolbar.textView.placeholder = @"请输入回复";
    [self setTitleView];
    [self.view addSubview:pullController.indicator];
    [pullController.indicator startAnimating];
    [self getXmlData:@"1"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.inputToolbar addObserverFromController:self];
    
}
-(void)setTitleView{
    NSString* content = [weiboData decodeFromPercentEscapeString:[self.data objectForKey:@"content"]];
    CGFloat height = [pullController tableView:pullController.tableViews heightForRow:content defaultHeight:60];
    //布局
    [titleView.imageView removeFromSuperview];
    titleView.customlb1.frame = CGRectMake(20,10,pullController.tableViews.frame.size.width-40,height);
    titleView.customlb2.frame = CGRectMake(70,height+12,20,20);
    titleView.customlb3.frame = CGRectMake(self.view.frame.size.width-80,height+12,20,20);
    titleView.custombtn1.frame = CGRectMake(30,height+10,30,30);
    titleView.custombtn2.frame = CGRectMake(self.view.frame.size.width-120,height+10,30,30);
    //显示
    [pullController customLabelFontWithView:titleView];//设置文字大小
    titleView.customlb1.text = content;//回复数
    titleView.customlb2.text = [self.data objectForKey:@"nice"];
    titleView.customlb3.text = [self.data objectForKey:@"bad"];
    titleView.customlb1.numberOfLines = 0;
    //button设置
    [titleView.custombtn1 addTarget:self action:@selector(niceWeibo:) forControlEvents:UIControlEventTouchUpInside];
    if([[self.data objectForKey:@"nflag"] isEqualToString:@"1"]){
        titleView.custombtn1.enabled = NO;
    }
    [titleView.custombtn2  addTarget:self action:@selector(badWeibo:) forControlEvents:UIControlEventTouchUpInside];
    if([[self.data objectForKey:@"bflag"] isEqualToString:@"1"]){
        titleView.custombtn2.enabled = NO;
    }
    CGRect frame = titleView.frame;
    frame.size.height = height+40;
    titleView.frame = frame;
    frame = pullController.tableViews.frame;
    frame.origin.y = titleView.frame.size.height;
    height = self.view.frame.size.height-KNavigationBarHeight-KTabBarHeight-titleView.frame.size.height;
    frame.size.height = height;
    pullController.tableViews.frame = frame;
}
-(void)niceWeibo:(id)sender{//点击赞
    UIButton* btn = (UIButton*)sender;
    btn.enabled = NO;
    niceFlg = YES;
    NSArray* arr1 = [NSArray arrayWithObjects:@"1",[self.data objectForKey:@"no"] ,@"1", @"1",nil];
    NSArray* arr2 = [NSArray arrayWithObjects:@"userno",@"no", @"type",@"flag",nil];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
    [weiboData submitDataFromUrl:RECORDURL postValuesAndKeys:dic];
}
-(void)badWeibo:(id)sender{//点击踩
    UIButton* btn = (UIButton*)sender;
    btn.enabled = NO;
    badFlg = YES;
    NSArray* arr1 = [NSArray arrayWithObjects:USERNO,[self.data objectForKey:@"no"],@"1", @"0",nil];
    NSArray* arr2 = [NSArray arrayWithObjects:@"userno",@"no", @"type",@"flag",nil];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
    [weiboData submitDataFromUrl:RECORDURL postValuesAndKeys:dic];
}
-(void)getXmlData:(NSString*)page{
    [pullController.indicator startAnimating];
    if ([page isEqualToString:@"1"]) {
        [pullController.allData removeAllObjects];
    }
    NSArray* arr1 = [NSArray arrayWithObjects:page,[self.data objectForKey:@"no"],nil];
    NSArray* arr2 = [NSArray arrayWithObjects:@"pageno",@"no",nil];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
    [weiboData getXMLDataFromUrl:URL postValuesAndKeys:dic];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	/* No longer listen for keyboard */
    [self.inputToolbar removeObserverFromController:self];
}
//成功获取XML数据
-(void)sucessParseXMLData:(PBWeiboDataConnect *)weiboDatas{
    if([weiboData.parseData count]>0){
        pullController.tableViews.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        pullController.tableViews.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    [pullController successGetXmlData:pullController withData:weiboData.parseData withNumber:10];
}
//成功提交数据
-(void)sucessSendPostData:(PBWeiboDataConnect *)weiboDatas{
    if(niceFlg){
        NSUInteger count = [titleView.customlb2.text intValue];
        titleView.customlb2.text = [NSString stringWithFormat:@"%d",count+1];
        niceFlg = !niceFlg;
    }
    if(badFlg){
        NSUInteger count = [titleView.customlb3.text intValue];
        titleView.customlb3.text = [NSString stringWithFormat:@"%d",count+1];
        badFlg = !badFlg;
    }
    //    if(replyFlg){
    ////        titleView.customlb1.text = content;
    //        replyFlg = !replyFlg;
    //    }
    [self getXmlData:@"1"];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)replyWeibo{//点击回复
    [self.inputToolbar.textView becomeFirstResponder];
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
-(void)inputButtonPressed:(NSString *)inputText//发送回复
{
    /* Called when toolbar button is pressed */
    //NSLog(@"Pressed button with text: '%@'", inputText);
    [pullController.indicator startAnimating];
    NSArray* arr1 = [NSArray arrayWithObjects:USERNO,[self.data objectForKey:@"no"],inputText, nil];
    NSArray* arr2 = [NSArray arrayWithObjects:@"cuserno",@"tcontentno", @"content",nil];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
    [weiboData submitDataFromUrl:REPLYURL postValuesAndKeys:dic];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [pullController.allData count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([pullController.allData count]>0){
        NSString* content = [weiboData decodeFromPercentEscapeString:[[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"content"]];
        return MAX([pullController tableView:tableView heightForRow:content defaultHeight:30]+50, 120);
    }
    return 0;
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row%2==0) {
        cell.backgroundColor = [UIColor colorWithRed:206.0f/255.0f green:206.0f/255.0f blue:206.0f/255.0f alpha:1.0];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    PBWeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [tableView registerNib:[UINib nibWithNibName:@"PBTutorWeiboCell" bundle:nil]forCellReuseIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }else{
        [cell.imageViews removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //初始化cell构造
    
    [cell initCellFrame];
    if([pullController.allData count]>0){
        NSMutableDictionary* dic = [pullController.allData objectAtIndex:indexPath.row];
        NSString* content = [weiboData decodeFromPercentEscapeString:[dic objectForKey:@"content"]];
        CGFloat height = [pullController tableView:tableView heightForRow:content defaultHeight:30];
        //cell布局
        cell.customlabel1.frame = CGRectMake(70,10,60,20);
        cell.customlabel2.frame = CGRectMake(self.view.frame.size.width-100,10,60,20);
        cell.customlabel3.frame = CGRectMake(15, 45, self.view.frame.size.width-50, height);
        cell.customImage1.frame = CGRectMake(50,10,20,20);
        cell.customImage2.frame = CGRectMake(self.view.frame.size.width-120,15,15,15);
        //cell显示
        [pullController customLabelFontWithView:[cell contentView]];//设置文字大小
        cell.customlabel1.text = [weiboData decodeFromPercentEscapeString:[dic objectForKey:@"name"]];//姓名
        cell.customlabel2.text = [dic objectForKey:@"cdate"];//回复时间
        cell.customlabel3.text = content;//回复内容
        cell.customlabel3.numberOfLines = 0;
        [cell.customlabel3 sizeToFit];
        //加载boss头像应该用异步方式
        cell.imageViews = [[CustomImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
        [[cell contentView] addSubview:cell.imageViews];
        NSString *replyURLStr = [NSString stringWithFormat:@"%@%@", HOST, [weiboData decodeFromPercentEscapeString:[dic objectForKey:@"urlimg"]]];
        if([[weiboData decodeFromPercentEscapeString:[dic objectForKey:@"urlimg"]] length]){
            [cell.imageViews.imageView loadImage:replyURLStr];
        }
    }
    
    // Configure the cell...
    
    return cell;
}


//实现下拉更新操作
-(void)getDataSource:(PBRefreshTableHeaderView *)view{
    [self getXmlData:@"1"];
}
//点击查看更多按钮
-(void)getMoreButtonDidPush:(PBRefreshTableHeaderView *)view{
    [self getXmlData:[NSString stringWithFormat:@"%d",pullController.pageno]];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[pullController._refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[pullController._refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
