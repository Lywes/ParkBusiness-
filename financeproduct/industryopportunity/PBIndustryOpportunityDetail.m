//
//  PBIndustryOpportunityDetail.m
//  ParkBusiness
//
//  Created by 上海 on 13-7-1.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define URL [NSString stringWithFormat:@"%@admin/index/searchindustryopportunity", HOST]
#import "PBIndustryOpportunityDetail.h"
#import "CustomImageView.h"
#import "PBQuestionListController.h"
#import "PBFinancInstitutDetailController.h"
#import "PBPrivateMessagesController.h"
#import "PBImageScrollView.h"
#import "PBCompanyDataManager.h"
#import "FAChatManager.h"
#import "PBRemarkListController.h"
#import "UIImageView+CreditLevel.h"
#import "PBStarEntrepreneursDetail.h"
@interface PBIndustryOpportunityDetail ()

@end

@implementation PBIndustryOpportunityDetail
@synthesize dataDictionary, detailTableView;
@synthesize searchDetail;
@synthesize flag;
@synthesize rootController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(7, 7, 25, 30);
        [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(popPreView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = item;
        myself = NO;
        [item release];
        
//        self.navigationController.navigationBar
    }
    return self;
}
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [inputToolbar keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [inputToolbar keyboardWillShowHide:notification];
    [inputToolbar keyboardWillHide];
}
-(void)remarkDidPush{
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) destructiveButtonTitle:nil otherButtonTitles:@"我要跟帖",@"跟帖列表", nil];
    [sheet showInView:self.navigationController.view];
    [sheet release];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [inputToolbar.textView becomeFirstResponder];
            break;
        case 1:{
            PBRemarkListController *controller = [[PBRemarkListController alloc] init];
            //需要传递一些参数过去
            controller.title = @"跟帖列表";
            NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:dataDictionary];
            [dic setObject:@"11" forKey:@"remarktype"];
            controller.infoDic = dic;
            [self.navigationController pushViewController: controller animated:YES];
            [controller release];
        }
            break;
        default:
            break;
    }
}
-(void)inputButtonPressed:(NSString *)inputText
{
    [indicator startAnimating];
    sendmanager = [[PBWeiboDataConnect alloc] init];
    sendmanager.delegate= self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"11", @"type", [NSString stringWithFormat:@"%d", [PBUserModel getUserId]], @"userno", [self.dataDictionary objectForKey:@"no"], @"commentno", inputText, @"content", nil];
    [sendmanager submitDataFromUrl:REMARKINFO postValuesAndKeys:dic];
    
}
-(void)viewTap:(UITapGestureRecognizer*)tap{
    [inputToolbar keyboardWillHide];
}
- (void) popPreView
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[dataDictionary objectForKey:@"userno"] intValue]==[PBUserModel getUserId]) {
        myself = YES;
    }
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:[NSString stringWithFormat:@"跟帖[%@]",[dataDictionary objectForKey:@"count"]?[dataDictionary objectForKey:@"count"]:0] style:UIBarButtonItemStylePlain target:self action:@selector(remarkDidPush)]];
    flag = [dataDictionary objectForKey:@"flag"];
    self.title = @"供求详细";
    titleArr = [[NSMutableArray alloc]initWithObjects:@"标题:",@"发布时间:",@"发布人:",@"行业:",@"内容:",@"有图有真相", nil];
    inputToolbar = [[UIInputToolbar alloc] initWithFrame:CGRectMake(0, isPad()?1024:(isPhone5()?568:480), isPad()?768:320, 40)];
    inputToolbar.delegate = self;
    inputToolbar.textView.placeholder = @"请输入提问";
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTap:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    [self.navigationController.view addSubview:inputToolbar];
    
    
    indicator = [[PBActivityIndicatorView alloc]initWithFrame:isPad()?CGRectMake(0, 0, 768, 1024 - KNavigationBarHeight):(isPhone5()?CGRectMake(0, 0, 320, 568- KNavigationBarHeight):CGRectMake(0, 0, 320, 480- KNavigationBarHeight))];    [self.view addSubview:indicator];
#pragma mark - 查询本条供求的详细
    if (self.searchDetail) {
        NSAssert([dataDictionary objectForKey:@"commentno"] != nil, @"查询供求详细的时候 commentno 没有传过来");
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", [PBUserModel getUserId]], @"personno", [dataDictionary objectForKey:@"commentno"],@"no",nil];
        PBdataClass *dataclass = [[PBdataClass alloc] init];
        dataclass.delegate = self;
        [dataclass dataResponse:[NSURL URLWithString:URL] postDic:dic searchOrSave:YES];
        [indicator startAnimating];
    }
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - 查询本条供求的详细成功
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas{
    if (datas.count>0) {
        dataDictionary = [datas objectAtIndex:0];
        [self.tableView reloadData];
        [indicator stopAnimating];
    }
    [dataclass release];
}
#pragma mark - 查询本条供求的详细失败
-(void)searchFilad{
    [indicator stopAnimating];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [inputToolbar addObserverFromController:self];
}
//自定义textView显示高度
-(CGFloat) heightForTextView:(NSString*)contentStr
{
    CGSize size = [contentStr sizeWithFont:[self getTextFont] constrainedToSize:CGSizeMake(isPad() ? 480 : 210, 1000) lineBreakMode:UILineBreakModeWordWrap];
    return MAX(42.0, size.height);
}

- (UIFont *) getTextFont
{
    return [UIFont systemFontOfSize:isPad() ? 16 : 14];
}

#pragma mark
#pragma mark UITableViewDataSourceMethod
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return titleArr.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [self getTextFont];
    cell.textLabel.text = [titleArr objectAtIndex:indexPath.section];
    switch (indexPath.section) {
            
        case 0:
        {
            cell.textLabel.text = @"";
            CGFloat originX2 = 10;
            UIImageView *imageaView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"projectname.png"]];
            imageaView1.frame = CGRectMake(originX2, 8, 21, 21);
            [cell.contentView addSubview:imageaView1];
            [imageaView1 release];
            
            UIImageView *imageaView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trade.png"]];
            imageaView2.frame = CGRectMake(originX2, 32, 21, 21);
            [cell.contentView addSubview:imageaView2];
            [imageaView2 release];
            
            CGFloat originX3 = isPad() ? 60 : 40;
            CGFloat labelWidth = isPad() ? 560 : 200;
            UILabel *bossNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX3, isPad()?2:-2   , labelWidth,isPad() ?30: 40)];
            bossNameLabel.numberOfLines = 0;
            bossNameLabel.text = [dataDictionary objectForKey:@"name"];
            bossNameLabel.backgroundColor = [UIColor clearColor];
            bossNameLabel.font = [self getTextFont];
            [cell.contentView addSubview:bossNameLabel];
            [bossNameLabel release];
            UILabel *bossIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX3, 25, labelWidth, 35)];
            bossIDLabel.text = [dataDictionary objectForKey:@"type"];
            bossIDLabel.numberOfLines = 0;
            bossIDLabel.backgroundColor = [UIColor clearColor];
            bossIDLabel.font = [self getTextFont];
            [cell.contentView addSubview:bossIDLabel];
            [bossIDLabel release];
            CGFloat buttonOriginX1 = isPad() ? 570 : 240;
            CGFloat buttonOriginY = isPad() ? 40 : 40;
            PBUserModel* user = [PBUserModel getPasswordAndKind];
            if (user.kind==2&&!myself) {
                UIButton *scButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [scButton setBackgroundImage:[UIImage imageNamed:@"custom_button"] forState:UIControlStateNormal];
                [scButton addTarget:self action:@selector(collectProject:) forControlEvents:UIControlEventTouchUpInside];
                scButton.tag = 88;
                if ([flag isEqualToString:@"1"]){
                    [scButton setTitle:@"已收藏" forState:UIControlStateNormal];
                    scButton.enabled = NO;
                }else{
                    [scButton setTitle:NSLocalizedString(@"nav_btn_sc", nil) forState:UIControlStateNormal];
                }
                scButton.titleLabel.font = [self getTextFont];
                scButton.titleLabel.textColor = [UIColor blackColor];
                scButton.frame = CGRectMake(buttonOriginX1, buttonOriginY-(isPad()?35:33), isPad() ? 65 : 50, 25);
                [cell.contentView addSubview:scButton];
            }
            break;
        }
            
        case 1:
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%@  %@",cell.textLabel.text,[dataDictionary objectForKey:@"cdate"]];
            break;
        }
            
        case 2:
        {
            UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5 , 200,30)];
            userNameLabel.text = [NSString stringWithFormat:@"%@  %@",cell.textLabel.text,[dataDictionary objectForKey:@"username"]];
            userNameLabel.backgroundColor = [UIColor clearColor];
            userNameLabel.font = [self getTextFont];
            cell.textLabel.text = @"";
            [cell.contentView addSubview:userNameLabel];
            [userNameLabel release];
            CGFloat buttonOriginX1 = isPad() ? 470 : 160;
            CGFloat buttonOriginX2 = isPad() ? 570 : 240;
            if (!myself) {
                if (![self hasAddThisFriend]) {
                    UIButton *addFriendButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    [addFriendButton setBackgroundImage:[UIImage imageNamed:@"custom_button"] forState:UIControlStateNormal];
                    [addFriendButton addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
                    [addFriendButton setTitle:@"加为好友" forState:UIControlStateNormal];
                    addFriendButton.titleLabel.font = [self getTextFont];
                    addFriendButton.frame = CGRectMake(buttonOriginX1 , isPad() ?18:15, isPad() ?90 :70, 30);
                    [cell.contentView addSubview:addFriendButton];
                }
                UIImageView* starImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 32, isPad() ?100:90, isPad() ?20:18)];
                [starImage setStarImageWithCredit:[[dataDictionary objectForKey:@"credit"] intValue]];
                [cell.contentView addSubview:starImage];
                [starImage release];
                UIButton *sendMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [sendMessageButton setBackgroundImage:[UIImage imageNamed:@"custom_button"] forState:UIControlStateNormal];
                [sendMessageButton addTarget:self action:@selector(sendPrivateMessages) forControlEvents:UIControlEventTouchUpInside];
                [sendMessageButton setTitle:@"私信" forState:UIControlStateNormal];
                sendMessageButton.titleLabel.font = [self getTextFont];
                sendMessageButton.titleLabel.textColor = [UIColor blackColor];
                sendMessageButton.frame = CGRectMake(buttonOriginX2, isPad() ?18:15, isPad() ? 60 : 50,  30);
                [cell.contentView addSubview:sendMessageButton];
            }
            break;
        }
        case 3:
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%@  %@",cell.textLabel.text,[dataDictionary objectForKey:@"trade"]];
            break;
        }
        case 4:
        {
            CGFloat textWidth = isPad() ? 640 : 280;
            cell.textLabel.text = [dataDictionary  objectForKey:@"content"];
            cell.textLabel.frame = CGRectMake(isPad() ? 8 : 4, 4, textWidth, [self heightForTextView:cell.textLabel.text]);
            cell.textLabel.numberOfLines = 0;
            break;
        }
        case 5:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            break;
        }
        default:
            break;
    }
    
    return cell;
}
//发送私信
- (void) sendPrivateMessages
{
    PBPrivateMessagesController *controller = [[PBPrivateMessagesController alloc] init];
    controller.messageInvesterNo = [dataDictionary objectForKey:@"userno"];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}
#pragma mark -  加为好友
- (void) addFriend
{
    if ([PBUserModel getPasswordAndKind].kind==0){
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您必须成为融商正式会员后才能使用此功能！" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) otherButtonTitles:@"申请正式加盟", nil];
        [alert show];
        [alert release];

    }
    else{
        FAChatManager *manager = [[FAChatManager alloc] init];
        [manager inviteToBeFreindTo:[[dataDictionary objectForKey:@"userno"] intValue] fromId:[PBUserModel getUserId]];
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"APPLYJOININ" object:nil];
        //        PBdataClass *dataclass = [[PBdataClass alloc] init];
        //        dataclass.delegate = self;
        //        [dataclass dataResponse:Joininapply_URL postDic:[NSDictionary dictionaryWithObjectsAndKeys:USERNO,@"userno",[PBUserModel getTel],@"tel", nil] searchOrSave:NO];
    }
    
}
//判断是否加为好友
- (BOOL) hasAddThisFriend
{
    BOOL hasFriend = NO;
    NSArray *friendList = [PBCompanyDataManager getMyFriendListFromSQL];
    for (int i = 0; i < friendList.count; i ++) {
        if ([[dataDictionary objectForKey:@"no"] isEqualToString:[friendList objectAtIndex:i]]) {
            hasFriend = YES;
        }
    }
    return hasFriend;
}
#pragma mark - 收藏
- (void)collectProject:(UIButton*)sender
{
    shoucangbtn = sender;
    shoucangbtn.enabled = NO;
    [indicator startAnimating];
    PBWeiboDataConnect  *collectData= [[PBWeiboDataConnect alloc] init];
    collectData.delegate = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[dataDictionary objectForKey:@"no"], @"projectno", [NSString stringWithFormat:@"%d", [PBUserModel getUserId]], @"personno", @"11",@"type",nil];
    [collectData submitDataFromUrl:FAVOURITES postValuesAndKeys:dic];
}
-(void)sucessSendPostData:(PBWeiboDataConnect *)weiboDatas{
    [indicator stopAnimating];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOpportunityData" object:nil];
    if (sendmanager == weiboDatas) {
        self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"跟帖[%d]",[[dataDictionary objectForKey:@"count"] intValue]+1];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已成功跟帖" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else{
        [shoucangbtn setTitle:@"已收藏" forState:UIControlStateNormal];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已成功收藏" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    [weiboDatas release];
}
#pragma mark
#pragma mark UITableViewDelegateMethod
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return (section == 4) ? @"内容：" : nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 44.0f;
    switch (indexPath.section) {
        case 0:
        {
            height = 60.0f;
            break;
        }
        case 2:
        {
            height = 60.0f;
            break;
        }
        case 4:
        {
            NSString *str = [dataDictionary  objectForKey:@"casedetail"];
            height = [self heightForTextView:str] + 10;
            break;
        }
        default:
            break;
    }
    return height;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        PBStarEntrepreneursDetail *controller = [[PBStarEntrepreneursDetail alloc] init];
        controller.no = [dataDictionary objectForKey:@"userno"];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
#pragma mark -有图有真相
    if (indexPath.section == 5) {
        PBImageScrollView* scroll = [[PBImageScrollView alloc]init];
        scroll.urlStr = [NSString stringWithFormat:@"%@/admin/index/searchopportunityimages",HOST];
        scroll.data = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[dataDictionary objectForKey:@"no"],@"no", nil];
        [self.navigationController pushViewController:scroll animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [dataDictionary release];
    [detailTableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setDataDictionary:nil];
    [self setDetailTableView:nil];
    [super viewDidUnload];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [inputToolbar removeObserverFromController:self];
}
@end
