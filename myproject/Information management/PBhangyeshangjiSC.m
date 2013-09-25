//
//  PBhangyeshangjiSC.m
//  ParkBusiness
//
//  Created by QDS on 13-6-26.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define JINTONGHANGYESHANGJI_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchopportunityfavourites",HOST]]

#import "PBhangyeshangjiSC.h"
#import "PBIndustryOpportunityDetail.h"
#import "NSObject+NAV.h"
@implementation PBhangyeshangjiSC

-(void)viewDidLoad{
    [super viewDidLoad];
}
-(void)initdata
{
    [self toGetTheData];
}
-(void)toGetTheData
{
    [activity startAnimating];
    PBdataClass *dc = [[PBdataClass alloc]init];
    dc.delegate = self;
    self.dataclass = dc;
    [dc release];
    [self.dataclass dataResponse:JINTONGHANGYESHANGJI_URL postDic:[NSDictionary dictionaryWithObjectsAndKeys:USERNO,@"userno", nil] searchOrSave:YES];
    
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    self._arr = datas;
    NSLog(@"行业商机收藏:%@",self._arr);
    [activity stopAnimating];
    [self.tableview reloadData];
    NSLog(@"%d",[self.dataclass retainCount]);
    
}
-(void)searchFilad{
     [activity stopAnimating];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self._arr.count>0) {
        return self._arr.count;
    }
    return 0;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]autorelease];

    }
    while ([cell.contentView.subviews lastObject] != nil) {
        [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    //标题与姓名
    UILabel *fromname = [[[UILabel alloc]init]autorelease];
    if (isPad()) {
        fromname.frame = CGRectMake(5, 0, 230, 20);
    }
    else
    {
        fromname.frame = CGRectMake(5, 0, 230, 20);
    }
    fromname.text = [NSString stringWithFormat:@"标题:   %@",[[self._arr objectAtIndex:indexPath.row] objectForKey:@"name"]];
    fromname.textAlignment = NSTextAlignmentLeft;
    fromname.font = [UIFont systemFontOfSize:13];
    fromname.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleWidth;
    [cell.contentView addSubview:fromname];
    
    UILabel *name = [[[UILabel alloc]init]autorelease];
    if (isPad()) {
        name.frame = CGRectMake(10, 20, 200, 20);
    }
    else
    {
        name.frame = CGRectMake(5, 20, 80, 20);
    }
    name.text = [NSString stringWithFormat:@"类型: %@",[[self._arr objectAtIndex:indexPath.row] objectForKey:@"type"]];
    name.textAlignment = NSTextAlignmentLeft;
    name.font = [UIFont systemFontOfSize:10];
    [cell.contentView addSubview:name];
    
    UILabel *trade = [[[UILabel alloc]init]autorelease];
    if (isPad()) {
        trade.frame = CGRectMake(220, 20, 200, 20);
    }
    else{
        trade.frame = CGRectMake(100, 20, 100, 20);
    }
    trade.text = [NSString stringWithFormat:@"行业: %@",[[self._arr objectAtIndex:indexPath.row] objectForKey:@"trade"]];
    trade.textAlignment = NSTextAlignmentLeft;
    trade.font = [UIFont systemFontOfSize:10];
    [cell.contentView addSubview:trade];
    
    UILabel *username = [[[UILabel alloc]init]autorelease];
    if (isPad()) {
        username.frame = CGRectMake(10, 40, 200, 20);
    }
    else
    {
        username.frame = CGRectMake(5, 40, 80, 20);
        
    }
    username.text = [NSString stringWithFormat:@"发布人: %@",[[self._arr objectAtIndex:indexPath.row] objectForKey:@"username"]];
    username.textAlignment = NSTextAlignmentLeft;
    username.font = [UIFont systemFontOfSize:10];
    [cell.contentView addSubview:username];
    
    UILabel *cdate = [[[UILabel alloc]init]autorelease];
    if (isPad()) {
        cdate.frame = CGRectMake(220, 40, 200, 20);
    }
    else{
        cdate.frame = CGRectMake(100, 40, 130, 20);
    }
    cdate.text = [NSString stringWithFormat:@"时间: %@",[[self._arr objectAtIndex:indexPath.row] objectForKey:@"cdate"]];
    cdate.textAlignment = NSTextAlignmentLeft;
    cdate.font = [UIFont systemFontOfSize:10];
    [cell.contentView addSubview:cdate];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PBIndustryOpportunityDetail *controller = [[PBIndustryOpportunityDetail alloc] initWithStyle:UITableViewStyleGrouped];
    controller.dataDictionary = [self._arr objectAtIndex:indexPath.row];
    
    [self customButtom:controller];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}
@end
