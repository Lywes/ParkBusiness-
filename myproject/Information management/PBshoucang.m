//
//  PBshoucang.m
//  ParkBusiness
//
//  Created by lywes lee on 13-4-22.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBshoucang.h"
#import "PBUserModel.h"
#import "PBAddCompanyBand.h"
#import "CommonProjectDetailController.h"
#import "PBAddFinanceAssure.h"
#import "PBAddInsureInfo.h"
#import "PBAddFinanceLease.h"
#import "NSObject+NAV.h"
@implementation PBshoucang
@synthesize shoucangarry;
-(void)viewDidLoad{
    [super viewDidLoad];
    self.shoucangarry = [[[NSMutableArray alloc]init]autorelease];
}
-(void)initdata
{   
    //data
    [self toGetTheData];
}
-(void)toGetTheData
{
    [activity startAnimating];
    PBdataClass *pbdataclass1 = [[PBdataClass alloc]init];
    pbdataclass1.delegate = self;
    NSString* userid = USERNO;
    [pbdataclass1 dataResponse:[NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/projectlist",HOST]] postDic:[NSDictionary dictionaryWithObjectsAndKeys:userid,@"personno", nil] searchOrSave:YES];
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    [activity stopAnimating];
    self.shoucangarry = datas;
    [self.tableview reloadData];
}
-(void)searchFilad{
     [activity stopAnimating];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.shoucangarry count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]autorelease];
        UILabel* timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(isPad()?450:150, 20, 100, 20)];
        timeLabel.tag = 10;
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = cell.detailTextLabel.font;
        timeLabel.textColor = cell.detailTextLabel.textColor;
        [[cell contentView] addSubview:timeLabel];
        [timeLabel release];
        
    }
    if (self.shoucangarry.count>0) {
        NSDictionary *dic = [self.shoucangarry objectAtIndex:indexPath.row];
        cell.textLabel.text = [dic objectForKey:@"proname"];
        cell.textLabel.font = [UIFont systemFontOfSize:isPad()?16:14];
        cell.detailTextLabel.text = [dic objectForKey:@"typename"] ;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:isPad()?12:10];
        
        UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:10];
        timeLabel.text = [dic objectForKey:@"favouritetime"];

    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* dic2 = [self.shoucangarry objectAtIndex:indexPath.row];
    int type = [[dic2 objectForKey:@"type"] intValue];
    if (type<3) {
        CommonProjectDetailController *controller = [[CommonProjectDetailController alloc] init];
        controller.dataDictionary = dic2;
        
        [self customButtom:controller];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    else if(type==3){//企业债券
        PBAddCompanyBand* bond = [[PBAddCompanyBand alloc]initWithStyle:UITableViewStyleGrouped];
        bond.ProjectStyle = ELSEPROJECTINFO;
        bond.title = [dic2 objectForKey:@"proname"];
        bond.datadic = dic2;
        
        [self customButtom:bond];
        [self.navigationController pushViewController:bond animated:YES];
        [bond release];
    }
    else if(type==4){//金融担保
        PBAddFinanceAssure* assure = [[PBAddFinanceAssure alloc]initWithStyle:UITableViewStyleGrouped];
        assure.ProjectStyle = ELSEPROJECTINFO;
        assure.title = [dic2 objectForKey:@"proname"];
        assure.datadic = dic2;
        
        [self customButtom:assure];
        [self.navigationController pushViewController:assure animated:YES];
        [assure release];
    }
    else if(type==5){//金融租赁
        PBAddFinanceLease* lease = [[PBAddFinanceLease alloc]initWithStyle:UITableViewStyleGrouped];
        lease.ProjectStyle = ELSEPROJECTINFO;
        lease.title = [dic2 objectForKey:@"proname"];
        lease.datadic = dic2;
        
        [self customButtom:lease];
        [self.navigationController pushViewController:lease animated:YES];
        [lease release];
    }
    else  if(type==6){//保险
        PBAddInsureInfo* insure = [[PBAddInsureInfo alloc]initWithStyle:UITableViewStyleGrouped];
        insure.ProjectStyle = ELSEPROJECTINFO;
        insure.title = [dic2 objectForKey:@"proname"];
        insure.datadic = dic2;
        
        [self customButtom:insure];
        [self.navigationController pushViewController:insure animated:YES];
        [insure release];
    }
    

}


@end
