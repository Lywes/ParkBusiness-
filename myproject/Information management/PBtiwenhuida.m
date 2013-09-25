//
//  PBtiwenhuida.m
//  ParkBusiness
//
//  Created by 上海 on 13-6-19.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define TIWENHUIDA_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchquestioninfolist",HOST]]
#import "PBtiwenhuida.h"
#import "PBAnswer.h"
#import "NSObject+NAV.h"
@implementation PBtiwenhuida
@synthesize tiwenhuida_arr,answer_arr,noanswer_arr;
static int btnTag = 20;

-(void)dealloc
{
    [tiwenhuida_arr release];
    [answer_arr release];
    [noanswer_arr release];
    [super dealloc];
}
-(void)viewDidLoad{

    [super viewDidLoad];
    [self initTopViewNumBtn:2 BtnNameArr:[NSArray arrayWithObjects:@"未回答",@"已回答", nil]];
    //data
    self.tiwenhuida_arr = [[[NSMutableArray alloc]init]autorelease];
    self.answer_arr = [[[NSMutableArray alloc]init]autorelease];;
    self.noanswer_arr = [[[NSMutableArray alloc]init]autorelease];
}
-(BOOL)TopViewHidden{
    return NO;
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
    [self.dataclass dataResponse:TIWENHUIDA_URL postDic:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"financeno",Nil] searchOrSave:YES];
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    NSLog(@"提问回答:%@",datas);
    [activity stopAnimating];
    if ([datas count]>0) {
        [self.noanswer_arr removeAllObjects];
        [self.answer_arr removeAllObjects];
        for (NSDictionary *dic in datas){
            if ([[dic objectForKey:@"answer"] isEqual:@""]) {
                [self.noanswer_arr addObject:dic];
            }
            else
            {
                [self.answer_arr addObject:dic];
            }
        }
        [self.tiwenhuida_arr addObjectsFromArray:self.noanswer_arr];
        [self.tableview reloadData];
    }
    //防止下拉刷新数据问题，可注释测试看看情况。
    UIButton *btn = (UIButton *)[self.view viewWithTag:btnTag];
    [self buttonPress:btn];
    [self.tableview reloadData];
}
-(void)searchFilad
{
    [activity stopAnimating];

}
-(void)buttonPress:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btnTag = btn.tag;           //静态变量
    [self BtnImageChange:sender];
    switch (btn.tag) {
        case 20:
            if (![self.tiwenhuida_arr isEqualToArray:self.noanswer_arr]) {
                [self.tiwenhuida_arr removeAllObjects];
                [self.tiwenhuida_arr addObjectsFromArray:self.noanswer_arr];
            }
            [self.tableview reloadData];
            break;
        case 21:
            [self.tiwenhuida_arr removeAllObjects];
            [self.tiwenhuida_arr addObjectsFromArray:self.answer_arr];
            [self.tableview reloadData];
            break;
            
        default:
            break;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.tiwenhuida_arr count] > 0) {
        return [self.tiwenhuida_arr count];

    }
    else
        return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]autorelease];
      
    }
    if (self.tiwenhuida_arr.count>0) {
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = [[self.tiwenhuida_arr objectAtIndex:indexPath.row]objectForKey:@"question"];
//        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.text = [[self.tiwenhuida_arr objectAtIndex:indexPath.row]objectForKey:@"cdate"];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.tiwenhuida_arr.count>0) {
        NSString *str = [[self.tiwenhuida_arr objectAtIndex:indexPath.row]objectForKey:@"question"];
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(isPad()?768:320, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        return MAX(size.height + 20, 44);    //default retun 44.0f;
    }
    else
        return KNavigationBarHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PBAnswer *controller = [[PBAnswer alloc]initWithStyle:UITableViewStylePlain];
    controller.data_dic = [self.tiwenhuida_arr objectAtIndex:indexPath.row];
    //        [self.navigationController pushViewController:answer animated:YES];
    
    [self customButtom:controller];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}
@end
