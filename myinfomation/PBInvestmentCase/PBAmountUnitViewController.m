//
//  PBAmountUnitViewController.m
//  ParkBusiness
//
//  Created by  on 13-3-22.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBAmountUnitViewController.h"
#import "PBAmountUnitData.h"
#import "PBInvestmentCaseDetailViewController.h"
#import "PBAddCaseViewController.h"
#define AMOUNT_UNIT_URL [NSString stringWithFormat:@"%@admin/index/searchkbnmaster",HOST]

@implementation PBAmountUnitViewController

@synthesize tableView1;
@synthesize str;
@synthesize icdVC;
@synthesize acVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(6, 6, 25, 30);
        [btn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(popBackgoView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = backBarBtn;
        [backBarBtn release];
        
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

#pragma mark - View lifecycle

    //自定义UITableView
- (void)tableViewInit {
   
    CGFloat viewWidth = isPad() ? 768 : 320;
    CGFloat viewHeight = (isPad() ? 1024 : (isPhone5() ? 568 :480)) - KTabBarHeight - KNavigationBarHeight;
    
    self.tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, viewWidth, viewHeight) style:UITableViewStyleGrouped];
    
    self.tableView1.dataSource=self;
	self.tableView1.delegate=self;
	self.tableView1.backgroundColor=[UIColor clearColor];
	[self.view addSubview:self.tableView1];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择金额单位";
    [self tableViewInit];
       
    unitArr = [[NSMutableArray alloc]init];
    NSMutableArray *arry = [PBAmountUnitData search];
    for(PBAmountUnitData *unit in arry)
        {
        [unitArr addObject:unit.name];
        }
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_wc", nil) style:UIBarButtonItemStylePlain target:self action:@selector(popBackgoView)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release]; 
    
}

#pragma mark-
#pragma mark-   UITableViewDataSource

    //返回多少行
- (NSInteger)tableView:(UITableView *)tableView_ numberOfRowsInSection:(NSInteger)section
{
    return [unitArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.textLabel.text = [unitArr objectAtIndex:indexPath.row];
    
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
    str = [unitArr objectAtIndex:indexPath.row];   
    icdVC.label2.text = str;
    acVC.label2.text = str;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
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
