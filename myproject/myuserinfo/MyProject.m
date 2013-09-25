//
//  MyProject.m
//  ParkBusiness
//
//  Created by lywes lee on 13-2-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define NUM_OF_PROJECTLAN 8
#define IPADSIZE 80.0f
#define IPHONESIZE 44.0f
#import "MyProject.h"
#import "PBAssureCompanyInfo.h"
#import "PBFinanceDataList.h"
#import "PBScienceProperty.h"
@interface MyProject ()
@end

@implementation MyProject
@synthesize tableview;
@synthesize projectinfos;
@synthesize pbprojectdata;
@synthesize ProjectStyle;
@synthesize dic;
-(void)dealloc
{
    [tableview release];
    [projectinfos release];
//    [pb_rongzi release];
//    [pb_businessmodel release];
//    [pb_projectplan release];
//    [pb_xiangmutuandui release];
//    [pb_xiangmuxinxi release];
    
    [keys release];
    [volue release];
    [xiangmuinfos=nil release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"项目信息";
        keys = [[NSMutableArray alloc]init];
        volue = [[NSMutableArray alloc]init];
        UIImage *image = [UIImage imageNamed:@"back.png"];
        UIButton *lefbt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [lefbt setBackgroundImage:image forState:UIControlStateNormal];
        [lefbt addTarget:self action:@selector(backUpView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftbutton = [[[UIBarButtonItem alloc]initWithCustomView:lefbt]autorelease];
        self.navigationItem.leftBarButtonItem = leftbutton;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.projectinfos  = [NSMutableArray arrayWithCapacity:NUM_OF_PROJECTLAN];
    NSArray *arry = [[NSArray alloc]initWithObjects:@"项目基本信息",@"项目团队",@"项目商业模式及业务状况",@"项目三年发展计划",@"公司近两年财务状况",@"项目知识产权",@"项目融资需求",@"项目动态",@"融资经历", nil];
    [self.projectinfos addObjectsFromArray:arry];
    [arry release];
}
-(void)backUpView
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    cell.textLabel.text = [self.projectinfos objectAtIndex:indexPath.section];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
      return self.projectinfos.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        pb_xiangmuxinxi = [[PBuserinfo alloc]initWithStyle:UITableViewStyleGrouped];
        if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
            pb_xiangmuxinxi.userinfos = self.dic;
            pb_xiangmuxinxi.popController = self;
            pb_xiangmuxinxi.ProjectStyle = ELSEPROJECTINFO;
        }
        else 
        {
            [pb_xiangmuxinxi navigatorRightButtonType:BIANJI];
            pb_xiangmuxinxi.projectno = self.pbprojectdata.no;
        }
        pb_xiangmuxinxi.type = self.pbprojectdata.type;
        [self.navigationController pushViewController:pb_xiangmuxinxi animated:YES];
        [pb_xiangmuxinxi release];
    }
    if (indexPath.section == 1) {
        pb_xiangmutuandui = [[PBprojectteam alloc]initWithStyle:UITableViewStyleGrouped];
        if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
            pb_xiangmutuandui.datadic = self.dic;
            pb_xiangmutuandui.ProjectStyle = ELSEPROJECTINFO;
        }
        else {
            pb_xiangmutuandui.projectno = self.pbprojectdata.no;
        }
        //        [pb_xiangmutuandui retain];
        [self.navigationController pushViewController:pb_xiangmutuandui animated:YES];
        [pb_xiangmutuandui release];
    }
    if (indexPath.section == 2) {
        pb_businessmodel = [[PBbusinessmodel alloc]initWithStyle:UITableViewStyleGrouped];
        if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
            pb_businessmodel.datadic = self.dic;
            pb_businessmodel.ProjectStyle = ELSEPROJECTINFO;
        }
        else {
            pb_businessmodel.projectno = self.pbprojectdata.no;
        }
        [self.navigationController pushViewController:pb_businessmodel animated:YES];
        [pb_businessmodel release];
    }
    if (indexPath.section == 3) {
        pb_projectplan = [[PBprojectplan alloc]initWithStyle:UITableViewStyleGrouped];
        if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
            pb_projectplan.datadic = self.dic;
             pb_projectplan.ProjectStyle = ELSEPROJECTINFO;
        }
        else {
             pb_projectplan.projectno = self.pbprojectdata.no;
        }
        [pb_projectplan retain];
        [self.navigationController pushViewController:pb_projectplan animated:YES];
        [pb_projectplan release];
        
    }
    if (indexPath.section == 4) {//近两年财务状况
        PBFinanceDataList* list = [[PBFinanceDataList alloc]initWithStyle:UITableViewStyleGrouped];
        list.projectno = self.pbprojectdata.no;
        list.count = 2;
        list.title = @"近两年财务状况";
        [self.navigationController pushViewController:list animated:YES];
        [list release];
        
    }
    if (indexPath.section == 5){//产权
        PBScienceProperty* property = [[PBScienceProperty alloc]initWithStyle:UITableViewStyleGrouped];
        property.projectno = self.pbprojectdata.no;
        [property navigatorRightButtonType:WANCHEN];
        property.title = @"知识产权";
        [self.navigationController pushViewController:property animated:YES];
        [property release];
        
    }
    if (indexPath.section == 6) {
        
        if (pb_rongzi) {
            [pb_rongzi release];
        }
        pb_rongzi = [[PBrongzi alloc]initWithStyle:UITableViewStyleGrouped];
         if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO])
         {
              pb_rongzi.datadic = self.dic;
              pb_rongzi.ProjectStyle = ELSEPROJECTINFO;
         }
         else {
             pb_rongzi.projectno = self.pbprojectdata.no;
         }
        [self.navigationController pushViewController:pb_rongzi animated:YES];
        
    }
    if (indexPath.section == 7) {
        
        if (!pb_trends) {
            pb_trends = [[PBprojectTrends alloc]initWithStyle:UITableViewStyleGrouped];
        }
        if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
            pb_trends.ProjectStyle = ELSEPROJECTINFO;
            pb_trends.OtherData = self.dic;
        }
        pb_trends.projectno = self.pbprojectdata.no;
        [self.navigationController pushViewController:pb_trends animated:YES];
        
    }
    if (indexPath.section == 8) {
        if (!pb_rongzilist) {
            pb_rongzilist = [[PBrongziList alloc]initWithStyle:UITableViewStyleGrouped];
        }
        if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
            pb_rongzilist.ProjectStyle = ELSEPROJECTINFO;
            pb_rongzilist.datadic = self.dic;
        }
        else
        {
             pb_rongzilist.projectno = self.pbprojectdata.no;
        }        
        [self.navigationController pushViewController:pb_rongzilist animated:YES];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableview = nil;
    self.projectinfos = nil;
    pb_xiangmuxinxi = nil;
    pb_xiangmutuandui = nil;
    pb_businessmodel = nil;
    pb_projectplan = nil;
    pb_rongzi = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
