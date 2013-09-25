//
//  PBinfocenterLeftVC.m
//  ParkBusiness
//
//  Created by China on 13-8-26.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBinfocenterLeftVC.h"
#import "PBinfoCenter.h"
#import "SideBarSelectedDelegate.h"
#import "NSObject+NAV.h"
#import "PBFinancing.h"
#import "PBsixin.h"
#import "PBpinglun.h"
#import "PBhuodong.h"
#import "PBguanzhu.h"
#import "PBouerquestion.h"
#import "PBxinwenSC.h"
#import "PBJinRongSC.h"
#import "PBAnLiSC.h"
#import "PBLicaiNewsSC.h"
#import "PBJigouNewsSC.h"
#import "PBhangyeshangjiSC.h"
#import "PBjinrongzhuanlan.h"
#import "PBBusinessPlanText.h"
#import "PBtiwenhuida.h"
#import "PBshoucang.h"
#import "PBBusinessFiancingNeed.h"
#import "PBBusinessLicaiNeed.h"
#import "PBUnreadMessageData.h"
#import "LeftCell.h"
#import "PBPublicSC.h"
#import "PBHightSC.h"
#import "PBProjectList.h"
//#import "PBFinancingNews.h"
#define UNREADURL [NSString stringWithFormat:@"%@/admin/index/searchunreadmessage",HOST]
@interface PBinfocenterLeftVC ()
{

}

@end

@implementation PBinfocenterLeftVC
@synthesize delegate;
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
    
#pragma mark - 信息管理
    NSMutableArray *arr;
    NSMutableArray *imagearr;
    NSMutableArray *image_hgarr;
    if ([PBUserModel getPasswordAndKind].kind < 3) {
            arr = [NSMutableArray arrayWithObjects:@"金融专栏",@"融资申请",@"我的私信",@"公益培训报名",@"高端课程报名",@"我的评论",@"我的提问",@"参加的活动",@"关注我",@"金融资讯收藏",@"理财资讯收藏",@"机构资讯收藏",@"企业供求收藏",@"金融产品收藏",@"金融案例收藏",nil];
        imagearr = [[NSMutableArray alloc] initWithObjects:@"ct_jrzl.png",@"rongzishengqin.png",@"ct_wdsx.png",@"ct_wdpl.png",@"ct_wdtw.png",@"ct_cjdhd.png",@"ct_gzw.png",@"ct_jrzxsc.png",@"ct_lczxsc.png",@"ct_jgzxsc.png",@"ct_qygqsc.png",@"ct_jrcpsc.png",@"ct_jralsc.png",@"ct_gypxbm.png",@"ct_gdpxbm.png", nil];
        image_hgarr = [[NSMutableArray alloc] initWithObjects:
                       @"ct_jrzl1.png",
                       @"rongzishengqin_hg.png",
                       @"ct_wdsx1.png",
                       @"ct_wdpl1.png",
                       @"ct_wdtw1.png",
                       @"ct_cjdhd1.png",
                       @"ct_gzw1.png",
                       @"ct_jrzxsc1.png",
                       @"ct_lczxsc1.png",
                       @"ct_jgzxsc1.png",
                       @"ct_qygqsc1.png",
                       @"ct_jrcpsc1.png",
                       @"ct_jralsc1.png",
                       @"ct_gypxbm1.png",
                       @"ct_gdpxbm1.png",
                       nil];
    }else {
            arr = [NSMutableArray arrayWithObjects:@"金融专栏",@"我的私信",@"提问回答",@"公益培训报名",@"高端课程报名",@"企业融资需求",@"企业理财需求",@"金融项目",@"关注我",@"金融资讯收藏",@"理财资讯收藏",@"机构资讯收藏",@"企业供求收藏",@"金融产品收藏",@"金融案例收藏",nil];
        imagearr = [[NSMutableArray alloc] initWithObjects:@"ct_jrzl.png",@"ct_wdsx.png",@"ct_wdtw.png",@"ct_qyrzxq.png",@"ct_lcxq.png",@"ct_jrxm.png",@"ct_gzw.png",@"ct_jrzxsc.png",@"ct_lczxsc.png",@"ct_jgzxsc.png",@"ct_qygqsc.png",@"ct_jrcpsc.png",@"ct_jralsc.png",@"ct_gypxbm.png",@"ct_gdpxbm.png",  nil];
        image_hgarr = [[NSMutableArray alloc] initWithObjects:
                       @"ct_jrzl1.png",
                       @"ct_wdsx1.png",
                       @"ct_wdtw1.png",
                       @"ct_qyrzxq1.png",
                       @"ct_lcxq1.png",
                       @"ct_jrxm1.png",
                       @"ct_gzw1.png",
                       @"ct_jrzxsc1.png",
                       @"ct_lczxsc1.png",
                       @"ct_jgzxsc1.png",
                       @"ct_qygqsc1.png",
                       @"ct_jrcpsc1.png",
                       @"ct_jralsc1.png",
                       @"ct_gypxbm1.png",
                       @"ct_gdpxbm1.png",
                       nil];
        }
    self._dataList = arr;
    self._imageList = imagearr;
    self._image_HGList = image_hgarr;
    [imagearr release];
    [image_hgarr release];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //获取未读信息
    PBWeiboDataConnect* connect = [[PBWeiboDataConnect alloc]init];
    connect.delegate = self;
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:USERNO,@"userno",[NSString stringWithFormat:@"%d",[PBUserModel getPasswordAndKind].kind],@"kind",nil];
    [connect getXMLDataFromUrl:UNREADURL postValuesAndKeys:dic];
}
//成功获取未读信息
-(void)sucessParseXMLData:(PBWeiboDataConnect *)weiboDatas{
    if([weiboDatas.parseData count]>0){
        [PBUnreadMessageData updateMessageData:[weiboDatas.parseData objectAtIndex:0]];
        [self.mainTableView reloadData];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell";
    LeftCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:isPad()?@"LeftCell_iPad":@"LeftCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        UIImageView *iamgeview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heibeijing.png"]];
        cell.selectedBackgroundView  = iamgeview;
        [iamgeview release];
    }
    cell.titlestr.text = [self._dataList objectAtIndex:indexPath.row];
    cell.titlestr.textColor = [UIColor whiteColor];
    NSString *str = [self._dataList objectAtIndex:indexPath.row];
    int unreadcount = 0;
    if ([str isEqualToString:@"金融专栏"]) {
        unreadcount = [PBUnreadMessageData countOfUnreadMessageWithKind:@"zhuanlan"];
    }
    else if ([str isEqualToString:@"关注我"]) {
        unreadcount = [PBUnreadMessageData countOfUnreadMessageWithKind:@"guanzhu"];
    }
    else if ([str isEqualToString:@"我的私信"]) {
        unreadcount = [PBUnreadMessageData countOfUnreadMessageWithKind:@"sixin"];
    }
    else if ([str isEqualToString:@"提问回答"]) {
        unreadcount = [PBUnreadMessageData countOfUnreadMessageWithKind:@"tiwen"];
    }
    else if ([str isEqualToString:@"金融项目"]) {
        unreadcount = [PBUnreadMessageData countOfUnreadMessageWithKind:@"xiangmu"];
    }
    else if ([str isEqualToString:@"企业融资需求"]) {
        unreadcount = [PBUnreadMessageData countOfUnreadMessageWithKind:@"rongzi"];
    }
    else if ([str isEqualToString:@"企业理财需求"]) {
        unreadcount = [PBUnreadMessageData countOfUnreadMessageWithKind:@"licai"];
    }
    if (unreadcount>0) {
        if (isPad()) {
            CGRect frame = cell.unreadmessage.frame;
            frame.origin.x -= 70;
            cell.unreadmessage.frame = frame;
        }
        cell.unreadmessage.hidden = NO;
        [cell.unreadmessage setTitle:[NSString stringWithFormat:@"%d",unreadcount] forState:UIControlStateDisabled];
        [cell.unreadmessage setBackgroundImage:[UIImage imageNamed:@"info_unread"] forState:UIControlStateDisabled];
    }
    if ((oldindex.row ==  indexPath.row) && oldindex) {
        cell.titleimage.image = [UIImage imageNamed:[self._image_HGList objectAtIndex:indexPath.row]];
    }
    else{
        cell.titleimage.image = [UIImage imageNamed:[self._imageList objectAtIndex:indexPath.row]];

    }
    return cell;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    
//    [self.mainTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
//    [self.mainTableView.delegate tableView:self.mainTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
       [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(HUIDANOTIFICATION:) name:@"回答的通知" object:nil];
}
-(void)initView{

    UIImageView *topview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, VIEWSIZE.width, isPad()?130: 60)];
    UIImage *image = [UIImage imageNamed:@"center_top.jpg"];
    topview.image = image;
    [self.view addSubview:topview];
    [topview release];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(7, isPad()?15:10, isPad()?100:40, isPad()?100:40);
    [btn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(popBackAgoView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UILabel *labele =[[UILabel alloc] initWithFrame:CGRectMake(btn.frame.size.width+15, 0, isPad()?280:180, topview.frame.size.height)];
    labele.backgroundColor = [UIColor clearColor];
    labele.font = [UIFont systemFontOfSize:isPad()?50:35];
    labele.text = @"信息中心";
    labele.textColor = [UIColor whiteColor];
    [self.view addSubview:labele];
    [labele release];
}
-(void)popBackAgoView{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"APPLYJOININ" object:self];
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 让定制的cell点击时换掉图片
    if ((oldindex.row !=  indexPath.row) || !oldindex) {
        UITableViewCell *cell1 = [tableView cellForRowAtIndexPath:indexPath];
        LeftCell *cell = (LeftCell *)cell1;
        cell.titleimage.image = [UIImage imageNamed:[self._image_HGList objectAtIndex:indexPath.row]];
        
        LeftCell *oldcell = (LeftCell *)[tableView cellForRowAtIndexPath:oldindex];
        oldcell.titleimage.image = [UIImage imageNamed:[self._imageList objectAtIndex:oldindex.row]];
        oldcell.selected = NO;
        oldindex = indexPath;
        [oldindex retain];
        
    }
    NSString *str = [_dataList objectAtIndex:indexPath.row];
    if (![super checkIdentify:str]) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您必须成为融商正式会员后才能使用此功能！" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) otherButtonTitles:@"申请正式加盟", nil];
        [alert show];
        [alert release];
        return;
    }
    if ([delegate respondsToSelector:@selector(leftSideBarSelectWithController:)]) {
        [delegate leftSideBarSelectWithController:[self subConWithIndex:indexPath.row]];
    }
}
-(void)HUIDANOTIFICATION:(NSNotification *)notifation
{
    NSString *str = notifation.object;
    if ([str isEqualToString:@"企业融资需求"])
    {
        NSInteger a = [self._dataList indexOfObject:str];
        [self subConWithIndex:a];
    }
    else if([str isEqualToString:@"企业理财需求"])
    {
        NSInteger a = [self._dataList indexOfObject:str];
        [self subConWithIndex:a];
    }
    
    
    else{
        [self subConWithIndex:5];
    }
    
}
- (UINavigationController *)subConWithIndex:(int)index
{
    UIViewController *VC = nil;
    NSString *str = [self._dataList objectAtIndex:index];
    if ([str isEqualToString:@"理财资讯收藏"]) {
        VC = [[PBLicaiNewsSC alloc] init];
//        PBFinancingNews *FinacingNews = [[PBFinancingNews alloc] init];
//        FinacingNews.title = @"融商资讯";
//        VC = FinacingNews;
    }
    else if ([str isEqualToString:@"公益培训报名"]) {
        VC = [[PBPublicSC alloc]init];
    }
    else if ([str isEqualToString:@"高端课程报名"]) {
        VC = [[PBHightSC alloc]init];
    }
    else if ([str isEqualToString:@"机构资讯收藏"]) {
        VC = [[PBJigouNewsSC alloc]init];
    }
    else if ([str isEqualToString:@"我的评论"]) {
        VC = [[PBpinglun alloc]init];
    }
    else if ([str isEqualToString:@"参加的活动"]) {
        VC = [[PBhuodong alloc]init];
    }
    else if ([str isEqualToString:@"我的提问"]) {
        VC = [[PBouerquestion alloc]init];
    }
    else if ([str isEqualToString:@"金融资讯收藏"]) {
        VC = [[PBxinwenSC alloc]init];
    }
    else if ([str isEqualToString:@"金融产品收藏"]) {
        VC = [[PBJinRongSC alloc]init];
    }
    else if ([str isEqualToString:@"金融案例收藏"]) {
        VC = [[PBAnLiSC alloc]init];
    }
    else if ([str isEqualToString:@"金融政策收藏"]) {
        VC = [[PBhuodong alloc]init];
    }
    else if ([str isEqualToString:@"企业供求收藏"]) {
        VC = [[PBhangyeshangjiSC alloc]init];
    }
    else if([str isEqualToString:@"融资申请"]){  //融资申请
        VC = [[PBProjectList alloc] initWithStyle:UITableViewStyleGrouped];
    }
    else if ([str isEqualToString:@"金融专栏"]) {
        if (click) {
            [PBUnreadMessageData updateOldNumWithKind:@"zhuanlan"];
            [self.mainTableView reloadData];
        }else{
            click = !click;
        }
        VC = [[PBjinrongzhuanlan alloc]init];
        [self.mainTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];

    }
    else if ([str isEqualToString:@"关注我"]) {
        [PBUnreadMessageData updateOldNumWithKind:@"guanzhu"];
        [self.mainTableView reloadData];
        [self.mainTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        VC = [[PBguanzhu alloc]init];
    }
    else if ([str isEqualToString:@"我的私信"]) {
        [PBUnreadMessageData updateOldNumWithKind:@"sixin"];
        [self.mainTableView reloadData];
        [self.mainTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        VC = [[PBsixin alloc]init];
    }
    else if ([str isEqualToString:@"商业计划书"]) {
        VC = [[PBBusinessPlanText alloc]init];
    }
    else if ([str isEqualToString:@"提问回答"]) {
        [PBUnreadMessageData updateOldNumWithKind:@"tiwen"];
        [self.mainTableView reloadData];
        [self.mainTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        VC = [[PBtiwenhuida alloc]init];
    }
    else if ([str isEqualToString:@"金融项目"]) {
        [PBUnreadMessageData updateOldNumWithKind:@"xiangmu"];
        [self.mainTableView reloadData];
        [self.mainTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        VC = [[PBshoucang alloc]init];
    }
    else if ([str isEqualToString:@"企业融资需求"]) {
        [PBUnreadMessageData updateOldNumWithKind:@"rongzi"];
        [self.mainTableView reloadData];
        [self.mainTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        VC = [[PBBusinessFiancingNeed alloc]init];
    }
    else if ([str isEqualToString:@"企业理财需求"]) {
        [PBUnreadMessageData updateOldNumWithKind:@"licai"];
        [self.mainTableView reloadData];
        [self.mainTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        VC = [[PBBusinessLicaiNeed alloc]init];
    }
    else if ([str isEqualToString:@"我的Q/A"]) {
        VC = [[PBBusinessLicaiNeed alloc]init];
    }

    VC.title = str;
    PBNavigationController *nav= [[PBNavigationController alloc] initWithRootViewController:VC];
    [self customNav:nav];
    
    [self customNavLeft:VC withBlock:^{
        if ([[PBinfoCenter share] respondsToSelector:@selector(showSideBarControllerWithDirection:)] && [[PBinfoCenter share] sideBarShowing] == NO) {
            [[PBinfoCenter share] showSideBarControllerWithDirection:SideBarShowDirectionLeft];
        }
        else if ([[PBinfoCenter share] sideBarShowing] == YES){
            [[PBinfoCenter share] showSideBarControllerWithDirection:SideBarShowDirectionNone];
        }
    }];
    
    [nav.navigationBar setBarStyle:UIBarStyleBlack];
    [VC release];
    return nav;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
