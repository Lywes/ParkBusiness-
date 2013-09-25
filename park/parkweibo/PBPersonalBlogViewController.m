//
//  PBPersonalBlogViewController.m
//  ParkBusiness
//
//  Created by  on 13-3-15.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBPersonalBlogViewController.h"
#import "PBBlogReplyViewController.h"
#import "PBBlogreplyCell.h"
#import "EGORefreshTableHeaderView.h"
#import "PBUserModel.h"

#define PARK_WEIBO_DETAIL_URL [NSString stringWithFormat:@"%@admin/index/searchweibocontent",HOST]
#define RECORD_URL  [NSString stringWithFormat:@"%@admin/index/updaterecord",HOST]
#define REPLY_URL   [NSString stringWithFormat:@"%@admin/index/replyweibo",HOST]
#define INSERT_URL  [NSString stringWithFormat:@"%@admin/index/inserweibocontent",HOST]


@implementation PBPersonalBlogViewController

@synthesize parkManager;
@synthesize data;
@synthesize inputToolbar;
@synthesize tcontentno;
@synthesize blogContent;
@synthesize popupTextView;
@synthesize blogContentTextView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.data = [[[NSMutableDictionary alloc]init]autorelease];

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
    //解码字符串
- (NSString *)decodeFromPercentEscapeString:(NSString *)string {
    NSMutableString* outputStr = [NSMutableString stringWithString:string];
    [outputStr replaceOccurrencesOfString:@"+" withString:@" " options:NSLiteralSearch range:NSMakeRange(0,outputStr.length)];
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)didReceiveMemoryWarning
{
        [super didReceiveMemoryWarning];
}

-(void)requestData:(NSString *)pageno{
    if([pageno isEqualToString:@"1"]){
        [pullController.allData removeAllObjects];
    }
     [pullController.indicator startAnimating];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:pageno, @"pageno", USERNO, @"userno", [self.data objectForKey:@"no"], @"weibono", nil];
    [parkManager getRequestData:PARK_WEIBO_DETAIL_URL forValueAndKey:dic];
    [dic release];

}

-(void)viewWillAppear:(BOOL)animated
{   
    
    [self requestData:@"1"];
    self.title = [parkManager decodeFromPercentEscapeString:[self.data objectForKey:@"theme"]];
    [super viewWillAppear:animated];
//    titleView.customlb1.text = [parkManager decodeFromPercentEscapeString:[self.data objectForKey:@"name"]];//姓名
    titleView.introduceTextView.text = [parkManager decodeFromPercentEscapeString:[self.data objectForKey:@"introduce"]];//介绍
    NSString *tutorURLStr = [NSString stringWithFormat:@"%@%@", HOST, [parkManager decodeFromPercentEscapeString:[self.data objectForKey:@"urlimg"]]];
    //加载boss头像应该用异步方式
    [titleView.imageView.imageView loadImage:tutorURLStr];
    
    [self.inputToolbar addObserverFromController:self];
    
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
    CGFloat height = isPad()?1024:(isPhone5()?568:480)-titleView.frame.size.height-KTabBarHeight-KNavigationBarHeight;
    pullController = [[PBPullTableViewController alloc]initWithFrame: CGRectMake(0, titleView.frame.size.height, isPad()?768:320, height)];

    pullController.delegate =self;
    pullController.tableViews.delegate = self;
    pullController.tableViews.dataSource = self;
    pullController.tableViews.backgroundColor=[UIColor clearColor];
    [self.view addSubview:pullController.tableViews];
    
   
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
        //上方的View
    
    if (isPad()) {
        titleView = [[PBBlogTitleView alloc]initWithFrame:CGRectMake(0, 0, 768, 120)];

    }else{
        titleView = [[PBBlogTitleView alloc]initWithFrame:CGRectMake(0, 0, 320, 120)];
    }
    [titleView.customlb1 removeFromSuperview];
    [self.view addSubview:titleView];
        //定义下方表UITableView
    [self tableViewInit];
    
    parkManager = [[PBParkManager alloc] init];
    parkManager.delegate = self;
    if([PBUserModel getUserId]==[[self.data objectForKey:@"cuserno"] intValue]){
        [self rightBtn];
    }
        //回复框
    self.inputToolbar = [[UIInputToolbar alloc] initWithFrame:CGRectMake(0, isPad()?1024:480, self.view.frame.size.width, 40)];
    inputToolbar.delegate = self;
    inputToolbar.textView.placeholder = @"请输入回复";
    [self.view addSubview:self.inputToolbar];
    [self.view addSubview:pullController.indicator];
    
    
}

//控制字数
-(void)popupTextView:(YIPopupTextView *)textView didChangeWithText:(NSString *)text{
    if([text length]>0){
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}
-(void)closePopTextView{//点击取消操作
    btnPressed = !btnPressed;

    self.navigationItem.rightBarButtonItem.enabled = YES;
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

- (void)viewWillDisappear:(BOOL)animated 
{
	[super viewWillDisappear:animated];
	/* No longer listen for keyboard */
    [self.inputToolbar removeObserverFromController:self];
}
-(void)replyWeibo:(id)sender{//点击回复
    UIButton* btn = (UIButton*)sender;
    self.tcontentno = [NSString stringWithFormat:@"%d",btn.tag];
    [self.inputToolbar.textView becomeFirstResponder];
}

-(void)inputButtonPressed:(NSString *)inputText//发送回复
{
    [pullController.indicator startAnimating];
    NSArray* arr1 = [NSArray arrayWithObjects:USERNO,self.tcontentno,inputText, nil];
    NSArray* arr2 = [NSArray arrayWithObjects:@"cuserno",@"contentno", @"content",nil];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
    [parkManager submitDataFromUrl:REPLY_URL postValuesAndKeys:dic];
    
}

-(void)rightBtn
{
    UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc] initWithTitle:@"写微博" style:UIBarButtonItemStylePlain target:self action:@selector(editView)];
    self.navigationItem.rightBarButtonItem = rightbtn;
    [rightbtn release];

}

-(void)editView
{
    btnPressed = !btnPressed;
    if (btnPressed == YES) {
        [self.navigationItem.rightBarButtonItem setTitle:NSLocalizedString(@"nav_btn_wc", nil)];
        popupTextView = [[YIPopupTextView alloc] initWithPlaceHolder:@"请输入内容..." maxCount:150];
        popupTextView.delegate = self;
        popupTextView.keyboardAppearance = UIKeyboardAppearanceDefault;
        popupTextView.text = blogContentTextView.text;
        popupTextView.superview.backgroundColor = [UIColor grayColor];
        [popupTextView showInView:self.view];

    }
    else{
       
        [self.navigationItem.rightBarButtonItem setTitle:@"写微博"];
        [popupTextView resignFirstResponder];
        [self submitBlogContent];
        [pullController.tableViews reloadData];
    
        
    }
   
}
                       
-(void)submitBlogContent
{
    [pullController.indicator startAnimating];
    self.blogContent = [self.data objectForKey:@"no"];
    NSArray* arr1 = [NSArray arrayWithObjects:self.blogContent,self.popupTextView.text ,nil];
    NSArray* arr2 = [NSArray arrayWithObjects:@"weibono",@"content",nil];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
    [parkManager submitDataFromUrl:INSERT_URL postValuesAndKeys:dic];
    [pullController.tableViews reloadData];
}
                       
-(void)editBtn
{
    btnPressed = NO;
    [self.navigationItem.rightBarButtonItem setTitle:@"写微博"];

}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{    
    
    if (range.location>=150
        ) {    
        
        if ([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder]; 
        }
        return NO;    
    }
    
    return YES;    
    
}

#pragma mark-
#pragma mark-   PBParkManagerDelegate

-(void)refreshData
{
    nodesMutableArr = [[NSArray arrayWithArray:parkManager.itemNodes] retain];
    [pullController successGetXmlData:pullController withData:nodesMutableArr withNumber:10];
}

    //返回多少行 
- (NSInteger)tableView:(UITableView *)tableView_ numberOfRowsInSection:(NSInteger)section
{
    return [pullController.allData count];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row%2==0) {
        cell.backgroundColor = [UIColor colorWithRed:206.0f/255.0f green:206.0f/255.0f blue:206.0f/255.0f alpha:1.0];
    }
}

    //单元格重用
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        //static BOOL nibsRegisted = NO;
    static NSString *CellIdentifier = @"CellIdentifier";
    
    PBBlogreplyCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSString *nibName = isPad() ? @"PBIpadBlogreplyCell" : @"PBBlogReplyCell";
    [_tableView registerNib:[UINib nibWithNibName:nibName bundle:nil]forCellReuseIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //初始化cell构造
    [cell initCellFrame];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    if([pullController.allData count]>0){
        NSMutableDictionary* dic = [pullController.allData objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSString *content = [parkManager decodeFromPercentEscapeString:[[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"content"]];
        CGFloat height = [pullController tableView:_tableView heightForRow:content defaultHeight:40];
            //cell布局
        if (isPad()) {
    
            cell.renqiImg.frame = CGRectMake(50,10,24,24);
            cell.dateimg.frame = CGRectMake(590,10,24,24);
            cell.customlabel1.frame = CGRectMake(80,10,100,20);
            cell.customlabel2.frame = CGRectMake(620,10,80,20);
            cell.customlabel3.frame = CGRectMake(70,height+60,20,20);
            cell.customlabel4.frame = CGRectMake(580,height+60,20,20);
            cell.customlabel5.frame = CGRectMake(20, 50, cell.frame.size.width-80, height);
            cell.custombutton1.frame = CGRectMake(40,height+60,20,20);
            cell.custombutton2.frame = CGRectMake(550,height+60,20,20);
            cell.custombutton3.frame = CGRectMake(620,height+60,60,20);

        }else{
            cell.customlabel1.frame = CGRectMake(50,10,100,20);
            cell.customlabel2.frame = CGRectMake(220,10,60,20);
            cell.customlabel3.frame = CGRectMake(70,height+60,20,20);
            cell.customlabel4.frame = CGRectMake(180,height+60,20,20);
            cell.customlabel5.frame = CGRectMake(20, 50, cell.frame.size.width-80, height);
            cell.custombutton1.frame = CGRectMake(40,height+60,20,20);
            cell.custombutton2.frame = CGRectMake(150,height+60,20,20);
            cell.custombutton3.frame = CGRectMake(220,height+60,60,20);
        }
        
            //cell显示
        [pullController customLabelFontWithView:[cell contentView]];
        cell.customlabel1.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"count"]];//回复数
        cell.customlabel2.text = [dic objectForKey:@"cdate"];//回复时间
        cell.customlabel3.text = [dic objectForKey:@"nice"];//赞数
        cell.customlabel4.text = [dic objectForKey:@"bad"];//踩数
        cell.customlabel5.text = [parkManager decodeFromPercentEscapeString:[dic objectForKey:@"content"]];//微博内容
        cell.customlabel5.numberOfLines = 0;
        [cell.customlabel5 sizeToFit];
            //设置button标题和响应
        NSInteger tag = [[dic objectForKey:@"no"] intValue];
            //[cell.custombutton1 setTitle:@"赞" forState:UIControlStateNormal];
        [cell.custombutton1 addTarget:self action:@selector(nice:) forControlEvents:UIControlEventTouchUpInside];
        cell.custombutton1.tag = tag;
         [cell.custombutton1 setBackgroundImage:[UIImage imageNamed:@"zan.png"] forState:UIControlStateNormal];
        
        if([[dic objectForKey:@"nflag"] isEqualToString:@"1"]){
            cell.custombutton1.enabled = NO;
        }
            //[cell.custombutton2 setTitle:@"踩" forState:UIControlStateNormal];
        [cell.custombutton2 addTarget:self action:@selector(bad:) forControlEvents:UIControlEventTouchUpInside];
        cell.custombutton2.tag = tag;
        [cell.custombutton2 setBackgroundImage:[UIImage imageNamed:@"cai.png"] forState:UIControlStateNormal];
        if([[dic objectForKey:@"bflag"] isEqualToString:@"1"]){
            cell.custombutton2.enabled = NO;
        }
        [cell.custombutton3 setTitle:@"回复" forState:UIControlStateNormal];
        [cell.custombutton3 addTarget:self action:@selector(replyWeibo:) forControlEvents:UIControlEventTouchUpInside];
        [cell.custombutton3 setBackgroundImage:[UIImage imageNamed:@"reply_btn.png"] forState:UIControlStateNormal];
        cell.custombutton3.tag = tag;
    }
   
    return cell;
    
}

-(void)nice:(id)sender
{
  
    UIButton* btn = (UIButton*)sender;
    btn.enabled = NO;
    NSArray* arr1 = [NSArray arrayWithObjects:USERNO,[NSString stringWithFormat:@"%d",btn.tag],@"0", @"1",nil];
    NSArray* arr2 = [NSArray arrayWithObjects:@"userno",@"no", @"type",@"flag",nil];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
    [parkManager submitDataFromUrl:RECORD_URL postValuesAndKeys:dic];
}

-(void)bad:(id)sender
{
    
    UIButton* btn = (UIButton*)sender;
    btn.enabled = NO;
    NSArray* arr1 = [NSArray arrayWithObjects:USERNO,[NSString stringWithFormat:@"%d",btn.tag],@"0", @"0",nil];
    NSArray* arr2 = [NSArray arrayWithObjects:@"userno",@"no", @"type",@"flag",nil];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
    [parkManager submitDataFromUrl:RECORD_URL postValuesAndKeys:dic];
}

    //成功提交数据
-(void)sucessSendPostData:(NSObject *)Data{
    [self requestData:@"1"];
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRow:(NSUInteger)row{
    NSString *content = [parkManager decodeFromPercentEscapeString:[[pullController.allData objectAtIndex:row] objectForKey:@"content"]];
    return [pullController tableView:tableView heightForRow:content defaultHeight:40];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:pullController.tableViews heightForRow:indexPath.row]+85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([pullController.allData count]>0) {
        blogReplyVC = [[PBBlogReplyViewController alloc] init];
        blogReplyVC.data = [pullController.allData objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:blogReplyVC animated:YES];
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc{
    [super dealloc];
    [parkManager release];
    [inputToolbar release];
    [titleView release];
}
@end
