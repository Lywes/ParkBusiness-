//
//  PBFinancingNeedVC.m
//  ParkBusiness
//
//  Created by China on 13-7-10.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define QIATAN_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/makearrangements",HOST]]

#define RONGZIXUQIU_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchmyneedsfeedback",HOST]]

#import "PBFinancingNeedVC.h"
#import "NSObject+PBLableHeight.h"
#import "NSObject+CellLine.h"
@interface PBFinancingNeedVC ()

@end

@implementation PBFinancingNeedVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableview.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 44*3);
//    NSMutableArray *arr = [[NSMutableArray alloc]initWithObjects:@"111",@"222",@"333",@"抢二楼，首先要网速快，宽带2兆起步，您要是手机党？谢了您呐，您歇会儿，这儿没您什么事儿。其次是耐力，手不离F5，在贴吧高峰时期，平均每10秒一下，您键盘要是塑料的您也别出来现眼，两天就得按坏了。还有就是要有眼力劲儿，看到0回复马上点开，粘贴复制要一气呵成，这就像开车，要油离配合。最后要有坚强的抗压能力，总会有某个比你还闲的孙子和你抢，这时候要跟丫死磕，看谁更闲的蛋疼。就是这么快。",@"555", nil];
//    [self.dataArr release];
//    self.dataArr = arr;
//    [arr release];


}

-(void)initdata
{
    self.dataclass = [[PBdataClass alloc]init];
    self.dataclass.delegate = self;
    NSDictionary *dic= [[NSDictionary alloc]initWithObjectsAndKeys:USERNO,@"userno",@"1",@"type", nil];
    [self.dataclass dataResponse:RONGZIXUQIU_URL postDic:dic searchOrSave:YES];
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    NSLog(@"融资需求：%@",datas);
    [self.dataclass release];
    self.dataArr = datas;
    [self.tableview reloadData];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width, 20)];
        name.numberOfLines = 0;
        name.font = [UIFont systemFontOfSize:13];
        name.tag = 11;
        
        UILabel *text = [[UILabel alloc]initWithFrame:CGRectZero];
        text.numberOfLines = 0;
        text.font = [UIFont systemFontOfSize:13];
        text.tag = 12;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"custom_button"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(INeedchat:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"我要洽谈" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:isPad()?12:10];
        btn.tag = 13;        
        [cell.contentView addSubview:name];
        [cell.contentView addSubview:text];
        [cell.contentView addSubview:btn];
        [name release];
        [text release];
    }
    UILabel *text = (UILabel *)[cell.contentView viewWithTag:12];
    UILabel *name = (UILabel *)[cell.contentView viewWithTag:11];
    UIButton *btn = (UIButton *)[cell.contentView viewWithTag:13];
    CGFloat a = 0.0f;
    if (self.dataArr.count>0) {
        a = [self HeightAStr:[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"answer"]];
    }
    [btn setFrame:CGRectMake(isPad()? 500:240, a+10, 60, 40)];
    if (self.dataArr.count>0) {
        text.text = [[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"answer"];
    }
    text.frame = CGRectMake(10, 20, self.view.frame.size.width - 10, a);
    name.text = [[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"financename"];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.dataArr.count>0) {
        return [self HeightAStr:[[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"answer"]] + 50;
    }
    return 44;
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
-(void)INeedchat:(UIButton *)sender
{
  NSIndexPath *inde =  [self.tableview indexPathForCell:(UITableViewCell *)sender.superview.superview];
    index = inde.row;
    UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"信息" message:@"思考好了再做决定" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) otherButtonTitles:@"确定", nil];
    [view show];
    [view release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSDictionary *dic= [[NSDictionary alloc]initWithObjectsAndKeys:
                            [[self.dataArr objectAtIndex:index] objectForKey:@"no"],@"no",                      nil];
        [self.dataclass dataResponse:QIATAN_URL postDic:dic searchOrSave:NO];
    }
}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    NSLog(@"%d",[intvalue integerValue]);
}
-(void)searchFilad
{
    
}
-(void)initSearchBar
{
    
}
-(void)InvestTableview
{
    
}
@end
