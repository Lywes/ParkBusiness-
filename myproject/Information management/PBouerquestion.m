//
//  PBouerquestion.m
//  ParkBusiness
//
//  Created by QDS on 13-6-25.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define OURQUESTION_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchquestioninfolist",HOST]]
#import "PBouerquestion.h"

@implementation PBouerquestion

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
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:USERNO,@"userno", nil];
    [self.dataclass dataResponse:OURQUESTION_URL postDic:dic searchOrSave:YES];
    [dic release];
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    self._arr = datas;
    NSLog(@"我们的提问:%@",self._arr);   
    [activity stopAnimating];
    [self.tableview reloadData];
     
}
-(void)searchFilad{
     [activity stopAnimating];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self._arr count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.numberOfLines = 0;
    
    if (self._arr.count>0) {
        cell.textLabel.text = [[self._arr objectAtIndex:indexPath.row]objectForKey:@"question"];
        cell.detailTextLabel.text =[[self._arr objectAtIndex:indexPath.row]objectForKey:@"cdate"];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [[self._arr objectAtIndex:indexPath.row] objectForKey:@"question"];
    NSString *str1 =[[self._arr objectAtIndex:indexPath.row] objectForKey:@"cdate"];
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize tag = [str sizeWithFont:font constrainedToSize:CGSizeMake(isPad()?480: 200, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize tag1 = [str1 sizeWithFont:font constrainedToSize:CGSizeMake(isPad()?480: 200, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    return MAX(44.0f, tag.height + tag1.height);
}
@end
