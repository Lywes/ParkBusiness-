//
//  PBAnLiSC.m
//  ParkBusiness
//
//  Created by QDS on 13-6-26.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define JINTONGANLI_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchmyfavourites",HOST]]
#import "PBAnLiSC.h"
#import "PBFinancialCaseDetailController.h"
#import "NSObject+NAV.h"
#import "UIImageView+WebCache.h"
@implementation PBAnLiSC

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
    [self.dataclass dataResponse:JINTONGANLI_URL postDic:[NSDictionary dictionaryWithObjectsAndKeys:@"10",@"type",USERNO,@"userno", nil] searchOrSave:YES];
    
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    self._arr = datas;
    NSLog(@"金融案例收藏:%@",self._arr);
    [activity stopAnimating];
    [self.tableview reloadData];
    
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
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    }

    while ([cell.contentView.subviews lastObject] != nil) {
        [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    //标题与姓名
    UILabel *fromname = [[UILabel alloc]init];
    fromname.text = [[self._arr objectAtIndex:indexPath.row] objectForKey:@"name"];
    CGSize size = STRSIZE(fromname.text);
    fromname.frame = CGRectMake(isPad()?50:45, 0, isPad()?VIEWSIZE.width-50:VIEWSIZE.width-44, size.height);
    fromname.numberOfLines = 0;
    fromname.font = [UIFont systemFontOfSize:15];
    [cell.contentView addSubview:fromname];
    [fromname release];
    
    UILabel *name = [[UILabel alloc]init];
    name.text = [[self._arr objectAtIndex:indexPath.row] objectForKey:@"financename"];
    CGSize size1 = STRSIZE(name.text);
    name.frame = CGRectMake(isPad()?50:45, size.height, isPad()?VIEWSIZE.width-50:VIEWSIZE.width-44, size1.height);
    name.lineBreakMode = UILineBreakModeWordWrap;
    name.font = [UIFont systemFontOfSize:15];
    [cell.contentView addSubview:name];
    [name release];
    
    //头像
    UIImageView* imageview = [[UIImageView alloc]initWithFrame:CGRectMake(5, (size.height + size1.height)/2 - 32/2, 32, 32)];
    //    imageview.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
    [cell.contentView addSubview:imageview];
    [imageview release];
    if (self._arr.count>0) {
        NSString *imagepath = [NSString stringWithFormat:@"%@%@",HOST,[[self._arr objectAtIndex:indexPath.row] objectForKey:@"imagepath"]];
        [imageview setImageWithURL:[NSURL URLWithString:imagepath]];
    }
    imageview.layer.shadowRadius = 5.0f;
    imageview.layer.masksToBounds = YES;
    imageview.layer.cornerRadius = 5.0f;
    
    
    NSLog(@">>>%d",cell.contentView.subviews.count);
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [[self._arr objectAtIndex:indexPath.row] objectForKey:@"financename"];
    NSString *str1 = [[self._arr objectAtIndex:indexPath.row] objectForKey:@"name"];
    CGSize a = STRSIZE(str);
    CGSize b = STRSIZE(str1);
    NSLog(@"%f",a.height+b.height);
    return MAX(44.0f, a.height+b.height);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PBFinancialCaseDetailController *anlixiagxi = [[PBFinancialCaseDetailController alloc]init];
    anlixiagxi.caseno = [[self._arr objectAtIndex:indexPath.row] objectForKey:@"no"];
    anlixiagxi.shoucang = @"1";
    anlixiagxi.flag = @"1";
    [self customButtom:anlixiagxi];
    [self.navigationController pushViewController:anlixiagxi animated:YES];
    [anlixiagxi release];
}
@end
