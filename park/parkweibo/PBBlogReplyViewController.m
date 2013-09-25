//
//  PBBlogReplyViewController.m
//  ParkBusiness
//
//  Created by  on 13-3-15.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBBlogReplyViewController.h"
#import "PBPersonalBlogViewController.h"
#import "PBBlogreplyCell.h"
#import "EGORefreshTableHeaderView.h"
#import "PBUserModel.h"

#define PARK_WEIBO_REPLY_URL [NSString stringWithFormat:@"%@admin/index/replyweibo",HOST]
#define DETAIL_URL [NSString stringWithFormat:@"%@admin/index/searchweibodetail",HOST]
#define RECORD_URL [NSString stringWithFormat:@"%@admin/index/updaterecord",HOST]

@implementation PBBlogReplyViewController

@synthesize data,inputToolbar,tableViews;
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
- (void)didReceiveMemoryWarning
{
       [super didReceiveMemoryWarning];
    
}

-(void)keyboardDown
{
        //我添加的代码，此代码可以让keyboard消失
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
        //[replyTextView resignFirstResponder];
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.inputToolbar addObserverFromController:self];
    [self setTitleView];
    [self.view addSubview:pullController.indicator];
    [self getXmlData:@"1"];
    
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
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    niceFlg = NO;
    badFlg = NO;
    self.title = @"回复列表";
    UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc] initWithTitle:@"回复" style:UIBarButtonItemStylePlain target:self action:@selector(replyWeibo)];
    self.navigationItem.rightBarButtonItem = rightbtn;
    [rightbtn release];
    parkManager = [[PBParkManager alloc] init];
    parkManager.delegate = self;
    
    [self keyboardDown];
    [self tableViewInit];
    
    if (isPad()) {
         titleView = [[PBBlogTitleView alloc]initWithFrame:CGRectMake(0, 0, 768, 120)];
    }else{
        titleView = [[PBBlogTitleView alloc]initWithFrame:CGRectMake(0, 0, 320, 120)];
    }
    [self.view addSubview:titleView];
    self.inputToolbar = [[UIInputToolbar alloc] initWithFrame:CGRectMake(0, isPad()?1024:480, self.view.frame.size.width, 40)];
    [self.view addSubview:self.inputToolbar];
    inputToolbar.delegate = self;
    
    inputToolbar.textView.placeholder = @"请输入回复";
    [titleView.introduceTextView removeFromSuperview];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRow:(NSString*)content{
    CGFloat contentWidth = pullController.tableViews.frame.size.width-80;
    UIFont *font1 = [UIFont systemFontOfSize:13];
    CGSize size = [content sizeWithFont:font1 constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:UILineBreakModeWordWrap];
    return size.height<40?40:size.height;
}

-(void)setTitleView{
    [titleView.imageView removeFromSuperview];
    NSString* content = [self.data objectForKey:@"content"];
    CGFloat height = [pullController tableView:pullController.tableViews heightForRow:content defaultHeight:40];
        //布局
    if (isPad()) {
        titleView.customlb1.frame = CGRectMake(10,10,pullController.tableViews.frame.size.width-20,height);
        titleView.customlb1.backgroundColor = [UIColor clearColor];
        titleView.customlb2.frame = CGRectMake(70,height+30,20,20);
        titleView.customlb3.frame = CGRectMake(640,height+30,20,20);
        titleView.custombtn1.frame = CGRectMake(40,height+30,20,20);
        titleView.custombtn2.frame = CGRectMake(610,height+30,20,20);
    }else{
        titleView.customlb1.frame = CGRectMake(10,10,pullController.tableViews.frame.size.width-20,height);
        titleView.customlb1.backgroundColor = [UIColor clearColor];
        titleView.customlb2.frame = CGRectMake(70,height+30,20,20);
        titleView.customlb3.frame = CGRectMake(240,height+30,20,20);
        titleView.custombtn1.frame = CGRectMake(40,height+30,20,20);
        titleView.custombtn2.frame = CGRectMake(210,height+30,20,20);
        }
    
        //显示
    [pullController customLabelFontWithView:titleView];//设置文字大小
    titleView.customlb1.text = content;//回复数
    titleView.customlb2.text = [self.data objectForKey:@"nice"];
    titleView.customlb3.text = [self.data objectForKey:@"bad"];
    titleView.customlb1.numberOfLines = 0;
        //button设置
    [titleView.custombtn1 setBackgroundImage:[UIImage imageNamed:@"zan.png"] forState:UIControlStateNormal];
        
    [titleView.custombtn2 setBackgroundImage:[UIImage imageNamed:@"cai.png"] forState:UIControlStateNormal];
    [titleView.custombtn1 addTarget:self action:@selector(niceWeibo:) forControlEvents:UIControlEventTouchUpInside];
    if([[self.data objectForKey:@"nflag"] isEqualToString:@"1"]){
        titleView.custombtn1.enabled = NO;
    }
    [titleView.custombtn2  addTarget:self action:@selector(badWeibo:) forControlEvents:UIControlEventTouchUpInside];
    if([[self.data objectForKey:@"bflag"] isEqualToString:@"1"]){
        titleView.custombtn2.enabled = NO;
    }
    CGRect frame = titleView.frame;
    frame.size.height = height+60;
    titleView.frame = frame;
    frame = pullController.tableViews.frame;
    frame.origin.y = titleView.frame.size.height;
    height = isPad()?1024:(isPhone5()?568:480)-titleView.frame.size.height-KTabBarHeight-KNavigationBarHeight;
    frame.size.height = height;
    pullController.tableViews.frame = frame;
}

-(void)getXmlData:(NSString *)pageno{
    if ([pageno isEqualToString:@"1"]) {
        [pullController.allData removeAllObjects];
    }
    [pullController.indicator startAnimating];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:pageno,@"pageno",[self.data objectForKey:@"no"], @"no", nil];
    [parkManager getRequestData:DETAIL_URL forValueAndKey:dic];
    [dic release];

}

-(void)niceWeibo:(id)sender{//点击赞
    UIButton* btn = (UIButton*)sender;
    btn.enabled = NO;
    niceFlg = YES;
    NSArray* arr1 = [NSArray arrayWithObjects:USERNO,[self.data objectForKey:@"no"] ,@"0", @"1",nil];
    NSArray* arr2 = [NSArray arrayWithObjects:@"userno",@"no", @"type",@"flag",nil];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
    [parkManager submitDataFromUrl:RECORD_URL postValuesAndKeys:dic];
}
-(void)badWeibo:(id)sender{//点击踩
    UIButton* btn = (UIButton*)sender;
    btn.enabled = NO;
    badFlg = YES;
    NSArray* arr1 = [NSArray arrayWithObjects:USERNO,[self.data objectForKey:@"no"],@"0", @"0",nil];
    NSArray* arr2 = [NSArray arrayWithObjects:@"userno",@"no", @"type",@"flag",nil];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
    [parkManager submitDataFromUrl:RECORD_URL postValuesAndKeys:dic];
}
- (void)viewWillDisappear:(BOOL)animated 
{
	[super viewWillDisappear:animated];
	/* No longer listen for keyboard */
    [self.inputToolbar removeObserverFromController:self];
}

    //成功提交数据
-(void)sucessSendPostData:(NSObject *)Data{
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
    [self getXmlData:@"1"];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

    //实现下拉更新操作
-(void)getDataSource:(EGORefreshTableHeaderView *)view{
    [self getXmlData:@"1"];
}
    //点击查看更多按钮
-(void)getMoreButtonDidPush:(EGORefreshTableHeaderView *)view{
    [self getXmlData:[NSString stringWithFormat:@"%d",pullController.pageno]];
}

    //拖动时调用方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[pullController._refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}
    //完成拖动时调用方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[pullController._refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

-(void)replyWeibo{//点击回复
    [self.inputToolbar.textView becomeFirstResponder];
    
}

-(void)inputButtonPressed:(NSString *)inputText//发送回复
{
   
    NSArray* arr1 = [NSArray arrayWithObjects:USERNO,[self.data objectForKey:@"no"],inputText, nil];
    NSArray* arr2 = [NSArray arrayWithObjects:@"cuserno",@"contentno", @"content",nil];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
    [parkManager submitDataFromUrl:PARK_WEIBO_REPLY_URL postValuesAndKeys:dic];
        
}

#pragma mark-
#pragma mark-   PBParkManagerDelegate

-(void)refreshData
{
    nodesMutableArr = [[NSMutableArray arrayWithArray:parkManager.itemNodes] retain];
    [pullController successGetXmlData:pullController withData:parkManager.itemNodes withNumber:10];
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

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    PBBlogreplyCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSString *nibName = isPad() ? @"PBIpadBlogreplyCell" : @"PBBlogReplyCell";
    [_tableView registerNib:[UINib nibWithNibName:nibName bundle:nil]forCellReuseIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }else{
        [cell.imageViews removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //初始化cell构造
    
    [cell initCellFrame];
    if([pullController.allData count]>0){
        NSString* content = [parkManager decodeFromPercentEscapeString:[[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"content"]];
        CGFloat height = [pullController tableView:_tableView heightForRow:content defaultHeight:40];
        NSMutableDictionary* dic = [pullController.allData objectAtIndex:indexPath.row];
        if (isPad()) {
            
            cell.customlabel1.frame = CGRectMake(120,10,60,20);
            cell.customlabel2.frame = CGRectMake(620,12,60,20);
            cell.customlabel3.frame = CGRectMake(5, 45, _tableView.frame.size.width-20, height);
            
            cell.imageViews.frame = CGRectMake(5, 5, 38, 38);
            cell.renqiImg.frame = CGRectMake(90,10,24,24);
            cell.dateimg.frame =  CGRectMake(590,10,24,24);
          
           
           
        }else{
                //cell布局
            cell.customlabel1.frame = CGRectMake(80,10,60,20);
            cell.customlabel2.frame = CGRectMake(220,10,60,20);
            cell.customlabel3.frame = CGRectMake(5, 40, _tableView.frame.size.width-20, height);
            cell.imageViews.frame = CGRectMake(5, 5, 35, 35);
            cell.renqiImg.frame = CGRectMake(50,9,27,26);
            cell.dateimg.frame = CGRectMake(190,9,24,24);

        }
        //cell显示
        [pullController customLabelFontWithView:[cell contentView]];//设置文字大小
        cell.customlabel1.text = [parkManager decodeFromPercentEscapeString:[dic objectForKey:@"name"]];//姓名
        cell.customlabel2.text = [dic objectForKey:@"cdate"];//回复时间
        cell.customlabel3.text = content;//回复内容
        cell.customlabel3.numberOfLines = 0;
        [cell.customlabel3 sizeToFit];
            //加载boss头像应该用异步方式
        NSString *replyURLStr = [NSString stringWithFormat:@"%@%@", HOST, [parkManager decodeFromPercentEscapeString:[dic objectForKey:@"urlimg"]]];
        cell.imageViews = [[CustomImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
        [[cell contentView] addSubview:cell.imageViews];
        if ([[parkManager decodeFromPercentEscapeString:[dic objectForKey:@"urlimg"]] length]) {
            [cell.imageViews.imageView loadImage:replyURLStr];
        }
        
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([pullController.allData count]>0){
        NSString* content = [parkManager decodeFromPercentEscapeString:[[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"content"]];
        return MAX([pullController tableView:tableView heightForRow:content defaultHeight:40]+50, 120);
    }
    return 0;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    
       [super dealloc];
}

@end
