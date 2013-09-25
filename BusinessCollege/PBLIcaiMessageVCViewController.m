//
//  PBLIcaiMessageVCViewController.m
//  ParkBusiness
//
//  Created by China on 13-8-28.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define ZHISHIKETANG_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/knowledgeclasslist",HOST]]
#define HEIGHTCELL     [[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"title"] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(isPad()?480:150, 1000) lineBreakMode:NSLineBreakByCharWrapping];
#import "PBLIcaiMessageVCViewController.h"
#import "UIImageView+WebCache.h"
@interface PBLIcaiMessageVCViewController ()

@end

@implementation PBLIcaiMessageVCViewController

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
	// Do any additional setup after loading the view.
}
-(void)initdata
{
    [ac startAnimating];
    PBdataClass *dataclass = [[PBdataClass alloc]init];
    dataclass.delegate = self;
    self.dataclass = dataclass;
    [dataclass release];
    if (pageno == 1) {
        [self.dataArr removeAllObjects];
    }
    NSDictionary *dic= [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageno],@"pageno",USERNO,@"userno",@"2",@"kind", nil];
    [self.dataclass dataResponse:ZHISHIKETANG_URL postDic:dic searchOrSave:YES];
    [dic release];
}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (!cell) {
//        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]autorelease];
//        cell.selectionStyle = UITableViewCellSelectionStyleGray;
//        
//        //            cell.backgroundColor = [UIColor whiteColor];
//        
//        UIImageView *imageview = [[UIImageView alloc]init];
//        imageview.tag = 11;
//        imageview.layer.masksToBounds = YES;
//        [imageview.layer setCornerRadius:7.0f];
//        [cell.contentView addSubview:imageview];
//        [imageview release];
//        
//        UILabel *name = [[UILabel alloc]init];
//        name.backgroundColor = [UIColor clearColor];
//        name.numberOfLines = 0;
//        name.tag = 12;
//        [cell.contentView addSubview:name];
//        [name release];
//        if (!isPad()) {
//            name.font = [UIFont systemFontOfSize:14];
//        }
//        
//    }
//    
//    UIImageView *imageview = (UIImageView *)[cell.contentView viewWithTag:11];
//    UILabel *name = (UILabel *)[cell.contentView viewWithTag:12];
//    
//    CGSize a = CGSizeZero;
//    if (self.dataArr.count>0) {
//        NSString *str = [[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"imagepath"];
//        [imageview setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOST, str]]];
//        name.text = [[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"title"];
//        a = HEIGHTCELL;
//    }
//    CGFloat b = isPad()?60:44;
//    imageview.frame =  CGRectMake((isPad()?678:300)-b, 0, b, b);
//    name.backgroundColor = [UIColor clearColor];
//    name.frame = CGRectMake(8, 0, isPad()?600:240,b);
//    name.textColor = [UIColor blackColor];
//    name.alpha = 1;
//    
//    return cell;
//}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    
//    return [self.dataArr count];
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (self.dataArr.count>0) {
//        //            CGSize a = HEIGHTCELL;
//        return isPad()?60:44;
//    }
//    else
//        return 44.0f;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return nil;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.0f;
//}
//-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
//{
//    if (pageno == 1) {
//        [self.dataArr removeAllObjects];
//    }
//    [ac stopAnimating];
//    [self.dataArr addObjectsFromArray:datas];
//    self.tableview.tableFooterView = [super setTableViewForFooter:[datas count] withNumber:20];
//    [self.tableview reloadData];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
