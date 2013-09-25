//
//  PBjinrongzhuanlan.m
//  ParkBusiness
//
//  Created by QDS on 13-6-25.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define JINRONGZHUANLAN_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/knowledgeclasslist",HOST]]
#import "PBjinrongzhuanlan.h"
#import "UIImageView+WebCache.h"
#import "PBtextVC.h"
#import "PBClassRoomDeatil.h"
#import "NSObject+NAV.h"
@implementation PBjinrongzhuanlan
@synthesize data_arr;
-(void)viewDidLoad{

    [super viewDidLoad];
}
-(void)initTableView{
    self.tableview = [[[UITableView alloc]initWithFrame:CGRectMake(0, 0, VIEWSIZE.width, VIEWSIZE.height) style:UITableViewStyleGrouped]autorelease];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    activity  = [[PBActivityIndicatorView alloc]initWithFrame:self.tableview.frame];
    [self.view addSubview:activity];
    UIButton *dingyue_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dingyue_btn setFrame:isPad()?CGRectMake(VIEWSIZE.width - 80, 5, 60, 35):CGRectMake(VIEWSIZE.width - 80, 10, 50, 25)];
    [dingyue_btn setTitle:@"订阅" forState:UIControlStateNormal];
    dingyue_btn.titleLabel.font = [UIFont systemFontOfSize:15];
    //    [dingyue_btn setBackgroundImage:[UIImage imageNamed:@"custom_button"] forState:UIControlStateNormal];
    [dingyue_btn setBackgroundColor:[UIColor clearColor]];
    [dingyue_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dingyue_btn setTitleShadowColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [self.topView addSubview:dingyue_btn];
    self.tableview.tableHeaderView = self.topView;
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
    [self.dataclass dataResponse:JINRONGZHUANLAN_URL postDic:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",[PBUserModel getUserId] ],@"userno",@"1",@"zlflag",Nil] searchOrSave:YES];
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    NSLog(@"金融专栏数据:%@",datas);
    [activity stopAnimating];
    
    if (datas.count>0) {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        NSMutableArray* array = [[NSMutableArray alloc]initWithObjects:[datas objectAtIndex:0], nil];
        for (int i = 0;i<[datas count];i++) {
            NSDictionary *dic = [datas objectAtIndex:i];
            if (![dic isEqualToDictionary:[datas lastObject]]) {
                NSDictionary *dic1 = [datas objectAtIndex:i+1];
                if ([[dic objectForKey:@"cdate"] isEqualToString:[dic1 objectForKey:@"cdate"]]) {
                    [array addObject:dic1];
                }else{
                    [arr addObject:array];
                    array = [[NSMutableArray alloc]init];
                    [array addObject:dic1];
                    
                }
            }
            
            
        }
        [arr addObject:array];
        [array release];
        self.data_arr = arr;
        
        [self.tableview reloadData];
        [arr release];
    }

}
-(void)searchFilad{
     [activity stopAnimating];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.data_arr objectAtIndex:section] count];;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.data_arr count];
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
    
    UILabel *name = [[UILabel alloc]init];
    if (self.data_arr.count>0) {
        name.text = [[[self.data_arr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row ] objectForKey:@"title"];
    }
    CGSize a = [name.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(isPad()?480: 150,1000) lineBreakMode:NSLineBreakByWordWrapping];
    name.frame = CGRectMake(5, 0, isPad()?480:VIEWSIZE.width - 70, MAX(30, a.height));
    name.textAlignment = NSTextAlignmentLeft;
    name.font = [UIFont systemFontOfSize:12];
    name.backgroundColor = [UIColor clearColor];
    name.numberOfLines = 0;
    [cell.contentView addSubview:name];
    [name release];
    //头像
    UIImageView* imageview = [[UIImageView alloc]initWithFrame:CGRectMake(isPad()?640:VIEWSIZE.width - 60, 5, 32, 32)];
    if (self.data_arr.count>0) {
        NSString *imagepath = [NSString stringWithFormat:@"%@%@",HOST,[[[self.data_arr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"imagepath"]];
        [imageview setImageWithURL:[NSURL URLWithString:imagepath]];
    }
    imageview.layer.shadowRadius = 5.0f;
    imageview.layer.masksToBounds = YES;
    imageview.layer.cornerRadius = 5.0f;
    [cell.contentView addSubview:imageview];
    [imageview release];
    

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [[[self.data_arr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row ] objectForKey:@"name"];
    CGSize a = [str sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(isPad()?480: 150,1000) lineBreakMode:NSLineBreakByWordWrapping];
    return MAX(44, a.height);
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    PBtextVC *classRoomDeatil = [[PBtextVC alloc]init];
//    classRoomDeatil.text = [[[self.data_arr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"content"];
//    classRoomDeatil.title = [[[self.data_arr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row ] objectForKey:@"title"];
//    PBNavigationController *nav = [[PBNavigationController alloc] initWithRootViewController:classRoomDeatil];
//    [self customNav:nav];
//    [self customButtom:classRoomDeatil];
//    [self presentModalViewController:nav  animated:YES];
//    [classRoomDeatil release];
//    [nav release];
    
    PBClassRoomDeatil *controller = [[PBClassRoomDeatil alloc]init];
    controller.datadic = [[self.data_arr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [self customButtom:controller];
    controller.navigationItem.rightBarButtonItems = nil;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];

}
@end
