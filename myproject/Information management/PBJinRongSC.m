//
//  PBmyLiCai.m
//  ParkBusiness
//
//  Created by QDS on 13-6-25.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define JINTONGSHOUCANG_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchmyfavourites",HOST]]
#import "PBJinRongSC.h"
#import "PBFinancialProductAndServeDetailController.h"
#import "UIImageView+WebCache.h"
#import "NSObject+NAV.h"
@implementation PBJinRongSC

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
    [self.dataclass dataResponse:JINTONGSHOUCANG_URL postDic:[NSDictionary dictionaryWithObjectsAndKeys:@"9",@"type",USERNO,@"userno", nil] searchOrSave:YES];
    
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    self._arr = datas;
    NSLog(@"金融产品收藏:%@",self._arr);
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
        
        
        //标题与姓名
        UILabel *fromname = [[UILabel alloc]init];
        fromname.tag = 10;
        fromname.text = [[self._arr objectAtIndex:indexPath.row] objectForKey:@"name"];
        CGSize size = STRSIZE(fromname.text);
        fromname.frame = CGRectMake(isPad()?50:45, 0, isPad()?VIEWSIZE.width-50:VIEWSIZE.width-44, size.height);
        fromname.numberOfLines = 0;
        fromname.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:fromname];
        [fromname release];
        
        UILabel *name = [[UILabel alloc]init];
         name.tag = 11;
        name.text = [[self._arr objectAtIndex:indexPath.row] objectForKey:@"financename"];
        CGSize size1 = STRSIZE(name.text);
        name.frame = CGRectMake(isPad()?50:45, size.height, isPad()?VIEWSIZE.width-50:VIEWSIZE.width-44, size1.height);
        name.lineBreakMode = UILineBreakModeWordWrap;
        name.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:name];
        [name release];
        
        //头像
        CGFloat orginheight = (size.height + size1.height)/2 - 32/2;
        UIImageView* imageview = [[UIImageView alloc]initWithFrame:CGRectMake(5, MAX(orginheight, 5), 32, 32)];
        imageview.tag = 12;
        if (self._arr.count>0) {
            NSString *imagepath = [NSString stringWithFormat:@"%@%@",HOST,[[self._arr objectAtIndex:indexPath.row] objectForKey:@"imagepath"]];
            [imageview setImageWithURL:[NSURL URLWithString:imagepath]];
        }
        [cell.contentView addSubview:imageview];
        [imageview release];

        imageview.layer.shadowRadius = 5.0f;
        imageview.layer.masksToBounds = YES;
        imageview.layer.cornerRadius = 5.0f;
        
    }

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [[self._arr objectAtIndex:indexPath.row] objectForKey:@"financename"];
    NSString *str1 = [[self._arr objectAtIndex:indexPath.row] objectForKey:@"name"];
    CGSize a = STRSIZE(str);
    CGSize b = STRSIZE(str1);
    return MAX(44.0f, a.height+b.height);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PBFinancialProductAndServeDetailController *controller = [[PBFinancialProductAndServeDetailController alloc]init];
    controller.no = [[self._arr objectAtIndex:indexPath.row] objectForKey:@"no"];
    
    [self customButtom:controller];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];

}
@end
