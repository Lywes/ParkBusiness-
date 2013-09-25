//
//  PBProjectTeamController.m
//  ParkBusiness
//
//  Created by QDS on 13-3-21.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBProjectTeamController.h"
#import "TeamCell.h"

#define kURLSTRING [NSString stringWithFormat:@"%@admin/index/projectgroup", HOST]


@interface PBProjectTeamController ()

@end

@implementation PBProjectTeamController
@synthesize noString;
@synthesize dataArray;
@synthesize manager;
@synthesize teamTableView;
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
    self.title = @"项目团队";
    
    CGFloat viewWidth = 320;
    CGFloat viewHeight = (isPhone5() ? 568 :480)-KTabBarHeight-KNavigationBarHeight;
    if (isPad()) {
        viewHeight = 1024-KTabBarHeight-KNavigationBarHeight;
        viewWidth = 768;
    }
    indicator = [[PBActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    [self.view addSubview:indicator];
    [indicator startAnimating];
    
    manager = [[PBManager alloc] init];
    manager.delegate = self;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:noString, @"no", nil];
    [manager requestBackgroundXMLData:kURLSTRING forValueAndKey:dic];
    
    manager.acIndicator = indicator;
}

#pragma mark -
#pragma mark ParseDataDelegateMethod
- (void) sucessParseXMLData
{
    [indicator stopAnimating];
    dataArray = [[NSArray arrayWithArray:manager.parseData] retain];
    [teamTableView reloadData];
}

#pragma mark -
#pragma mark TableViewDataSourceMethod
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TeamCellIdentifier";
    //cell不能为空
    static BOOL nibsRegisted = NO;
    TeamCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        nibsRegisted = NO;
    }
    if (!nibsRegisted) {
        UINib *nib = [UINib nibWithNibName:@"TeamCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        nibsRegisted = YES;
    }
    if (cell==nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
    cell.teamNameLabel.text = [dic objectForKey:@"name"];
    cell.teamJobLabel.text = [dic objectForKey:@"teamjob"];
    cell.teamJobYearLabel.text = [dic objectForKey:@"years"];
    cell.teamMarryLabel.text = [dic objectForKey:@"married"];
    cell.teamExperienceLabel.text = [dic objectForKey:@"experience"];
    return cell;
}

#pragma mark -
#pragma mark TableViewDelegateMethod
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88.0;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [indicator release];
    [noString release];
    [manager release];
    [dataArray release];
    [teamTableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setIndicator:nil];
    [self setNoString:nil];
    [self setDataArray:nil];
    [self setManager:nil];
    [self setTeamTableView:nil];
    [super viewDidUnload];
}
@end
