//
//  PBInvestmentCaseViewController.m
//  ParkBusiness
//
//  Created by  on 13-3-12.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define _STRPOST_(x) x  == NULL? @"":x

#import "PBInvestmentCaseViewController.h"
#import "PBInvestmentCaseDetailViewController.h"
#import "PBInvestmentCaseCell.h"
#import "PBAddCaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "PBUserModel.h"
#import "PBFinancingCase.h"
#import "PBAddAnLiData.h"
#import "DBFinancingCase.h"
#define PARK_ACTIVITY_URL [NSString stringWithFormat:@"%@admin/index/searchprojectbyuserid",HOST]

#define kSCNavBarImageTag                   10

@implementation PBInvestmentCaseViewController

@synthesize parkManager;
@synthesize tableView1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated
{
     arry = [DBFinancingCase search];
    [arry retain];

//    detailArr = [PBDetailAnLiData search];
    [tableView1 reloadData];
}

//自定义UITableView
- (void)tableViewInit {
    
    CGFloat viewWidth = isPad() ? 768 : 320;
    CGFloat viewHeight = (isPad() ? 1024 : (isPhone5() ? 568 :480)) - KTabBarHeight - KNavigationBarHeight;
    
    tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, viewWidth, viewHeight) style:UITableViewStylePlain];

    tableView1.delegate = self;
    tableView1.dataSource = self;
	
	[self.view addSubview:tableView1];
}


-(void)navigationBarBackgroundImage
{
    UINavigationBar *navBar = self.navigationController.navigationBar;
    
    
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        //if iOS 5.0 and later
        [navBar setBackgroundImage:[UIImage imageNamed:@"topnavigation.png"] forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        UIImageView *imageView = (UIImageView *)[navBar viewWithTag:kSCNavBarImageTag];
        if (imageView == nil)
        {
            imageView = [[UIImageView alloc] initWithImage:
                         [UIImage imageNamed:@"topnavigation.png"]];
            [imageView setTag:kSCNavBarImageTag];
            [navBar insertSubview:imageView atIndex:0];
            [imageView release];
        }
    }
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationBarBackgroundImage];
    [self rightBarButton];
    [self tableViewInit];
    
}

-(void)rightBarButton
{

    UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(nextView)];
    self.navigationItem.rightBarButtonItem = rightbtn;
    [rightbtn release]; 
    
}

-(void)nextView
{
    /*
    PBAddCaseViewController *addVC = [[PBAddCaseViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
    [addVC release];
     */
   
    PBFinancingCase *addVC = [[PBFinancingCase alloc] initWithStyle:UITableViewStyleGrouped];
    addVC.title = @"追加融资案例";
    addVC.Mod_Add = @"add";
    PBNavigationController *nav = [[PBNavigationController alloc]initWithRootViewController:addVC];
    nav.navigationBar.barStyle = UIBarStyleBlack;
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:nav animated:YES];
    [addVC release];
    [nav release];
}

#pragma mark-
#pragma mark-   UITableViewDataSource

//返回多少行
- (NSInteger)tableView:(UITableView *)tableView_ numberOfRowsInSection:(NSInteger)section
{
    return [arry count];
}

//单元格重用(用的cell是自己定制的)
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static BOOL nibsRegisted = NO;
    static NSString *identifier = @"CellIdentifier";
    
    PBInvestmentCaseCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        nibsRegisted = NO;
    }
    
    if (!nibsRegisted) {
        NSString *nibName = isPad() ? @"PBIpadInvestmentCaseCell" : @"PBInvestmentCaseCell";
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:identifier];
        nibsRegisted = YES;
    }
    if (cell==nil) {
        cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    }
    DBFinancingCase *anLi = [arry objectAtIndex:indexPath.row];
//    PBDetailAnLiData *detailAnLi = [detailArr objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.nameLabel.text = anLi.name == NULL?@"":anLi.name;
//    cell.dateLabelView.text = detailAnLi.starttime == NULL?@"":detailAnLi.starttime;
    cell.imageView.image = [UIImage imageNamed:@"touzianli1.png"];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PBFinancingCase *addVC = [[PBFinancingCase alloc] initWithStyle:UITableViewStyleGrouped];
    addVC.title = NSLocalizedString(@"_title_cpfwxxxx", nil);
    DBFinancingCase *db = [arry objectAtIndex:indexPath.row];
    NSMutableArray *dataarr = [[NSMutableArray alloc] initWithObjects:
                               [NSMutableArray arrayWithObjects:
                                _STRING_H_(db.name),
                                [NSString stringWithFormat:@"%@",[PBKbnMasterModel getKbnNameById:db.type withKind:@"projecttype"]],
                                [NSString stringWithFormat:@"%@",[PBKbnMasterModel getKbnNameById:db.trade withKind:@"industry"]],
                                _STRING_H_(db.companyinfo), nil],
                               [NSMutableArray arrayWithObjects:_STRING_H_(db.casedetail), nil],
                               [NSMutableArray arrayWithObjects:@"点击选择/查看", nil],
                               nil];
    addVC.DataArr = dataarr;
    addVC.Mod_Add = @"mod";
    addVC.productno = db.productno;
    addVC.projectno = db.no;
    [addVC.tableView reloadData];
    [self.navigationController pushViewController:addVC animated:YES];
    [db release];
    [addVC release];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)dealloc
{
    RB_SAFE_RELEASE(arry);
    [super dealloc];
}
@end
