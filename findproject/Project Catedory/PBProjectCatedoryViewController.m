//
//  PBProjectCatedoryViewController.m
//  ParkBusiness
//
//  Created by QDS on 13-3-18.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBProjectCatedoryViewController.h"
#import "PBSpecificTradeController.h"
#import "MainCategoryCell.h"

#define kURLSTRING [NSString stringWithFormat:@"%@admin/index/tradekinds", HOST]

@interface PBProjectCatedoryViewController ()

@end

@implementation PBProjectCatedoryViewController
@synthesize manager;
@synthesize dataArray;
@synthesize tradekindTabelView;
@synthesize indicator;

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
    // Do any additional setup after loading the view from its nib.
    self.title = @"行业分类";
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
    [manager requestBackgroundXMLData:kURLSTRING forValueAndKey:nil];
    
    manager.acIndicator = indicator;
}

#pragma mark -
#pragma mark ParseDataDelegateMethod
- (void) sucessParseXMLData
{
    [indicator stopAnimating];
    dataArray = [[NSArray arrayWithArray:manager.parseData] retain];
    [tradekindTabelView reloadData];
}

#pragma mark -
#pragma mark TableViewDataSourceMethod
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *identifier = @"MainCategoryCell";
    static BOOL nibsRegistered = NO;
    
    MainCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        nibsRegistered = NO;
    }
    
    if (!nibsRegistered) {
        NSString *nibName = isPad() ? @"MainCategoryCell_iPad" : @"MainCategoryCell";
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        nibsRegistered = YES;
    }
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    [imageView setImage:[[UIImage imageNamed:@"fillcell.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
    cell.backgroundView = imageView;
    [imageView release];
    
    cell.mainCategoryImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"industry%d.png",indexPath.row+1]];
    cell.mainCategoryLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    return cell;
}

#pragma mark -
#pragma mark TableViewDelegateMethod
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PBSpecificTradeController *controller = [[PBSpecificTradeController alloc] init];
    controller.tradeString = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"id"];
    controller.tradeTitleString = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [indicator release];
    [manager release];
    [dataArray release];
    [tradekindTabelView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setIndicator:nil];
    [self setManager:nil];
    [self setDataArray:nil];
    [self setTradekindTabelView:nil];
    [super viewDidUnload];
}
@end
