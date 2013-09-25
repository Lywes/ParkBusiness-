//
//  PBActivityReview.m
//  ParkBusiness
//
//  Created by 上海 on 13-6-13.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBActivityReview.h"
#define SEARCHACTIVITYXIANGXI [NSURL URLWithString:[NSString stringWithFormat:@"%@admin/index/activitydetail",HOST]]
@interface PBActivityReview ()

@end

@implementation PBActivityReview
@synthesize no;
-(void)dealloc
{
    [self.dataclass release];
    [self.DataArr release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"活动回顾";
        [self backUpView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initPresentView];
    [self initPresentData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.dataclass.delegate = self;
    [self.dataclass dataResponse:SEARCHACTIVITYXIANGXI postDic:[NSDictionary dictionaryWithObjectsAndKeys:self.no,@"no",nil] searchOrSave:YES];
}
-(void)initPresentView
{
    //加载动画
    self.activity = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.activity];
}
-(void)initPresentData
{
    NSMutableArray *a1 = [NSMutableArray arrayWithObjects:@"举办单位",@"协办单位", nil];
    NSMutableArray *a2 = [NSMutableArray arrayWithObjects:@"活动地点",@"举办时间",@"参加企业数", nil];
    NSMutableArray *a4 = [NSMutableArray arrayWithObjects:@"活动现场图片", nil];
    self.headArr = [[[NSMutableArray alloc]initWithObjects:a1,@"主要嘉宾",a2,a4, nil]autorelease];
    self.DataArr = [NSMutableArray arrayWithCapacity:100];
    self.dataclass = [[PBdataClass alloc]init];
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    NSDictionary *dic = [datas objectAtIndex:0];
    NSArray *a2 = [NSArray arrayWithObjects:[dic objectForKey:@"maincompany"],[dic objectForKey:@"cocompany"],nil];
    NSArray *a3 = [NSArray array];
    if (![[dic objectForKey:@"attendees"] isEqualToString:@""]) {
        a3 = [NSArray arrayWithArray:[dic objectForKey:@"attendees"]];
    }
    NSArray *a5 = [NSArray arrayWithObjects:[dic objectForKey:@"address"],[dic objectForKey:@"stdate"],[self.DataDic objectForKey:@"amount"],nil];
    self.DataArr = [NSMutableArray arrayWithObjects:a2,a3,a5, nil];
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            return 2;
        case 1:
        {
            if (self.DataArr.count>0) {
                NSInteger a = [[self.DataArr objectAtIndex:section] count];
                if (a>0) {
                    return a;
                }
                else {
                    return 1;
                }
            }
        }
        case 2:
            return 3;
        case 3:
            return 1;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier]autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:ContentFontSize];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:ContentFontSize];
    if (indexPath.section != 1) {
        id Aclass = [self.headArr objectAtIndex:indexPath.section];
        if ([Aclass isKindOfClass:[NSMutableArray class]]) {
            cell.textLabel.text = [Aclass objectAtIndex:indexPath.row];
        }
        else {
            cell.textLabel.text = Aclass;
        }
    }
    
    if (indexPath.section ==0 || indexPath.section == 2) {
        UILabel *lable = [self addshortLable];
        [cell.contentView addSubview:lable];
        if ([self.DataArr count]>0) {
            lable.text = [[self.DataArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        }
    }
    if (indexPath.section == 1) {
        if (self.DataArr.count>0) {
            NSArray *arr = [self.DataArr objectAtIndex:indexPath.section];
            if (arr.count>0) {
                id dic = [arr objectAtIndex:indexPath.row];
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    cell.textLabel.text = [dic objectForKey:@"job"];
                    cell.detailTextLabel.text = [dic objectForKey:@"name"];
                }
            }
            else {
                cell.hidden = YES;
            }
            
        }
        else {
            cell.hidden = YES;
        }
    }
    if ([self.stylename isEqualToString:@"huigu"]) {
        if (indexPath.section == 3) {
            cell.textLabel.text = [[self.headArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text  = @"点击下载";
        }
    }
    return cell;
}
/*
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (indexPath.section == 0) {
 return 120.0f;
 }
 else {
 return 44;
 }
 }
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        if (![self.DataArr count]>0) {
            return nil;
        }
        else {
            if ([[self.DataArr objectAtIndex:section] count]>0) {
                NSString *str = @"重要嘉宾";
                return str;
            }
            
        }
        
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
