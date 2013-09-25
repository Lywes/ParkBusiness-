//
//  PBInvestmentIndustryViewController.m
//  ParkBusiness
//
//  Created by  on 13-3-22.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBInvestmentIndustryViewController.h"
#import "PBInvestmentSettingViewController.h"
#import "PBIndustryDB.h"
#import "MainCategoryCell.h"

#define kSCNavBarImageTag                   10
#define INVESTMENT_INDUSTRY_URL [NSString stringWithFormat:@"%@admin/index/searchkbnmaster",HOST]

@implementation PBInvestmentIndustryViewController

@synthesize parkManager;
@synthesize tableView1;
@synthesize indepatharry;
@synthesize str;
@synthesize noStr;
@synthesize str1;
@synthesize str2;
@synthesize str3;
@synthesize strMutableArr;
@synthesize setting;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
      [super didReceiveMemoryWarning];
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

- (void)viewWillAppear:(BOOL)animated
{
    
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"11111");
}
-(void)viewDidDisappear:(BOOL)animated{
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
     arr = [[NSMutableArray alloc] init];
    self.indepatharry = [NSMutableArray arrayWithCapacity:3];
    self.strMutableArr = [NSMutableArray arrayWithCapacity:3];
    [self tableViewInit];
//    
//      if (isPad()) {
//         navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,768,44)];
//    }else{
//         navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
////
//    }
//    
    if ([navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])  
        {  
                //if iOS 5.0 and later  
            [navigationBar setBackgroundImage:[UIImage imageNamed:@"topnavigation.png"] forBarMetrics:UIBarMetricsDefault];  
        }  
    else  
        {  
            UIImageView *imageView = (UIImageView *)[navigationBar viewWithTag:kSCNavBarImageTag];  
            if (imageView == nil)  
                {  
                    imageView = [[UIImageView alloc] initWithImage:  
                                 [UIImage imageNamed:@"topnavigation.png"]];  
                    [imageView setTag:kSCNavBarImageTag];  
                    [navigationBar insertSubview:imageView atIndex:0];  
                    [imageView release];  
                }  
        }  

    
    UIBarButtonItem *leftbtn = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_qx", nil) style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftbtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_wc", nil) style:UIBarButtonItemStylePlain target:self action:@selector(finish)];  
  
    NSMutableArray *arry = [PBIndustryDB search];
    for(PBIndustryDB *industry in arry)
        {
        NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:industry.name,@"name",[NSString stringWithFormat:@"%d",industry.no],@"no",nil];
            [arr addObject:dic];
        }

}

-(void)back
{
      [self dismissModalViewControllerAnimated:YES];
    
}
-(void)finish
{
    NSMutableString * strings = [[[NSMutableString alloc]init]autorelease];
    for (NSDictionary *dic in strMutableArr) {
        [strings appendString:[dic objectForKey:@"name"]];
    }
    self.setting.arr = strMutableArr;
    self.setting.string1 = strings;
    [self.setting.tableView1 reloadData];
    [self dismissModalViewControllerAnimated:YES];
}

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
    cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    
   
    if ([self.indepatharry containsObject:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
        cell.accessoryType = UITableViewCellAccessoryNone;

        return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
       
    str = [[arr objectAtIndex:indexPath.row] objectForKey:@"name"];

    UITableViewCell *cell = [self.tableView1 cellForRowAtIndexPath:indexPath]; 
    if ([self.indepatharry count]<=3) {
   
    if(cell.accessoryType == UITableViewCellAccessoryNone)
    {
    if ([self.indepatharry count]<3)
        {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.indepatharry addObject:indexPath];
        [self.strMutableArr addObject:[arr objectAtIndex:indexPath.row]];
        }
    }
    else
        {
            cell.accessoryType = UITableViewCellAccessoryNone; 
            [self.indepatharry removeObject:indexPath];
            [self.strMutableArr removeObject:[arr objectAtIndex:indexPath.row]];
        }
        
   }  
  
     [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
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
