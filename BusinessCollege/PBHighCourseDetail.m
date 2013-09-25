//
//  PBHighCourseDetail.m
//  ParkBusiness
//
//  Created by China on 13-7-2.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define GAODUANKECHENXIANGQING_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/seniorclassdetail",HOST]]
#define TUANGOUBAOMING_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/seniorclassapply",HOST]]
#define hasApply [[self.DataDic objectForKey:@"flag"] isEqual:@"1"]
#import "PBHighCourseDetail.h"
#import "NSObject+NVBackBtn.h"
#import "PBInstitutionInfo.h"
#import "PBtextVC.h"
@interface PBHighCourseDetail ()
{
    UIButton *canjia_btn;
}
-(void)initdata;
-(void)successApply;
@end

@implementation PBHighCourseDetail

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"高端课程详细";
    }
    return self;
}
#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//	[self customButtomItem:self];
//    [self navigatorRightButtonNme:@"团购报名" backimageName:nil];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithTitle:@"团购报名" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemPress:)];
    self.navigationItem.rightBarButtonItem = bar;
    [bar release];
    PBActivityIndicatorView *ac = [[PBActivityIndicatorView alloc] initWithFrame:self.view.frame];
    self.activity = ac;
    [ac release];
    [self.view addSubview:self.activity];
    
    [self initdata];
    NSArray *ar = [[NSArray alloc]initWithObjects:@"标准收费(元)",@"团购价格(元)",@"最低团购人数",@"已团购人数", nil];
    self.headArr = [[[NSMutableArray alloc]initWithObjects:@"名称",@"课程提供机构",@"课程简介",@"课程安排",ar,@"团购须知", nil]autorelease];
    [ar release];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, isPad()?5:0, self.view.frame.size.width, 55)];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 255, 50);
    [btn setBackgroundImage:[UIImage imageNamed:@"custom_button.png"] forState:UIControlStateNormal];
    [view addSubview:btn];
    btn.center = view.center;
    canjia_btn = btn;
    [btn addTarget:self action:@selector(rightBarButtonItemPress:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"团购报名" forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = UITextAlignmentCenter;
    self.tableView.tableFooterView = view;
    [view release];

    
    if (hasApply) {
        [self successApply];
    }
}
#pragma mark - 网络请求数据
-(void)initdata
{
    [self.activity startAnimating];
    PBdataClass *dataclass = [[PBdataClass alloc]init];
    dataclass.delegate = self;
    self.dataclass = dataclass;
    [dataclass release];
    NSDictionary *dic= [[NSDictionary alloc]initWithObjectsAndKeys:[self.DataDic objectForKey:@"no"],@"no", nil];
    [self.dataclass dataResponse:GAODUANKECHENXIANGQING_URL postDic:dic searchOrSave:YES];
    [dic release];
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    NSLog(@"高端课程详情:%@",datas);
    if (datas.count>0) {
        self.DataDic = [datas objectAtIndex:0];
        NSArray* s0 = [NSArray arrayWithObjects:[self.DataDic objectForKey:@"name"], nil];
        NSArray* s1 = [NSArray arrayWithObjects:[self.DataDic objectForKey:@"jgname"],
                       nil];
        NSArray *s4 = [NSArray arrayWithObjects:
                       [self.DataDic objectForKey:@"standardpay"],
                       [self.DataDic objectForKey:@"grouppay"],
                       [self.DataDic objectForKey:@"groupamount"],
                       [self.DataDic objectForKey:@"groupnum"],
                       nil];
        NSArray* s2 = [NSArray arrayWithObjects:@"", nil];
        NSArray* s3 = [NSArray arrayWithObjects:@"", nil];
         NSArray* s5 = [NSArray arrayWithObjects:@"", nil];
        self.DataArr = [[[NSMutableArray alloc ]initWithObjects:s0,s1,s2,s3,s4,s5, nil]autorelease];
        [self.tableView reloadData];
        
    }
    [self.activity stopAnimating];
}
-(void)searchFilad
{
    [self showAlertViewWithMessage:@"网络状况不好"];
     [self.activity stopAnimating];
}
-(void)successApply
{
    self.navigationItem.rightBarButtonItem = nil;
    [canjia_btn setEnabled:NO];
    [canjia_btn setTitle:@"已报名" forState:UIControlStateDisabled];
}
#pragma mark - 团购报名按钮
-(void)rightBarButtonItemPress:(id)sender
{
    UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"信息" message:@"请确认你已经阅读过团购须知,报名成功后我们的业务经理会尽快与你联系" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) otherButtonTitles:@"确定", nil];
    [view show];
    [view release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSDictionary *dic= [[[NSDictionary alloc]initWithObjectsAndKeys:
                            [self.DataDic objectForKey:@"no"],@"seniorclassno",
                            [self.DataDic objectForKey:@"groupamount"],@"amount",
                            @"1",@"flag",
                            USERNO,@"userno", nil]autorelease];
        [self.dataclass dataResponse:TUANGOUBAOMING_URL postDic:dic searchOrSave:NO];
    }
}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    if ([intvalue intValue]>0) {
        [self showAlertViewWithMessage:@"成功申请"];
        [self successApply];
    }
    else
        [self showAlertViewWithMessage:@"申请失败，请重新提交申请"];
}
#pragma mark - didSelectRowAtIndexPath
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PBtextVC *textVC = [[[PBtextVC alloc]init]autorelease];
    switch (indexPath.section) {
        case 1:
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            PBInstitutionInfo *detail = [[PBInstitutionInfo alloc]initWithStyle:UITableViewStyleGrouped];
            detail.DataDic = self.DataDic;
            [self.navigationController pushViewController:detail animated:YES];
            [detail release];
        }
            break;
        case 2:
            textVC.title = @"课程简介";
            textVC.text = [self.DataDic objectForKey:@"introduce"];
            [self.navigationController pushViewController:textVC animated:YES];
            break;
        case 3:
            textVC.title = @"课程安排";
            textVC.text  =[self.DataDic objectForKey:@"classplan"];
            [self.navigationController pushViewController:textVC animated:YES];
            break;
        case 5:
            textVC.title = @"团购须知";
            textVC.text  =[self.DataDic objectForKey:@"groupbuymsg"];
            [self.navigationController pushViewController:textVC animated:YES];
            break;
        default:
            break;
    }
}
#pragma mark - cell绘制方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell  = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier]autorelease];
    if (indexPath.section != 4 && indexPath.section != 0) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    id text = [self.headArr objectAtIndex:indexPath.section];
    if ([text isKindOfClass:[NSArray class]]) {
        cell.textLabel.text = [[self.headArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    else
    {
        cell.textLabel.text = [self.headArr objectAtIndex:indexPath.section];
    }
    
    if (indexPath.section == 0|| indexPath.section == 1 || indexPath.section == 4) {
        UILabel *detailTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(250, 0, 250, 24)];
        detailTextLabel.backgroundColor = [UIColor clearColor];
        detailTextLabel.tag = 131;
        detailTextLabel.numberOfLines = 0;
        [cell.contentView addSubview:detailTextLabel];
        [detailTextLabel release];
    }
    
    
    //数据

    if (self.DataArr.count>0) {
        UILabel *detailTextLabel = (UILabel *)[cell.contentView viewWithTag:131];
        detailTextLabel.text = [[self.DataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        CGSize a = [detailTextLabel.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(isPad()?480:150, 1000) lineBreakMode:NSLineBreakByCharWrapping];
        [detailTextLabel setFrame:CGRectMake(isPad()?250:120,0 , isPad()?250:180, MAX(a.height, 44.0f))];
    }
   
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [[self.DataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
   CGSize a = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(isPad()?480:150, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    return MAX(a.height, 44.0f);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 0;
    switch (section) {
        case 0:
            num = 1;
            break;
        case 1:
            num = 1;
            break;
        case 2:
            num = 1;
            break;
        case 3:
            num = 1;
            break;
        case 4:
            num = 4;
            break;
        case 5:
            num = 1;
            break;
        default:
            break;
    }
    return num;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
