//
//  PBSuccessprojectList.m
//  ParkBusiness
//
//  Created by 上海 on 13-5-14.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define CHENGGONGANLI_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@admin/index/searchsuccessproject",UNION]]
#import "PBSuccessprojectList.h"
#import "PBSuccessProject.h"
@interface PBSuccessprojectList ()
-(void)initData;
@end

@implementation PBSuccessprojectList
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"成功案例";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self backUpView];
    [self initData];
}
-(void)initData
{
    dataclass = [[PBdataClass alloc]init];
    dataclass.delegate = self;
    [dataclass dataResponse:CHENGGONGANLI_URL postDic:nil searchOrSave:YES];
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    self.DataArr = [[[NSMutableArray alloc]init]autorelease];
    [self.DataArr addObjectsFromArray:datas];
    NSLog(@"%@",self.DataArr);
    [self.tableView reloadData];
}
-(void)searchFilad
{
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [self.DataArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    }
    if (self.DataArr.count > 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [[self.DataArr objectAtIndex:indexPath.section] objectForKey:@"proname"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PBSuccessProject *success = [[PBSuccessProject alloc]initWithStyle:UITableViewStyleGrouped];
    success.DataDic = [self.DataArr objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:success animated:YES];
    [success release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
