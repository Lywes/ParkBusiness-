//
//  PBStarEntrepreneursDetail.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-8.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define SEARCHDETAILUSER [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/detailuser",HOST]]
#import "PBStarEntrepreneursDetail.h"
#import "PBPrivateMessagesController.h"
#import "CustomImageView.h"
#import "FAChatManager.h"
#import "PBUserModel.h"
#import "PBWeiboReplyController.h"
#import "PBAllReviewController.h"
#import "UIImageView+CreditLevel.h"
@interface PBStarEntrepreneursDetail ()
@end

@implementation PBStarEntrepreneursDetail
@synthesize starDetailTabelView;
@synthesize dataDictionary;
@synthesize no;

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
    [self dismissModalViewControllerAnimated:YES];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"详细信息";
    
    NSArray *section1 = [[NSArray alloc] initWithObjects:@"name&&photo", nil];

    NSArray *section2 = [[NSArray alloc] initWithObjects:@"signature", nil];
    
    NSArray *section3 = [[NSArray alloc] initWithObjects:@"园区：", @"行业：", @"公司：",  @"职位：",@"企业规模：", nil];
    
    NSArray *section4 = [[NSArray alloc] initWithObjects:@"全部评论", nil];
    starEntrepreneursDatarow = [[NSArray arrayWithObjects:section1, section2, section3, section4, nil] retain];
    [section1 release];
    [section2 release];
    [section3 release];
    [section4 release];
//    self.title = [dataDictionary objectForKey:@"name"];
    if (no) {
        dataclass = [[PBdataClass alloc]init];
        dataclass.delegate = self;
        [dataclass dataResponse:SEARCHDETAILUSER postDic:[NSDictionary dictionaryWithObjectsAndKeys:no,@"no", nil] searchOrSave:YES];
    }
}

-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    if (datas.count>0) {
        self.dataDictionary = [datas objectAtIndex:0];
        [self.starDetailTabelView reloadData];
    }

}

-(void)searchFilad
{
    
}
- (UIFont *) getTextFont
{
    return [UIFont systemFontOfSize:isPad() ? PadContentFontSize : ContentFontSize];
}

//自定义textView显示高度
-(CGFloat) heightForTextView:(NSString*)contentStr
{
    CGSize size = [contentStr sizeWithFont:[self getTextFont] constrainedToSize:CGSizeMake(isPad() ? 480 : 210, 1000) lineBreakMode:UILineBreakModeWordWrap];
    return MAX(42.0, size.height);
}

//发送私信
- (void) sendMessage
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
    NSArray *friendList = [PBCompanyDataManager getMyFriendListFromSQL];
    for (int i = 0; i < friendList.count; i ++) {
        if ([[dataDictionary objectForKey:@"no"] isEqualToString:[friendList objectAtIndex:i]]) {
            hasFriend = YES;
        }
    }
    return hasFriend;
}

#pragma mark -
#pragma mark TableViewDataSourece
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [starEntrepreneursDatarow count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[starEntrepreneursDatarow objectAtIndex:section] count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *DetailIdentifier = @"DetailIdentifier";
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DetailIdentifier] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section) {
        case 0:
            //定制第一行，包括投资人的头像和名字
        {
            CustomImageView *bossPhotoView = [[CustomImageView alloc] initWithFrame:CGRectMake(3, 3, 48, 48)];
            [bossPhotoView.imageView loadImage:[NSString stringWithFormat:@"%@%@", HOST, [dataDictionary objectForKey:@"imagepath"]]];
            [cell.contentView addSubview:bossPhotoView];
            [bossPhotoView release];
            
            CGFloat imageOriginX1 = isPad() ? 90 : 70;
            UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatarslogo.png"]];
            imageView1.frame = CGRectMake(imageOriginX1, 6, 21, 21);
            [cell.contentView addSubview:imageView1];
            [imageView1 release];
            UIImageView *starImage = [[UIImageView alloc] initWithFrame:CGRectMake(isPad() ? 300 : 170, 6, 100, isPad() ?25:20)];
            [starImage setStarImageWithCredit:[[dataDictionary objectForKey:@"credit"] intValue]];
            [cell.contentView addSubview:starImage];
            [starImage release];
            UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"useridno.png"]];
            imageView2.frame = CGRectMake(imageOriginX1, 40, 21, 21);
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
        {
            NSArray *keyArray = [[NSArray alloc] initWithObjects:@"park", @"trade", @"companyname", @"companyjob",@"companyscale", nil];
            int scale = [PBKbnMasterModel getKbnIdByName:[dataDictionary objectForKey:@"companyscale"] withKind:@"staff"];
            NSString* companyscale = [NSString stringWithFormat:@"companyscale%d",scale>0?scale:1];
//            int job = [PBKbnMasterModel getKbnIdByName:[dataDictionary objectForKey:@"companyjob"] withKind:@"job"];
            NSString* companyjob = @"companyjob.png";
//            [NSString stringWithFormat:@"companyjob%d",job>0?job:1];
            NSArray *iconArray = [[NSArray alloc] initWithObjects:@"parkname.png", @"industry.png", @"company.png", companyjob,companyscale, nil];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iconArray objectAtIndex:indexPath.row]]];
            imageView.frame = CGRectMake(isPad() ? 16 : 8, 8, 28, 28);
            [cell.contentView addSubview:imageView];
            [imageView release];
            [iconArray release];
            
            
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(isPad() ? 60 : 44, 12, 90, 21)];
            label1.font = [self getTextFont];
            label1.backgroundColor = [UIColor clearColor];
            label1.text = [[starEntrepreneursDatarow objectAtIndex:2] objectAtIndex:indexPath.row];
            [cell.contentView addSubview:label1];
            [label1 release];
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(120, 4, isPad() ? 550 : 190, 35)];
            label2.font = [self getTextFont];
            label2.numberOfLines = 0;
            label2.backgroundColor = [UIColor clearColor];
            label2.text = [dataDictionary objectForKey:[keyArray objectAtIndex:indexPath.row]];
            [cell.contentView addSubview:label2];
            [label2 release];
            [keyArray release];
            break;
        }
            
        case 3:
        {
            NSArray *imageArray = [[NSArray alloc] initWithObjects:@"allremark.png", @"allweibo.png", nil];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]]];
            imageView.frame = CGRectMake(isPad() ? 16 : 8, 8, 28, 28);
            [cell.contentView addSubview:imageView];
            [imageView release];
            [imageArray release];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(isPad() ? 60 : 44, 12, 180, 21)];
            label.font = [UIFont systemFontOfSize:14.0];
            label.text = [[starEntrepreneursDatarow objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
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
#pragma mark -
#pragma mark TableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat tableCellHeight = 0;
    switch (indexPath.section) {
        case 0:
            tableCellHeight = 80;
            break;
        case 1:
        {
            NSString *str = [dataDictionary  objectForKey:@"signature"];
            tableCellHeight = [self heightForTextView:str] + 23;
            break;
        }
        case 2:
        case 3:
            tableCellHeight = 44;
            break;
        default:
            break;
    }
    return tableCellHeight;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        NSString *usernoStr = [dataDictionary objectForKey:@"no"];
        switch (indexPath.row) {
            case 0:
            {
                PBAllReviewController *arController = [[PBAllReviewController alloc] init];
                arController.userNoString = usernoStr;
                [self.navigationController pushViewController:arController animated:YES];
                [arController release];
                break;
            }
            case 1:
            {
                PBWeiboReplyController *wrController = [[PBWeiboReplyController alloc] init];
                wrController.userNoString = usernoStr;
                [self.navigationController pushViewController:wrController animated:YES];
                [wrController release];
                break;
            }
            default:
                break;
        }
    }
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return  @"个性签名";
    }
    return nil;
}

- (void)viewDidUnload
{
    [self setDataDictionary:nil];
    [self setStarDetailTabelView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc
{
    [starEntrepreneursDatarow release];
    [starDetailTabelView release];
    [dataDictionary release];
    [super dealloc];
}

@end
