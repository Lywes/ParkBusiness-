//
//  PBInvestorCaseDetail.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-7.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBInvestorCaseDetail.h"
#import "CommonProjectDetailController.h"

#define kURLSTRING [NSString stringWithFormat:@"%@admin/index/searchprojectbyno", HOST]

@interface PBInvestorCaseDetail ()

@end

@implementation PBInvestorCaseDetail
@synthesize caseDetailManager;
@synthesize caseDetailProjectNoStr;
@synthesize caseDetailArray;
@synthesize caseDetailTableView;
@synthesize caseDetailProjectNameStr;
@synthesize indicator;

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
    self.title = NSLocalizedString(@"_tb_alxq", nil);
    
    NSArray *section1 = [[NSArray alloc] initWithObjects:@"photo and name", nil];
    NSArray *section2 = [[NSArray alloc] initWithObjects:@"detail introduce", nil];
    NSArray *section3 = [[NSArray alloc] initWithObjects:@"行业成分:", @"投资时间:", @"投资金额:", @"股份比例:", nil];
    NSArray *section4 = [[NSArray alloc] initWithObjects:@"项目链接", nil];
    //判断，当项目编号no为空时，不显示项目链接
    caseDetailRow = [[NSArray arrayWithObjects:section1, section2, section3, section4, nil] retain];
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
    
    NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:caseDetailProjectNoStr, @"no", nil];
    caseDetailManager = [[PBManager alloc] init];
    caseDetailManager.delegate = self;
    [caseDetailManager requestBackgroundXMLData:kURLSTRING forValueAndKey:dataDic];
    
    caseDetailManager.acIndicator = indicator;
}

#pragma mark -
#pragma mark ParseDataDelegateMethod
- (void) sucessParseXMLData
{
    [indicator stopAnimating];
    caseDetailArray = [[NSArray arrayWithArray:caseDetailManager.parseData] retain];
//    NSLog(@"%@", caseDetailArray);
    [caseDetailTableView reloadData];
}


//自定义文本显示高度
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
#pragma mark TabelViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    //projectno不为空，有案例链接的界面。若空，则不链接
    int sectionNum = [caseDetailRow count];
    NSString *str = [[caseDetailArray objectAtIndex:0] objectForKey:@"projectinfono"];
    if ([str length] == 0) {
        sectionNum -= 1;
    }
    return sectionNum;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = [caseDetailRow objectAtIndex:section];
    return [arr count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";

    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 0:
            //定制第一行，包括投资人的头像和名字
        {
            UILabel *bossNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 21)];
            bossNameLabel.text = caseDetailProjectNameStr;
            [cell.contentView addSubview:bossNameLabel];
            bossNameLabel.font = [self getTextFont];
            bossNameLabel.backgroundColor = [UIColor clearColor];
            [bossNameLabel release];
            break;
        }
            
        case 1:
        {
            NSString *str = [[caseDetailArray objectAtIndex:0] objectForKey:@"projectintroduce"];
            UITextView *introduceTextView = [[UITextView alloc] initWithFrame:CGRectMake(isPad() ? 8 : 4, 12, isPad() ? 679 : 300, [self heightForTextView:str])];
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
            NSArray *caseDetailInfoArray = [[NSArray alloc] initWithObjects:@"trade", @"starttime", @"money", @"share", nil];
            NSArray *iconArray = [[NSArray alloc] initWithObjects: @"industrycomposition.png", @"time.png", @"investoramount.png", @"stake.png", nil];
            
            UIImageView* fillImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
            [fillImageView setImage:[[UIImage imageNamed:@"fillcell.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
            cell.backgroundView = fillImageView;
            [fillImageView release];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iconArray objectAtIndex:indexPath.row]]];
            imageView.frame = CGRectMake(8, 8, 28, 28);
            [cell.contentView addSubview:imageView];
            
            
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(44, 12, 80, 21)];
            label1.text = [[caseDetailRow objectAtIndex:2] objectAtIndex:indexPath.row];
            label1.backgroundColor = [UIColor clearColor];
            label1.font = [self getTextFont];
            [cell.contentView addSubview:label1];
            [label1 release];
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(124, 12, isPad() ? 500 : 170, 21)];
            label2.font = [self getTextFont];
            label2.backgroundColor = [UIColor clearColor];
            NSDictionary *caseDetailDic = [caseDetailArray objectAtIndex:0];
            if (indexPath.row == 3) {
                NSArray *arr = [NSArray arrayWithObject:@"%"];
                label2.text = [NSString stringWithFormat:@"%@%@", [caseDetailDic objectForKey:@"share"], [arr objectAtIndex:0]];
            } else if (indexPath.row == 2) {
                NSString *moneyString = [caseDetailDic objectForKey:@"money"];
                if (moneyString.length > 0) {
                    label2.text = [NSString stringWithFormat:@"%@（%@）", moneyString, [caseDetailDic objectForKey:@"moneyunit"]];
                }
            } else {
                label2.text = [caseDetailDic objectForKey:[caseDetailInfoArray objectAtIndex:indexPath.row]];
            }
            [cell.contentView addSubview:label2];
            [label2 release];
            [caseDetailInfoArray release];
            break;
        }
            
        case 3:
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 28, 28)];
            imageView.image = [UIImage imageNamed:@"projectlink.png"];
            [cell.contentView addSubview:imageView];
            [imageView release];
            
            UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(44, 12, 100, 21)];
            label.text = @"项目链接";
            label.backgroundColor = [UIColor clearColor];
            label.font = [self getTextFont];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = 0;
    switch (indexPath.section) {
        case 0:
            rowHeight = 44.0f;
            break;
            
        case 1:
        {
            NSString *str = [[caseDetailArray objectAtIndex:0] objectForKey:@"projectintroduce"];
            rowHeight = [self heightForTextView:str] + 23;
            break;
        }
            
        case 2:  
        case 3:
            rowHeight = 44.0f;
            break;
            
        default:
            break;
    }
    return rowHeight;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        NSString *str = [[caseDetailArray objectAtIndex:0] objectForKey:@"projectinfono"];
        CommonProjectDetailController *controller = [[CommonProjectDetailController alloc] init];
        controller.caseNo = str;
        controller.type = [[caseDetailArray objectAtIndex:0] objectForKey:@"type"];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}

- (void)viewDidUnload
{
    [self setIndicator:nil];
    [self setCaseDetailProjectNameStr:nil];
    [self setCaseDetailArray:nil];
    [self setCaseDetailProjectNoStr:nil];
    [self setCaseDetailManager:nil];
    [self setCaseDetailTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [indicator release];
    [caseDetailProjectNameStr release];
    [caseDetailArray release];
    [caseDetailProjectNoStr release];
    [caseDetailManager release];
    [caseDetailRow release];
    [caseDetailTableView release];
    [super dealloc];
}
@end
