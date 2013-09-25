//
//  PBInvestorDetail.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-5.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBInvestorDetail.h"
#import "PBInvestorCase.h"
#import "PBPrivateMessagesController.h"
#import "CustomImageView.h"
#import "PBProjectInfoListModel.h"
#import "FAChatManager.h"

#define kURLSTRING [NSString stringWithFormat:@"%@admin/index/searchinvestordetailbyno", HOST]
#define kSENDPDFURLSTRING [NSString stringWithFormat:@"%@admin/index/sendftp", HOST]

@interface PBInvestorDetail ()

@end

@implementation PBInvestorDetail
@synthesize investorNo;
@synthesize XMLInvestorDetailManager;
@synthesize investorDetailData;
@synthesize investorDetailTableView;
@synthesize indicator;
@synthesize sendManager;
@synthesize projectInfoArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(7, 7, 25, 30);
        [btn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(popBackAgoView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = backBarBtn;
        [backBarBtn release];
    }
    return self;
}

- (void) popBackAgoView
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"详细信息";
    
//    UIButton *sbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    sbtn.frame = CGRectMake(6, 6, 48, 32);
//    [sbtn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"custom_button.png"]]];
//    [sbtn setTitle:@"发送" forState:UIControlStateNormal];
//    sbtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
//    [sbtn addTarget:self action:@selector(sendInfomation) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sendBtn = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendInfomation)];
    self.navigationItem.rightBarButtonItem = sendBtn;
    [sendBtn release];
    
    NSArray *section1 = [[NSArray alloc] initWithObjects:@"name&&photo", nil];
    NSArray *section2 = [[NSArray alloc] initWithObjects:@"introduce", nil];
    NSArray *section3 = [[NSArray alloc] initWithObjects:@"主投行业:", @"细分行业:", @"本年项目:", @"平均金额:", @"其他资源:", nil];
    NSArray *section4 = [[NSArray alloc] initWithObjects:@"投资案例", nil];
    datarow_ = [[NSArray arrayWithObjects:section1, section2, section3, section4, nil] retain];
    [section1 release];
    [section2 release];
    [section3 release];
    [section4 release];
    
    CGFloat viewWidth = 320;
    CGFloat viewHeight = (isPhone5() ? 568 :480)-KTabBarHeight-KNavigationBarHeight;
    if (isPad()) {
        viewHeight = 1024-KTabBarHeight-KNavigationBarHeight;
        viewWidth = 768;
    }
    
    indicator = [[PBActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    [self.view addSubview:indicator];
    [indicator startAnimating];
    
    NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys: investorNo, @"no", nil];
    XMLInvestorDetailManager = [[PBManager alloc] init];
    XMLInvestorDetailManager.delegate = self;
    [XMLInvestorDetailManager requestBackgroundXMLData:kURLSTRING forValueAndKey:dataDic];
    
    XMLInvestorDetailManager.acIndicator = indicator;
}

#pragma mark -
#pragma mark ParseDataDelegateMethod
- (void) sucessParseXMLData
{
    [indicator stopAnimating];
    if (XMLInvestorDetailManager.parseData.count > 0) {
        investorDetailData = [[NSDictionary dictionaryWithDictionary: [XMLInvestorDetailManager.parseData objectAtIndex:0]] retain];
        [investorDetailTableView reloadData];
    }
}

//自定义textView显示高度
-(CGFloat) heightForTextView:(NSString*)contentStr
{
    CGSize size = [contentStr sizeWithFont:[self getTextFont] constrainedToSize:CGSizeMake(isPad() ? 480 : 210, 1000) lineBreakMode:UILineBreakModeWordWrap];
    return MAX(42.0, size.height);
}

//根据设备的不同得到不同的字体大小
- (UIFont *) getTextFont
{
    return [UIFont systemFontOfSize:(isPad() ? PadContentFontSize : ContentFontSize)];
}

#pragma mark -
#pragma mark 触发按钮时应该执行的操作


- (void) sendInfomation { //no       rno
    sendManager = [[PBSendData alloc] init];
    sendManager.delegate = self;
    
    projectInfoArray = [[NSArray arrayWithArray:[PBProjectInfoListModel getProjectNameFromSQL]] retain];
    
    if (projectInfoArray.count == 0) {
        [self alertWarning:@"当前没有可投资项目"];
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        UIActionSheet *projectActionSheet = [[UIActionSheet alloc] initWithTitle:@"选择项目" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:[projectInfoArray objectAtIndex: 0], nil];
        if (projectInfoArray.count > 1) {
            for (int i = 1; i < projectInfoArray.count; i ++) {
                [projectActionSheet addButtonWithTitle:[projectInfoArray objectAtIndex:i]];
            }
        }
        [projectActionSheet addButtonWithTitle:NSLocalizedString(@"nav_btn_qx", nil)];
        [projectActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}


- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //匹配的项目编号
    if (buttonIndex < [projectInfoArray count]) {
        NSDictionary *sendValueDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", buttonIndex + 1], @"no", [investorDetailData objectForKey:@"no"], @"rno", nil];
        [sendManager sendDataWithURL:kSENDPDFURLSTRING andValueAndKeyDic:sendValueDic];
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}


- (void) successSendData
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [indicator stopAnimating];
    if ([sendManager.warnSting isEqualToString:@"failed"]) {
        [self alertWarning:@"PDF文档发送失败"];
    } else {
        [self alertWarning:@"PDF文档发送成功"];
    }
}

- (void) alertWarning:(NSString *) str
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发送" message:str delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
    [alert show];
    [alert release];
}


- (void) sendPrivateMessages
{
    PBPrivateMessagesController *controller = [[PBPrivateMessagesController alloc] init];
    controller.messageInvesterNo = investorNo;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

//加为好友时需要判断，若已经加过好友了，则应该把加为好友的出发按钮隐藏，暂时还没加，那么高亮显示提醒用户加对方为好友
- (void) addFriend
{
    FAChatManager *manager = [[[FAChatManager alloc] init] autorelease];
    [manager inviteToBeFreindTo:[investorNo intValue] fromId:[PBUserModel getUserId]];
}


//判断是否已加过好友，若已加，“加为好友”按钮不显示
- (BOOL) hasAddThisFriend
{
    BOOL hasFriend = NO;
    NSArray *friendList = [PBProjectInfoListModel getMyFriendListFromSQL];
    for (int i = 0; i < friendList.count; i ++) {
        if ([[investorDetailData objectForKey:@"no"] isEqualToString:[friendList objectAtIndex:i]]) {
            hasFriend = YES;
        }
    }
    return hasFriend;
}

#pragma mark -
#pragma mark TableViewDataSourece
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [datarow_ count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[datarow_ objectAtIndex:section] count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *DetailIdentifier = @"DetailIdentifier";
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DetailIdentifier] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    NSLog(@"%f", cell.frame.size.width);
    switch (indexPath.section) {
        case 0:
            //定制第一行，包括投资人的头像和名字
        {
            NSString *URLString = [NSString stringWithFormat:@"%@%@", HOST, [investorDetailData objectForKey:@"picture"]];
            
            CustomImageView *bossPhotoImageView = [[CustomImageView alloc] initWithFrame:CGRectMake(3, 3, 48, 48)];
            [bossPhotoImageView.imageView loadImage: URLString];
            [cell.contentView addSubview:bossPhotoImageView];
            [bossPhotoImageView release];
            
            CGFloat originX2 = isPad() ? 90 : 70;
            UIImageView *imageaView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatarslogo.png"]];
            imageaView1.frame = CGRectMake(originX2, 6, 21, 21);
            [cell.contentView addSubview:imageaView1];
            [imageaView1 release];
            
            UIImageView *imageaView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"useridno.png"]];
            imageaView2.frame = CGRectMake(originX2, 33, 21, 21);
            [cell.contentView addSubview:imageaView2];
            [imageaView2 release];
            
            CGFloat originX3 = isPad() ? 120 : 100;
            CGFloat labelWidth = isPad() ? 100 : 80;
            UILabel *bossNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX3, 6, labelWidth, 21)];
            bossNameLabel.text = [investorDetailData objectForKey:@"myname"];
            bossNameLabel.backgroundColor = [UIColor clearColor];
            bossNameLabel.font = [self getTextFont];
            [cell.contentView addSubview:bossNameLabel];
            [bossNameLabel release];
            
            UILabel *bossIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX3, 33, labelWidth, 21)];
            bossIDLabel.text = [investorDetailData objectForKey:@"no"];
            bossIDLabel.backgroundColor = [UIColor clearColor];
            bossIDLabel.font = [self getTextFont];
            [cell.contentView addSubview:bossIDLabel];
            [bossIDLabel release];
            
            //添加2个button，一个加为好友，一个发送私信
            CGFloat buttonOriginX1 = isPad() ? 500 : 170;
            CGFloat buttonOriginY = isPad() ? 10 : 15;
            if (![self hasAddThisFriend]) {
                UIButton *addFriendButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [addFriendButton setBackgroundImage:[UIImage imageNamed:@"custom_button"] forState:UIControlStateNormal];
                [addFriendButton addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
                [addFriendButton setTitle:@"加为好友" forState:UIControlStateNormal];
                addFriendButton.titleLabel.font = [self getTextFont];
                addFriendButton.titleLabel.textColor = [UIColor blackColor];
                addFriendButton.frame = CGRectMake(buttonOriginX1, buttonOriginY, isPad() ? 80 : 60, isPad() ? 40 : 30);
                [cell.contentView addSubview:addFriendButton];
            }

            CGFloat buttonOriginX2 = isPad() ? 600 : 240;
            UIButton *sendMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [sendMessageButton setBackgroundImage:[UIImage imageNamed:@"custom_button"] forState:UIControlStateNormal];
            [sendMessageButton addTarget:self action:@selector(sendPrivateMessages) forControlEvents:UIControlEventTouchUpInside];
            [sendMessageButton setTitle:@"私信" forState:UIControlStateNormal];
            sendMessageButton.titleLabel.font = [self getTextFont];
            sendMessageButton.titleLabel.textColor = [UIColor blackColor];
            sendMessageButton.frame = CGRectMake(buttonOriginX2, buttonOriginY, isPad() ? 70 : 50, isPad() ? 40 : 30);
            [cell.contentView addSubview:sendMessageButton];
            break;
        }
        
        case 1:
        {
            CGFloat textWidth = isPad() ? 679 : 300;
            NSString *str = [investorDetailData  objectForKey:@"signature"];
            UITextView *introduceTextView = [[UITextView alloc] initWithFrame:CGRectMake(isPad() ? 8 : 4, 12, textWidth, [self heightForTextView:str])];
            introduceTextView.text = str;
            introduceTextView.font = [self getTextFont];
            introduceTextView.editable = NO;
            introduceTextView.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:introduceTextView];
            [introduceTextView release];
            break;
        }
            
        case 2:
            //定制第三行，投资人投资情况和投资方向
        {
            NSArray *keyArray = [[NSArray alloc] initWithObjects:@"investtrade", @"investsubdivision", @"annualinvestno", @"projectfund_avg", @"carveoutresourse", nil];
            NSArray *iconArray = [[NSArray alloc] initWithObjects:@"maininvest.png", @"nicheinvest.png", @"thisyearproject.png", @"averageamount.png", @"otherresource.png", nil];
            
            UIImageView* fillImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
            [fillImageView setImage:[[UIImage imageNamed:@"fillcell.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
            cell.backgroundView = fillImageView;
            [fillImageView release];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iconArray objectAtIndex:indexPath.row]]];
            imageView.frame = CGRectMake(8, 8, 28, 28);
            [cell.contentView addSubview:imageView];
            [imageView release];
            
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(isPad() ? 60 : 44, 12, 60, 21)];
            label1.font = [self getTextFont];
            label1.text = [[datarow_ objectAtIndex:2] objectAtIndex:indexPath.row];
            label1.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label1];
            [label1 release];
            
            CGFloat labelOriginX = isPad() ? 140 : 104;
            CGFloat labelWidth = isPad() ? 520 : 190;
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(labelOriginX, 12, labelWidth, 21)];
            
            label2.font = [self getTextFont];

            if (indexPath.row == 3) {
                NSString *countString = [investorDetailData  objectForKey:@"projectfund_avg"];
                if (countString.length > 0) {
                    label2.text = [NSString stringWithFormat:@"%@（万元）", countString];
                }
            } else {
                NSString *labelString = [investorDetailData  objectForKey:[keyArray objectAtIndex:indexPath.row]];
                label2.numberOfLines = 0;
                CGSize labelSize = [labelString sizeWithFont:[self getTextFont] constrainedToSize:CGSizeMake(labelWidth, 44) lineBreakMode:UILineBreakModeCharacterWrap];
                if (labelSize.height > 20) {
                    label2.frame = CGRectMake(labelOriginX, 7, labelWidth, MAX(30.0, labelSize.height));
                } 
                label2.text = labelString;
            }
            label2.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label2];
            [label2 release];
            break;
        }
            
        case 3:
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"investcase.png"]];
            imageView.frame = CGRectMake(8, 8, 28, 28);
            [cell.contentView addSubview:imageView];
            [imageView release];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(isPad() ? 60 : 44, 12, 100, 21)];
            label.text = @"投资案例";
            label.font = [self getTextFont];
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            [label release];

            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        default:
            break;
    }
    
    return cell;
}

#pragma mark -
#pragma mark TableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat tableCellHeight = 0;
    switch (indexPath.section) {
        case 0:
            tableCellHeight = 60;
            break;
        case 1:
        {
            NSString *str = [investorDetailData  objectForKey:@"sketch"];
            tableCellHeight = [self heightForTextView:str] + 23;
//            NSLog(@"%f", tableCellHeight);
            break;
        }
        case 2:
            tableCellHeight = 44;
            break;
        case 3:
            tableCellHeight = 44;
            break;
        default:
            break;
    }
    return tableCellHeight;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return (section == 1) ? @"介绍" : nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        //跳转到投资案例详细界面
        PBInvestorCase *controller = [[PBInvestorCase alloc] init];
        controller.allCaseInverstorNo = self.investorNo;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    
}

- (void)viewDidUnload
{
    [self setProjectInfoArray:nil];
    [self setSendManager:nil];
    [self setIndicator:nil];
    [self setInvestorDetailTableView:nil];
    [self setInvestorDetailData:nil];
    [self setInvestorNo:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [projectInfoArray release];
    [sendManager release];
    [indicator release];
    [datarow_ release];
    [investorDetailData release];
    [investorDetailTableView release];
    [super dealloc];
}

@end
