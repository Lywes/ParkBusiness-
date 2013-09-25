//
//  PBFinanceDataList.m
//  ParkBusiness
//
//  Created by 上海 on 13-5-22.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBFinanceDataList.h"
#import "PBAddFinanceData.h"
#define SEARCHURL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchfinancingleaseaccount",HOST]]
@interface PBFinanceDataList ()

@end

@implementation PBFinanceDataList
@synthesize count;
@synthesize projectno;
@synthesize productno;
@synthesize mode;
@synthesize userinfo;
@synthesize ProjectStyle;
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
    [dataList release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self backButton];
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_wc", nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveDidPush)];
        
    }else{
        [self searchInserver];
    }
    dataList = [[NSMutableArray alloc]init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)saveDidPush
{
    if ([dataList count]==self.count) {
        if (self.count==3&&[self.mode isEqualToString:@"add"]) {
            [self dismissModalViewControllerAnimated:YES];
            if (self.productno>0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"showalert" object:nil];
            }
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请先完善财务信息！"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    int year = [[formatter stringFromDate:[NSDate date]] intValue];
    int type = self.count==2?1:5;
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        dataList = [PBFinanceAccountData searchData:self.projectno withyear:year-self.count withType:type];
    }
    
    [self.tableView reloadData];
}

-(void)searchInserver
{
    [activity startAnimating];
    PBdataClass *dataclass = [[PBdataClass alloc]init];
    dataclass.delegate = self;
    [dataclass dataResponse:SEARCHURL postDic:[NSDictionary dictionaryWithObjectsAndKeys:[self.userinfo objectForKey:@"no"],@"projectno",[self.userinfo objectForKey:@"type"],@"type", nil] searchOrSave:YES];
}
//获取网络数据
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    for (NSMutableDictionary *dic in datas) {
        PBFinanceAccountData* data = [self dataZhuanhuan:dic];
        [dataList addObject:data];
    }
    [activity stopAnimating];
    [self.tableView reloadData];
}
//数据转换
-(PBFinanceAccountData *)dataZhuanhuan:(NSMutableDictionary *)dic
{
    PBFinanceAccountData* data = [[PBFinanceAccountData alloc]init];
    data.year = [[dic objectForKey:@"year"] intValue];
    data.assetamount = [[dic objectForKey:@"assetamount"] intValue];
    data.responseamount = [[dic objectForKey:@"responseamount"] intValue];
    data.netasset = [[dic objectForKey:@"netasset"] intValue];
    data.assetdebtrate = [[dic objectForKey:@"assetdebtrate"] intValue];
    data.salesrevenue = [[dic objectForKey:@"salesrevenue"] intValue];
    data.pretaxprofit = [[dic objectForKey:@"pretaxprofit"] intValue];
    data.aftertaxprofit = [[dic objectForKey:@"aftertaxprofit"] intValue];
    data.activitycashflow = [[dic objectForKey:@"activitycashflow"] intValue];
    data.others = [dic objectForKey:@"others"] ;
    return data;
}
-(void)addButtonPress{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    int year = [[formatter stringFromDate:[NSDate date]] intValue]-1;
    PBAddFinanceData* detailView = [[PBAddFinanceData alloc]init];
    detailView.mode = @"add";
    detailView.type = self.count==2?1:5;
    detailView.projectno = self.projectno;
    year -= [dataList count];
    [detailView navigatorRightButtonType:ZUIJIA];
    detailView.title = [NSString stringWithFormat:@"%d年度财政信息",year];
    detailView.year = year;
    [self.navigationController pushViewController:detailView animated:YES];
    [detailView release];
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
    if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        return [dataList count];
    }
    return [dataList count]==0?1:([dataList count]==self.count?self.count:[dataList count]+1);
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
    int section = [dataList count]<self.count?indexPath.section-1:indexPath.section;
    if ([dataList count]<self.count&&indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"list_addfriend.png"] ;
        cell.textLabel.text = @"追加新记录";
    }else if(indexPath.section >= 0){
        cell.imageView.image = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        PBFinanceAccountData* data  = [dataList objectAtIndex:section];
        cell.textLabel.text = [NSString stringWithFormat:@"%d年度",data.year];
    }

    // Configure the cell...
    
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int section = [dataList count]<self.count?indexPath.section-1:indexPath.section;
    if ([dataList count]<self.count&&indexPath.section == 0) {
        [self addButtonPress];
    }else if(indexPath.section >= 0){
        PBFinanceAccountData* data  = [dataList objectAtIndex:section];
        PBAddFinanceData* detailView = [[PBAddFinanceData alloc]init];
        detailView.pbfinanceData = data;
        detailView.mode = @"mod";
        detailView.ProjectStyle = self.ProjectStyle;
        detailView.type = self.count==2?1:5;
        if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]){
            [detailView navigatorRightButtonType:BIANJI];
        }
        detailView.title = [NSString stringWithFormat:@"%d年度财政信息",data.year];
        [self.navigationController pushViewController:detailView animated:YES];
        [detailView release];
    }
    
}

@end
