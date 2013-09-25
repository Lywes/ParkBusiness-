//
//  PBBusinessFiancingNeed.m
//  ParkBusiness
//
//  Created by China on 13-7-12.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBBusinessFiancingNeed.h"
#import "PBBusinessFiancingdetail.h"
#import "NSObject+NAV.h"
#define BusinessFiancingNeed_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchfinanceneeds",HOST]]
@implementation PBBusinessFiancingNeed
@synthesize quanbu_arr,weijieda_arr,yijieda_arr;
@synthesize name,use,funds;

-(void)dealloc
{
    [name=nil release];
    [use=nil release];
    [funds=nil release];
    [quanbu_arr=nil release];
    [weijieda_arr=nil release];
    [yijieda_arr=nil release];
    [super dealloc];
    
}
-(BOOL)TopViewHidden{
    return NO;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self initTopViewNumBtn:3 BtnNameArr:[NSArray arrayWithObjects:@"全部",@"未解答",@"已解答", nil]];
    //data
    NSMutableArray *aa = [[NSMutableArray alloc]init];
    self._arr = aa;
    [aa release];
    NSMutableArray *a1 = [[NSMutableArray alloc]init];
    NSMutableArray *a2 = [[NSMutableArray alloc]init];
    NSMutableArray *a3 = [[NSMutableArray alloc]init];
    self.quanbu_arr = a1;
    self.weijieda_arr = a2;
    self.yijieda_arr = a3;
    [a1 release];
    [a2 release];
    [a3 release];

}
-(void)initdata
{

    [self toGetTheData];
}

-(void)toGetTheData
{
    [activity startAnimating];
    PBdataClass * data = [[PBdataClass alloc]init];
    data.delegate = self;
    self.dataclass = data;
    [data release];
    NSDictionary *dic =[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",[PBUserModel getCompanyno]],@"financeno", nil];
    [self.dataclass dataResponse:BusinessFiancingNeed_URL postDic:dic searchOrSave:YES];
    [dic release];
    

}
static int btnTag = 20;
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    NSLog(@"企业融资需求：%@",datas);
    [activity stopAnimating];
    [self.quanbu_arr removeAllObjects];
     [self.yijieda_arr removeAllObjects];
     [self.weijieda_arr removeAllObjects];
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
    //防止下拉刷新数据问题，可注释测试看看情况。
    UIButton *btn = (UIButton *)[self.view viewWithTag:btnTag];
    [self buttonPress:btn];
    [self.tableview reloadData];
}
-(void)searchFilad{
    [activity stopAnimating];
}
-(void)buttonPress:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btnTag = btn.tag;           //静态变量
    [self BtnImageChange:sender];
    [self._arr removeAllObjects];
    switch (btn.tag) {
        case 20:
            if (![self._arr isEqualToArray:self.quanbu_arr]) {
                [self._arr addObjectsFromArray:self.quanbu_arr];

            }
            break;
        case 21:
            if (![self._arr isEqualToArray:self.weijieda_arr]) {
                [self._arr addObjectsFromArray:self.weijieda_arr];
            }
            break;
        case 22:
            if (![self._arr isEqualToArray:self.yijieda_arr]) {
                [self._arr addObjectsFromArray:self.yijieda_arr];

            }
            break;
            
        default:
            break;
    }
    [self.tableview reloadData];
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
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:isPad()?@"PBBusinessFinancingNeedCell_iPad":@"PBBusinessFinancingNeedCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    if (self._arr.count>0) {
        NSString *str = [[self._arr objectAtIndex:indexPath.row] objectForKey:@"username"];
        self.name.text = str;
        self.use.text = [[self._arr objectAtIndex:indexPath.row]objectForKey:@"fundused"];
        [self.use sizeToFit];
        self.funds.text =[[self._arr objectAtIndex:indexPath.row] objectForKey:@"fundneed"];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSString *str = [[self._arr objectAtIndex:indexPath.row]objectForKey:@"fundused"];
//    CGSize size = STRSIZE(str);
//    return MAX(size.height-100, 80);
    if (self._arr.count>0) {
        NSString *str = [[self._arr objectAtIndex:indexPath.row]objectForKey:@"fundused"];
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(isPad()?688:255, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        return MAX(size.height + 45, 44);
    }
    return 44.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PBBusinessFiancingdetail *zhence = [[PBBusinessFiancingdetail alloc]initWithNibName:isPad()?@"PBBusinessFiancingdetail_iPad":@"PBBusinessFiancingdetail" bundle:nil];
    zhence.data_dic = [self._arr objectAtIndex:indexPath.row];
    
    [self customButtom:zhence];
    [self.navigationController pushViewController:zhence animated:YES];
    [zhence release];
}

@end
