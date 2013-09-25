//
//  PBTutorWeiboController.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-14.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define URL [NSString stringWithFormat:@"%@/admin/index/searchtweibocontent",HOST]
#define REPLYURL [NSString stringWithFormat:@"%@/admin/index/replytweibo",HOST]
#define RECORDURL [NSString stringWithFormat:@"%@/admin/index/updaterecord",HOST]
#define SUBMITURL [NSString stringWithFormat:@"%@/admin/index/inserttweibocontent",HOST]
#import "PBWeiboCell.h"
#import "PBTutorWeiboController.h"
#import "PBReplyWeiboController.h"
#import "PBUserModel.h"
#import "PBFinancInstitutDetailController.h"
#import "PBInvestorDetail.h"
@interface PBTutorWeiboController ()

@end

@implementation PBTutorWeiboController
@synthesize data,inputToolbar,tcontentno,tutorflag,type;
-(void)dealloc{
    [super dealloc];
    [weiboData release];
    [titleView release];
    [popupTextView release];
}
- (id)init
{
    self = [super init];
    if (self) {
        self.data = [[NSMutableDictionary alloc]init];
        
        // Custom initialization
    }
    return self;
}

-(void)writeWeibo{//写微博
    [self.inputToolbar keyboardWillHide];
    btnPressed = !btnPressed;
    if (btnPressed) {//发微博
        //发微博页面
        popupTextView = [[YIPopupTextView alloc] initWithPlaceHolder:@"请输入内容..." maxCount:150];
        popupTextView.delegate = self;
        popupTextView.keyboardAppearance = UIKeyboardAppearanceDefault;
        popupTextView.superview.backgroundColor = [UIColor grayColor];
        [popupTextView showInView:self.view];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(writeWeibo)];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
    }else{//完成发送
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(writeWeibo)];
        [popupTextView resignFirstResponder];
        [pullController.indicator startAnimating];
        NSArray* arr1 = [NSArray arrayWithObjects:[self.data objectForKey:@"no"],popupTextView.text ,nil];
        NSArray* arr2 = [NSArray arrayWithObjects:@"tweibono",@"content",nil];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
        [weiboData submitDataFromUrl:SUBMITURL postValuesAndKeys:dic];
    }
}
-(void)closePopTextView{//点击取消操作
    btnPressed = !btnPressed;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(writeWeibo)];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}
//控制字数
-(void)popupTextView:(YIPopupTextView *)textView didChangeWithText:(NSString *)text{
    if([text length]>0){
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}
//右边导航键
-(void)rightNavBtn
{
    if ([self.type isEqualToString:@"1"]) {
        if ([PBUserModel getUserId]==[[self.data objectForKey:@"cuserno"] intValue]&&[PBUserModel getPasswordAndKind].kind==1) {
            UIBarButtonItem* rightbtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(writeWeibo)];
            self.navigationItem.rightBarButtonItem = rightbtn;
        }else{
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 26)];
            [btn addTarget:self action:@selector(navigationBarPress:) forControlEvents:UIControlEventTouchUpInside];
            [btn setBackgroundImage:[UIImage imageNamed:@"friend.png"] forState:UIControlStateNormal];
            UIBarButtonItem *rightbar = [[UIBarButtonItem alloc]initWithCustomView:btn];
            self.navigationItem.rightBarButtonItem = rightbar;
            [btn release];
            [rightbar release];
        }
    }
    else if ([self.type isEqualToString:@"2"])
    {
        if ([PBUserModel getCompanyno]==[[self.data objectForKey:@"cuserno"] intValue]&&[PBUserModel getPasswordAndKind].kind==3)
        {
            UIBarButtonItem* rightbtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(writeWeibo)];
            self.navigationItem.rightBarButtonItem = rightbtn;
        }else{
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 26)];
            [btn addTarget:self action:@selector(navigationBarPress:) forControlEvents:UIControlEventTouchUpInside];
            [btn setBackgroundImage:[UIImage imageNamed:@"friend.png"] forState:UIControlStateNormal];
            UIBarButtonItem *rightbar = [[UIBarButtonItem alloc]initWithCustomView:btn];
            self.navigationItem.rightBarButtonItem = rightbar;
            [btn release];
            [rightbar release];
        }
    }
}
//右边导航键跳转
-(void)navigationBarPress:(id)sender
{
    if ([self.type isEqualToString:@"1"]) {
        PBInvestorDetail *touziren = [[PBInvestorDetail alloc]init];
        touziren.investorNo = [self.data objectForKey:@"cuserno"];
        [self.navigationController pushViewController:touziren animated:YES];
        [touziren release];
    }
    else
    {
        PBFinancInstitutDetailController *jinrongjigou = [[PBFinancInstitutDetailController alloc]init];
        jinrongjigou.financeno = [self.data objectForKey:@"cuserno"];
        jinrongjigou.dataDictionary = self.data;
        [self.navigationController pushViewController:jinrongjigou animated:YES];
        [jinrongjigou release];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    titleView = [[PBWeiboTitleView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    [self.view addSubview:titleView];
    weiboData = [[PBWeiboDataConnect alloc]init];
    weiboData.delegate = self;
    CGFloat height = self.view.frame.size.height-KNavigationBarHeight-KTabBarHeight-titleView.frame.size.height;
    //下拉显示
    pullController = [[PBPullTableViewController alloc]initWithFrame:CGRectMake(0, titleView.frame.size.height, self.view.frame.size.width, height)];
    pullController.delegate =self;
    pullController.tableViews.delegate = self;
    pullController.tableViews.dataSource = self;
    [pullController customButtomItem:self];//设置返回按钮
    weiboData.indicator = pullController.indicator;
    [self.view addSubview:pullController.tableViews];
    self.inputToolbar = [[UIInputToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40)];
    [self.view addSubview:self.inputToolbar];
    inputToolbar.delegate = self;
    inputToolbar.textView.placeholder = @"请输入回复";
    [self rightNavBtn];
    [self.view addSubview:pullController.indicator];
    [pullController.indicator startAnimating];
    
    //设置顶部视图
    [self setTitleView];
    
}
-(void)editBtn{
    
}
//设置顶部视图
-(void)setTitleView{
    NSString* content = [self.data objectForKey:@"content"];
    CGFloat height = [pullController tableView:pullController.tableViews heightForRow:content defaultHeight:80];
    //布局
    titleView.customlb3.frame = CGRectMake(100,20,self.view.frame.size.width-110,height);
    UIImageView* customimage1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"avatarslogo.png"]];
    UIImageView *customimage2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"trade.png"]];
    [titleView addSubview:customimage1];
    [titleView addSubview:customimage2];
    customimage1.frame = CGRectMake(100,10,20,20);
    customimage2.frame = CGRectMake(self.view.frame.size.width-90,13,15,15);
    //显示
    [pullController customLabelFontWithView:titleView];//设置文字大小
    CGRect frame = titleView.customlb1.frame;
    frame.size.height = 30;
    frame.origin.y -= 5;
    titleView.customlb1.frame = frame;
    titleView.customlb1.numberOfLines = 0;
    frame = titleView.customlb2.frame;
    frame.origin.x += 15;
    titleView.customlb2.frame = frame;
    titleView.customlb1.text = [weiboData decodeFromPercentEscapeString:[self.data objectForKey:@"name"]];//导师姓名
    titleView.customlb2.text = [weiboData decodeFromPercentEscapeString:[self.data objectForKey:@"trade"]];//行业
    titleView.customlb3.text = [weiboData decodeFromPercentEscapeString:[self.data objectForKey:@"introduce"]];//导师介绍
    titleView.customlb3.numberOfLines = 0;
    //加载boss头像应该用异步方式
    NSString *tutorURLStr = [NSString stringWithFormat:@"%@%@", HOST, [weiboData decodeFromPercentEscapeString:[self.data objectForKey:@"urlimg"]]];
    [titleView.imageView.imageView loadImage:tutorURLStr];
    
    
    //顶部视图和表单布局调整
    frame = titleView.frame;
    frame.size.height = height+40;
    titleView.frame = frame;
    frame = pullController.tableViews.frame;
    frame.origin.y = titleView.frame.size.height;
    height = self.view.frame.size.height-KNavigationBarHeight-KTabBarHeight-titleView.frame.size.height;
    frame.size.height = height;
    pullController.tableViews.frame = frame;
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
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([popupTextView.text length]>149){
        popupTextView.text = [popupTextView.text substringToIndex:149];
        return NO;
    }
    return YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.inputToolbar addObserverFromController:self];
    [self getXmlData:@"1"];
}

-(void)getXmlData:(NSString*)page{
    [pullController.indicator startAnimating];
    if([page isEqualToString:@"1"]){
        [pullController.allData removeAllObjects];
    }
    NSArray* arr1 = [NSArray arrayWithObjects:page,[self.data objectForKey:@"no"],USERNO, nil];
    NSArray* arr2 = [NSArray arrayWithObjects:@"pageno",@"tweibono", @"userno",nil];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
    [weiboData getXMLDataFromUrl:URL postValuesAndKeys:dic];
}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	/* No longer listen for keyboard */
    //     [self.inputToolbar keyboardWillHide];
    [self.inputToolbar removeObserverFromController:self];
   
}
//成功获取XML数据
-(void)sucessParseXMLData:(PBWeiboDataConnect *)weiboDatas{
    [pullController successGetXmlData:pullController withData:weiboData.parseData withNumber:10];
}
//成功提交数据
-(void)sucessSendPostData:(PBWeiboDataConnect *)weiboDatas{
    [self getXmlData:@"1"];
}

-(void)replyWeibo:(id)sender{//点击回复
    UIButton* btn = (UIButton*)sender;
    self.tcontentno = [NSString stringWithFormat:@"%d",btn.tag];
    [self.inputToolbar.textView.internalTextView becomeFirstResponder];
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
    NSArray* arr1 = [NSArray arrayWithObjects:USERNO,self.tcontentno,inputText, nil];
    NSArray* arr2 = [NSArray arrayWithObjects:@"cuserno",@"tcontentno", @"content",nil];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
    [weiboData submitDataFromUrl:REPLYURL postValuesAndKeys:dic];
    
}
-(void)niceWeibo:(id)sender{//点击赞
    UIButton* btn = (UIButton*)sender;
    btn.enabled = NO;
    //    [indicator startAnimating];
    NSArray* arr1 = [NSArray arrayWithObjects:USERNO,[NSString stringWithFormat:@"%d",btn.tag],@"1", @"1",nil];
    NSArray* arr2 = [NSArray arrayWithObjects:@"userno",@"no", @"type",@"flag",nil];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
    [weiboData submitDataFromUrl:RECORDURL postValuesAndKeys:dic];
}
-(void)badWeibo:(id)sender{//点击踩
    UIButton* btn = (UIButton*)sender;
    btn.enabled = NO;
    NSArray* arr1 = [NSArray arrayWithObjects:USERNO,[NSString stringWithFormat:@"%d",btn.tag],@"1", @"0",nil];
    NSArray* arr2 = [NSArray arrayWithObjects:@"userno",@"no", @"type",@"flag",nil];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
    [weiboData submitDataFromUrl:RECORDURL postValuesAndKeys:dic];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row%2==0) {
        cell.backgroundColor = [UIColor colorWithRed:206.0f/255.0f green:206.0f/255.0f blue:206.0f/255.0f alpha:1.0];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* content = [weiboData decodeFromPercentEscapeString:[[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"content"]];
    return [pullController tableView:tableView heightForRow:content defaultHeight:40]+70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PBWeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [tableView registerNib:[UINib nibWithNibName:@"PBTutorWeiboCell" bundle:nil]forCellReuseIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //初始化cell构造
    [cell initCellFrame];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if([pullController.allData count]>0){
        [pullController customLabelFontWithView:[cell contentView]];//设置文字大小
        NSMutableDictionary* dic = [pullController.allData objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSString* content = [weiboData decodeFromPercentEscapeString:[[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"content"]];
        CGFloat height = [pullController tableView:tableView heightForRow:content defaultHeight:40];
        //cell布局
        cell.customlabel1.frame = CGRectMake(60,10,60,20);
        cell.customlabel2.frame = CGRectMake(self.view.frame.size.width-110,10,60,20);
        cell.customlabel3.frame = CGRectMake(70,height+40,20,20);
        cell.customlabel4.frame = CGRectMake(self.view.frame.size.width-140,height+40,20,20);
        cell.customlabel5.frame = CGRectMake(30, 35, self.view.frame.size.width-80, height);
        cell.custombutton1.frame = CGRectMake(35,height+35,30,30);
        cell.custombutton2.frame = CGRectMake(self.view.frame.size.width-175,height+35,30,30);
        cell.custombutton3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [cell.custombutton3 setBackgroundImage:[UIImage imageNamed:@"custom_button"] forState:UIControlStateNormal];
        cell.custombutton3.frame = CGRectMake(self.view.frame.size.width-100,height+40,60,20);
        cell.customImage1.frame = CGRectMake(35,10,20,20);
        cell.customImage2.frame = CGRectMake(self.view.frame.size.width-130,15,15,15);

        //cell显示
        cell.customlabel1.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"count"]];//回复数
        cell.customlabel2.text = [dic objectForKey:@"cdate"];//回复时间
        cell.customlabel3.text = [dic objectForKey:@"nice"];//赞数
        cell.customlabel4.text = [dic objectForKey:@"bad"];//踩数
        cell.customlabel5.text = [weiboData decodeFromPercentEscapeString:[dic objectForKey:@"content"]];//微博内容
        cell.customlabel5.numberOfLines = 0;
        [cell.customlabel5 sizeToFit];
        //设置button标题和响应
        NSInteger tag = [[dic objectForKey:@"no"] intValue];
        [cell.custombutton1 addTarget:self action:@selector(niceWeibo:) forControlEvents:UIControlEventTouchUpInside];
        cell.custombutton1.tag = tag;
        if([[dic objectForKey:@"nflag"] isEqualToString:@"1"]){
            cell.custombutton1.enabled = NO;
        }
        [cell.custombutton2 addTarget:self action:@selector(badWeibo:) forControlEvents:UIControlEventTouchUpInside];
        cell.custombutton2.tag = tag;
        if([[dic objectForKey:@"bflag"] isEqualToString:@"1"]){
            cell.custombutton2.enabled = NO;
        }
        [cell.custombutton3 setTitle:@"回复" forState:UIControlStateNormal];
        [cell.custombutton3 addTarget:self action:@selector(replyWeibo:) forControlEvents:UIControlEventTouchUpInside];
        cell.custombutton3.tag = tag;
    }
    
    return cell;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRow:(NSUInteger)row{
//    CGFloat contentWidth = pullController.tableViews.frame.size.width-80;
//    UIFont *font = [UIFont systemFontOfSize:12];
//    NSString *content = [weiboData decodeFromPercentEscapeString:[[pullController.allData objectAtIndex:row] objectForKey:@"content"]];
//    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:UILineBreakModeWordWrap];
//    return size.height<40?40:size.height;
//}

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
    if ([pullController.allData count]>0) {
        PBReplyWeiboController* reply = [[[PBReplyWeiboController alloc]init]autorelease];
        reply.title = @"回复列表";
        reply.data = [pullController.allData objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:reply animated:YES];
    }
}

@end
