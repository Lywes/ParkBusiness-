//
//  PBpinglun.m
//  ParkBusiness
//
//  Created by 上海 on 13-6-18.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define OURPINGLUN_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchremarklist",HOST]] 
#import "PBpinglun.h"
#import "PBUserModel.h"
#import "UIImageView+WebCache.h"
#import "NSObject+NAV.h"
#import "PBClassRoomDeatil.h"
#import "PBFinancialProductAndServeDetailController.h"
#import "PBIndustryOpportunityDetail.h"
@interface PBpinglun ()
-(void)toGetTheData;
@end
@implementation PBpinglun
@synthesize pinglun_arry;
-(void)dealloc
{
    [attentionInfo release];
    [attention release];
    [pbgzvc release];
    [self.pinglun_arry=nil release];
    [super dealloc];
    
}
-(void)viewDidLoad{
    [super viewDidLoad];
}
-(BOOL)TopViewHidden{
    return YES;
}
-(void)initdata
{
    //data
    self.pinglun_arry = [[[NSMutableArray alloc]init]autorelease];
    [self toGetTheData];
}
-(void)toGetTheData
{
    [activity startAnimating];
    attention = [[PBdataClass alloc]init];
    attention.delegate = self;
    [attention dataResponse:OURPINGLUN_URL postDic:[NSDictionary dictionaryWithObjectsAndKeys:USERNO,@"userno",[NSString stringWithFormat:@"%d",pageno],@"pageno",Nil] searchOrSave:YES];
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    NSLog(@"我们的评论:%@",datas);
    [activity stopAnimating];
    if ([datas count]>0) {
            [self.pinglun_arry addObjectsFromArray:datas];
            [self.tableview reloadData];
        }
     NSLog(@"》》》》%d",[self.pinglun_arry count]);
}
-(void)searchFilad{
     [activity stopAnimating];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.pinglun_arry count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [[self.pinglun_arry objectAtIndex:indexPath.row]objectForKey:@"content"];
    cell.detailTextLabel.text = [[self.pinglun_arry objectAtIndex:indexPath.row]objectForKey:@"cdate"];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [[self.pinglun_arry objectAtIndex:indexPath.row] objectForKey:@"content"];
    UIFont *font = [UIFont systemFontOfSize:13];
    CGSize tag = [str sizeWithFont:font constrainedToSize:CGSizeMake(isPad()?480: 250, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    return MAX(44.0f, tag.height);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [[self.pinglun_arry objectAtIndex:indexPath.row]objectForKey:@"type"];
#pragma mark -  跳转金融资讯详细
    if ([str isEqualToString:@"12"]) {
        PBClassRoomDeatil *detail = [[PBClassRoomDeatil alloc] init];
        detail.datadic = [self.pinglun_arry objectAtIndex:indexPath.row];
        [self customButtom:detail];
        [self.navigationController pushViewController:detail animated:YES];
        [detail release];
    }
#pragma mark -  跳转产品详细
    if ([str isEqualToString:@"3"]) {
        PBFinancialProductAndServeDetailController *detail = [[PBFinancialProductAndServeDetailController alloc] init];
        detail.dataDictionary = [self.pinglun_arry objectAtIndex:indexPath.row];
        detail.no = [[self.pinglun_arry objectAtIndex:indexPath.row]objectForKey:@"commentno"];
        [self customButtom:detail];
        [self.navigationController pushViewController:detail animated:YES];
        [detail release];
    }
#pragma mark -  跳转供求详细
    if ([str isEqualToString:@"11"]) {
        PBIndustryOpportunityDetail *controller = [[PBIndustryOpportunityDetail alloc] initWithStyle:UITableViewStyleGrouped];
        controller.searchDetail = YES;
        controller.dataDictionary = [self.pinglun_arry objectAtIndex:indexPath.row];
        [self customButtom:controller];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}
@end
