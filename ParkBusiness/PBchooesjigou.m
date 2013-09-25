//
//  PBchooesjigou.m
//  ParkBusiness
//
//  Created by China on 13-7-19.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define SAVEURL [NSString stringWithFormat:@"%@/admin/index/updatecompanyno",HOST]
#import "PBchooesjigou.h"
#import "PBWeiboCell.h"
#import "PBpersonerInfo.h"
@implementation PBchooesjigou
@synthesize postURL_str;
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"请选择您所属金融机构";
    [searchBar removeFromSuperview];
    //下拉显示
    pullController = [[PBPullTableViewController alloc]initWithFrame:CGRectMake(0, 0, VIEWSIZE.width, VIEWSIZE.height - KNavigationBarHeight)];
    pullController.delegate =self;
    pullController.tableViews.delegate = self;
    pullController.tableViews.dataSource = self;
    [self.view addSubview:pullController.tableViews];
    [self.view addSubview:pullController.indicator];
    companyData = [[PBWeiboDataConnect alloc]init];
    companyData.delegate = self;
    self.navigationItem.rightBarButtonItem.title  = @"下一步";
    [self requestData:@"1"];
}
- (void) requestData:(NSString *)pageno
{
    if ([pageno isEqualToString:@"1"]) {
        [pullController.allData removeAllObjects];
    }
    [pullController.indicator startAnimating];
    //下面这句代码为特例
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:pageno, @"pageno", nil];
    [companyData getXMLDataFromUrl:self.postURL_str postValuesAndKeys:dic];
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
                   NSArray *a1 = nil;
                   NSArray *a2 = nil;
                   if ([data objectForKey:@"groupid"]) {
                       a1 = [[NSArray alloc]initWithObjects:@"companyno",@"no", @"gid",nil];
                       a2 = [[NSArray alloc]initWithObjects:[data objectForKey:@"no"],
                             USERNO,[data objectForKey:@"groupid"],
                             nil];
                   }
                   else
                   {
                       a1 = [[NSArray alloc]initWithObjects:@"companyno",@"no",nil];
                       a2 = [[NSArray alloc]initWithObjects:[data objectForKey:@"no"],
                             USERNO,
                             nil];
                   }
                   [companyData submitDataFromUrl:SAVEURL postValuesAndKeys:[[NSMutableDictionary alloc]initWithObjects:a2 forKeys:a1]];
                   NSMutableDictionary* dic = self.popController.dic;
                   [dic setObject:[data objectForKey:@"name"] forKey:@"公司:"];
                   [dic setObject:[data objectForKey:@"no"] forKey:@"companyno"];
                   self.popController.dic = dic;
               } copy];
        int oldRow = (oldint == nil)?-1:oldint.row;
        int currentRow = indexPath.row;
        if (currentRow != oldRow) {
            UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldint];
            oldCell.accessoryType = UITableViewCellAccessoryNone;
            oldint = [indexPath retain];
        }
}
#pragma mark - 点击下一步成功后的回调
-(void)sucessSendPostData:(PBWeiboDataConnect *)weiboDatas{
    
    PBpersonerInfo *personal = [[PBpersonerInfo alloc]initWithStyle:UITableViewStyleGrouped];
//    personal.headArr = [[NSMutableArray alloc]initWithObjects:@"真实姓名",@"性别", nil];
    [self.navigationController pushViewController:personal animated:YES];
    [personal release];

}

@end
