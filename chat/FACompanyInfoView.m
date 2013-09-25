//
//  FACompanyInfoView.m
//  FASystemDemo
//
//  Created by Hot Hot Hot on 12-11-23.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import "FACompanyInfoView.h"
#import "FAAddCompanyFriendView.h"
#import "FACompanyInfoCell.h"
#import "FAFriendData.h"
#import "PBUserModel.h"
#import "FAChatManager.h"
#import "FAPeopleChatView.h"
#import "PBPrivateMessagesController.h"
#import "PBInvestorDetail.h"
#import "PBStarEntrepreneursDetail.h"
#define URL [NSString stringWithFormat:@"%@/admin/index/searchgps",HOST]
@interface FACompanyInfoView ()

@end

@implementation FACompanyInfoView
@synthesize kind,pageno,parentController;
-(void)dealloc
{
    [super dealloc];
    [pullController release];
    //    UITabBarController* rootController;
    [weiboData release];
    [investbtn release];
    [companybtn release];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        
        self.title = @"寻找附近会员";
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.kind = @"";
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    UIView *headView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, isPad()?768:320, 40)]autorelease];
    CGFloat width = headView.frame.size.width/2;
    //设置下拉按钮
    investbtn = [self setSelectButton:CGRectMake(0, 0, width-1, headView.frame.size.height) title:@"投资人"];
    [investbtn addTarget:self action:@selector(investClicked) forControlEvents:UIControlEventTouchUpInside];
    companybtn = [self setSelectButton:CGRectMake(width+1,0 , width-1, headView.frame.size.height) title:@"企业家"];
    [companybtn addTarget:self action:@selector(companyClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headView];
    [headView addSubview:investbtn];
    [headView addSubview:companybtn];
    //设置下拉图片
    CGFloat height = isPad()?1024:(isPhone5()?568:480)-KTabBarHeight-KNavigationBarHeight;
    pullController = [[PBPullTableViewController alloc]initWithFrame:CGRectMake(0,40, self.view.frame.size.width, height-40)];
    pullController.delegate =self;
    pullController.tableViews.delegate = self;
    pullController.tableViews.dataSource = self;
    [self.view addSubview:pullController.tableViews];
    weiboData = [[PBWeiboDataConnect alloc]init];
    weiboData.delegate = self;
    weiboData.indicator = pullController.indicator;
    [self.view addSubview:pullController.indicator];
    pullController.pageno = 1;
    [self getXmlData:@"1"];
}

//设置下拉列表button
-(UIButton*)setSelectButton:(CGRect)frame title:(NSString*)title{
    UIButton *btnSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSelect setTitle:title forState:UIControlStateNormal];
    btnSelect.backgroundColor = [UIColor grayColor];
    btnSelect.frame = frame;
    return btnSelect;
    
}
-(void)investClicked{
    investbtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dropnormal.png"]];
    companybtn.backgroundColor = [UIColor grayColor];
    self.kind = @"1";
    [self getXmlData:@"1"];
}
-(void)companyClicked{
    investbtn.backgroundColor = [UIColor grayColor];
    companybtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dropnormal.png"]];
    self.kind = @"2";
    [self getXmlData:@"1"];
}
-(void)getXmlData:(NSString*)page{
    [pullController.indicator startAnimating];
    self.pageno = page;
    canMove = YES;
    [locationManager startUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [locationManager stopUpdatingLocation];
    NSString* latitudeStr = [NSString stringWithFormat:@"%g",newLocation.coordinate.latitude];
    
    NSString* longitudeStr = [NSString stringWithFormat:@"%g",newLocation.coordinate.longitude];
    if (canMove) {
        canMove = !canMove;
        if ([self.pageno isEqualToString:@"1"]) {
            [pullController.allData removeAllObjects];
        }
        NSArray* arr1 = [NSArray arrayWithObjects:self.pageno,USERNO,self.kind,latitudeStr,longitudeStr, nil];
        NSArray* arr2 = [NSArray arrayWithObjects:@"pageno",@"userno",@"kind" ,@"latitude",@"longitude",nil];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
        [weiboData getXMLDataFromUrl:URL postValuesAndKeys:dic];
        [dic release];
    }
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"error" message:@"获取位置失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
//    [alert release];
    PBAlertView* alert = [[PBAlertView alloc]initWithMessage:@"获取位置失败"];
    [alert show];
    [alert release];
}

- (void)startUpdatingLocation
{
    
}

- (void)stopUpdatingLocation
{
    
}
//实现下拉更新操作
- (void)getDataSource:(PBPullTableViewController*)view{
    [self getXmlData:@"1"];
}
-(void)sucessParseXMLData:(PBWeiboDataConnect *)weiboDatas{
    [pullController successGetXmlData:pullController withData:weiboData.parseData withNumber:20];
    
}
-(void)getMoreButtonDidPush:(PBRefreshTableHeaderView *)view{
    [self getXmlData:[NSString stringWithFormat:@"%d",pullController.pageno]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[pullController._refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[pullController._refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}
//-(void)AddCompany
//{
//    FAAddCompanyFriendView* addCompany=[[FAAddCompanyFriendView alloc] init] ;
//    NSArray* tabs=[NSArray arrayWithObjects:addCompany, nil];
//    rootController=[[UITabBarController alloc] init];
//    [rootController setViewControllers:tabs animated:NO];
//    [self.navigationController pushViewController:rootController animated:YES];
//    
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FACompanyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [tableView registerNib:[UINib nibWithNibName:isPad()?@"FACompanyInfoCell_ipad":@"FACompanyInfoCell" bundle:nil]forCellReuseIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }else {
        [cell.imageViews removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    if ([pullController.allData count]>0) {
        NSMutableDictionary* dic = [pullController.allData objectAtIndex:indexPath.row];
        // Configure the cell...
        [pullController customLabelFontWithView:[cell contentView]];
        cell.customlabel1.text = [weiboData decodeFromPercentEscapeString:[dic objectForKey:@"name"]];
        cell.customlabel2.text = [dic objectForKey:@"no"];
        cell.customlabel3.text = [weiboData decodeFromPercentEscapeString:[dic objectForKey:@"companyname"]];
        cell.customlabel4.text = [weiboData decodeFromPercentEscapeString:[dic objectForKey:@"companyjob"]];
        cell.customlabel5.text = [[dic objectForKey:@"kind"] isEqualToString:@"1"]?@"投资人":@"企业家";
        cell.customlabel6.text = [NSString stringWithFormat:@"%@ 公里",[dic objectForKey:@"distance"]];
        //加载boss头像应该用异步方式
        NSString *userimageStr = [NSString stringWithFormat:@"%@%@", HOST, [weiboData decodeFromPercentEscapeString:[dic objectForKey:@"imagepath"]]];
        cell.imageViews = [[[CustomImageView alloc]initWithFrame:CGRectMake(5, 10, 65 , 65)]autorelease];
        [[cell contentView] addSubview:cell.imageViews];
        [cell.imageViews.imageView loadImage:userimageStr];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    //判断投资人或企业家
    if([pullController.allData count]>0){
        PBStarEntrepreneursDetail *controller = [[PBStarEntrepreneursDetail alloc] init];
        controller.dataDictionary = [pullController.allData objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    if([pullController.allData count]>0){
        int friendId = [[[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"no"] intValue];
        NSString* friend = [FAFriendData isFriend:friendId]?@"发送会话":@"邀请好友";
        UIActionSheet *sheet = [[[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) destructiveButtonTitle:nil otherButtonTitles:friend,@"私信", nil]autorelease];
        sheet.tag = friendId;
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([pullController.allData count]>0){
        int friendId = actionSheet.tag;
        if (buttonIndex == 0) {
            if([FAFriendData isFriend:friendId]){//已经成为好友 发起会话
                FAPeopleChatView* view = [[[FAPeopleChatView alloc] initWithNibName:isPad()?@"FAPeopleChatView_ipad": @"FAPeopleChatView" bundle:nil] autorelease];
                view.friendid = friendId;
                view.readflg =0;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:view];
                nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                //view.title = className;
                [self.parentController.navigationController presentViewController:nav animated:YES completion:NULL];
                [nav release];
            }else{//不是好友 邀请
                FAChatManager *manager = [[[FAChatManager alloc] init] autorelease];
                [manager inviteToBeFreindTo:friendId fromId:[PBUserModel getUserId]];
            }
        }
        if (buttonIndex == 1) {//发送私信
            PBPrivateMessagesController *controller = [[PBPrivateMessagesController alloc] init];
            controller.messageInvesterNo = [NSString stringWithFormat:@"%d",friendId];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
    }
}

@end
