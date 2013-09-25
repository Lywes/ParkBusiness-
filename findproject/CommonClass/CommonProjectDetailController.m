//
//  CommonProjectDetailController.m
//  ParkBusiness
//
//  Created by QDS on 13-3-18.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "CommonProjectDetailController.h"
#import "PBProjectTeamController.h"
#import "PBProjectDynamicController.h"
#import "PBFinancialDemandController.h"
#import "PBFinancialDemandController.h"
#import "PBPrivateMessagesController.h"
#import "PBFinanceExperienceController.h"
#import "CustomImageView.h"
#import "PBprojectteam.h"
#import "PBprojectTrends.h"
#import "PBrongzi.h"
#import "PBrongziList.h"
#import "PBFinanceDataList.h"
#import "PBBankFinanceNeeds.h"
#import "PBAssureCompanyInfo.h"
//收藏的URL
#define kSENDURLSTRING [NSString stringWithFormat:@"%@admin/index/addmyfavourites", HOST]
//获取收藏数据的URL
#define kPROJECTURLSTRING [NSString stringWithFormat:@"%@admin/index/searchproject", HOST]

@interface CommonProjectDetailController ()

@end

@implementation CommonProjectDetailController
@synthesize dataDictionary;
@synthesize caseNo;
@synthesize type;
@synthesize  manager;
@synthesize detailTableView;
@synthesize collectButton;
@synthesize collectData;
@synthesize indicator;
@synthesize favouritesManager;
@synthesize favouritesInfoListArray;

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
    
    self.title = @"详细信息";
    if ([[self.dataDictionary objectForKey:@"type"] intValue] == 1) {
        titleArr = [[NSMutableArray alloc] initWithObjects:@"项目团队",@"公司近两年财务数据", @"项目动态", NSLocalizedString(@"Left_mainTable_RZXQ", nil), @"融资经历", nil];
    }else{
        titleArr = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"_tb_gsgk", nil), NSLocalizedString(@"Left_mainTable_RZXQ", nil), nil];
    }

    //设置收藏
    PBUserModel* user = [PBUserModel getPasswordAndKind];
    if (user.kind==1) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_sc", nil) style:UIBarButtonItemStylePlain target:self action:@selector(collectProject)];
        if ([[self.dataDictionary objectForKey:@"flag"] isEqualToString:@"1"]) {
            //从后台获取数据，是否收藏该项目，若已经收藏则为“已收藏”，button不可用。否则收藏按钮可用
            self.navigationItem.rightBarButtonItem.title = @"已收藏";
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    }
    
    if (([caseNo length] != 0) && (caseNo != nil)) {
        CGFloat viewWidth = 320;
        CGFloat viewHeight = (isPhone5() ? 568 :480)-KTabBarHeight-KNavigationBarHeight;
        if (isPad()) {
            viewHeight = 1024-KTabBarHeight-KNavigationBarHeight;
            viewWidth = 768;
        }
        indicator = [[PBActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        [self.view addSubview:indicator];
        [indicator startAnimating];
    }else{
        caseNo = [dataDictionary objectForKey:@"no"];
        type = [dataDictionary objectForKey:@"type"];
    }
    manager = [[PBManager alloc] init];
    manager.delegate = self;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:caseNo, @"no", type,@"type",nil];
    [manager requestBackgroundXMLData:kPROJECTURLSTRING forValueAndKey:dic];
    
    manager.acIndicator = indicator;
}

- (UIFont *) getTextFont
{
    return [UIFont systemFontOfSize: isPad() ? PadContentFontSize : ContentFontSize];
}

#pragma mark -
#pragma mark ParseDataDelegateMethod
- (void) sucessParseXMLData
{
    [indicator stopAnimating];
    if ([manager.parseData count] > 0) {
        dataDictionary = [[[NSArray arrayWithArray:manager.parseData] objectAtIndex:0] retain];
    }
    [detailTableView reloadData];
}

#pragma mark -
#pragma mark SuccessSendMessageMethod
- (void) successSendData
{
    if ([collectData.warnSting isEqualToString:@"succeed"]) {
        //从后台获取数据，是否收藏该项目，若已经收藏则为“已收藏”，button不可用。否则收藏按钮可用
        self.navigationItem.rightBarButtonItem.title = @"已收藏";
    }
}

//收藏
- (void) collectProject
{
    collectData = [[PBSendData alloc] init];
    collectData.delegate = self;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[dataDictionary objectForKey:@"no"], @"projectno", [NSString stringWithFormat:@"%d", [PBUserModel getUserId]], @"personno", [dataDictionary objectForKey:@"type"],@"type",nil];
    [collectData sendDataWithURL:kSENDURLSTRING andValueAndKeyDic:dic];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

////发送私信
//- (void) sendPrivateMessage
//{
//    //发送私信需要传递的参数为发送者编号，接收者编号、内容和标题
//    PBPrivateMessagesController *controller = [[PBPrivateMessagesController alloc] init];
//    //接收者编号，项目的负责人
//    controller.messageInvesterNo = [dataDictionary objectForKey:@"companyno"];
//    [self.navigationController pushViewController:controller animated:YES];
//    [controller release];
//}

#pragma mark -
#pragma mark TableViewDataSourceMethod
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
//    self.title = [dataDictionary objectForKey:@"proname"];
    return 6;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger cellNumber = 1;
    
    cellNumber = (section == 5) ? titleArr.count: 1;
    if (section == 3) {
        cellNumber = titleArr.count==5?1:0;
    }
    return cellNumber;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"DetailIdentifier";
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat imageOriginX = isPad() ? 20 : 8;
    CGFloat label1OriginX = isPad() ? 60 : 44;
    CGFloat label1Width = isPad() ? 80 : 60;
    CGFloat label2OriginX = isPad() ? 130 : 104;
    CGFloat label2Width = isPad() ? 500 : 184;
    switch (indexPath.section) {
        case 0:
        {
            [self customSection0AppointCell:cell];
            break;
        }
            
        case 1:
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"industrycomposition.png"]];
            imageView.frame = CGRectMake(imageOriginX, 8, 28, 28);
            [cell.contentView addSubview:imageView];
            [imageView release];
            
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(label1OriginX, 12, label1Width, 21)];
            label1.text = @"行业划分：";
            label1.font = [self getTextFont];
            label1.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label1];
            [label1 release];
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(label2OriginX, 12, label2Width, 21)];
            label2.font = [self getTextFont];
            label2.backgroundColor = [UIColor clearColor];
            label2.text = [dataDictionary objectForKey: @"trade"];
            [cell.contentView addSubview:label2];
            [label2 release];
            break;
        }
            
        case 2:
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"time.png"]];
            imageView.frame = CGRectMake(imageOriginX, 8, 28, 28);
            [cell.contentView addSubview:imageView];
            [imageView release];
            
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(label1OriginX, 12,            isPad() ? 120 : 84, 21)];
            label1.text = @"项目开始时间：";
            label1.font = [self getTextFont];
            label1.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label1];
            [label1 release];
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(isPad() ? 156 : 128, 12, isPad() ? 400 : 160, 21)];
            label2.font = [self getTextFont];
            label2.backgroundColor = [UIColor clearColor];
            label2.text = [dataDictionary objectForKey: @"stdate"];
            [cell.contentView addSubview:label2];
            [label2 release];
            break;
        }
            
        case 3:
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"projectstage.png"]];
            imageView.frame = CGRectMake(imageOriginX, 8, 28, 28);
            [cell.contentView addSubview:imageView];
            [imageView release];
            
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(label1OriginX, 12, label1Width, 21)];
            label1.text = @"项目阶段：";
            label1.font = [self getTextFont];
            label1.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label1];
            [label1 release];
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(label2OriginX, 12, label2Width, 21)];
            label2.font = [self getTextFont];
            label2.backgroundColor = [UIColor clearColor];
            label2.text = [dataDictionary objectForKey: @"stage"];
            [cell.contentView addSubview:label2];
            [label2 release];
            break;
        }
            
        case 4:
        {
            [self customSection4:indexPath.row appointCell:cell];
            break;
        }

            
        case 5:
        {
            [self customSection5:indexPath.row appointCell:cell];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        default:
            break;
    }
    return cell;
}

/*******************************************
 自定义3个section中的cell
 section1：包括头像，负责人名字，公司名、行业和开始时间
 section2：项目简介
 section3：项目具体信息的拓展
 *******************************************/
- (void) customSection0AppointCell:(UITableViewCell *) cell
{
    CustomImageView *customView = [[CustomImageView alloc] initWithFrame:CGRectMake(isPad() ? 6 : 3, 3, 48, 48)];
    [customView.imageView loadImage:[NSString stringWithFormat:@"%@%@", HOST, [dataDictionary objectForKey:@"imagepath"]]];
    [cell.contentView addSubview:customView];
    [customView release];
    
    if (isPad()) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake( 80, 20, 400, 21)];
        label.text = [dataDictionary objectForKey:@"proname"];
        label.backgroundColor = [UIColor clearColor];
        label.font = [self getTextFont];
        [cell.contentView addSubview:label];
        [label release];
      
    } else {
        CGFloat labelWidth = 135.0;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, labelWidth, 21)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [self getTextFont];
        
        NSString *labelString = [dataDictionary objectForKey:@"proname"];;
        label.numberOfLines = 0;
        CGSize labelSize = [labelString sizeWithFont:[self getTextFont] constrainedToSize:CGSizeMake(labelWidth, 44) lineBreakMode:UILineBreakModeCharacterWrap];
        
        if (labelSize.height > 35) {
            label.frame = CGRectMake(60, 7, labelWidth,  MIN(45.0, labelSize.height));
        } else if (labelSize.height > 20) {
            label.frame = CGRectMake(60, 15, labelWidth, labelSize.height);
        }
        label.text = labelString;
        
        [cell.contentView addSubview:label];
        [label release];
    }
    
    
}

//自定义文本显示高度
-(CGFloat) heightForTextView:(NSString*)contentStr
{
    CGSize size = [contentStr sizeWithFont:[self getTextFont] constrainedToSize:CGSizeMake(isPad() ? 480 : 210, 1000) lineBreakMode:UILineBreakModeWordWrap];
    return MAX(42.0, size.height);
}

- (void) customSection4:(NSInteger)num appointCell:(UITableViewCell *) cell
{
    NSString *str = [dataDictionary objectForKey:@"introduce"];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake((isPad() ? 8 : 4), 12, isPad() ? 679 : 300 , [self heightForTextView:str])];
    textView.editable = NO;
    textView.font = [self getTextFont];
    textView.backgroundColor = [UIColor clearColor];
    textView.text = str;
    [cell.contentView addSubview:textView];
    [textView release];
}

- (void) customSection5:(NSInteger)num appointCell:(UITableViewCell *) cell
{
    NSArray *iconArray = [[NSArray alloc] initWithObjects:@"projectteam.png", @"projectdynamic.png", @"financingdemand.png", @"financingexperience.png",@"financingexperience.png", nil];
    

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iconArray objectAtIndex:num]]];
    imageView.frame = CGRectMake(isPad() ? 20 : 8, 8, 28, 28);
    [cell.contentView addSubview:imageView];
    [imageView release];
//    cell.imageView.image = [UIImage imageNamed:[iconArray objectAtIndex:num]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(isPad() ? 60 : 44, 12, 160, 21)];
    label.font = [self getTextFont];
    label.backgroundColor = [UIColor clearColor];
//    cell.textLabel.text = [titleArr objectAtIndex:num];
    label.text = [titleArr objectAtIndex:num];
    [cell.contentView addSubview:label];
    [label release];
}

#pragma mark -
#pragma mark TableViewDelegateMethod
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = 0.0;
    switch (indexPath.section) {
        case 0:
        {
            cellHeight = 60.0;
            break;
        }
            
        case 1:
        case 2:
        case 3:
        {
            cellHeight = 44.0;
            break;
        }
            
        case 4:
        {
            NSString *str = [dataDictionary objectForKey:@"introduce"];
            cellHeight = [self heightForTextView:str] + 23;
            break;
        }
            
        case 5:
        {
            cellHeight = 44.0;
            break;
        }
            
        default:
            break;
    }
    return  cellHeight;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return (section == 4) ? @"项目介绍" : nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 5) {
        
        switch (indexPath.row) {
            case 0:
            {
                if ([type isEqualToString:@"1"]) {
                    PBprojectteam *projectteam = [[PBprojectteam alloc]initWithStyle:UITableViewStyleGrouped];
                    projectteam.ProjectStyle = ELSEPROJECTINFO;
                    projectteam.datadic = dataDictionary;
                    [self.navigationController pushViewController:projectteam animated:YES];
                    [projectteam release];
                }else{
                    PBAssureCompanyInfo* company = [[PBAssureCompanyInfo alloc]initWithStyle:UITableViewStyleGrouped];
                    company.ProjectStyle = ELSEPROJECTINFO;
                    company.datadic = dataDictionary;
                    company.title = [titleArr objectAtIndex:0];
                    company.type = [[dataDictionary objectForKey:@"type"] intValue];
                    [self.navigationController pushViewController:company animated:YES];
                    [company release];
                }
                break;
            }
            case 1:
            {
                if ([type isEqualToString:@"1"]) {
                    PBFinanceDataList *financeData = [[PBFinanceDataList alloc]initWithStyle:UITableViewStyleGrouped];
                    financeData.ProjectStyle = ELSEPROJECTINFO;
                    financeData.userinfo = dataDictionary;
                    financeData.count = 2;
                    financeData.title = [titleArr objectAtIndex:1];
                    [self.navigationController pushViewController:financeData animated:YES];
                    [financeData release];
                }else{
                    PBBankFinanceNeeds* needs = [[PBBankFinanceNeeds alloc]initWithStyle:UITableViewStyleGrouped];
                    needs.ProjectStyle = ELSEPROJECTINFO;
                    needs.datadic = dataDictionary;
                    needs.title = [titleArr objectAtIndex:1];
                    [self.navigationController pushViewController:needs animated:YES];
                    [needs release];
                }
                
                break;
            }
            case 2:
            {                
                PBprojectTrends *projecttrends = [[PBprojectTrends alloc]initWithStyle:UITableViewStyleGrouped];
                projecttrends.ProjectStyle = ELSEPROJECTINFO;
                projecttrends.OtherData = dataDictionary;
                [self.navigationController pushViewController:projecttrends animated:YES];
                [projecttrends release];
                break;
            }
            
            case 3:
            {
                PBrongzi *financialController = [[PBrongzi alloc] initWithStyle:UITableViewStyleGrouped];
                financialController.datadic = dataDictionary;
                financialController.ProjectStyle = ELSEPROJECTINFO;
                [self.navigationController pushViewController:financialController animated:YES];
                [financialController release];
                break;
            }
            case 4:
            {
                PBrongziList *controller = [[PBrongziList alloc] initWithStyle:UITableViewStyleGrouped];
                controller.ProjectStyle = ELSEPROJECTINFO;
                controller.datadic = dataDictionary;
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
                break;
            }
                
            default:
                break;
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
    [favouritesInfoListArray release];
    [favouritesManager release];
    [indicator release];
    [collectData release];
    [manager release];
    [caseNo release];
    [dataDictionary release];
    [detailTableView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setFavouritesInfoListArray:nil];
    [self setFavouritesManager:nil];
    [self setIndicator:nil];
    [self setCollectData:nil];
    [self setCollectButton:nil];
    [self setManager:nil];
    [self setCaseNo:nil];
    [self setDataDictionary:nil];
    [self setDetailTableView:nil];
    [super viewDidUnload];
}
@end