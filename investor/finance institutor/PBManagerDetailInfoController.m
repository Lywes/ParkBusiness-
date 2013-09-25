//
//  PBManagerDetailInfoController.m
//  ParkBusiness
//
//  Created by QDS on 13-5-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBManagerDetailInfoController.h"
#import "PBProjectInfoListModel.h"
#import "PBPrivateMessagesController.h"
#import "FAChatManager.h"
#import "PBUserModel.h"
#import "PBFinancialCaseController.h"
#import "PBWeiboReplyController.h"
#import "UIImageView+CreditLevel.h"
@interface PBManagerDetailInfoController ()

@end

@implementation PBManagerDetailInfoController
@synthesize dataDictionary;
@synthesize detailTableView;

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
        [item release];
    }
    return self;
}

- (void) popPreView
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"详细信息";
    NSArray *section1 = [[NSArray alloc] initWithObjects:@"name&&photo", nil];
    NSArray *section2 = [[NSArray alloc] initWithObjects:@"signature", nil];
    NSArray *section3 = [[NSArray alloc] initWithObjects:@"机构：", @"职务：", nil];
    NSArray *section4 = [[NSArray alloc] initWithObjects:NSLocalizedString(@"_title_cpfwxxxx", nil), nil];
    sectionAndRowDataArray = [[NSArray arrayWithObjects:section1, section2, section3, section4, nil] retain];
    [section1 release];
    [section2 release];
    [section3 release];
    [section4 release];
}

- (void) sendPrivateMessages
{
    PBPrivateMessagesController *controller = [[PBPrivateMessagesController alloc] init];
    controller.messageInvesterNo = [dataDictionary objectForKey:@"no"];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

//判断是否已加过好友，若已加，“加为好友”按钮不显示
- (BOOL) hasAddThisFriend
{
    BOOL hasFriend = NO;
    NSArray *friendList = [PBProjectInfoListModel getMyFriendListFromSQL];
    for (int i = 0; i < friendList.count; i ++) {
        if ([[dataDictionary objectForKey:@"no"] isEqualToString:[friendList objectAtIndex:i]]) {
            hasFriend = YES;
        }
    }
    return hasFriend;
}
//加为好友时需要判断，若已经加过好友了，则应该把加为好友的出发按钮隐藏，暂时还没加，那么高亮显示提醒用户加对方为好友
- (void) addFriend
{
    if ([PBUserModel getPasswordAndKind].kind==0) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您必须成为融商正式会员后才能使用此功能！" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) otherButtonTitles:@"申请正式加盟", nil];
        [alert show];
        [alert release];
        return;
    }

    FAChatManager *manager = [[[FAChatManager alloc] init] autorelease];
    [manager inviteToBeFreindTo:[[dataDictionary objectForKey:@"no"] intValue] fromId:[PBUserModel getUserId]];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"APPLYJOININ" object:nil];
    }
    
}
//自定义textView显示高度
-(CGFloat) heightForTextView:(NSString*)contentStr
{
    CGSize size = [contentStr sizeWithFont:[self getTextFont] constrainedToSize:CGSizeMake(isPad() ? 480 : 210, 1000) lineBreakMode:UILineBreakModeWordWrap];
    return MAX(42.0, size.height);
}

- (UIFont *) getTextFont
{
    return [UIFont systemFontOfSize:isPad() ? PadContentFontSize : ContentFontSize];
}

#pragma mark
#pragma mark UITableViewDataSourceMethod
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionAndRowDataArray.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[sectionAndRowDataArray objectAtIndex:section] count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section) {
            
        case 0:
        {
            NSString *URLString = [NSString stringWithFormat:@"%@%@", HOST, [dataDictionary objectForKey:@"imagepath"]];
            
            CustomImageView *bossPhotoImageView = [[CustomImageView alloc] initWithFrame:CGRectMake(3, 3, 48, 48)];
            [bossPhotoImageView.imageView loadImage: URLString];
            [cell.contentView addSubview:bossPhotoImageView];
            [bossPhotoImageView release];
            
            CGFloat originX2 = isPad() ? 90 : 70;
            UIImageView *imageaView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatarslogo.png"]];
            imageaView1.frame = CGRectMake(originX2, 6, 21, 21);
            [cell.contentView addSubview:imageaView1];
            [imageaView1 release];
            UIImageView *starImage = [[UIImageView alloc] initWithFrame:CGRectMake(isPad() ? 300 : 170, 6, 100, isPad() ?25:20)];
            [starImage setStarImageWithCredit:[[dataDictionary objectForKey:@"credit"] intValue]];
            [cell.contentView addSubview:starImage];
            [starImage release];
            UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"useridno.png"]];
            imageView2.frame = CGRectMake(originX2, 40, 21, 21);
            [cell.contentView addSubview:imageView2];
            [imageView2 release];
            
            CGFloat labelOriginX1 = isPad() ? 120 : 95;
            CGFloat labelWidth = isPad() ? 120 : 70;
            UILabel *bossNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelOriginX1, 6, labelWidth, 21)];
            bossNameLabel.font = [self getTextFont];
            bossNameLabel.text = [dataDictionary objectForKey:@"name"];
            bossNameLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:bossNameLabel];
            [bossNameLabel release];
            
            UILabel *bossIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelOriginX1, 40, labelWidth, 21)];
            bossIDLabel.font = [self getTextFont];
            bossIDLabel.text = [dataDictionary objectForKey:@"no"];
            bossIDLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:bossIDLabel];
            [bossIDLabel release];
            
            //添加2个button，一个加为好友，一个发送私信
            CGFloat btnOriginY = 40;
            CGFloat btnHeight = 30;
            
            if (![self hasAddThisFriend]) {
                UIButton *addFriendButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [addFriendButton setBackgroundImage:[UIImage imageNamed:@"custom_button"] forState:UIControlStateNormal];
                [addFriendButton addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
                [addFriendButton setTitle:@"加为好友" forState:UIControlStateNormal];
                addFriendButton.titleLabel.font = [self getTextFont];
                addFriendButton.frame = CGRectMake(isPad() ? 300 : 170 , btnOriginY,isPad() ? 80: 60, btnHeight);
                [cell.contentView addSubview:addFriendButton];
            }
            
            UIButton *sendMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [sendMessageButton setBackgroundImage:[UIImage imageNamed:@"custom_button"] forState:UIControlStateNormal];
            [sendMessageButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
            [sendMessageButton setTitle:@"私信" forState:UIControlStateNormal];
            sendMessageButton.titleLabel.font = [self getTextFont];
            sendMessageButton.frame = CGRectMake(isPad() ? 400 : 240, btnOriginY, 50, btnHeight);
            [cell.contentView addSubview:sendMessageButton];
            break;
        }
            
        case 1:
        {
            CGFloat textWidth = isPad() ? 679 : 300;
            NSString *str = [dataDictionary  objectForKey:@"signature"];
            UITextView *signatureTextView = [[UITextView alloc] initWithFrame:CGRectMake(isPad() ? 8 : 4, 12, textWidth, [self heightForTextView:str])];
            signatureTextView.text = str;
            signatureTextView.font = [self getTextFont];
            signatureTextView.editable = NO;
            signatureTextView.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:signatureTextView];
            [signatureTextView release];
            break;
        }
            
        case 2:
            //定制第三行，投资人投资情况和投资方向
        {
            NSArray *keyArray = [[NSArray alloc] initWithObjects:@"financename", @"companyjob", nil];
            NSArray *iconArray = [[NSArray alloc] initWithObjects:@"financinginstitution.png", @"companyjob.png", nil];
            
            UIImageView* fillImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
            [fillImageView setImage:[[UIImage imageNamed:@"fillcell.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
            cell.backgroundView = fillImageView;
            [fillImageView release];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iconArray objectAtIndex:indexPath.row]]];
            imageView.frame = CGRectMake(isPad() ? 20 : 10, 8, 28, 28);
            [cell.contentView addSubview:imageView];
            [imageView release];
            
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(isPad() ? 80 : 44, 12, 60, 21)];
            label1.font = [self getTextFont];
            label1.text = [[sectionAndRowDataArray objectAtIndex:2] objectAtIndex:indexPath.row];
            label1.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label1];
            [label1 release];
            
            
            CGFloat labelOriginX = isPad() ? 140 : 104;
            CGFloat labelWidth = isPad() ? 520 : 190;
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(labelOriginX, 12, labelWidth, 21)];            
            label2.font = [self getTextFont];            
            label2.text = [dataDictionary  objectForKey:[keyArray objectAtIndex:indexPath.row]];            
            label2.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label2];
            [label2 release];
            [keyArray release];
            [iconArray release];
            break;
        }
            
        case 3:
        {
            NSArray *imageNameArray = [[NSArray alloc] initWithObjects:@"financingcase.png", @"allweibo.png", nil];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[imageNameArray objectAtIndex:indexPath.row]]];
            imageView.frame = CGRectMake(isPad() ? 20 : 10, 8, 28, 28);
            [cell.contentView addSubview:imageView];
            [imageView release];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(isPad() ? 80 : 44, 12, 100, 21)];
            label.text = [[sectionAndRowDataArray objectAtIndex:3] objectAtIndex:indexPath.row];
            label.font = [self getTextFont];
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            [label release];
            
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [imageNameArray release];
            break;
        }

            
        default:
            break;
    }
    
    return cell;
}

#pragma mark
#pragma mark UITableViewDelegateMethod
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return (section == 1) ? @"业务介绍" : nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 44.0f;
    switch (indexPath.section) {
        case 0:
        {
            height = 80.0f;
            break;
        }
        case 1:
        {
            NSString *str = [dataDictionary  objectForKey:@"signature"];
            height = [self heightForTextView:str] + 23;
            break;
        }
        default:
            break;
    }
    return height;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            PBFinancialCaseController *controller = [[PBFinancialCaseController alloc] init];
            controller.fnoString = [dataDictionary objectForKey:@"companyno"];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];            
        } else {
            PBWeiboReplyController *controller = [[PBWeiboReplyController alloc] init];
            controller.userNoString = [dataDictionary objectForKey:@"no"];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [dataDictionary release];
    [detailTableView release];
    [super dealloc];
}

- (void) viewDidUnload
{
    [self setDetailTableView:nil];
    [self setDataDictionary:nil];
    [super dealloc];
}

@end
