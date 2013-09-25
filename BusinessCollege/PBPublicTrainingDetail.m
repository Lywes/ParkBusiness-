//
//  PBPublicTrainingDetail.m
//  ParkBusiness
//
//  Created by QDS on 13-7-1.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define GONGYIPEIXUNXIANGQING_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/welfaretrainingdetail",HOST]]
#define GONGYIPEIXUNCANJIASHENGQING_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/wtapply",HOST]]
#define hasApply [[self.DataDic objectForKey:@"flag"] isEqual:@"1"]

#import "PBPublicTrainingDetail.h"
#import "NSObject+NVBackBtn.h"
#import "PBLecturerDetail.h"
#import "UIImageView+WebCache.h"
#import "NSObject+PBLableHeight.h"
#import "PBtextVC.h"
@interface PBPublicTrainingDetail ()
{
    UIButton *footBtn;
}
-(void)initdata;
-(void)successApply;
@end

@implementation PBPublicTrainingDetail

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"公益培训详情";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithTitle:@"申请参加" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemPress:)];
    self.navigationItem.rightBarButtonItem = bar;
    [bar release];
    
    PBActivityIndicatorView *activity = [[PBActivityIndicatorView alloc] initWithFrame:self.view.frame];
    self.activity = activity;
    [self.view addSubview:self.activity];
    [activity release];
    [self initdata];

    NSArray* s0 = [NSArray arrayWithObjects:@"名称", nil];
    NSArray* s1 = [NSArray arrayWithObjects:@"举办单位",@"承办单位",@"协办单位", nil];
    NSArray *s4 = [NSArray arrayWithObjects:@"培训时间",@"培训地点",@"已报名/定员", nil];
    NSArray* s2 = [NSArray arrayWithObjects:@"培训讲师", nil];
    NSArray* s3 = [NSArray arrayWithObjects:@"课程培训安排", nil];
    self.headArr = [[[NSMutableArray alloc]initWithObjects:s0,s1,s2,s3,s4, nil]autorelease];
    
    
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, isPad()?5:0, self.view.frame.size.width, 55)];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 255, 50);
    [btn setBackgroundImage:[UIImage imageNamed:@"custom_button.png"] forState:UIControlStateNormal];
    btn.center = view.center;
    footBtn = btn;
    [view addSubview:btn];
    [btn addTarget:self action:@selector(rightBarButtonItemPress:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"申请参加" forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = UITextAlignmentCenter;
    self.tableView.tableFooterView = view;
    [view release];
    if (hasApply) {
        [self successApply];
    }
}
#pragma mark – 申请参加按钮
-(void)rightBarButtonItemPress:(id)sender
{
    UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"信息" message:@"确定要申请参加培训吗？" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) otherButtonTitles:@"确定", nil];
    [view show];
    [view release];
  
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.activity startAnimating];
        NSDictionary *dic= [[NSDictionary alloc]initWithObjectsAndKeys:
                            [self.DataDic objectForKey:@"no"],@"welfaretrainingno",
                            [self.DataDic objectForKey:@"amount"],@"amount",
                            USERNO,@"userno", nil];
        [self.dataclass dataResponse:GONGYIPEIXUNCANJIASHENGQING_URL postDic:dic searchOrSave:NO];
        [dic release];
    }
}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    if ([intvalue intValue]>0) {
        [self showAlertViewWithMessage:@"成功申请"];
        [self successApply];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"_GONGYIPEIXUN_RELOAD" object:nil];
    }
    else
        [self showAlertViewWithMessage:@"申请失败，请重新提交申请"];
    [self.activity stopAnimating];
}
-(void)successApply{
    self.navigationItem.rightBarButtonItem = nil;
    [footBtn setEnabled: NO];
    [footBtn setTitle:@"已参加" forState:UIControlStateDisabled];
}
#pragma mark – 网络请求数据
-(void)initdata
{
    [self.activity startAnimating];
    PBdataClass *dataclass1 = [[PBdataClass alloc]init];
    dataclass1.delegate = self;
    self.dataclass = dataclass1;
    [dataclass1 release];
     NSDictionary *dic= [[NSDictionary alloc]initWithObjectsAndKeys:[self.DataDic objectForKey:@"no"],@"no", nil];
    [self.dataclass dataResponse:GONGYIPEIXUNXIANGQING_URL postDic:dic searchOrSave:YES];
    [dic release];
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    NSLog(@"公益培训详情:%@",datas);
    if (datas.count>0) {
        self.DataDic = [datas objectAtIndex:0];
        NSArray* s0 = [NSArray arrayWithObjects:[self.DataDic objectForKey:@"name"], nil];
        NSArray* s1 = [NSArray arrayWithObjects:
                       [self.DataDic objectForKey:@"maincompany"],
                       [self.DataDic objectForKey:@"company"],
                       [self.DataDic objectForKey:@"cocompany"],
                       nil];
        NSString *str1 = [self.DataDic objectForKey:@"applyamount"];
        if ([str1 isEqualToString:@""]) {
            str1 = @"0";
        }
        NSString *str2 = [self.DataDic objectForKey:@"amount"];
        if ([str2 isEqualToString:@""]) {
            str2 = @"0";
        }
        NSString *str3 = [str1 stringByAppendingFormat:@"/%@",str2];
        NSArray *s4 = [NSArray arrayWithObjects:
                       [self.DataDic objectForKey:@"plandate"],
                       [self.DataDic objectForKey:@"address"],
                       str3,
                       nil];
        
        NSArray* s2 = [NSArray arrayWithObjects:@"", nil];
        NSArray* s3 = [NSArray arrayWithObjects:@"", nil];
        self.DataArr = [NSMutableArray arrayWithObjects:s0,s1,s2,s3,s4, nil];
        [self.tableView reloadData];
        
    }
    [self.activity stopAnimating];
}

-(void)searchFilad
{
    [self showAlertViewWithMessage:@"获取数据失败"];
     [self.activity stopAnimating];
}
#pragma mark – tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    //点击颜色与右边箭头
  if (indexPath.section == 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    }
    else
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //页面数据
    if (indexPath.section != 2) {
        cell.textLabel.text = [[self.headArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    else
    {
        if ([[self.DataDic objectForKey:@"speakers"] count]>0) {
            UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, isPad()?400:200, 40)];
            UILabel *job = [[UILabel alloc]initWithFrame:CGRectMake(80, 44, isPad()?400:200, 40)];
            name.backgroundColor = [UIColor clearColor];
            job.backgroundColor = [UIColor clearColor];
            name.text = [[[self.DataDic objectForKey:@"speakers"] objectAtIndex:indexPath.row] objectForKey:@"name"];
            job.text = [[[self.DataDic objectForKey:@"speakers"] objectAtIndex:indexPath.row] objectForKey:@"job"];
            UIImageView * imageview = [[[UIImageView alloc]initWithFrame:CGRectMake(3, 15, 58, 58)]autorelease];
            NSString *imagepath = [[[self.DataDic objectForKey:@"speakers"] objectAtIndex:indexPath.row] objectForKey:@"imagepath"];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOST,imagepath]];
            [imageview setImageWithURL:url];
            imageview.layer.shadowRadius = 5.0f;
            imageview.layer.masksToBounds = YES;
            imageview.layer.cornerRadius = 5.0f;
            
            [cell.contentView addSubview:imageview];
            [cell.contentView addSubview:name];
            [cell.contentView addSubview:job];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.textLabel.text = nil;
        }
     
    }
    //中间lable
    if (indexPath.section != 2 && indexPath.section != 3) {
        UILabel *detailTextLabel;
        detailTextLabel = [[UILabel alloc]init];
        detailTextLabel.backgroundColor = [UIColor clearColor];
        detailTextLabel.numberOfLines = 0;
        if (self.DataArr.count>0) {
            NSString *str =  [[self.DataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            CGSize a = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(isPad() ? 480 : 100, 1000) lineBreakMode:NSLineBreakByWordWrapping];
            detailTextLabel.text = str;
            [detailTextLabel setFrame:CGRectMake(isPad()?250:120, 0, isPad()?350:180, MAX(a.height, 44))];
        }
        [cell.contentView addSubview:detailTextLabel];
        [detailTextLabel release];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
      if (indexPath.section != 2 && indexPath.section != 3) {
       NSString *str =  [[self.DataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
       CGSize a = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(isPad() ? 480 : 100, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        return    MAX(a.height, 44);
      }
    return 88.0f;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        NSString *str = [[self.headArr objectAtIndex:section] objectAtIndex:0];
        return str;
    }
    else
        return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 1;
    switch (section) {
        case 0:
            num = 1;
            break;
        case 1:
            num = 3;
            break;
        case 2:
        {
            if ([[self.DataDic objectForKey:@"speakers"] isKindOfClass:[NSArray class]]) {
                NSArray * sun = [self.DataDic objectForKey:@"speakers"];
                num = [sun count];
            }
            else
                num = 0;
        }
            break;
        case 3:
            num = 1;
            break;
        case 4:
            num = 3;
            break;
        default:
            break;
    }
    return num;
}

#pragma mark – 点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        PBLecturerDetail *teacher = [[PBLecturerDetail alloc]initWithStyle:UITableViewStyleGrouped];
        teacher.DataDic = [[self.DataDic objectForKey:@"speakers"] objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:teacher animated:YES];
        [teacher release];
    }
    if (indexPath.section == 3) {
        PBtextVC *teacher = [[PBtextVC alloc]init];
        teacher.text = [self.DataDic objectForKey:@"classplan"];
        teacher.title = @"课程培训安排";
        [self.navigationController pushViewController:teacher animated:YES];
        [teacher release];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
