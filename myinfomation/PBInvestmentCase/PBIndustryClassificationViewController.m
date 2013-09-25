//
//  PBIndustryClassificationViewController.m
//  ParkBusiness
//
//  Created by  on 13-3-22.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBIndustryClassificationViewController.h"
#import "PBInvestmentCaseDetailViewController.h"
#import "MainCategoryCell.h"
#import "PBIndustryData.h"
#import "PBIndustryDB.h"

#define INDUSTRY_CLASSIFICATION_URL [NSString stringWithFormat:@"%@admin/index/searchkbnmaster",HOST]

@implementation PBIndustryClassificationViewController
@synthesize tradeArr;
@synthesize parkManager;
@synthesize tableView1;
@synthesize hangyeStr;

-(void)dealloc
{
    [self.tradeArr release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tradeArr = [[NSMutableDictionary alloc]init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(6, 6, 25, 30);
        [btn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(popBackgoView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = backBarBtn;
        [backBarBtn release];
        
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_wc", nil) style:UIBarButtonItemStylePlain target:self action:@selector(popBackgoView)];
        self.navigationItem.rightBarButtonItem = rightButton;
        [rightButton release];        
    }
    return self;
}

-(void)popBackgoView
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

    //自定义UITableView
- (void)tableViewInit {
    
    CGFloat viewWidth = isPad() ? 768 : 320;
    CGFloat viewHeight = (isPad() ? 1024 : (isPhone5() ? 568 :480)) - KTabBarHeight - KNavigationBarHeight;
    
    self.tableView1 = [[[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, viewWidth , viewHeight)] autorelease];
    
    self.tableView1.dataSource=self;
	self.tableView1.delegate=self;
	self.tableView1.backgroundColor=[UIColor clearColor];
	[self.view addSubview:self.tableView1];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择行业";
    [self tableViewInit];
    
    
    
    parkManager = [[PBParkManager alloc] init];
    parkManager.delegate = self;
    nodesMutableArr = [PBIndustryData search:@"industry"];
//    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"industry", @"kind",  nil];
//    [parkManager getRequestData:INDUSTRY_CLASSIFICATION_URL forValueAndKey:dic];
//    [dic release];
    
    arr = [[NSMutableArray alloc] init];
    NSMutableArray *arry = [PBIndustryDB search];
    for(PBIndustryDB *industry in arry)
        {
        NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:industry.name,@"name",[NSString stringWithFormat:@"%d",industry.no],@"no",nil];
        [arr addObject:dic];
        }


    
 
}

#pragma mark-
#pragma mark-   PBParkManagerDelegate
-(void)refreshData
{
    nodesMutableArr = [[NSArray arrayWithArray:parkManager.itemNodes] retain];
    [tableView1 reloadData];
}

#pragma mark-
#pragma mark-   UITableViewDataSource

    //返回多少行
- (NSInteger)tableView:(UITableView *)tableView_ numberOfRowsInSection:(NSInteger)section
{
    return [[PBIndustryDB search] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"MainCategoryCell";
    static BOOL nibsRegistered = NO;
    
    MainCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        nibsRegistered = NO;
    }
    
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"MainCategoryCell" bundle:nil];
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
    cell.mainCategoryLabel.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    if (indexPath.row == oldIndexpath.row && oldIndexpath != nil) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int oldRow = (oldIndexpath == nil)?-1:oldIndexpath.row;
    int currentRow = indexPath.row;
    if (currentRow != oldRow) {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexpath]; 
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        oldIndexpath = [indexPath retain];
    }
    
    hangyeStr = [[arr objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    [self.tradeArr setObject:hangyeStr forKey:@"name"];
    [self.tradeArr setObject:[[arr objectAtIndex:indexPath.row] objectForKey:@"no"] forKey:@"id"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
