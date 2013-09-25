//
//  PBMyFInanceNeedsLIst.m
//  ParkBusiness
//
//  Created by wangzhigang on 13-7-11.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBMyFInanceNeedsList.h"
#import "PBMyNeedsCell.h"
#import "PBMyNeedsSelectView.h"
#import "PBMyFinanceNeedsDetail.h"
#import "PBMyFinanceNeedsDetail_ipad.h"
#import "PBFinancalProductsController.h"
#import "PBUnreadMessageData.h"
#define URL [NSString stringWithFormat:@"%@admin/index/searchmyfinanceneeds", HOST]
#define FURL [NSString stringWithFormat:@"%@admin/index/submitfinanceneeds", HOST]
@interface PBMyFinanceNeedsList ()

@end

@implementation PBMyFinanceNeedsList
@synthesize rootViewController;
@synthesize needDic;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}
-(void)dealloc{
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *rightbtn1 = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"MyFinanceNeedsList_WYRZ", nil) style:UIBarButtonItemStylePlain target:self action:@selector(showTitleView)];
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
    [self refreshData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sucessSendData:) name:@"sucessSendData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:@"reloadMyNeedsData" object:nil];
}
-(void)reloadData:(NSNotification*)notification{
    [tableView reloadData];
}
-(void)showTitleView{
    titleView = [[PBFinanceNeedsView alloc]init];
    titleView.delegate = self;
    PBNavigationController* navi = [[PBNavigationController alloc]initWithRootViewController:titleView];
    [navi.navigationBar setBackgroundImage:[UIImage imageNamed:@"topnavigation.png"] forBarMetrics:UIBarMetricsDefault];
    navi.navigationBar.barStyle = UIBarStyleBlack;
    titleView.title = NSLocalizedString(@"MyFinanceNeedsList_WYRZ", nil);
    if (isPad()) {
        [titleView show:self.navigationController];
        [titleView initPopView:self.navigationController];
    }else{
        [titleView initPopView:navi];
        [self.navigationController presentModalViewController:navi animated:YES];
    }
}
-(void)refreshData{
    PBWeiboDataConnect* connect = [[PBWeiboDataConnect alloc]init];
    connect.delegate = self;
    connect.indicator = indicator;
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:USERNO,@"userno", nil];
    [connect getXMLDataFromUrl:URL postValuesAndKeys:dic];
    [indicator startAnimating];
}
-(void)sucessSendData:(NSNotification*)notification{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的需求已经发送给相关机构 我们会尽快处理" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.tag = 1;
    [alert show];
    [alert release];
    [self refreshData];
}
-(void)popViewWillShow:(NSMutableDictionary *)dic{//点击我要融资
    if ([titleView checkText]) {
        [indicator startAnimating];
        [titleView setSubmitBtn:NO];
        PBWeiboDataConnect* connect = [[PBWeiboDataConnect alloc]init];
        connect.delegate = self;
        [dic setObject:@"1" forKey:@"type"];
        self.needDic = dic;
        [connect submitDataFromUrl:FURL postValuesAndKeys:dic];
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请完善融资需求信息！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
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
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:weiboDatas.receiveStr,@"needsno",@"1",@"type" ,nil];
    [PBUnreadMessageData saveMyNeedsWithDic:dic];
    [indicator stopAnimating];
    [self sucessSendData:nil];
    if (isPad()) {
        [titleView dismiss];
    }else{
        [titleView hidden];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"我们已帮您再金融超市中找到适合您融资需求的产品 请点击查看" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alert.tag = 2;
        [alert show];
        [alert release];
    }
    if (alertView.tag == 2) {
        PBFinancalProductsController* product = [[PBFinancalProductsController alloc]init];
        NSArray* arr1 = [NSArray arrayWithObjects:
                         @"1",
                         USERNO,
                         [needDic objectForKey:@"fundneed"],
                         [needDic objectForKey:@"yearsale"],
                         [needDic objectForKey:@"trade"],
                         nil];
        
        NSArray* arr2 = [NSArray arrayWithObjects:
                         @"pageno",
                         @"userno",
                         @"fund",
                         @"yearsale",
                         @"industry",
                         nil];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
        product.searchDic = dic;
        [dic release];
        product.flag = 1;
        [self.navigationController pushViewController:product animated:YES];
    }
}
-(void)tapTheView:(UITapGestureRecognizer*)tap{
    [titleView.fundused resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
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
    
    [_tableView registerNib:[UINib nibWithNibName:isPad()?@"PBMyNeedsCell_ipad":@"PBMyNeedsCell" bundle:nil]forCellReuseIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jrcs_cellselect.png"]];
        cell.selectedBackgroundView = imageView;
        [imageView release];
    }
    if (allData.count>0) {
        NSMutableDictionary* dic = [allData objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.difficulty.text = [dic objectForKey:@"difficulty"];
        cell.fundused.text = [dic objectForKey:@"fundused"];
        int unreadcount = [PBUnreadMessageData countOfUnreadNeedsMessageWithType:1 WithNeedsNo:[[dic objectForKey:@"no"] intValue]];
        NSLog(@"unreadcount=%d",unreadcount);
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
        PBMyFinanceNeedsDetail_ipad* detail = [[PBMyFinanceNeedsDetail_ipad alloc]init];
        detail.title = @"融资需求详细";
        detail.dicData = [allData objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        PBMyFinanceNeedsDetail* detail = [[PBMyFinanceNeedsDetail alloc]init];
        detail.title = @"融资需求详细";
        detail.dicData = [allData objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detail animated:YES];
    }
    
    
}
@end
