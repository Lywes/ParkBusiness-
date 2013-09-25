//
//  PBxinwenSC.m
//  ParkBusiness
//
//  Created by QDS on 13-6-26.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define JINTONGXINWEN_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchknowledgeclassfavourites",HOST]]
#import "UIImageView+WebCache.h"
#import "PBxinwenSC.h"
#import "PBClassRoomDeatil.h"
#import "NSObject+NAV.h"
@implementation PBxinwenSC

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
    [self.dataclass dataResponse:JINTONGXINWEN_URL postDic:[NSDictionary dictionaryWithObjectsAndKeys:USERNO,@"userno", nil] searchOrSave:YES];
    
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    self._arr = datas;
    NSLog(@"金融资讯收藏:%@",self._arr);
    [activity stopAnimating];
    [self.tableview reloadData];
    
}
-(void)searchFilad
{
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
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        UIImageView* imageview = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 32, 32)];
        [cell.contentView addSubview:imageview];
        [imageview release];
        imageview.tag = 10;
        imageview.layer.shadowRadius = 5.0f;
        imageview.layer.masksToBounds = YES;
        imageview.layer.cornerRadius = 5.0f;
        
        UILabel *fromname = [[UILabel alloc]init];
        fromname.tag =11;
        fromname.text = [[self._arr objectAtIndex:indexPath.row] objectForKey:@"title"];
        fromname.numberOfLines = 10;
        fromname.lineBreakMode = UILineBreakModeClip;
        fromname.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:fromname];
        [fromname release];
    }
    
    UIImageView *imageview = (UIImageView *)[cell.contentView viewWithTag:10];
    if (self._arr.count>0) {
        NSString *imagepath = [NSString stringWithFormat:@"%@%@",HOST,[[self._arr objectAtIndex:indexPath.row] objectForKey:@"imagepath"]];
        [imageview setImageWithURL:[NSURL URLWithString:imagepath]];
    }
    UILabel *fromname = (UILabel *)[cell.contentView viewWithTag:11];
    CGSize a = [fromname.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(isPad()?480:150, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    fromname.frame = CGRectMake(isPad()?50:45, -5, isPad()?VIEWSIZE.width - 50:VIEWSIZE.width - 45, MAX(44.0f, a.height));
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PBClassRoomDeatil *detail = [[PBClassRoomDeatil alloc]init];
    detail.datadic = [self._arr objectAtIndex:indexPath.row];
    [self customButtom:detail];
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
}
@end
