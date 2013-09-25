//
//  PBprojectplan.m
//  ParkBusiness
//
//  Created by 新平 圣 on 13-3-4.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define SEARCHPROJECTPLAN [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchprojectplan",HOST]]
#import "PBprojectplan.h"
#import "PBPlanData.h"
@interface PBprojectplan()
-(void)searchInserver;
@end
@implementation PBprojectplan
@synthesize arry_lables,celltext;
@synthesize projectno;
-(void)dealloc
{
    [arry_lables = nil release];
    [self.celltext release];
    [pbaddprojectpaln release];
    [dataclass release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.celltext = nil;
    pbaddprojectpaln = nil;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title  =@"项目发展计划";
        UILabel *lable1 = [[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 45)]autorelease];
        UILabel *lable2 = [[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 45)]autorelease];

        self.arry_lables = [[[NSMutableArray  alloc]initWithObjects:lable1,lable2, nil]autorelease];
        self.celltext = [[NSMutableArray alloc]init];
    }
    return self;
}
-(void)viewLoding
{
    activity = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    dataclass = [[PBdataClass alloc]init];
    dataclass.delegate = self;
}
-(void)viewWillAppear:(BOOL)animated
{
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        [self navigatorRightButtonType:ZUIJIA];
        self.tableView.allowsSelection = YES;
        NSMutableArray *arry = [PBPlanData searchWhereProjectno:self.projectno];
        if (arry.count !=0) {
            self.celltext = arry;
            [self.tableView reloadData];
        }
        if (arry.count >=3) {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
    else {
        [self.view addSubview:activity];
        [self searchInserver];
    }

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [activity removeFromSuperview];
}
-(void)searchInserver
{
    [activity startAnimating];
   [dataclass dataResponse:SEARCHPROJECTPLAN postDic:[NSDictionary dictionaryWithObjectsAndKeys:[self.datadic objectForKey:@"companyno"],@"companyno",[self.datadic objectForKey:@"projectno"],@"projectno", nil] searchOrSave:YES];
}
/*
 获取失败
 */
-(void)searchFilad
{
    [activity stopAnimating]; 
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    NSLog(@"字段:%@",self.datadic);
    NSLog(@"项目发展计划:%@",datas);
    celltext = datas;
    [self.tableView reloadData];
     [activity stopAnimating]; 
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.celltext count] < 3) {
        if (!self.navigationItem.rightBarButtonItem ) {
            [self navigatorRightButtonType:ZUIJIA];
        }
    }
    return [self.celltext count];

}

-(void)addSubViewForCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        cell.textLabel.text = @"第一年发展计划";
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = @"第二年发展计划";
    }
    if (indexPath.section == 2) {
        cell.textLabel.text = @"第三年发展计划";
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    pbaddprojectpaln = [[PBaddprojectplan alloc]initWithStyle:UITableViewStyleGrouped];
    pbaddprojectpaln._datas = self.celltext;
    pbaddprojectpaln.number = indexPath.section;
    if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        pbaddprojectpaln.ProjectStyle = ELSEPROJECTINFO;
    }
    else {
        pbaddprojectpaln.projectno = self.projectno;
    }    
    if (indexPath.section == 0) {
        pbaddprojectpaln.className = @"第一年发展计划";
    }
    if (indexPath.section == 1) {
        pbaddprojectpaln.className = @"第二年发展计划";
    }
    if (indexPath.section == 2) {
        pbaddprojectpaln.className = @"第三年发展计划";
    }
    
    [self.navigationController pushViewController:pbaddprojectpaln animated:YES];
    [pbaddprojectpaln release];
}
-(void)editButtonPress:(id)sender
{
    pbaddprojectpaln = [[PBaddprojectplan alloc]initWithStyle:UITableViewStyleGrouped];
    pbaddprojectpaln.projectno = self.projectno;
    if ([celltext count]== 0) {
        [pbaddprojectpaln._datas removeAllObjects];
        pbaddprojectpaln.className = @"第一年发展计划";
    }
    if ([celltext count]== 1) {
        [pbaddprojectpaln._datas removeAllObjects];
        pbaddprojectpaln.className = @"第二年发展计划";
    }
    if ([celltext count]== 2) {
        [pbaddprojectpaln._datas removeAllObjects];
        pbaddprojectpaln.className = @"第三年发展计划";
    }
    [self.navigationController pushViewController:pbaddprojectpaln animated:YES];
    [pbaddprojectpaln release];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO])  {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            NSInteger no = [[self.celltext objectAtIndex:indexPath.section] no];
            numsection = indexPath.section;
            [activity startAnimating];
            [dataclass dataResponse:[NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/addprojectplan",HOST]] postDic:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",no],@"no",@"del",@"mode", nil] searchOrSave:NO];
        }
    }

}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    [PBPlanData deleteId:[intvalue intValue]];
    [self.celltext removeObjectAtIndex:numsection];
    [self.tableView reloadData];
    [activity stopAnimating];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
