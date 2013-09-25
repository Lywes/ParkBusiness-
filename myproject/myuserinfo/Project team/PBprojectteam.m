//
//  PBprojectteam.m
//  ParkBusiness
//
//  Created by 新平 圣 on 13-3-1.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#define KSEARCHPROJECTTEAM [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchgroup",HOST]]
#import "PBprojectteam.h"
#import "PBteamData.h"
#import "PBKbnMasterModel.h"
#import "AsyncImageView.h"
#import "UIImageView+WebCache.h"
@interface PBprojectteam()
//-(void)teamMemberData;//服务器传输
-(void)teamMemberDBData;
-(void)zuijiaButtonPress:(id)sender;
-(void)searchInserver;
@end


@implementation PBprojectteam
@synthesize teammembers,projectno;
@synthesize ProjectStyle;
@synthesize datadic;
-(void)dealloc
{
    [activity release];
    [self.datadic release];
    [self.teammembers release];
    [pbdataclass release];
//    [zuijia release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"项目团队";
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        [self teamMemberDBData];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    activity = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:activity];
    [activity retain];
    pbdataclass = [[PBdataClass alloc]init];
    pbdataclass.delegate = self;
    self.teammembers = [[[NSMutableArray alloc]init]autorelease];
    //tableview背景
    UIImage *image = [UIImage imageNamed:@"back.png"];
    UIButton *lefbt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [lefbt setBackgroundImage:image forState:UIControlStateNormal];
    [lefbt addTarget:self action:@selector(backUpView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbutton = [[[UIBarButtonItem alloc]initWithCustomView:lefbt]autorelease];
    self.navigationItem.leftBarButtonItem = leftbutton;
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        UIBarButtonItem *button_zuijia = [[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_zj", nil) style:UIBarButtonItemStylePlain target:self action:@selector(zuijiaButtonPress:)]autorelease];
        self.navigationItem.rightBarButtonItem = button_zuijia;
      
    } 
    else {
          [self searchInserver];
    }
}
-(void)backUpView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)teamMemberDBData
{
    self.teammembers = [PBteamData searchWhereProjectno:self.projectno];
    if ([self.teammembers count]>0) {
        [self.tableView reloadData];
    }
}
-(void)searchInserver
{
    [activity startAnimating];
 
    [pbdataclass dataResponse:KSEARCHPROJECTTEAM postDic:[NSDictionary dictionaryWithObjectsAndKeys:[self.datadic objectForKey:@"companyno"],@"companyno",[self.datadic objectForKey:@"no"],@"projectno", nil] searchOrSave:YES];
}

/*
 获取失败
 */
-(void)searchFilad
{
    [activity stopAnimating]; 
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    self.teammembers = datas;
    [activity stopAnimating];
    [self.tableView reloadData];
}
-(void)zuijiaButtonPress:(id)sender
{
    zuijia = [[PBzuijia alloc]initWithStyle:UITableViewStyleGrouped];
    [zuijia navigatorRightButtonType:ZUIJIA];
    if ([zuijia.memberinfos count]!=0) {
        [zuijia.memberinfos removeAllObjects];
    }
    zuijia.projectno = self.projectno;
    [self.navigationController pushViewController:zuijia animated:YES];
    [zuijia release];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.teammembers = nil;
    zuijia = nil;
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
  
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.teammembers count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    UILabel *lable;
    if (isPad()) {
         lable = [[[UILabel alloc]initWithFrame:CGRectMake(350, 7, 200, 30)]autorelease];
        lable.font = [UIFont systemFontOfSize:PadContentFontSize];
    }
    else {
        lable = [[[UILabel alloc]initWithFrame:CGRectMake(250, 7, 200, 30)]autorelease];
        lable.font = [UIFont systemFontOfSize:ContentFontSize];
    }
   
    lable.backgroundColor = [UIColor clearColor];
    [cell addSubview:lable];
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        if ([self.teammembers count] > 0) {
            PBteamData *teamdat = [self.teammembers objectAtIndex:indexPath.section];
            cell.textLabel.text = teamdat.name;
            lable.text = [NSString stringWithFormat:@"%@",[PBKbnMasterModel getKbnNameById:teamdat.teamjob withKind:@"job"]];
            cell.imageView.image = teamdat.imagepath;
        }
    }
    else
    {
        NSString *imagepath = [NSString stringWithFormat:@"%@%@",HOST,[[self.teammembers objectAtIndex:indexPath.section] objectForKey:@"imagepath"]];
        [cell.imageView setImageWithURL:[NSURL URLWithString:imagepath]];
  
       NSString *str = [[self.teammembers objectAtIndex:indexPath.section] objectForKey:@"teamjob"];
        int a = str.intValue;
        lable.text = [NSString stringWithFormat:@"%@",[PBKbnMasterModel getKbnNameById:a withKind:@"job"]];
        cell.textLabel.text = [[self.teammembers objectAtIndex:indexPath.section] objectForKey:@"name"];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    zuijia = [[PBzuijia alloc]initWithStyle:UITableViewStyleGrouped];
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
         [zuijia navigatorRightButtonType:BIANJI];       
    } 
    else
    {
     zuijia.ProjectStyle = ELSEPROJECTINFO;
    }
    zuijia.memberinfos = self.teammembers;//传入数据数组;
    zuijia.number = indexPath.section;//传入数据索引
    zuijia.projectno = self.projectno;
    [self.navigationController pushViewController:zuijia animated:YES];
    [zuijia release];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            NSInteger no = [[self.teammembers objectAtIndex:indexPath.section] no];
            [activity startAnimating];
            numbersection = indexPath.section;
            [pbdataclass dataResponse:[NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/addgroup",HOST]] postDic:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",no],@"no",@"del",@"mode", nil] searchOrSave:NO];
        }   

    }

}

-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    [PBteamData deleteId:[intvalue intValue]];
    [self.teammembers removeObjectAtIndex:numbersection];
    [self.tableView reloadData];
     [activity stopAnimating];
}


@end
