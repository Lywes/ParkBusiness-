//
//  PBProjectStageViewController.m
//  ParkBusiness
//
//  Created by  on 13-4-21.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBProjectStageViewController.h"
#import "PBStageData.h"

@implementation PBProjectStageViewController

@synthesize tableView1;
@synthesize str;

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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)finishBtn
{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"nav_btn_wc", nil)style:UIBarButtonItemStylePlain target:self action:@selector(popBackgoView)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];
    
    
}

-(void)popBackgoView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tableViewInit
{
    CGFloat viewWidth = isPad() ? 768 : 320;
    CGFloat viewHeight = (isPad() ? 1024 : (isPhone5() ? 568 :480)) - KTabBarHeight - KNavigationBarHeight;
    
    tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight) style:UITableViewStyleGrouped];
    
    tableView1.delegate = self;
    tableView1.dataSource = self;
    [self.view addSubview:tableView1];
}


#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择融资阶段";
    [self tableViewInit];
    [self finishBtn];
    
    stageArr = [[NSMutableArray alloc]init];
    NSMutableArray *arry = [PBStageData search];
    for(PBStageData *stage in arry)
        {
        [stageArr addObject:stage.name];
        }

    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

    //返回多少行
- (NSInteger)tableView:(UITableView *)tableView_ numberOfRowsInSection:(NSInteger)section
{
    return [stageArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.textLabel.text = [stageArr objectAtIndex:indexPath.row];
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
    str = [stageArr objectAtIndex:indexPath.row];  
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
