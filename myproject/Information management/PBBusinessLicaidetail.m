//
//  PBBusinessLicaidetail.m
//  ParkBusiness
//
//  Created by China on 13-7-15.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBBusinessLicaidetail.h"
#import "PBcompanyDetailVC.h"
@interface PBBusinessLicaidetail ()

@end

@implementation PBBusinessLicaidetail

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
    self.trade_identification.hidden = YES;
    self.salerroom_identification.hidden = YES;
    self.trade.hidden = YES;
    self.saleroom.hidden = YES;
    self.title = @"企业理财需求";
}
-(void)KitText
{
    self.name.text = [self.data_dic objectForKey:@"username"];
    self.funds.text = [self.data_dic objectForKey:@"availablefund"];
    if ([[self.data_dic objectForKey:@"answer"] isEqualToString:@""])
    {
        _arry = [[NSMutableArray alloc]initWithObjects:
                 [self.data_dic objectForKey:@"username"],
                 [self.data_dic objectForKey:@"type"],
                 [self.data_dic objectForKey:@"availablefund"],
                 [self.data_dic objectForKey:@"timeperiod"],
                 [self.data_dic objectForKey:@"expectreturn"],
                 @"",
                 nil];
        _sectiontitle_arr = [[NSMutableArray alloc]initWithObjects:@"姓名",NSLocalizedString(@"_tb_lclx", nil),NSLocalizedString(@"_tb_kyzj", nil),NSLocalizedString(@"_tb_sjzq", nil),@"期望回报率",NSLocalizedString(@"_tb_gsgk", nil), nil];
    }
    else
    {
        _arry = [[NSMutableArray alloc]initWithObjects:
                 [self.data_dic objectForKey:@"username"],
                 [self.data_dic objectForKey:@"type"],
                 [self.data_dic objectForKey:@"availablefund"],
                 [self.data_dic objectForKey:@"timeperiod"],
                 [self.data_dic objectForKey:@"expectreturn"],
                 @"",
                 [self.data_dic objectForKey:@"answer"],nil];
        _sectiontitle_arr = [[NSMutableArray alloc]initWithObjects:@"姓名",NSLocalizedString(@"_tb_lclx", nil),@"可用资金(万元)",NSLocalizedString(@"_tb_sjzq", nil),@"期望回报率",NSLocalizedString(@"_tb_gsgk", nil),@"我的回答", nil];
        self.answer.hidden = YES;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section==5) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    NSLog(@"%d",[intvalue integerValue]);
    [self.tbview reloadData];
    self.answer.hidden = YES;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"回答的通知" object:@"企业理财需求"];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 5) {
        PBcompanyDetailVC *vc = [[PBcompanyDetailVC alloc] initWithStyle:UITableViewStyleGrouped];
        vc.ProjectStyle = ELSEPROJECTINFO;
        vc.datadic = self.data_dic;
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
