//
//  PBRightVC.m
//  PBParkBusiness
//
//  Created by China on 13-8-19.
//  Copyright (c) 2013年 WINSEN. All rights reserved.
//
#define Joininapply_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/joininapply",HOST]]
#define COMPANYURL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchcompanyinfo",HOST]]
#define FINANCEURL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchfinancinginstitution",HOST]]
#define shengji_URL [NSString stringWithFormat:@"%@/admin/index/levelup",HOST]
#define CREDITURL @"http://www.ifdz.net/credit.html"
#import "PBRightVC.h"
#import "LeftCell.h"
#import "PBSidebarVC.h"
#import "SideBarSelectedDelegate.h"
#import "PBMainViewController.h"
#import "PBFinancialCaseController.h"
#import "NSObject+NAV.h"
#import "Personal.h"
#import "PBAboutUsView.h"
#import "PBfankui.h"
#import "PBHelpView.h"
#import "PBwelcomeVC.h"
#import "PBinfoCenter.h"
#import "UIImageView+CreditLevel.h"
#import "PBShezhiData.h"
#import "PBWebViewController.h"
#import "PBInsertDataModel.h"
#import "PBCompanyData.h"
#import "PBJoinBusinessUnionVC.h"
#import "PBSettings.h"
//#import "PBFinancingNews.h"
//#import "PBpersonerInfo.h"
//#import "PBChooseJobController.h"
#import <ShareSDK/ShareSDK.h>
@interface PBRightVC ()
{
    NSArray *_dataList;
    NSArray *_imageList;
    int _selectIdnex;
}
@end

@implementation PBRightVC
@synthesize shezhi,xinxizhongxin,guanyuwomen,bangzhu,fankui,icon_image,icon_image_back,starImage,tuijian_btn,Join_btn,name;
@synthesize delegate;
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    presentController = self;    
    _dataList = [[NSArray alloc ] initWithObjects :@"园区之窗",NSLocalizedString(@"Left_mainTable_JRAL", nil), nil];
    _imageList = [[NSArray alloc] initWithObjects:@"yuanquzhichuan.png",@"jinronganli.png", nil];
    for (int i = 10; i<16; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
        [btn setBackgroundImage:[UIImage imageNamed:@"heibeijing.png"] forState:UIControlStateHighlighted];
    }
    
    //游客身份正式加入联盟按钮隐藏
    if ([PBUserModel getPasswordAndKind].kind==0) {
        self.Join_btn.hidden = NO;
    }
    else{
         self.Join_btn.hidden = YES;
    }
    
    
    /******可滑动界面右边按钮的不同，通过注册此通知完成点击右边按钮的一些操作
     *********/
    [[NSNotificationCenter defaultCenter] addObserverForName:nil object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        if ([note.name isEqualToString:@"RIGHTSIDE"]) {
            [[PBSidebarVC share] showSideBarControllerWithDirection:SideBarShowDirectionRight];
        }
        if ([note.name isEqualToString:@"APPLYJOININ"]) {
            if (note.object) {
                presentController = (UIViewController*)note.object;
            }else{
                presentController = self;
            }
            NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
            if ([userData integerForKey:@"kind"]==0) {
                [self performSelector:@selector(JoinTheAlliance)];;//加盟
            }else{	
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的申请已再审核中，请稍等！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            
        }
    }];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didicon_image_btn:)];
    [self.icon_image_back addGestureRecognizer:tap];
    
    [tap release];
}
#pragma mark - 点击头像 Method
-(void)didicon_image_btn:(UITapGestureRecognizer *)tap{
     PBSettings*setting = [[PBSettings alloc]initWithStyle:UITableViewStyleGrouped withString:@"行业划分:"];
    PBNavigationController *nav = [[PBNavigationController alloc] initWithRootViewController:setting];
    [self customButtom:setting];
    [self customNav:nav];
    [self presentModalViewController:nav animated:YES];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [starImage setStarImageWithCredit:[PBUserModel getCredit]];
    //获得的本地数据，头像与名字
    NSMutableArray* data = [PBShezhiData searchBy:[PBUserModel getUserId]];
    PBShezhiData* user = [data objectAtIndex:0];
    icon_image.image = user.imagepath;
    name.text = user.name;
}
-(IBAction)btnPress:(id)sender{
    UIButton *btn = (UIButton *)sender;

    //    if (btn.tag != 11 && btn.tag!= 14&& btn.tag!= 15 && btn.tag!= 16 && btn.tag!= 17) {
    //
    //    }
    //    else{
    switch (btn.tag) {
        case 11:{   //信息中心
            PBinfoCenter *sidebar = [[PBinfoCenter alloc] init];
//            PBFinancingNews *sidebar = [[PBFinancingNews alloc] init];
            sidebar.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentModalViewController:sidebar animated:YES];
            [sidebar release];
  
        }
        case 13:{   //反馈
            
            PBfankui *controller1 = [[PBfankui alloc] initWithStyle:UITableViewStyleGrouped];
            PBNavigationController *nav = [[PBNavigationController alloc] initWithRootViewController:controller1];
            [self customNav:nav];
            [self customButtom:controller1];
            [self presentModalViewController:nav animated:YES];
        }
            break;
        case 14:{   //帮助
            
            PBwelcomeVC *controller = [[PBwelcomeVC alloc] init];
            [self customButtom:controller];
            [self presentModalViewController:controller animated:YES];
            [controller release];
        }
            
            break;
        case 15:{//推荐
            [self shareThirdApp];
        }
            
            break;
        case 16:{
            NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
            if ([userData integerForKey:@"kind"]==0) {
                [self JoinTheAlliance];//加盟
            }else{
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的申请已再审核中，请稍等！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            
        }
            break;
        case 17:{
            [self  upgrade];        //升级
        }
            
            break;
            
        default:
        {
            if ([delegate respondsToSelector:@selector(leftSideBarSelectWithController:)]) {
                if (btn.tag == _selectIdnex) {
                    [delegate leftSideBarSelectWithController:nil];
                }else
                {
                    [delegate leftSideBarSelectWithController:[self subConWithIndex:btn.tag]];
                }
            }
        }
            break;
    }

}
-(void)shareThirdApp{
    //定义菜单分享列表
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeSMS,ShareTypeMail,ShareTypeWeixiSession,ShareTypeWeixiTimeline, nil];
    
    //创建分享内容
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:IMAGE_NAME ofType:IMAGE_EXT];
    id<ISSContent> publishContent = [ShareSDK content:CONTENT
                                       defaultContent:@""
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"融商"
                                                  url:@"http://www.ifdz.net/install.html"
                                          description:@"融商应用分享"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //创建容器
    id<ISSContainer> container = [ShareSDK container];
    UIButton* shareBtn = (UIButton*)[self.view viewWithTag:15];
    [container setIPadContainerWithView:shareBtn arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"i金融开发区"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"i金融开发区"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    id<ISSShareOptions> shareOptions = [ShareSDK simpleShareOptionsWithTitle:@"内容分享" shareViewDelegate:nil];
    //显示分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:shareOptions
                            result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess)
                                {
                                    PBAlertView* alert = [[PBAlertView alloc]initWithMessage:@"分享成功！"];
                                    [alert show];
                                    [alert release];
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    PBAlertView* alert = [[PBAlertView alloc]initWithMessage:[error errorDescription]];
                                    [alert show];
                                    [alert release];
                                    
                                }
                            }];
}
- (UINavigationController *)subConWithIndex:(int)index
{
    UIViewController *VC = nil;
    switch (index) {
            //        case 1:{//金融案例
            //            PBFinancialCaseController *controller = [[PBFinancialCaseController alloc] init];
            //            VC = controller;
            //        }
            break;
        case 10://个人设置
        {
            Personal *controller = [[Personal alloc] init];
//            PBpersonerInfo *controller = [[PBpersonerInfo alloc] initWithStyle:UITableViewStyleGrouped];
            VC = controller;

        }
            break;
        case 12://关于我们
        {
            PBAboutUsView *controller = [[PBAboutUsView alloc] init];
            VC = controller;
        }
            break;
            //        case 13://反馈
            //        {
            //            PBfankui *controller = [[PBfankui alloc] initWithStyle:UITableViewStyleGrouped];
            //           VC = controller;
            //        }
            break;
            //        case 14://帮助
            //        {
            //            PBwelcomeVC *controller = [[PBwelcomeVC alloc] init];
            //            VC = controller;
            //        }
            break;
            
        default:
            break;
    }
    PBNavigationController *nav= [[PBNavigationController alloc] initWithRootViewController:VC];
    [nav.navigationBar setBarStyle:UIBarStyleBlack];
    [self customNav:nav];
    [self customNavLeft:VC withBlock:^{
        if ([[PBSidebarVC share] respondsToSelector:@selector(showSideBarControllerWithDirection:)] && [[PBSidebarVC share] sideBarShowing] == NO) {
            [[PBSidebarVC share] showSideBarControllerWithDirection:SideBarShowDirectionLeft];
        }
        else if ([[PBSidebarVC share] sideBarShowing] == YES){
            [[PBSidebarVC share] showSideBarControllerWithDirection:SideBarShowDirectionNone];
        }
    }];
    if (index != 13) {
        [self customNavRight:VC];
    }
    
    [VC release];
    return nav ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 升级
-(void)upgrade{
    indicator = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:indicator];
    [indicator startAnimating];
    PBInsertDataConnect* connect = [[PBInsertDataConnect alloc] init];
    connect.delegate = self;
    int kind = [[NSUserDefaults standardUserDefaults] integerForKey:@"kind"];
    [connect getUpgradeDataFromUrl:shengji_URL withDic:
     [NSMutableDictionary dictionaryWithObjectsAndKeys:VERSION,@"version",[PBUserModel getTel],@"tel",
                                                        kind==2?@"5":[NSString stringWithFormat:@"%d",[PBUserModel getPasswordAndKind].kind],@"kind",
                                                        [NSString stringWithFormat:@"%d",[PBUserModel getParkNo]],@"parkno",
      nil]];
}
-(void)successGetUpgradeData:(NSMutableDictionary*)insertData{
    [indicator stopAnimating];
    NSMutableDictionary* stateDic = [insertData objectForKey:@"states"];
    if ([insertData objectForKey:@"versions"]) {//有新版本更新
       NSMutableArray* versionArr = [insertData objectForKey:@"versions"];
        NSString* state = [stateDic objectForKey:@"state"];
        if ([state isEqualToString:@"1"]) {//成功加盟
            [self hasJoinTheAlliance:[stateDic objectForKey:@"companyno"]];
        }
        BOOL succ = YES;
        upgradeUrl = [[versionArr objectAtIndex:0] objectForKey:@"url"];
        for (NSMutableDictionary* dic in versionArr) {//更新SQL
            NSString* sql = [dic objectForKey:@"sql"];
            if (![PBUserModel executeWithSql:sql]) {
                succ = NO;
                break;
            }
        }
        if (succ) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已获取最新版本 是否更新？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            alert.tag = 2;
            [alert show];
            [alert release];
        }else{
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"更新失败 请稍后更新" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
    }else{//最新版本
        if ([[stateDic objectForKey:@"state"] isEqualToString:@"0"]||[PBUserModel getPasswordAndKind].kind!=0) {
            PBAlertView* alert = [[PBAlertView alloc]initWithMessage:@"您当前已为最新版本！"];
            [alert show];
            [alert release];
        }else{//成功加盟
            [self hasJoinTheAlliance:[stateDic objectForKey:@"companyno"]];
            PBAlertView* alert = [[PBAlertView alloc]initWithMessage:@"您已成功加盟！"];
            [alert show];
            [alert release];
        }
    }
}
//成功加盟会员更新公司数据
-(void)hasJoinTheAlliance:(NSString*)companyno{
    PBAlertView* alert = [[PBAlertView alloc]initWithMessage:@"您已成功加盟！"];
    [alert show];
    [alert release];
    [PBUserModel updateCompanyno:[companyno intValue]];
    PBdataClass *dataclass = [[PBdataClass alloc] init];
    dataclass.delegate = self;
    NSUserDefaults* userData = [NSUserDefaults standardUserDefaults];
    if ([userData integerForKey:@"kind"]==1) {//企业家会员
        [dataclass dataResponse:COMPANYURL postDic:[NSDictionary dictionaryWithObjectsAndKeys:companyno,@"no", nil] searchOrSave:YES];
    }else{//金融人士会员
        [dataclass dataResponse:FINANCEURL postDic:[NSDictionary dictionaryWithObjectsAndKeys:companyno,@"no", nil] searchOrSave:YES];
    }
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas{
    NSUserDefaults* userData = [NSUserDefaults standardUserDefaults];
    if ([userData integerForKey:@"kind"]==1) {//企业家会员
        [PBInsertDataModel saveCompanyInfoRecord:[datas objectAtIndex:0]];
        [PBUserModel updateKind:2];
    }else{//金融人士会员
        [self saveFinancingInstitudeInfo:[datas objectAtIndex:0]];
        [PBUserModel updateKind:3];
    }
    [userData setInteger:-1 forKey:@"kind"];
    [userData synchronize];
}
//保存金融机构信息
-(void)saveFinancingInstitudeInfo:(NSMutableDictionary*)dic{
    PBCompanyData *data = [[PBCompanyData alloc]init];
    data.parkno = [PBUserModel getParkNo];
    data.no = [[dic objectForKey:@"no"] intValue];
    UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOST,[dic objectForKey:@"imagepath"]]]]];
    data.image = image;
    data.name = [dic objectForKey:@"name"];
    [data saveRecord];
}
#pragma mark - 申请加入联盟
-(void)JoinTheAlliance
{
    UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"请确认" message:@"选择申请正式加盟的会员类型" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) otherButtonTitles:@"企业人士",@"金融人士", nil];
    alt.alertViewStyle = UIAlertViewStyleDefault;
    [alt show];
    [alt release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==2) {
        if (buttonIndex==1) {//更新APP
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:upgradeUrl]];
        }
    }else{
        if (buttonIndex == 1) {
            PBdataClass *dataclass = [[PBdataClass alloc] init];
            dataclass.delegate = self;
            [dataclass dataResponse:Joininapply_URL postDic:[NSDictionary dictionaryWithObjectsAndKeys:USERNO,@"userno",[PBUserModel getTel],@"tel", nil] searchOrSave:NO];
        }
        if(buttonIndex == 2){
            PBJoinBusinessUnionVC *join = [[PBJoinBusinessUnionVC alloc] initWithStyle:UITableViewStyleGrouped];
            join.title = @"申请加盟";
            PBNavigationController *nav = [[PBNavigationController alloc] initWithRootViewController:join];
            [self customButtom:join];
            [self customNav:nav];
            [presentController presentModalViewController:nav animated:YES];
        }
    }
}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString *)intvalue{
    if ([intvalue integerValue] ==  1) {
        NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
        [userData setInteger:1 forKey:@"kind"];
        [userData synchronize];
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
-(IBAction)goCreditIntroduce:(id)sender{
    PBWebViewController* web = [[PBWebViewController alloc]init];
    web.url = CREDITURL;
    web.title = @"诚信积分介绍";
    PBNavigationController* navi = [[PBNavigationController alloc]initWithRootViewController:web];
    [navi.navigationBar setBackgroundImage:[UIImage imageNamed:@"topnavigation.png"] forBarMetrics:UIBarMetricsDefault];
    navi.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController presentModalViewController:navi animated:YES];
    
}
@end
