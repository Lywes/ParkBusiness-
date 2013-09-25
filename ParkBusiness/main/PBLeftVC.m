//
//  PBLeftVC.m
//  PBParkBusiness
//
//  Created by China on 13-8-19.
//  Copyright (c) 2013年 WINSEN. All rights reserved.
//
#define TOPVIEW_HEIGHT  60
#define UNREADURL [NSString stringWithFormat:@"%@/admin/index/searchunreadneedsmessage",HOST]
#define Joininapply_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/joininapply",HOST]]
#import "PBLeftVC.h"
#import "PBSidebarVC.h"
#import "SideBarSelectedDelegate.h"
#import "PBFinancing.h"
#import "PBMyFinanceNeedsList.h"
#import "PBMainMyNeedsController.h"
#import "PBProjectList.h"
#import "PBIndustryOpportunityList.h"
#import "PBMyManageMoneyNeedsList.h"
#import "PBMainFinanceInformation.h"
#import "PBBusinessCollegeMainNV.h"
#import "LeftCell.h"
#import "NSObject+NAV.h"
#import "PBFinancalProductsController.h"
#import "PBFinancialCaseController.h"
#import "PBMainViewController.h"
#import "PBFinancingNews.h"
#import "PBMainCompaniesController.h"
#import "PBUnreadMessageData.h"
#import "PBFinancingCaseController.h"
#import "PBAboutUsView.h"
@interface PBLeftVC ()
{

    int _selectIdnex;
}
-(void)initData;
-(void)initTableView;
@end

@implementation PBLeftVC

@synthesize mainTableView,delegate,_dataList,_imageList,_image_HGList,_detailList;
-(void)dealloc{
    RB_SAFE_RELEASE(_dataList);
    RB_SAFE_RELEASE(_imageList);
    RB_SAFE_RELEASE(oldindex);
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initData{
    click = NO;
    if([PBUserModel getPasswordAndKind].kind==3){//金融经理人
        _dataList = [[NSArray alloc ] initWithObjects :
                     NSLocalizedString(@"Left_mainTable_RS", nil),
                     NSLocalizedString(@"Left_mainTable_LCXQ", nil),
                     NSLocalizedString(@"Left_mainTable_JRCS", nil),
                     NSLocalizedString(@"Left_mainTable_QYGQ", nil),
                     NSLocalizedString(@"Left_mainTable_HYZC", nil), nil];
        _imageList = [[NSArray alloc] initWithObjects:@"rongshangzixun.png",@"licaixuqiu.png",@"jinrongchaoshi.png",@"jinronganli.png",@"huiyuan.png", nil];
        _image_HGList  = [[NSArray alloc] initWithObjects:@"rongshangzixun_hg.png",@"licaixuqiu_hg.png",@"jinrongchaoshi_hg.png",@"jinronganli_hg.png",@"huiyuan.png", nil];
        
        _detailList = [[NSArray alloc] initWithObjects:
                       @"发布最新金融、理财相关资讯，以及金融机构新产品、新政策信息。",
                       @"提出您的理财需求，金融机构推荐最适合您的理财方案供您选择。",
                       @"汇聚平台金融机构的各种类型针对中小企业的金融产品。",
                       @"查看金融案例帮您更好的理解相关金融产品。",
                       @"了解各园区招商信息，寻找行业合作伙伴企业的窗口。", nil];
    }else{//游客 政府公职人员 企业家
        _dataList = [[NSArray alloc ] initWithObjects :
                     NSLocalizedString(@"Left_mainTable_RS", nil),
                     NSLocalizedString(@"Left_mainTable_RZXQ", nil),
                     NSLocalizedString(@"Left_mainTable_LCXQ", nil),
                     NSLocalizedString(@"Left_mainTable_JRCS", nil),
                     NSLocalizedString(@"Left_mainTable_QYGQ", nil),
                     NSLocalizedString(@"Left_mainTable_HYZC", nil), nil];
        _imageList = [[NSArray alloc] initWithObjects:@"rongshangzixun.png",@"rongzixuqiu.png",@"licaixuqiu.png",@"jinrongchaoshi.png",@"jinronganli.png",@"huiyuan.png", nil];
        _image_HGList  = [[NSArray alloc] initWithObjects:@"rongshangzixun_hg.png",@"rongzixuqiu_hg.png",@"licaixuqiu_hg.png",@"jinrongchaoshi_hg.png",@"jinronganli_hg.png",@"huiyuan_hg.png", nil];
        _detailList = [[NSArray alloc] initWithObjects:
                       @"发布最新金融、理财相关资讯，以及金融机构新产品、新政策信息。",
                       @"填写最简单的融资需求，就可获取金融机构提供的最专业的融资方案供您比较、选择。",
                       @"提出您的理财需求，金融机构推荐最适合您的理财方案供您选择。",
                       @"汇聚平台金融机构的各种类型针对中小企业的金融产品。",
                       @"免费发布供求商业信息，在融商平台企业会员中寻找商机。",
                       @"了解各园区招商信息，寻找行业合作伙伴企业的窗口。", nil];
    }
//    _dataList = [[NSArray alloc ] initWithObjects :NSLocalizedString(@"Left_mainTable_RS", nil),NSLocalizedString(@"Left_mainTable_RZXQ", nil),NSLocalizedString(@"Left_mainTable_LCXQ", nil),NSLocalizedString(@"Left_mainTable_JRCS", nil),NSLocalizedString(@"Left_mainTable_JRAL", nil),@"融资申请",@"园区之窗",@"园区会员", nil];
//    _imageList = [[NSArray alloc] initWithObjects:@"Finacing1.png",@"Finacing2.png",@"Finacing3.png",@"Finacing4.png",@"Finacing5.png",@"Finacing6.png",@"Finacing7.png",@"huiyuan.png", nil];

    
}
#pragma mark - 顶部融商view
-(void)initView{
    UIImageView *topview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, VIEWSIZE.width,isPad()?135:TOPVIEW_HEIGHT)];
    UIImage *image = [UIImage imageNamed:@"heibeijing.png"];
    topview.image = image;
    
    UIImage *image2 = [UIImage imageNamed:@"left_top.png"];
    UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:isPad()?CGRectMake(0, 0, VIEWSIZE.width/2+50,135):CGRectMake(0, 0, 280,TOPVIEW_HEIGHT)];
    imageview2.image = image2;
    [topview addSubview:imageview2];
    
    UIImage *image1 = [UIImage imageNamed:@"left_top_zi.png"];
    UIImageView *zi = [[UIImageView alloc] initWithFrame:isPad()?CGRectMake(30, 30, image1.size.width,image1.size.height):CGRectMake(30, 15, image1.size.width/2,image1.size.height/2)];
    zi.image = image1;
    [topview addSubview:zi];
    
    [self.view addSubview:topview];
    [topview release];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didtopviewGes:)];
    topview.userInteractionEnabled = YES;
    [topview addGestureRecognizer:tap];
    [tap release];
    
}
-(void)didtopviewGes:(UITapGestureRecognizer *)tap{
    if ([delegate respondsToSelector:@selector(leftSideBarSelectWithController:)]) {
        [delegate leftSideBarSelectWithController:[self subConWithIndex:-1]];
    }
}
-(void)initTableView{
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, isPad()?130:TOPVIEW_HEIGHT, self.view.frame.size.width, self.view.frame.size.height-(isPad()?125:TOPVIEW_HEIGHT)) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    self.mainTableView = tableview;
    self.mainTableView.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_background.jpg"]]autorelease];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableview release];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self.mainTableView.delegate tableView:self.mainTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initView];
    [self initTableView];
//    if ([delegate respondsToSelector:@selector(leftSideBarSelectWithController:)]) {
//        [delegate leftSideBarSelectWithController:[self subConWithIndex:0]];
//        _selectIdnex = 0;
//    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    PBInsertDataConnect* connect = [[PBInsertDataConnect alloc]init];
    connect.delegate = self;
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:USERNO,@"userno",[NSString stringWithFormat:@"%d",[PBUserModel getPasswordAndKind].kind],@"kind", nil];
    [connect getUnreadMessageFromUrl:UNREADURL postValuesAndKeys:dic];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:@"reloadMyNeedsData" object:nil];
}
-(void)reloadData:(NSNotification*)notification{
    [self.mainTableView reloadData];
}

//成功获取未读信息
-(void)sucessGetUnreadMessage:(NSMutableArray *)messageArr{
    [PBUnreadMessageData updateNeedsMessageData:messageArr];
    [self.mainTableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataList count];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSelected:(oldindex.row  == indexPath.row)];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    LeftCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:isPad()?@"LeftCell_iPad":@"LeftCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        UIImageView *iamgeview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heibeijing.png"]];
        cell.selectedBackgroundView  = iamgeview;
        [iamgeview release];
        cell.tag = indexPath.row +1;
    }
    cell.detail_lb.text = [_detailList objectAtIndex:indexPath.row];
    cell.titlestr.text = [_dataList objectAtIndex:indexPath.row];
    cell.titlestr.textColor = [UIColor whiteColor];
    if ((oldindex.row  == indexPath.row) && oldindex) {
        cell.titleimage.image = [UIImage imageNamed:[self._image_HGList objectAtIndex:indexPath.row]];
    }
    else{
        cell.titleimage.image = [UIImage imageNamed:[self._imageList objectAtIndex:indexPath.row]];
        
    }
    NSString *str = [self._dataList objectAtIndex:indexPath.row];
    int unreadcount = 0;
    if ([str isEqualToString:NSLocalizedString(@"Left_mainTable_RS", nil)]) {
        unreadcount = [PBUnreadMessageData countOfUnreadMessageWithKind:@"zixun"];
    }
    else if ([str isEqualToString:NSLocalizedString(@"Left_mainTable_RZXQ", nil)]) {
        unreadcount = [PBUnreadMessageData countOfUnreadNeedsMessageWithType:1 WithNeedsNo:-1];
    }
    else if ([str isEqualToString:NSLocalizedString(@"Left_mainTable_LCXQ", nil)]) {
        unreadcount = [PBUnreadMessageData countOfUnreadNeedsMessageWithType:2 WithNeedsNo:-1];
    }
    if (unreadcount>0) {
        cell.unreadmessage.hidden = NO;
        NSString* count = unreadcount>10?@"10+":[NSString stringWithFormat:@"%d",unreadcount];
        [cell.unreadmessage setTitle:count forState:UIControlStateDisabled];
        [cell.unreadmessage setBackgroundImage:[UIImage imageNamed:@"info_unread"] forState:UIControlStateDisabled];
    }else{
        cell.unreadmessage.hidden = YES;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return isPad()?125.0f:60.0f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 让定制的cell点击时换掉图片
    if ((indexPath.row != oldindex.row) || !oldindex) {
        LeftCell *cell = (LeftCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.titleimage.image = [UIImage imageNamed:[_image_HGList objectAtIndex:indexPath.row]];
        LeftCell *oldcell = (LeftCell *)[tableView cellForRowAtIndexPath:oldindex];
        oldcell.titleimage.image = [UIImage imageNamed:[_imageList objectAtIndex:oldindex.row]];
        oldcell.selected = NO;
        oldindex = indexPath;
        [oldindex retain];

    }

//    LeftCell *cell = (LeftCell *)[tableView viewWithTag:indexPath.row +1];
//    cell.titleimage.image = [UIImage imageNamed:[_image_HGList objectAtIndex:indexPath.row]];
//    for (int i = 1; i<_dataList.count +1; i++) {
//        if (i != indexPath.row+1) {
//            LeftCell *cell1 = (LeftCell *)[tableView viewWithTag:i];
//            cell1.titleimage.image = [UIImage imageNamed:[_imageList objectAtIndex:i - 1]];
//        }
//    }
    
    
    NSString *str = [_dataList objectAtIndex:indexPath.row];
    if (![self checkIdentify:str]) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您必须成为融商正式会员后才能使用此功能！" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) otherButtonTitles:@"申请正式加盟", nil];
        [alert show];
        [alert release];
        return;
    }
    if ([str isEqualToString:NSLocalizedString(@"Left_mainTable_HYZC", nil)]) {
        PBMainCompaniesController *controller = [[PBMainCompaniesController alloc] init];
        PBNavigationController *nav = [[PBNavigationController alloc] initWithRootViewController:controller];
        nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        nav.navigationBarHidden = YES;
        [self presentModalViewController:nav animated:YES];
        [controller release];
        [nav release];
    }
    else if ([str isEqualToString:@"园区之窗"])
    {
        
        PBMainViewController *controller = [[PBMainViewController alloc] init];
        PBNavigationController *nav = [[PBNavigationController alloc] initWithRootViewController:controller];
        nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        nav.navigationBarHidden = YES;
        [self presentModalViewController:nav animated:YES];
        [controller release];
        [nav release];
    }
    else{
        if ([delegate respondsToSelector:@selector(leftSideBarSelectWithController:)]) {
            [delegate leftSideBarSelectWithController:[self subConWithIndex:indexPath.row]];
        }
    }
       
}
//判断是否为游客
-(BOOL)checkIdentify:(NSString*)str{
    
    if ([PBUserModel getPasswordAndKind].kind==0) {
        if ([str isEqualToString:NSLocalizedString(@"Left_mainTable_RZXQ", nil)]||[str isEqualToString:NSLocalizedString(@"Left_mainTable_LCXQ", nil)]||[str isEqualToString:@"融资申请"]) {
            return NO;
        }
    }
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"APPLYJOININ" object:nil];
//        PBdataClass *dataclass = [[PBdataClass alloc] init];
//        dataclass.delegate = self;
//        [dataclass dataResponse:Joininapply_URL postDic:[NSDictionary dictionaryWithObjectsAndKeys:USERNO,@"userno",[PBUserModel getTel],@"tel", nil] searchOrSave:NO];
    }
    
}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString *)intvalue{
    if ([intvalue integerValue] ==  1) {
        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"申请成功" message:@"申请加盟成功,稍后有服务人员与你联系" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alt show];
        [alt release];
        [self performSelector:@selector(dismissAlt:) withObject:alt afterDelay:2.0];
    }
    [dataclass release];
}

-(void)searchFilad{
    UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络不流畅" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alt show];
    [alt release];
}
-(void)dismissAlt:(UIAlertView *)alt{
    [alt dismissWithClickedButtonIndex:0 animated:YES];
}
- (PBNavigationController *)subConWithIndex:(int)index
{
    UIViewController *VC = nil;
    NSString *str;
    if (index == -1) {
        str = @"关于我们";
    }
    else
    {
        str = [_dataList objectAtIndex:index];
    }
    if ([str isEqualToString:NSLocalizedString(@"Left_mainTable_RS", nil)]) {// 金融咨询资讯
        if (click) {
            [PBUnreadMessageData updateOldNumWithKind:@"zixun"];
            LeftCell *cell = (LeftCell*)[mainTableView cellForRowAtIndexPath:oldindex];
            cell.unreadmessage.hidden = YES;
        }else{
            click = !click;
        }
        PBFinancingNews *FinacingNews = [[PBFinancingNews alloc] init];
        FinacingNews.title = NSLocalizedString(@"Left_mainTable_RS", nil);
        VC = FinacingNews;
    }
    else if ([str isEqualToString:NSLocalizedString(@"Left_mainTable_RZXQ", nil)]){ // 融资需求
        PBMyFinanceNeedsList *FinacingNeed = [[PBMyFinanceNeedsList alloc] init];
         FinacingNeed.title = NSLocalizedString(@"Left_mainTable_RZXQ", nil);
        VC=FinacingNeed;
    }
    else if ([str isEqualToString:NSLocalizedString(@"Left_mainTable_LCXQ", nil)]){  //理财需求
        PBMyManageMoneyNeedsList *managemoney = [[PBMyManageMoneyNeedsList alloc] init];
        managemoney.title = NSLocalizedString(@"Left_mainTable_LCXQ", nil);
        VC = managemoney;
    }

    else if ([str isEqualToString:NSLocalizedString(@"Left_mainTable_JRCS", nil)]){  //金融超市
        PBFinancalProductsController* allproduct = [[PBFinancalProductsController alloc]init];
        allproduct.flag = 1;
        allproduct.title = NSLocalizedString(@"Left_mainTable_JRCS", nil);
        VC = allproduct;
    }
    else if ([str isEqualToString:NSLocalizedString(@"Left_mainTable_QYGQ", nil)]){  //企业供求
        PBIndustryOpportunityList *class = [[PBIndustryOpportunityList alloc] init];
        VC = class;
    }
    else if ([str isEqualToString:@"关于我们"]){  //关于我们
        PBAboutUsView *controller = [[PBAboutUsView alloc] init];
        VC = controller;  
    }
    else{
        
    }
    PBNavigationController *nav= [[PBNavigationController alloc] initWithRootViewController:VC];
    [self customNav:nav];
    [self customNavLeft:VC withBlock:^{
        if ([[PBSidebarVC share] respondsToSelector:@selector(showSideBarControllerWithDirection:)] && [[PBSidebarVC share] sideBarShowing] == NO) {
            [[PBSidebarVC share] showSideBarControllerWithDirection:SideBarShowDirectionLeft];
        }
        else if ([[PBSidebarVC share] sideBarShowing] == YES){
            [[PBSidebarVC share] showSideBarControllerWithDirection:SideBarShowDirectionNone];
        }
    }];
    [self customNavRight:VC];

    [nav.navigationBar setBarStyle:UIBarStyleBlack];
    [VC release];
    return nav;
}

@end
