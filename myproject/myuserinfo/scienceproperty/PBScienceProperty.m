//
//  PBScienceProperty.m
//  ParkBusiness
//
//  Created by 上海 on 13-5-23.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBScienceProperty.h"
#import "PBProjectData.h"
#import "PBPatentInfoList.h"
#define URL [NSString stringWithFormat:@"%@/admin/index/searchscienceproperty",HOST]
#define SAVEURL [NSString stringWithFormat:@"%@/admin/index/addscienceproperty",HOST]
@interface PBScienceProperty ()
-(void)postOtherData;
-(void)SearchOnServer;
-(PBProjectData *)dataZhuanhuan:(NSMutableDictionary *)dic;
@end

@implementation PBScienceProperty
@synthesize userinfos;
@synthesize projectno;
@synthesize mode;
@synthesize type;
@synthesize pbdata;
@synthesize textDic;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewLoding
{
    CGRect frame = self.view.frame;
    frame.size.height = frame.size.height-KTabBarHeight-KNavigationBarHeight;
    self.tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
    acitivity = [[PBActivityIndicatorView alloc]initWithFrame:frame];
    [acitivity retain];
    titleArr = [[NSMutableArray alloc]initWithObjects:@"专利情况",@"软件著作权号码:",@"植物新品种:",@"集成电路布图设计登记号:",nil];
    self.textDic = [[NSMutableDictionary alloc]init];
}


-(void)viewWillDisappear:(BOOL)animated{
    [acitivity removeFromSuperview];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSubview:acitivity];
    if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        self.tableView.allowsSelection = NO;
        self.pbdata = [[PBProjectData alloc]init];
        [self SearchOnServer];
    }else{//本地取数据
        self.pbdata = [PBProjectData searchImagePath:self.projectno];
    }
    if ([self.textDic count]>0) {
        [self settingTextLabel];
    }
    [self.tableView reloadData];
    
}

-(void)settingTextLabel{
    self.pbdata.softwareno = [self.textDic objectForKey:@"软件著作权号码:"]?[self.textDic objectForKey:@"软件著作权号码:"]:self.pbdata.softwareno;
    self.pbdata.plantname = [self.textDic objectForKey:@"植物新品种:"]?[self.textDic objectForKey:@"植物新品种:"]:self.pbdata.plantname;
    self.pbdata.diagramno = [self.textDic objectForKey:@"集成电路布图设计登记号:"]?[self.textDic objectForKey:@"集成电路布图设计登记号:"]:self.pbdata.diagramno;
}
#pragma mark -编辑状态
-(void)editState
{
    [self.tableView reloadData];
}
#pragma mark - 从服务器服务器取数据
-(void)SearchOnServer
{
    [acitivity startAnimating];
    PBdataClass *pb = [[PBdataClass alloc]init];
    pb.delegate = self;
[pb dataResponse:[NSURL URLWithString:URL] postDic:[NSDictionary dictionaryWithObjectsAndKeys:[self.userinfos objectForKey:@"no"],@"no", nil]searchOrSave:YES];
    
}
/*
 获取失败
 */
-(void)searchFilad
{
    [acitivity stopAnimating];
}
/*
 上传成功
 */
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    if (datas.count > 0) {
        [self dataZhuanhuan:[datas objectAtIndex:0]];
    }
    [acitivity stopAnimating];
}
/*
 上传失败
 */
-(void)requestFilad
{
    [acitivity stopAnimating];
}
-(PBProjectData *)dataZhuanhuan:(NSMutableDictionary *)dic
{
    self.pbdata.softwareno = [dic objectForKey:@"softwareno"];
    self.pbdata.plantname = [dic objectForKey:@"plantname"];
    self.pbdata.diagramno = [dic objectForKey:@"diagramno"];
    [self.tableView reloadData];
    return self.pbdata;
}
#pragma mark - 数据上传到服务器
-(void)postDataOnserver
{
    [acitivity startAnimating];
    [self postOtherData];
    
}

-(void)postOtherData
{
    PBdataClass *pb = [[PBdataClass alloc]init];
    pb.delegate = self;
    NSArray *a1 = [[NSArray alloc]initWithObjects:@"mode",@"no",@"softwareno",@"plantname",@"diagramno", nil];
    NSArray *a2 = [[NSArray alloc]initWithObjects:@"mod",
                   [NSString stringWithFormat:@"%d",self.pbdata.no],
                   self.pbdata.softwareno?self.pbdata.softwareno:@"",
                   self.pbdata.plantname?self.pbdata.plantname:@"",
                   self.pbdata.diagramno?self.pbdata.diagramno:@"",
                   nil];
    [pb dataResponse:[NSURL URLWithString:SAVEURL] postDic:[[NSDictionary alloc]initWithObjects:a2 forKeys:a1] searchOrSave:NO];
    
}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    //上传到本地
    [self.pbdata saveRecord];
    [acitivity stopAnimating];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44.0f;

    if (indexPath.section == 2) {
         height = MAX([self tableView:tableView heightForRow:indexPath.section withContent:self.pbdata.plantname]+10, 44.0f);
    }else if (indexPath.section == 3){
//         height = MAX([self tableView:tableView heightForRow:indexPath.section withContent:self.pbdata.diagramno]+10, 44.0f);
    }
    return height;
    
}

//自定义文本显示高度
-(CGFloat)tableView:(UITableView *)tableView heightForRow:(int)section withContent:(NSString*)content{
    CGFloat contentWidth = tableView.frame.size.width-60;
    UIFont *font = [UIFont systemFontOfSize:PadContentFontSmallSize];
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:UILineBreakModeWordWrap];
    return size.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return [titleArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return 1;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        return [titleArr objectAtIndex:section];
    }
    return nil;
}
#pragma mark - cell内容设置
-(void)addSubViewForCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        cell.textLabel.text = [titleArr objectAtIndex:indexPath.section];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section > 0) {
        //设置内容
        UIFont *font = [UIFont systemFontOfSize:PadContentFontSmallSize];
        CGFloat height = 0;
        CGRect frame = CGRectMake(10, 5, self.tableView.frame.size.width-(isPad()?130:60), 35);
        UILabel *lable = [[UILabel alloc]initWithFrame:frame];
        lable.backgroundColor = [UIColor clearColor];
        lable.lineBreakMode = UILineBreakModeMiddleTruncation;
        lable.numberOfLines = 0;
        lable.font = font;
        switch (indexPath.section) {
            case 1:
                lable.text = self.pbdata.softwareno;
                break;
            case 2:
                height = MAX([self tableView:self.tableView heightForRow:indexPath.section withContent:self.pbdata.plantname], 35.0f);
                frame.size.height = height;
                lable.frame = frame;
                lable.text = self.pbdata.plantname;
                break;
            case 3:
                height = MAX([self tableView:self.tableView heightForRow:indexPath.section withContent:self.pbdata.diagramno], 35.0f);
                frame.size.height = height;
                lable.frame = frame;
                lable.text = self.pbdata.diagramno;
                break;
            default:
                break;
        }
        [[cell contentView] addSubview:lable];
        [lable release];
    }
    
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PBPatentInfoList* list = [[PBPatentInfoList alloc]initWithStyle:UITableViewStyleGrouped];
        list.projectno = self.pbdata.no;
        list.title = @"专利情况";
        [self.navigationController pushViewController:list animated:YES];
        [list release];
    }else{
        [self pushviewBy:tableView indexPath:indexPath];
    }
    
}
-(void)pushviewBy:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    
    pbtextfield = [[PBtextField alloc]initWithStyle:UITableViewStyleGrouped];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *lable = [cell.contentView.subviews objectAtIndex:0];
    pbtextfield.equstr = lable.text;
    pbtextfield.tableview1 = tableView;
    pbtextfield.indepath = indexPath;
    pbtextfield.science = self;
    pbtextfield.detailStr = @"*以逗号分隔输入多个";
    pbtextfield.title = [titleArr objectAtIndex:indexPath.section];
    [pbtextfield.textfield becomeFirstResponder];
    [self.navigationController pushViewController:pbtextfield animated:YES];
    [pbtextfield release];
}



@end
