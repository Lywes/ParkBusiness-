//
//  PBguanzhu.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-7.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBguanzhu.h"
#import "PBUserModel.h"
#import "UIImageView+WebCache.h"
#import "PBInvestorDetail.h"
#import "PBStarEntrepreneursDetail.h"
#import "NSObject+NAV.h"
@interface PBguanzhu ()
-(void)toGetTheData;
@end
@implementation PBguanzhu
@synthesize touziren_arry,qiyejia_arry,guanzhu_arry,zhengfu_arry;
static int btnTag = 20;
-(void)dealloc
{
    [attentionInfo release];
    [attention release];
    [pbgzvc release];
    [self.touziren_arry=nil release];
    [self.qiyejia_arry=nil release];
    [self.guanzhu_arry=nil release];
    RB_SAFE_RELEASE(zhengfu_arry);
    [super dealloc];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    //button
    [self initTopViewNumBtn:3 BtnNameArr:[NSArray arrayWithObjects:@"政府公职人员",@"企业家",@"金融经理人", nil]];
    //data
    self.touziren_arry = [[[NSMutableArray alloc]init]autorelease];
    self.qiyejia_arry = [[[NSMutableArray alloc]init]autorelease];
    self.zhengfu_arry = [[[NSMutableArray alloc]init]autorelease];
    self.guanzhu_arry = [[[NSMutableArray alloc]init]autorelease];
    [self.guanzhu_arry addObjectsFromArray:self.touziren_arry];
}
-(BOOL)TopViewHidden{
    return NO; //default return YES
}
-(void)initdata
{

    [self toGetTheData];
}
-(void)toGetTheData
{
    [activity startAnimating];
    attention = [[PBdataClass alloc]init];
    attention.delegate = self;
    [attention dataResponse:[NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchattention",HOST]] postDic:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageno],@"pageno",USERNO,@"userno", nil] searchOrSave:YES];
    NSLog(@"%@",USERNO);
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{   
    NSLog(@"guanzhu:%@",datas);
    [activity stopAnimating];
    if ([datas count]>0) {
        if (attention == dataclass) {
            [self.zhengfu_arry removeAllObjects];
            [self.qiyejia_arry removeAllObjects];
            [self.touziren_arry removeAllObjects];
            for (NSMutableDictionary *dic in datas) {
                if ([[dic objectForKey:@"kind"]  isEqualToString:@"1"]) {
                    [self.zhengfu_arry addObject:dic];
                }
                else if([[dic objectForKey:@"kind"]  isEqualToString:@"2"]) {
                    [self.qiyejia_arry addObject:dic];
                }
                else{
                    [self.touziren_arry addObject:dic];
                }
            }
            [self.guanzhu_arry removeAllObjects];
            [self.guanzhu_arry addObjectsFromArray:self.touziren_arry];
            UIButton *btn = (UIButton *)[self.view viewWithTag:btnTag];
            [self buttonPress:btn];
            [self.tableview reloadData];
        }
    }
}
-(void)searchFilad{
    [activity stopAnimating];
}
-(void)buttonPress:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btnTag = btn.tag;
    [self BtnImageChange:sender];
    switch (btn.tag) {
        case 20:
            
            if (![self.guanzhu_arry isEqualToArray:self.zhengfu_arry]) {
                [self.guanzhu_arry removeAllObjects];
                [self.guanzhu_arry addObjectsFromArray:self.zhengfu_arry];
                 [self.tableview reloadData];
            }
            
            break;
        case 21:
        {
            [self.guanzhu_arry removeAllObjects];
            [self.guanzhu_arry addObjectsFromArray:self.qiyejia_arry];
           [self.tableview reloadData];
        }
            
            break;
        case 22:
        {
            [self.guanzhu_arry removeAllObjects];
            [self.guanzhu_arry addObjectsFromArray:self.touziren_arry];
            [self.tableview reloadData];
        }
            break;

        default:
            break;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.guanzhu_arry count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]autorelease];
        UIImageView *imageview;
        UIImageView *timeimage;
        UILabel *name;
        UILabel *time;
        if (isPad()) {
            name  = [[[UILabel alloc]initWithFrame:CGRectMake(50, 0, 100, 44)]autorelease];
            time  = [[[UILabel alloc]initWithFrame:CGRectMake(480, 0, 150, 44)]autorelease];
            timeimage = [[[UIImageView alloc]initWithFrame:CGRectMake(450, 9, 21, 21)]autorelease];
            name.font = [UIFont systemFontOfSize:PadContentFontSize];
            time.font = [UIFont systemFontOfSize:PadContentFontSize];
        }
        else {
            name  = [[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 90, 44)]autorelease];
            time  = [[[UILabel alloc]initWithFrame:CGRectMake(220, 0, 80, 44)]autorelease];
            timeimage = [[[UIImageView alloc]initWithFrame:CGRectMake(200, 9, 21, 21)]autorelease];
            name.font = [UIFont systemFontOfSize:ContentFontSize];
            time.font = [UIFont systemFontOfSize:ContentFontSize];
        }
        imageview = [[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 32, 32)]autorelease];
        NSString *imagepath = [NSString stringWithFormat:@"%@%@",HOST,[[self.guanzhu_arry objectAtIndex:indexPath.row] objectForKey:@"imagepath"]];
        [imageview setImageWithURL:[NSURL URLWithString:imagepath]];
        [cell.contentView addSubview:imageview];
        name.text = [[self.guanzhu_arry objectAtIndex:indexPath.row] objectForKey:@"username"];
        time.text = [[self.guanzhu_arry objectAtIndex:indexPath.row] objectForKey:@"time"];
        timeimage.image = [UIImage imageNamed:@"time.png"];
        imageview.layer.shadowRadius = 5.0f;
        imageview.layer.masksToBounds = YES;
        imageview.layer.cornerRadius = 5.0f;
        name.backgroundColor = [UIColor clearColor];
        time.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:name];
        [cell.contentView addSubview:time];
        [cell.contentView addSubview:timeimage];
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    NSString *kind = [[self.guanzhu_arry objectAtIndex:indexPath.row] objectForKey:@"kind"];
    NSString *no = [[self.guanzhu_arry objectAtIndex:indexPath.row] objectForKey:@"no"];
    if ([kind isEqualToString:@"1"]) {
        PBInvestorDetail *controller = [[PBInvestorDetail alloc] init];
        controller.investorNo = no;
        [self customButtom:controller];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    else {
        PBStarEntrepreneursDetail *controller = [[PBStarEntrepreneursDetail alloc] init];
        controller.no = no;
        
        
        [self customButtom:controller];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }

}
-(void)getInfoFromattentionBynoAtIdexpath:(NSIndexPath *)indexpath
{
    [attentionInfo dataResponse:[NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchusermaster",HOST]] postDic:[NSDictionary dictionaryWithObjectsAndKeys:[[self.guanzhu_arry objectAtIndex:indexpath.row] objectForKey:@"no"],@"no", nil]searchOrSave:YES];
}
@end
