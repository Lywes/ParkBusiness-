//
//  PBrongziList.m
//  ParkBusiness
//
//  Created by lywes lee on 13-4-19.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define SEARCHERONGZIJINGLI [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchinvestexperience",HOST]]

#import "PBrongziList.h"
#import "PBrongzijingliData.h"
@interface PBrongziList ()
-(void)searchInserver;
@end

@implementation PBrongziList
@synthesize arry;
@synthesize projectno;
@synthesize investorcase;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"融资经历";
    }
    return self;
}
-(void)viewLoding
{
    activity = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
}
-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
       self.arry = [PBrongzijingliData searchWhereProjectno:self.projectno];
        [self navigatorRightButtonType:ZUIJIA];

    }
    else {
        [self.view addSubview:activity];
        [self searchInserver];
    }
    [self.tableView reloadData];
}
-(void)searchInserver
{
    [activity startAnimating]; 
    [dataclass dataResponse:SEARCHERONGZIJINGLI postDic:[NSDictionary dictionaryWithObjectsAndKeys:[self.datadic objectForKey:@"companyno"],@"companyno",[self.datadic objectForKey:@"no"],@"projectno", nil] searchOrSave:YES];
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
    NSLog(@"字段:%@",self.datadic);
    NSLog(@"融资经历:%@",datas);
    self.arry = datas;
     [self.tableView reloadData];
    [activity stopAnimating]; 
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.arry = [[[NSMutableArray alloc]init]autorelease];
    dataclass = [[PBdataClass alloc]init];
    dataclass.delegate = self;
    
}
-(void)postDataOnserver
{
    if (self.investorcase) {
        [self.investorcase release];
    }
    self.investorcase = [[PBinvestexperience alloc]initWithStyle:UITableViewStyleGrouped];
    [self.investorcase navigatorRightButtonType:WANCHEN];
    self.investorcase.title =@"添加";
    self.investorcase.projectno = self.projectno;
    [self.navigationController pushViewController:self.investorcase animated:YES];

}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.investorcase) {
        [self.investorcase release];
    }
    self.investorcase = [[PBinvestexperience alloc]initWithStyle:UITableViewStyleGrouped];
    if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        self.investorcase.datadic = [self.arry objectAtIndex:indexPath.section];
        self.investorcase.ProjectStyle = ELSEPROJECTINFO;
    }
    else {
        [self.investorcase navigatorRightButtonType:BIANJI];
        self.investorcase.data = [self.arry objectAtIndex:indexPath.section];
        self.investorcase.projectno = self.projectno;
    }
    self.investorcase.title =@"融资信息";
    [self.navigationController pushViewController:self.investorcase animated:YES];
}
- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [self.arry count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (arry.count>0) {
        if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
            cell.textLabel.text = [[self.arry objectAtIndex:indexPath.section]objectForKey:@"investors"];
            cell.detailTextLabel.text = [[self.arry objectAtIndex:indexPath.section]objectForKey:@"financetime"];
        }
        else {
            PBrongzijingliData *data = [self.arry objectAtIndex:indexPath.section];
            cell.textLabel.text = data.investors;
            cell.detailTextLabel.text = data.financetime;
        }
     
    }

    return cell;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            NSInteger no = [[self.arry objectAtIndex:indexPath.section] no];
            [activity startAnimating];
            numsection = indexPath.section;
            [dataclass dataResponse:[NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/addinvestexperience",HOST]] postDic:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",no],@"no",@"del",@"mode", nil] searchOrSave:NO];
        }
        
    }
}

-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    [PBrongzijingliData deleteId:[intvalue intValue]];
    [self.arry removeObjectAtIndex:numsection];
    [self.tableView reloadData];
    [activity stopAnimating];

}


@end
