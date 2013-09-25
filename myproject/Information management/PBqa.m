//
//  PBqa.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-6.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBqa.h"
#import "PBUserModel.h"
@interface PBqa ()
-(void)toGetTheData;
@end
@implementation PBqa
@synthesize myqa_arry,weihuifu_arry,yihuifu_arry;
-(void)dealloc
{
    [self.myqa_arry=nil release];
    [self.weihuifu_arry=nil release];
    [self.yihuifu_arry=nil release];
    [super dealloc];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.weihuifu_arry = [[[NSMutableArray alloc]init]autorelease];
    
    self.yihuifu_arry = [[[NSMutableArray alloc]init]autorelease];
    self.myqa_arry = [[[NSMutableArray alloc]init]autorelease];
    [self.myqa_arry addObjectsFromArray:self.weihuifu_arry];
    //button
    NSArray * text = [[NSArray alloc]initWithObjects:@"未回复",@"已回复", nil];
    float x = VIEWSIZE.width/2;
    for (int i = 0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*x, 0, x, 44);
        [btn setTitle:[text objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (i == 0) {
            [btn setBackgroundImage:[UIImage imageNamed:@"message1.png"] forState:UIControlStateNormal];
            
        }
        else
        {
            [btn setBackgroundImage:[UIImage imageNamed:@"message.png"] forState:UIControlStateNormal];
        }
        btn.titleLabel.font = [UIFont fontWithName:@"Hoefler Text" size:13];
        btn.tag = 40+i;
        [btn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
        [self.topView addSubview:btn];
    }
    [text release];
}

-(void)initdata
{
 
    [self toGetTheData];
}

-(void)toGetTheData
{
    [activity startAnimating];
    PBdataClass *pbdataclass2 = [[PBdataClass alloc]init];
    pbdataclass2.delegate = self;
    [pbdataclass2 dataResponse:[NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchquestion",HOST]] postDic:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"pageno",USERNO,@"persono",@"0",@"flg", nil] searchOrSave:YES];
}
-(void)searchFilad{
     [activity stopAnimating];
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    NSLog(@"我的私信:%@",datas);
     [activity stopAnimating];
    for (NSMutableDictionary *dic in datas) {
        if ([[dic objectForKey:@"answer"]  isEqualToString:@"0"]) {
            [self.weihuifu_arry addObject:dic];
            [self.myqa_arry removeAllObjects];
            [self.myqa_arry addObjectsFromArray:self.weihuifu_arry];
        }
        else {
            [self.yihuifu_arry addObject:dic];
        }
    }
    [self.tableview reloadData];
}
-(void)buttonPress:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [btn setBackgroundImage:[UIImage imageNamed:@"message1.png"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"Hoefler Text" size:13];
    for (int i = 40; i<42; i++) {
        if (i!=btn.tag) {
            UIButton *btn1 = (UIButton *)[self.view viewWithTag:i];
            [btn1 setBackgroundImage:[UIImage imageNamed:@"message.png"] forState:UIControlStateNormal];
        }
        
    }
    switch (btn.tag) {
        case 40:
            
            if (![self.myqa_arry isEqualToArray:self.weihuifu_arry]) {
                [self.myqa_arry removeAllObjects];
                [self.myqa_arry addObjectsFromArray:self.weihuifu_arry];
                [self.tableview reloadData];
            }
            
            break;
        case 41:
            [self.myqa_arry removeAllObjects];
            [self.myqa_arry addObjectsFromArray:self.yihuifu_arry];
            [self.tableview reloadData];
            
            break;
            
        default:
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.myqa_arry count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]autorelease];
    }
    if (self.myqa_arry.count>0) {
        cell.textLabel.text = [[self.myqa_arry objectAtIndex:indexPath.row]objectForKey:@"question"];
        cell.detailTextLabel.text = [[self.myqa_arry objectAtIndex:indexPath.row]objectForKey:@"createdate"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
