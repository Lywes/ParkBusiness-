//
//  PBHighCourseVC.m
//  ParkBusiness
//
//  Created by QDS on 13-7-1.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define GAODUANKECHEN_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/seniorclass",HOST]]

#import "PBHighCourseVC.h"
#import "PBHighCourseDetail.h"
#import "NSObject+CellLine.h"
@interface PBHighCourseVC ()

@end

@implementation PBHighCourseVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
}
-(void)viewWillDisappear:(BOOL)animated{
    [searchBar resignFirstResponder];
}
-(void)initdata
{
    [ac startAnimating];
    PBdataClass *dataclass = [[PBdataClass alloc]init];
    dataclass.delegate = self;
    self.dataclass = dataclass;
    [dataclass release];
    if (pageno==1) {
        [self.dataArr removeAllObjects];
    }
    NSDictionary *dic= [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageno],@"pageno",USERNO,@"userno", nil];
    [self.dataclass dataResponse:GAODUANKECHEN_URL postDic:dic searchOrSave:YES];
    [dic release];
}
#pragma mark –搜索框
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1
{
    NSDictionary *dic= [[[NSDictionary alloc]initWithObjectsAndKeys:searchBar1.text,@"name",USERNO,@"userno", nil]autorelease];
    [self.dataclass dataResponse:GAODUANKECHEN_URL postDic:dic searchOrSave:YES];
    [searchBar resignFirstResponder];
}
#pragma mark –tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.highlightedTextColor = [UIColor blackColor];
        cell.detailTextLabel.highlightedTextColor = [UIColor blackColor];
    }
    if (self.dataArr.count>0) {
        NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"hightcourse.png"];
        cell.textLabel.text = [dic objectForKey:@"name"];
        cell.detailTextLabel.text = [dic objectForKey:@"jgname"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PBHighCourseDetail *detail = [[PBHighCourseDetail alloc]initWithStyle:UITableViewStyleGrouped];
    detail.DataDic = [self.dataArr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
