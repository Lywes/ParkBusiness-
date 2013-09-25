//
//  PBChooseGovernment.m
//  ParkBusiness
//
//  Created by 上海 on 13-8-23.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBChooseGovernment.h"
#import "PBchooesjigou.h"
#import "PBWeiboCell.h"
#import "PBpersonerInfo.h"
#define SAVEURL [NSString stringWithFormat:@"%@/admin/index/updatecompanyno",HOST]
#define URL [NSString stringWithFormat:@"%@admin/index/searchgovernmentsection", HOST]
@interface PBChooseGovernment ()

@end

@implementation PBChooseGovernment

-(void)viewDidLoad
{
        [super viewDidLoad];
//    if ([self.LoginOrSeting isEqualToString:@"login"]) {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextDidPush)];
//    }
    self.title = @"请选择您所属金融机构";
    searchBar.placeholder = @"请输入部门名称";
//    [searchBar removeFromSuperview];
    
}
- (void) requestData:(NSString *)pageno
{
    if ([pageno isEqualToString:@"1"]) {
        [pullController.allData removeAllObjects];
    }
    [pullController.indicator startAnimating];
    //下面这句代码为特例
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:pageno, @"pageno",searchBar.text,@"name", nil];
    [companyData getXMLDataFromUrl:URL postValuesAndKeys:dic];
}
#pragma mark - 点击cell的Function
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    myblock = [^(void)
               {
                   [pullController.indicator startAnimating];
                   NSMutableDictionary* data = [pullController.allData objectAtIndex:indexPath.row];
                   PBWeiboCell* cell = (PBWeiboCell*)[pullController.tableViews cellForRowAtIndexPath:indexPath];
                   // Navigation logic may go here. Create and push another view controller.
                   [self saveCompanyData:data withImage:cell.imageViews.imageView.image];//保存本地数据
                   [PBUserModel updateCompanyno:[[data objectForKey:@"no"] intValue]];
                   NSArray *a1 = [[NSArray alloc]initWithObjects:@"companyno",@"no",nil];
                   NSArray *a2 = [[NSArray alloc]initWithObjects:[data objectForKey:@"no"],
                                  USERNO,
                                  nil];
                   [companyData submitDataFromUrl:SAVEURL postValuesAndKeys:[[NSMutableDictionary alloc]initWithObjects:a2 forKeys:a1]];
                   NSMutableDictionary* dic = self.popController.dic;
                   [dic setObject:[data objectForKey:@"name"] forKey:@"公司:"];
                   [dic setObject:[data objectForKey:@"no"] forKey:@"companyno"];
                   self.popController.dic = dic;
               } copy];
    
    if ([self.LoginOrSeting isEqualToString:@"login"]) {
        int oldRow = (oldint == nil)?-1:oldint.row;
        int currentRow = indexPath.row;
        if (currentRow != oldRow) {
            UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldint];
            oldCell.accessoryType = UITableViewCellAccessoryNone;
            oldint = [indexPath retain];
        }
    }else
    {
        myblock();
    }
}
#pragma mark - 点击下一步成功后的回调
-(void)sucessSendPostData:(PBWeiboDataConnect *)weiboDatas{
    if ([self.LoginOrSeting isEqualToString:@"login"]) {
        PBpersonerInfo *personal = [[PBpersonerInfo alloc]initWithStyle:UITableViewStyleGrouped];
//        personal.headArr = [[NSMutableArray alloc]initWithObjects:@"真实姓名",@"性别", nil];
        [self.navigationController pushViewController:personal animated:YES];
        [personal release];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
}

@end
