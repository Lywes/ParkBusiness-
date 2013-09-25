//
//  PBInvestorCase.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-6.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBInvestorCase.h"
#import "PBInvestorCaseDetail.h"
#import "InvestorCaseCell.h"

#define kURLSTRING [NSString stringWithFormat:@"%@admin/index/searchprojectbyuserid", HOST]

@interface PBInvestorCase ()

@end

@implementation PBInvestorCase
@synthesize investorCaseManager;
@synthesize allCaseInverstorNo;
@synthesize investorAllCaseArray;
@synthesize investorCaseTableView;
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
    self.navigationItem.title = @"投资案例";
    
    CGFloat viewWidth = 320;
    CGFloat viewHeight = (isPhone5() ? 568 :480)-KTabBarHeight-KNavigationBarHeight;
    if (isPad()) {
        viewHeight = 1024-KTabBarHeight-KNavigationBarHeight;
        viewWidth = 768;
    }
    indicator = [[PBActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    [self.view addSubview:indicator];
    [indicator startAnimating];
    
    NSDictionary *dataDic = [[NSDictionary alloc] initWithObjectsAndKeys:allCaseInverstorNo, @"personno", nil];
    investorCaseManager = [[PBManager alloc] init];
    investorCaseManager.delegate = self;
    [investorCaseManager requestBackgroundXMLData:kURLSTRING forValueAndKey:dataDic];
    [dataDic release];
    
    investorCaseManager.acIndicator = indicator;
}

#pragma mark -
#pragma mark ParseDataDelegateMethod
- (void) sucessParseXMLData
{
    [indicator stopAnimating];
    investorAllCaseArray = [[NSArray arrayWithArray:investorCaseManager.parseData] retain];
    [investorCaseTableView reloadData];
}

#pragma mark -
#pragma mark TabelViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [investorAllCaseArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CaseCellIndentifier = @"CaseCellIndentifier";
    static BOOL nibsRegistered = NO;
    
    InvestorCaseCell *cell = [tableView dequeueReusableCellWithIdentifier:CaseCellIndentifier];
    if (cell == nil) {
        nibsRegistered = NO;
    }
    
    if (!nibsRegistered) {
        NSString *nibName = isPad() ? @"InvestorCaseCell_iPad" : @"InvestorCaseCell";
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CaseCellIndentifier];
        nibsRegistered = YES;
    }
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:CaseCellIndentifier];
    } 
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    [imageView setImage:[[UIImage imageNamed:@"fillcell.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
    cell.backgroundView = imageView;
    [imageView release];
    
    cell.investorCaseLabel.text = [[investorAllCaseArray objectAtIndex:indexPath.row] objectForKey:@"projectname"];
    cell.investorTimeLabel.text = [[investorAllCaseArray objectAtIndex:indexPath.row] objectForKey:@"starttime"];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark -
#pragma mark TableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PBInvestorCaseDetail *caseDetailController = [[PBInvestorCaseDetail alloc] init];
    //数据的传递
    caseDetailController.caseDetailProjectNoStr = [[investorAllCaseArray objectAtIndex:indexPath.row] objectForKey:@"no"];
    caseDetailController.caseDetailProjectNameStr = [[investorAllCaseArray objectAtIndex:indexPath.row] objectForKey:@"projectname"];
    [self.navigationController pushViewController:caseDetailController animated:YES];
    [caseDetailController release];
}

- (void)viewDidUnload
{
    [self setIndicator:nil];
    [self setInvestorAllCaseArray:nil];
    [self setAllCaseInverstorNo:nil];
    [self setInvestorCaseManager:nil];
    [self setInvestorCaseTableView:nil];
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
    [investorAllCaseArray release];
    [allCaseInverstorNo release];
    [investorCaseManager release];
    [investorCaseTableView release];
    [super dealloc];
}
@end
