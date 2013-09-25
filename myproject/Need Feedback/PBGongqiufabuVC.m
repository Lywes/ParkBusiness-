//
//  PBGongqiufabuVC.m
//  ParkBusiness
//
//  Created by China on 13-7-10.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define GONGQIUFABU_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchindustryopportunity",HOST]]
#import "PBGongqiufabuVC.h"
#import "PBGongqiufabucell.h"
@interface PBGongqiufabuVC ()

@end

@implementation PBGongqiufabuVC

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
    self.tableview.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 44*3);
}
-(void)initdata
{
    self.dataclass = [[PBdataClass alloc]init];
    self.dataclass.delegate = self;
    NSDictionary *dic= [[NSDictionary alloc]initWithObjectsAndKeys:USERNO,@"userno", nil];
    [self.dataclass dataResponse:GONGQIUFABU_URL postDic:dic searchOrSave:YES];
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    NSLog(@"供求发布：%@",datas);
    [self.dataclass release];
    self.dataArr = datas;
    [self.tableview reloadData];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    PBGongqiufabucell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:isPad()?@"Gongqiufabucell_iPad":@"Gongqiufabucell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.name.text = [[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"name"];
     cell.trade.text = [[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"trade"];
     cell.cdate.text = [[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"cdate"];
     cell.type.text = [[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"type"];
     cell.ldate.text = [[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"enddate"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PUSHPBIndustryOpportunityDetail" object:[self.dataArr objectAtIndex:indexPath.row]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return isPad()? 144.0f:114.0f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.dataArr count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initSearchBar
{
    
}

-(void)InvestTableview
{
    
}
@end
