//
//  PBMyManageMoneyNeedsList.m
//  ParkBusiness
//
//  Created by wangzhigang on 13-7-11.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBMyManageMoneyNeedsList.h"
#import "PBMyNeedsCell.h"
#import "PBMyNeedsSelectView.h"
#import "PBMyManageMoneyNeedsDetail.h"
#import "PBMyManageMoneyNeedsDetail_ipad.h"
#import "PBUnreadMessageData.h"
#import "PBFinancalProductsController.h"
#define URL [NSString stringWithFormat:@"%@admin/index/searchmymanagemoneyneeds", HOST]
#define MURL [NSString stringWithFormat:@"%@admin/index/submitmanagemoneyneeds", HOST]
@interface PBMyManageMoneyNeedsList ()

@end

@implementation PBMyManageMoneyNeedsList
@synthesize rootViewController;
@synthesize needDic;
-(void)dealloc{
    RB_SAFE_RELEASE(tableView);
    RB_SAFE_RELEASE(indicator);
    RB_SAFE_RELEASE(allData);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *rightbtn1 = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"PBMyManageMoneyNeedsList_WYLC", nil) style:UIBarButtonItemStylePlain target:self action:@selector(showTitleView)];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.tag = 101;
    btn1.frame = CGRectMake(3, 1.5, 40, 40);
    [btn1 addTarget:self action:@selector(backHomeView:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"right_back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *barButton1 = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:barButton1,rightbtn1, nil];
    
    
    
    allData = [[NSMutableArray alloc]init];
    	// Do any additional setup after loading the view.
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTheView:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-KNavigationBarHeight)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    indicator = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:indicator];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sucessSendData:) name:@"sucessSendData" object:nil];
    [self refreshData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:@"reloadMyNeedsData" object:nil];
}
-(void)reloadData:(NSNotification*)notification{
    [tableView reloadData];
}
-(void)showTitleView{
    titleView = [[PBManageMoneyView alloc]init];
    titleView.delegate = self;
    PBNavigationController* navi = [[PBNavigationController alloc]initWithRootViewController:titleView];
    [navi.navigationBar setBackgroundImage:[UIImage imageNamed:@"topnavigation.png"] forBarMetrics:UIBarMetricsDefault];
    navi.navigationBar.barStyle = UIBarStyleBlack;
    titleView.title = NSLocalizedString(@"PBMyManageMoneyNeedsList_WYLC", nil);
    if (isPad()) {
        [titleView initPopView:self.navigationController];
        [titleView show:self.navigationController];
    }else{
        [titleView initPopView:navi];
        [self.navigationController presentModalViewController:navi animated:YES];
    }
}

-(void)refreshData{
    [indicator startAnimating];
    PBWeiboDataConnect* connect = [[PBWeiboDataConnect alloc]init];
    connect.delegate = self;
    connect.indicator = indicator;
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:USERNO,@"userno", nil];
    [connect getXMLDataFromUrl:URL postValuesAndKeys:dic];
}
-(void)sucessSendData:(NSNotification*)notification{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的需求已经发送给相关机构 我们会尽快处理" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.tag = 1;
    [alert show];
    [self refreshData];
    if (isPad()) {
        [titleView dismiss];
    }else{
        [titleView hidden];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"我们已帮您再金融超市中找到适合您理财需求的产品 请点击查看" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alert.tag = 2;
        [alert show];
        [alert release];
    }
    if (alertView.tag == 2) {
        PBFinancalProductsController* product = [[PBFinancalProductsController alloc]init];
        NSArray* arr1 = [NSArray arrayWithObjects:
                         @"1",
                         USERNO,
                         [needDic objectForKey:@"expectreturn"],
                         [needDic objectForKey:@"timeperiod"],
                         [needDic objectForKey:@"type"],
                         @"7",
                         nil];
        
        NSArray* arr2 = [NSArray arrayWithObjects:
                         @"pageno",
                         @"userno",
                         @"earor",
                         @"timaperiod",
                         @"mmtype",
                         @"type",
                         nil];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
        product.searchDic = dic;
        [dic release];
        product.flag = 1;
        [self.navigationController pushViewController:product animated:YES];
    }
}
-(void)popViewWillShow:(NSMutableDictionary *)dic{//点击我要理财
    [indicator startAnimating];
    [titleView setSubmitBtn:NO];
    PBWeiboDataConnect* connect = [[PBWeiboDataConnect alloc]init];
    connect.delegate = self;
    needDic = dic;
    [connect submitDataFromUrl:MURL postValuesAndKeys:dic];
}
-(void)sucessParseXMLData:(PBWeiboDataConnect *)weiboDatas{
    [indicator stopAnimating];
    allData = weiboDatas.parseData;
//    [PBUnreadMessageData updateMyNeedsWithArray:allData withType:1];
    if ([allData count]==0) {
        [self showTitleView];
    }
    [tableView reloadData];
}
-(void)sucessSendPostData:(PBWeiboDataConnect *)weiboDatas{
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:weiboDatas.receiveStr,@"needsno",@"2",@"type" ,nil];
    [PBUnreadMessageData saveMyNeedsWithDic:dic];
    [indicator stopAnimating];
    [self sucessSendData:nil];
}

-(void)tapTheView:(UITapGestureRecognizer*)tap{
    [titleView.expectreturn resignFirstResponder];
    [titleView.availablefund resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return isPad()?70.0f:90.0f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [allData count];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PBMyNeedsCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [_tableView registerNib:[UINib nibWithNibName:isPad()?@"PBMyManageNeedsCell_ipad":@"PBMyManageNeedsCell" bundle:nil]forCellReuseIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jrcs_cellselect.png"]];
        cell.selectedBackgroundView = imageView;
        [imageView release];
    }
    if (allData.count>0) {
        NSMutableDictionary* dic = [allData objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.availablefund.text = [dic objectForKey:@"availablefund"];
        cell.timeperiod.text = [dic objectForKey:@"timeperiod"];
        cell.expectreturn.text = [dic objectForKey:@"expectreturn"];
        cell.type.text = [dic objectForKey:@"type"];
        int unreadcount = [PBUnreadMessageData countOfUnreadNeedsMessageWithType:2 WithNeedsNo:[[dic objectForKey:@"no"] intValue]];
        if (unreadcount>0) {
            cell.unreadmessage.hidden = NO;
            [cell.unreadmessage setTitle:[NSString stringWithFormat:@"%d",unreadcount] forState:UIControlStateDisabled];
            [cell.unreadmessage setBackgroundImage:[UIImage imageNamed:@"info_unread"] forState:UIControlStateDisabled];
        }else{
            cell.unreadmessage.hidden = YES;
        }
    }
    
    // Configure the cell...
    
    return cell;
}
-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isPad()) {
        PBMyManageMoneyNeedsDetail_ipad* detail = [[PBMyManageMoneyNeedsDetail_ipad alloc]init];
        detail.title = NSLocalizedString(@"_title_lcxqxx", nil);
        detail.dicData = [allData objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        PBMyManageMoneyNeedsDetail* detail = [[PBMyManageMoneyNeedsDetail alloc]init];
        detail.title = NSLocalizedString(@"_title_lcxqxx", nil);
        detail.dicData = [allData objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detail animated:YES];
    }
}
@end
