//
//  PBSectoralEntrepreneurs.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-7.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBSectoralEntrepreneurs.h"
#import "PBSpecificSectoralCompaniesController.h"
#import "MainCategoryCell.h"

#define kURLSTRING [NSString stringWithFormat:@"%@admin/index/tradekinds", HOST]

@interface PBSectoralEntrepreneurs ()

@end

@implementation PBSectoralEntrepreneurs
@synthesize sectoralManager;
@synthesize sectoralDataArray;
@synthesize sectoralTableView;
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
    self.title = @"行业分类";
    
    CGFloat viewWidth = 320;
    CGFloat viewHeight = (isPhone5() ? 568 :480)-KTabBarHeight-KNavigationBarHeight;
    if (isPad()) {
        viewWidth = 768;
        viewHeight = 1024-KTabBarHeight-KNavigationBarHeight;
    }
    
    indicator = [[PBActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    [self.view addSubview:indicator];
    [indicator startAnimating];
    
    sectoralManager = [[PBManager alloc] init];
    sectoralManager.delegate = self;
    [sectoralManager requestBackgroundXMLData:kURLSTRING forValueAndKey:nil];
    
    sectoralManager.acIndicator = indicator;
}

#pragma mark -
#pragma mark ParseDataDelegateMethod
- (void) sucessParseXMLData
{
    [indicator stopAnimating];
    sectoralDataArray = [[NSArray arrayWithArray:sectoralManager.parseData] retain];
    [sectoralTableView reloadData];
}

#pragma mark -
#pragma mark TableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [sectoralDataArray count];
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
    
    cell.mainCategoryLabel.text = [[sectoralDataArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.mainCategoryImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"industry%d.png",indexPath.row+1]];
    return cell;
}

#pragma mark -
#pragma mark TableViewDelegateMethod
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PBSpecificSectoralCompaniesController *controller = [[PBSpecificSectoralCompaniesController alloc] init];
    controller.tradeID = [[sectoralDataArray objectAtIndex:indexPath.row] objectForKey:@"id"];
    controller.titleString = [[sectoralDataArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void)viewDidUnload
{
    [self setIndicator:nil];
    [self setSectoralDataArray:nil];
    [self setSectoralManager:nil];
    [self setSectoralTableView:nil];
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
    [indicator release];
    [sectoralDataArray release];
    [sectoralManager release];
    [sectoralTableView release];
    [super dealloc];
}
@end
