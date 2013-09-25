//
//  PBBusinessLicaiNeed.m
//  ParkBusiness
//
//  Created by China on 13-7-15.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define BusinessLICAINeed_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchmanagemoneyneeds",HOST]]

#import "PBBusinessLicaiNeed.h"
#import "PBBusinessLicaidetail.h"
#import "NSObject+NAV.h"
@implementation PBBusinessLicaiNeed
@synthesize name=_name;
@synthesize date=_date;
@synthesize qiwang=_qiwang;
@synthesize keyongzijin=_keyongzijin;
@synthesize licaileixing = _licaileixing;
-(void)dealloc
{
    RB_SAFE_RELEASE(_name);
    RB_SAFE_RELEASE(_date);
    RB_SAFE_RELEASE(_qiwang);
    RB_SAFE_RELEASE(_keyongzijin);
    [super dealloc];
}
-(BOOL)TopViewHidden{
    return NO;
}
-(void)viewDidLoad{
    [super viewDidLoad];
}
-(void)toGetTheData
{
    //    [activity startAnimating];
    PBdataClass * data = [[PBdataClass alloc]init];
    data.delegate = self;
    self.dataclass = data;
    [data release];
    NSDictionary *dic =[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",[PBUserModel getCompanyno]],@"financeno", nil];
    [self.dataclass dataResponse:BusinessLICAINeed_URL postDic:dic searchOrSave:YES];
    [dic release];
    
    
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    NSLog(@"企业理财需求：%@",datas);
    [activity stopAnimating];
    [self.quanbu_arr removeAllObjects];
    [datas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         [self.quanbu_arr addObject:obj];
         if (![[obj objectForKey:@"answer"] isEqual:@""]) {
             [self.yijieda_arr addObject:obj];
         }
         else
             [self.weijieda_arr addObject:obj];
         if (stop) {
             [self._arr removeAllObjects];
             [self._arr addObjectsFromArray:self.quanbu_arr];
         }
     }];
    [self.tableview reloadData];
}
-(void)searchFilad{
    [activity stopAnimating];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:isPad()?@"PBBusinessLicaiNeedCell_iPad":@"PBBusinessLicaiNeedCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    if (self._arr.count>0) {
        NSString *str = [[self._arr objectAtIndex:indexPath.row] objectForKey:@"username"];
        self.name.text = str;
        self.date.text = [[self._arr objectAtIndex:indexPath.row]objectForKey:@"timeperiod"];
        [self.use sizeToFit];
        self.qiwang.text = [[self._arr objectAtIndex:indexPath.row] objectForKey:@"expectreturn"];
        self.keyongzijin.text = [[self._arr objectAtIndex:indexPath.row] objectForKey:@"availablefund"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PBBusinessLicaidetail *zhence = [[PBBusinessLicaidetail alloc]initWithNibName:isPad()?@"PBBusinessFiancingdetail_iPad":@"PBBusinessFiancingdetail" bundle:nil];
    zhence.data_dic = [self._arr objectAtIndex:indexPath.row];
    
    [self customButtom:zhence];
    [self.navigationController pushViewController:zhence animated:YES];
    [zhence release];
}
@end
