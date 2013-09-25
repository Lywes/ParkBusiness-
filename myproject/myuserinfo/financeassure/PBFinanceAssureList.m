//
//  PBFinanceAssureList.m
//  ParkBusiness
//
//  Created by 上海 on 13-5-28.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBFinanceAssureList.h"
#import "PBAddFinanceAssure.h"
#import "PBAssureCompanyInfo.h"
#import "PBAddCompanyBand.h"
#import "PBAddFinanceLease.h"
#import "PBFinanceDataList.h"
#import "PBuserinfo.h"
#import "PBBankFinanceNeeds.h"
@interface PBFinanceAssureList ()

@end

@implementation PBFinanceAssureList
@synthesize projectno;
@synthesize type;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc{
    [super dealloc];
    [titleArr release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.type==2) {
        titleArr  = [[NSMutableArray alloc]initWithObjects:@"项目基本信息",@"企业现状",NSLocalizedString(@"Left_mainTable_RZXQ", nil), nil];
    }else if (self.type==3) {
        titleArr = [[NSMutableArray alloc]initWithObjects:@"企业债券",@"企业基本信息", nil];
    }else if(self.type==4){
        titleArr = [[NSMutableArray alloc]initWithObjects:@"金融担保",@"企业基本信息", nil];
    }else if(self.type==5){
        titleArr = [[NSMutableArray alloc]initWithObjects:@"金融租赁",@"企业基本信息",@"近三年财务信息", nil];
    }
    [self backButton];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)backButton
{
    UIImage *image = [UIImage imageNamed:@"back.png"];
    UIButton *lefbt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [lefbt setBackgroundImage:image forState:UIControlStateNormal];
    [lefbt addTarget:self action:@selector(backUpView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbutton = [[[UIBarButtonItem alloc]initWithCustomView:lefbt]autorelease];
    self.navigationItem.leftBarButtonItem = leftbutton;
}
-(void)backUpView
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [titleArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat: @"project%d.png",indexPath.section+1]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [titleArr objectAtIndex:indexPath.section];    // Configure the cell...
    
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
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (self.type==2) {
            PBuserinfo* userinfo = [[PBuserinfo alloc]initWithStyle:UITableViewStyleGrouped];
            userinfo.type = self.type;
            [userinfo navigatorRightButtonType:BIANJI];
            userinfo.projectno = self.projectno;
            [self.navigationController pushViewController:userinfo animated:YES];
        }
        if (self.type==3) {
            PBAddCompanyBand* add = [[PBAddCompanyBand alloc]initWithStyle:UITableViewStyleGrouped];
            add.mode = @"mod";
            [add navigatorRightButtonType:BIANJI];
            add.projectno = self.projectno;
            add.title = [titleArr objectAtIndex:0];
            [self.navigationController pushViewController:add animated:YES];
        }
        if (self.type==4) {
            PBAddFinanceAssure* add = [[PBAddFinanceAssure alloc]initWithStyle:UITableViewStyleGrouped];
            add.mode = @"mod";
            [add navigatorRightButtonType:BIANJI];
            add.projectno = self.projectno;
            add.title = [titleArr objectAtIndex:0];
            [self.navigationController pushViewController:add animated:YES];
        }
        if (self.type==5) {
            PBAddFinanceLease* add = [[PBAddFinanceLease alloc]initWithStyle:UITableViewStyleGrouped];
            add.mode = @"mod";
            [add navigatorRightButtonType:BIANJI];
            add.projectno = self.projectno;
            add.title = [titleArr objectAtIndex:0];
            [self.navigationController pushViewController:add animated:YES];
        }
    }
    if (indexPath.section == 1) {
        PBAssureCompanyInfo* company = [[PBAssureCompanyInfo alloc]initWithStyle:UITableViewStyleGrouped];
        company.mode = @"mod";
        company.type = self.type;
        [company navigatorRightButtonType:BIANJI];
        company.projectno = self.projectno;
        company.title = [titleArr objectAtIndex:1];
        [self.navigationController pushViewController:company animated:YES];
    }
    if (indexPath.section == 2) {
        if (self.type==2) {
            PBBankFinanceNeeds* needs = [[PBBankFinanceNeeds alloc]init];
            [needs navigatorRightButtonType:BIANJI];
            needs.projectno = self.projectno;
            needs.title = NSLocalizedString(@"Left_mainTable_RZXQ", nil);
            [self.navigationController pushViewController:needs animated:YES];
            [needs release];
        }else{
            PBFinanceDataList* list = [[PBFinanceDataList alloc]initWithStyle:UITableViewStyleGrouped];
            list.mode = @"mod";
            list.count = 3;
            list.projectno = self.projectno;
            list.title = [titleArr objectAtIndex:2];
            [self.navigationController pushViewController:list animated:YES];
        }
    }
}

@end
