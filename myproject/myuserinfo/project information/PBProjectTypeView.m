//
//  PBProjectTypeView.m
//  ParkBusiness
//
//  Created by QDS on 13-5-14.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBProjectTypeView.h"
#import "PBuserinfo.h"
#import "PBKbnMasterModel.h"
#import "PBAddFinanceAssure.h"
#import "PBAssureCompanyInfo.h"
@interface PBProjectTypeView ()

@end

@implementation PBProjectTypeView
@synthesize rowno;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    allData = [[NSMutableArray alloc]init];
    NSMutableArray* arr = [PBKbnMasterModel getKbnInfoByKind:@"projecttype"];
    for (PBKbnMasterModel* model in arr) {
        [allData addObject:model.name];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextDidPush)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_qx", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelDidPush)];
    [self.navigationItem setHidesBackButton:YES];
    self.rowno = -1;//所选角色
    self.tableView.tableHeaderView = [self headerView];
}
-(UIView *)headerView
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    UITextView *fheaderView = [[[UITextView alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width-40, 100)]autorelease];
    fheaderView.font = [UIFont systemFontOfSize:isPad()?16:14];
    fheaderView.text = @"如果您还不清楚贵公司适合何种融资方式，请在'我的需求'模块中按照要求填写您的融资需求，本平台上的各家金融机构会根据您的融资需求给出具体的融资方案，供您参考与选择。您也可以拨打如下电话咨询我们的金融专家：021-53930568。";
    fheaderView.scrollEnabled = NO;
    fheaderView.backgroundColor = [UIColor clearColor];
    [view addSubview:fheaderView];
    return view;
}
-(void)dealloc
{
    [allData release];
    [super dealloc];
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"请选择项目类型：";
}
-(void)cancelDidPush{
    [self dismissModalViewControllerAnimated:YES];
}
-(void)nextDidPush{
    if (self.rowno>=0) {
        PBuserinfo* userinfo  = [[PBuserinfo alloc]initWithStyle:UITableViewStyleGrouped];
        switch (self.rowno) {
            case 0:
                [userinfo navigatorRightButtonType:BIANJI];
                userinfo.mode = @"add";
                userinfo.title = @"新项目";
                userinfo.type = self.rowno+1;
                [self.navigationController pushViewController:userinfo animated:YES];
                break;
            case 1:
                [userinfo navigatorRightButtonType:NEXT];
                userinfo.mode = @"add";
                userinfo.type = self.rowno+1;
                userinfo.title = @"银行贷款申请";
                [self.navigationController pushViewController:userinfo animated:YES];
                break;
            case 2:{
                PBAssureCompanyInfo* company = [[PBAssureCompanyInfo alloc]initWithStyle:UITableViewStyleGrouped];
                [company navigatorRightButtonType:NEXT];
                company.mode = @"add";
                company.type = self.rowno+1;
                company.title = @"企业基本信息";
                [self.navigationController pushViewController:company animated:YES];
                }
                break;
            case 3:{
                PBAddFinanceAssure* assure = [[PBAddFinanceAssure alloc]initWithStyle:UITableViewStyleGrouped];
                [assure navigatorRightButtonType:NEXT];
                assure.mode = @"add";
                assure.type = self.rowno+1;
                assure.title = @"金融担保申请";
                [self.navigationController pushViewController:assure animated:YES];
                }
                break;
            case 4:{
                PBAssureCompanyInfo* company = [[PBAssureCompanyInfo alloc]initWithStyle:UITableViewStyleGrouped];
                [company navigatorRightButtonType:NEXT];
                company.mode = @"add";
                company.type = self.rowno+1;
                company.title = @"企业基本信息";
                [self.navigationController pushViewController:company animated:YES];
            }
                break;
            default:
                break;
        }
        [userinfo release];
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择项目类型" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [allData count]-1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    if (self.rowno==indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.textLabel.text = [allData objectAtIndex:indexPath.row];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    self.rowno = indexPath.row;
    [self.tableView reloadData];
}

@end
