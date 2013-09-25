//
//  PBProjectDynamicController.m
//  ParkBusiness
//
//  Created by QDS on 13-3-21.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBProjectDynamicController.h"
#import "DynamicCell.h"

#define kURLSTRING [NSString stringWithFormat:@"%@admin/index/projectdynamic", HOST]


@interface PBProjectDynamicController ()

@end

@implementation PBProjectDynamicController
@synthesize noString;
@synthesize dataArray;
@synthesize manager;
@synthesize dynamicTableView;
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
    self.title = @"项目动态";
    
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
    [dynamicTableView reloadData];
}


#pragma mark -
#pragma mark TableViewDataSourceMethod
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

//- (UITableViewCell *) reuseCellWithIdentifier:(NSString *) identifierString andXib:(NSString *)xibNameString
//{
//    
//}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"DynamicCellIdentifier";
    //cell不能为空
    static BOOL nibsRegisted = NO;
    DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        nibsRegisted = NO;
    }
    if (!nibsRegisted) {
        UINib *nib = [UINib nibWithNibName:@"DynamicCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        nibsRegisted = YES;
    }
    if (cell==nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
    cell.dynamicLabel.text = [dic objectForKey:@"dynamic"];
    cell.dynamicTimeLabel.text = [dic objectForKey:@"cdate"];
    return cell;
}

#pragma mark -
#pragma mark TableViewDelegateMethod

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
    [dynamicTableView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setIndicator:nil];
    [self setNoString:nil];
    [self setManager:nil];
    [self setDataArray:nil];
    [self setDynamicTableView:nil];
    [super viewDidUnload];
}
@end
