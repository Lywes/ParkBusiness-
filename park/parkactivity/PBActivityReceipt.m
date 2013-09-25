//
//  PBActivityReceipt.m
//  ParkBusiness
//
//  Created by 上海 on 13-6-14.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBActivityReceipt.h"
#define URL [NSString stringWithFormat:@"%@admin/index/applymeeting",HOST]
@interface PBActivityReceipt ()
-(void)initPopView;
-(void)postOtherData;
@end

@implementation PBActivityReceipt
@synthesize userinfos;
@synthesize projectno;
@synthesize mode;
@synthesize type;
-(void)dealloc
{
    [acitivity release];
    [userinfos release];
    [titleArr release];
    [name release];
    [job release];
    [joblabel release];
    [tel release];
    [amount release];
    [super dealloc];
}
- (void)viewLoding
{
    self.title = @"报名参加活动";
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    acitivity = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    titleArr = [[NSMutableArray alloc]initWithObjects:@"参加人姓名:",@"职务:",@"联系方式:",@"参加人数:",nil];
    
    [self initPopView];
    //本地取数据
    job = [[NSMutableArray alloc]init];
    NSMutableArray *arry1 = [PBIndustryData search:@"job"];
    for (PBIndustryData * industryData in arry1 ) {
        if (industryData.name != NULL) {
            [job addObject:industryData.name];
        }
    }
    [self backButton];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [name resignFirstResponder];
    [amount resignFirstResponder];
    [tel resignFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated{
    [acitivity removeFromSuperview];
    [self viewTapped:nil];
    [self initInputView];
}
-(void)initPopView
{
    //弹出选择画面
    pop =[[POPView alloc]init];
    pop.delegate = self;
    pop.view.hidden = YES;
    [self.view addSubview:pop.view];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    isedit = NO;
    [self.view addSubview:acitivity];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initInputView];
    [self.tableView reloadData];
}

-(void)initInputView{
    for (int i = 0; i<[titleArr count]; i++){
        CGSize textSize = [[titleArr objectAtIndex:i] sizeWithFont:[UIFont boldSystemFontOfSize:16]];
        CGRect frame = CGRectMake(textSize.width+20, 5, self.tableView.frame.size.width-textSize.width-(isPad()?120:50), 35);
        if (i == 0) {
            name = [[UITextField alloc]initWithFrame:frame];
        }
        if (i == 1) {
            joblabel = [[UILabel alloc]initWithFrame:frame];
            joblabel.backgroundColor = [UIColor clearColor];
            }
        if (i == 2) {
             tel = [[UITextField alloc]initWithFrame:frame];
            tel.keyboardType = UIKeyboardTypeNumberPad;
        }
        if (i == 3) {
            amount = [[UITextField alloc]initWithFrame:frame];
            amount.keyboardType = UIKeyboardTypeNumberPad;
        }
    }
    
}

#pragma mark -编辑状态
-(void)editState
{
    [self.tableView reloadData];
}
#pragma mark - 从服务器服务器取数据
/*
 获取失败
 */
-(void)searchFilad
{
    [acitivity stopAnimating];
}


#pragma mark - 数据上传到服务器
-(void)postDataOnserver
{
    if ([name.text length]>0&&[joblabel.text length]>0&&[tel.text length]>0&&[amount.text length]>0) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认提交回执信息？" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) otherButtonTitles:@"确认", nil];
        [alert show];
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请完整填写回执信息" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [acitivity startAnimating];
        [self postOtherData];
    }
    
}

-(void)postOtherData
{
    PBdataClass *pb = [[PBdataClass alloc]init];
    pb.delegate = self;
    NSArray *a1 = [[NSArray alloc]initWithObjects:@"userno",@"meetingno",@"companyno",@"name",@"tel",@"job",@"amount",nil];
    NSArray *a2 = [[NSArray alloc]initWithObjects:
                   [NSString stringWithFormat:@"%d", [PBUserModel getUserId]],
                   [self.datadic objectForKey:@"no"],
                   [NSString stringWithFormat:@"%d",[PBUserModel getCompanyno]],
                   name.text?name.text:@"",
                   tel.text?tel.text:@"",
                   [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:joblabel.text?joblabel.text:@"" withKind:@"job"]],
                   amount.text?amount.text:@"",
                   nil];
    [pb dataResponse:[NSURL URLWithString:URL] postDic:[[NSDictionary alloc]initWithObjects:a2 forKeys:a1] searchOrSave:NO];
}

-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue{
    [self.navigationController popViewControllerAnimated:YES];
    self.parentViewController.navigationItem.rightBarButtonItem.title = @"已参加";
    self.parentViewController.navigationItem.rightBarButtonItem.enabled = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"已成功接受您的报名！" delegate:self.parentViewController cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

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


#pragma mark - cell内容设置
-(void)addSubViewForCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = [titleArr objectAtIndex:indexPath.section];
    if (indexPath.section == 0) {
        [[cell contentView] addSubview:name];
    }
    if (indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [[cell contentView] addSubview:joblabel];
    }
    if (indexPath.section == 2) {
        [[cell contentView] addSubview:tel];
        
    }
    if (indexPath.section == 3) {
        [[cell contentView] addSubview:amount];
    }
    
    for (UITextField* textField in [[cell contentView] subviews]) {
        if ([textField isKindOfClass:[UITextField class]]) {
            [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [textField setEnabled:!isedit];
            if (isedit) {
                [textField setBorderStyle:UITextBorderStyleNone];
            }else{
                [textField setBorderStyle:UITextBorderStyleRoundedRect];
            }
        }
    }
}


#pragma mark - IPAD 调试
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        [pop.view removeFromSuperview];
        pop._arry = job;
        pop.name = @"职位";
        pop.view.hidden = !pop.view.hidden;
        [pop popClickAction];
    }
}
#pragma mark -POPview delegate
- (void)popView:(POPView *)popview didSelectIndexPath:(NSIndexPath *)indexPath{
    if ([pop._arry isEqualToArray:job]) {
        joblabel.text = [popview._arry objectAtIndex:indexPath.row];
    }
}
@end
