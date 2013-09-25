//
//  PBDetailIndustryMarketViewController.m
//  ParkBusiness
//
//  Created by  on 13-4-1.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBDetailIndustryMarketViewController.h"
#import "PBDetailIndustryData.h"
#import "PBInvestmentSettingViewController.h"

@implementation PBDetailIndustryMarketViewController
@synthesize tableView1;
@synthesize str;
@synthesize arr;
@synthesize strMutableArr;
@synthesize indepatharry;
@synthesize setting;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(6, 6, 48, 32);
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

-(void)rightBtn
{
    
   UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"nav_btn_wc", nil) style:UIBarButtonItemStylePlain target:self action:@selector(edit)];
    self.navigationItem.rightBarButtonItem = rightbtn;
    [rightbtn release];

}

-(void)edit
{
    strings = [[[NSMutableString alloc]init]autorelease];
    for (NSString *st in strMutableArr) {
        [strings appendString:st];
    }
    self.setting.string2 = strings;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择细分市场";
    [self rightBtn];
    [self tableViewInit];
    self.indepatharry = [NSMutableArray arrayWithCapacity:5];
    self.strMutableArr = [NSMutableArray arrayWithCapacity:5];
    
    detailIndustryArr = [[NSMutableArray alloc]init];
    for (NSDictionary * dic in self.arr) {
        int no = [[dic objectForKey:@"no"] intValue];
        NSMutableArray *arry = [PBDetailIndustryData searchInducstry:no];
        for(PBDetailIndustryData *detailIndustry in arry)
            {
            [detailIndustryArr addObject:detailIndustry.name];
            }
    }
  
}


- (NSInteger)tableView:(UITableView *)tableView_ numberOfRowsInSection:(NSInteger)section
{
    return [detailIndustryArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    if ([self.indepatharry containsObject:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.textLabel.text = [detailIndustryArr objectAtIndex:indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
        // str = [[nodesMutableArr objectAtIndex:indexPath.row] objectForKey:@"kbnname"];
    str = [detailIndustryArr objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [self.tableView1 cellForRowAtIndexPath:indexPath]; 
    if ([self.indepatharry count]<=5) {
        
        if(cell.accessoryType == UITableViewCellAccessoryNone)
            {
            if ([self.indepatharry count]<5)
                {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [self.indepatharry addObject:indexPath];
                [self.strMutableArr addObject:str];
                }
            }
        else
            {
            cell.accessoryType = UITableViewCellAccessoryNone; 
            [self.indepatharry removeObject:indexPath];
            [self.strMutableArr removeObject:str];
            }
        
    }  
   
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
//    strings = [[[NSMutableString alloc]init]autorelease];
//    for (NSString *st in strMutableArr) {
//        [strings appendString:st];
//    }
        //iSVC.string1 = strings;
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
