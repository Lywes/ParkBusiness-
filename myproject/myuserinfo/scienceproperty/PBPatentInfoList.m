//
//  PBPatentInfoList.m
//  ParkBusiness
//
//  Created by 上海 on 13-5-23.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBPatentInfoList.h"
#import "PBPatantData.h"
#import "PBAddPatentInfo.h"
@interface PBPatentInfoList ()

@end

@implementation PBPatentInfoList
@synthesize projectno;
@synthesize userinfos;
@synthesize ProjectStyle;
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
    UIBarButtonItem *rightbutton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_zj", nil) style:UIBarButtonItemStylePlain target:self action:@selector(addDidPush)];
    self.navigationItem.rightBarButtonItem = rightbutton;
    [rightbutton release];
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
       [self backButton];
    }
    else {
        [self searchInserver];
    }
    
    activity = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:activity];
    [activity retain];
    pbdataclass = [[PBdataClass alloc]init];
    pbdataclass.delegate = self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)searchInserver
{
    [activity startAnimating];
    
//    [pbdataclass dataResponse:KSEARCHPROJECTTEAM postDic:[NSDictionary dictionaryWithObjectsAndKeys:[self.datadic objectForKey:@"companyno"],@"companyno",[self.datadic objectForKey:@"no"],@"projectno", nil] searchOrSave:YES];
}
-(void)addDidPush{//点击追加按钮
    PBAddPatentInfo* edit = [[PBAddPatentInfo alloc]initWithStyle:UITableViewStyleGrouped];
    [edit navigatorRightButtonType:ZUIJIA];
    edit.mode = @"add";
    edit.projectno = self.projectno;
    edit.title = @"追加新专利";
    [self.navigationController pushViewController:edit animated:YES];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dataList = [PBPatantData searchData:self.projectno];
    [self.tableView reloadData];
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
    return [dataList count];
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
    if ([dataList count]>0) {
        PBPatantData* data = [dataList objectAtIndex:indexPath.section];
        cell.textLabel.text = data.name?data.name:@"";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
   
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO])
        return YES;
    return NO;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger no = [[dataList objectAtIndex:indexPath.section] no];
        [activity startAnimating];
        [pbdataclass dataResponse:[NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/addpatentinfo",HOST]] postDic:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",no],@"no",@"del",@"mode", nil] searchOrSave:NO];
    }
}

-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    [PBPatantData deleteRecord:[intvalue intValue]];
    dataList = [PBPatantData searchData:self.projectno];
    [self.tableView reloadData];
    [activity stopAnimating];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    PBAddPatentInfo* edit = [[PBAddPatentInfo alloc]initWithStyle:UITableViewStyleGrouped];
    PBPatantData* data = [dataList objectAtIndex:indexPath.section];
    [edit navigatorRightButtonType:BIANJI];
    edit.mode = @"mod";
    edit.title = data.name;
    edit.pbdata = data;
    [self.navigationController pushViewController:edit animated:YES];
    
}

@end
