//
//  PBDetailBusinessPlanViewController.m
//  ParkBusiness
//
//  Created by  on 13-3-30.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBDetailBusinessPlanViewController.h"

#define DETAIL_BUSINESS_PLAN_URL [NSString stringWithFormat:@"%@admin/index/searchprojectbyno",HOST]

@implementation PBDetailBusinessPlanViewController

@synthesize parkManager;
@synthesize data;
@synthesize tableView1;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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

-(void)viewWillAppear:(BOOL)animated
{
    parkManager = [[PBParkManager alloc] init];
    parkManager.delegate = self;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[self.data objectForKey:@"projectno"], @"no", nil];
    [parkManager getRequestData:DETAIL_BUSINESS_PLAN_URL forValueAndKey:dic];
    [dic release];
   

}

#pragma mark-
#pragma mark-   PBParkManagerDelegate

-(void)refreshData
{
    nodesMutableArr = [[NSArray arrayWithArray:parkManager.itemNodes] retain];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"项目介绍:";
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"所属行业:";
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"投资金额:";
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = @"金额单位:";
    }
    if (indexPath.row == 4) {
        cell.textLabel.text = @"项目链接:";
    }
       
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];    
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
