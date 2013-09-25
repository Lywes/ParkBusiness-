//
//  PBprojectTrends.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-28.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define KSEARCHPROJECTDYNAMIC [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/projectdynamic",HOST]]
#import "PBprojectTrends.h"
#import "PBtrendData.h"
@interface PBprojectTrends ()
-(void)searchInserver;
@end

@implementation PBprojectTrends
@synthesize _trends;
@synthesize projectno;
@synthesize ProjectStyle;
@synthesize OtherData;
-(void)dealloc
{
    [pbtrend release];
    [self._trends release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"项目最新动态";
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{

    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        self._trends = [PBtrendData searchByprojectno:self.projectno];
        [self.tableView reloadData];
    }

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [activity removeFromSuperview];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    dataclass = [[PBdataClass alloc]init];
    dataclass.delegate  = self;
    if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        activity = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
        [self.view addSubview:activity];
        [self searchInserver];
    }
    else {

        [self navigatorRightButtonType:ZUIJIABUTTON];
    }
    
}
-(void)searchInserver
{
    [activity startAnimating];
    [dataclass dataResponse:KSEARCHPROJECTDYNAMIC postDic:[NSDictionary dictionaryWithObjectsAndKeys:[self.OtherData objectForKey:@"companyno"],@"companyno",[self.OtherData objectForKey:@"no"],@"no", nil] searchOrSave:YES];
    
}
/*
 获取失败
 */
-(void)searchFilad
{
    [activity stopAnimating]; 
}
/*
 获取成功
 */
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    NSLog(@"字段:%@",self.OtherData);
    NSLog(@"项目动态:%@",datas);
    [activity stopAnimating];
    self._trends = datas;
    [self.tableView reloadData];

}
-(void)editButtonPress:(id)sender
{
    if (pbtrend) {
        [pbtrend release];
    }
    pbtrend = [[PBtrend alloc]initWithStyle:UITableViewStyleGrouped];
    pbtrend.title = @"追加动态";
    pbtrend.projectno = self.projectno;
    [pbtrend navigatorRightButtonType:ZUIJIA];
    [self.navigationController pushViewController:pbtrend animated:YES];

}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [self._trends count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        if ([self._trends count]>0) {
            PBtrendData *data = [self._trends objectAtIndex:indexPath.section];
            cell.textLabel.text = data.condition;
            cell.detailTextLabel.text = data.cdate;
        }
    }
    else {
        cell.textLabel.text = [[self._trends objectAtIndex:indexPath.section] objectForKey:@"dynamic"];
        cell.detailTextLabel.text = [[self._trends objectAtIndex:indexPath.section] objectForKey:@"cdate"];   
    }
    return cell;
}





#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (pbtrend) {
        [pbtrend release];
    }
    pbtrend = [[PBtrend alloc]initWithStyle:UITableViewStyleGrouped];
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        pbtrend.trends = [self._trends objectAtIndex:indexPath.section];
        pbtrend.title = @"项目动态";
        [pbtrend navigatorRightButtonType:BIANJI];
        pbtrend.projectno = self.projectno;
    }
    else {
        pbtrend.OtherData = [self._trends objectAtIndex:indexPath.section];
        pbtrend.ProjectStyle = ELSEPROJECTINFO;
    }
    [self.navigationController pushViewController:pbtrend animated:YES];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            NSInteger no = [[self._trends objectAtIndex:indexPath.section] no];
            [activity startAnimating];
            numsection = indexPath.section;
            [dataclass dataResponse:[NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/addprojectcondition",HOST]] postDic:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",no],@"no",@"del",@"mode", nil] searchOrSave:NO];
        }
        
    }
}

-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    [PBtrendData deleteId:[intvalue intValue]];
    [self._trends removeObjectAtIndex:numsection];
    [self.tableView reloadData];
    [activity stopAnimating];
}
@end
