//
//  PBAddFinanceLease.m
//  ParkBusiness
//
//  Created by 上海 on 13-5-29.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBAddFinanceLease.h"
#import "PBFinanceDataList.h"
#import "PBAssureCompanyInfo.h"
#define URL [NSString stringWithFormat:@"%@/admin/index/searchfinancinglease",HOST]
#define SAVEURL [NSString stringWithFormat:@"%@/admin/index/addfinancinglease",HOST]
@interface PBAddFinanceLease ()
-(void)initPopView;
-(void)postOtherData;
-(void)SearchOnServer;
-(PBFinanceLeaseData *)dataZhuanhuan:(NSMutableDictionary *)dic;
@end

@implementation PBAddFinanceLease
@synthesize userinfos;
@synthesize pbdata;
@synthesize projectno;
@synthesize mode;
@synthesize type;
-(void)dealloc
{
    [acitivity release];
    [userinfos release];
    [titleArr release];
    [typelabel release];
    [leasedeviceinfo release];
    [projectamount release];
    [leasetype release];
    [super dealloc];
}
- (void)viewLoding
{
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    acitivity = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    titleArr = [[NSMutableArray alloc]initWithObjects:@"项目类型:",@"项目金额(万元):",@"租赁设备情况:",@"公司概况:",@"近三年财务数据:",nil];
    
    [self initPopView];
    //本地取数据
    leasetype = [[NSMutableArray alloc]init];
    NSMutableArray *arry1 = [PBIndustryData search:@"leasetype"];
    for (PBIndustryData * industryData in arry1 ) {
        if (industryData.name != NULL) {
            [leasetype addObject:industryData.name];
        }
    }
    [self backButton];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [projectamount resignFirstResponder];
    [leasedeviceinfo resignFirstResponder];
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
    willAppear = NO;
    [self.view addSubview:acitivity];
    
}
#pragma mark SuccessSendMessageMethod
- (void) successSendData
{
    if ([self.collectData.warnSting isEqualToString:@"succeed"]) {
        //从后台获取数据，是否收藏该项目，若已经收藏则为“已收藏”，button不可用。否则收藏按钮可用
        self.navigationItem.rightBarButtonItem.title = @"已收藏";
    }
}

//收藏
- (void) collectProject
{
    self.collectData = [[PBSendData alloc] init];
    self.collectData.delegate = self;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[self.datadic objectForKey:@"no"], @"projectno", [NSString stringWithFormat:@"%d", [PBUserModel getUserId]], @"personno", [self.datadic objectForKey:@"type"],@"type",nil];
    [self.collectData sendDataWithURL:FAVOURITES andValueAndKeyDic:dic];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        PBUserModel* user = [PBUserModel getPasswordAndKind];
        if (user.kind!=2&&[self.datadic objectForKey:@"flag"]) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_sc", nil) style:UIBarButtonItemStylePlain target:self action:@selector(collectProject)];
            if ([[self.datadic objectForKey:@"flag"] isEqualToString:@"1"]) {
                //从后台获取数据，是否收藏该项目，若已经收藏则为“已收藏”，button不可用。否则收藏按钮可用
                self.navigationItem.rightBarButtonItem.title = @"已收藏";
                self.navigationItem.rightBarButtonItem.enabled = NO;
            }
        }
        self.pbdata = [[PBFinanceLeaseData alloc]init];
        [self SearchOnServer];
    }else{//本地取数据
        if (!willAppear) {
            self.pbdata = [PBFinanceLeaseData searchData:self.projectno];
            willAppear = !willAppear;
        }
    }
    [self initInputView];
    [self.tableView reloadData];
}

-(void)initInputView{
    for (int i = 0; i<[titleArr count]; i++){
        CGSize textSize = [[titleArr objectAtIndex:i] sizeWithFont:[UIFont boldSystemFontOfSize:16]];
        CGRect frame = CGRectMake(textSize.width+20, 5, self.tableView.frame.size.width-textSize.width-(isPad()?120:50), 35);
        if (i == 0) {
            typelabel = [[UILabel alloc]initWithFrame:frame];
            typelabel.backgroundColor = [UIColor clearColor];
            typelabel.text = [PBKbnMasterModel getKbnNameById:self.pbdata.type withKind:@"leasetype"];
        }
        if (i == 1) {
            projectamount = [[UITextField alloc]initWithFrame:frame];
            projectamount.text = [NSString stringWithFormat:@"%d",self.pbdata.projectamount];
        }
        if (i == 2) {
            leasedeviceinfo = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-(isPad()?90:20), 120)];
            leasedeviceinfo.tag = 3;
            leasedeviceinfo.backgroundColor = [UIColor clearColor];
            leasedeviceinfo.textAlignment = UITextAlignmentLeft;
            leasedeviceinfo.delegate = self;
            leasedeviceinfo.text = self.pbdata.leasedeviceinfo;
        }
    }
    
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
    [pb dataResponse:[NSURL URLWithString:URL] postDic:[NSDictionary dictionaryWithObjectsAndKeys:[self.datadic objectForKey:@"no"],@"no", nil]searchOrSave:YES];
    
}
/*
 获取失败
 */
-(void)searchFilad
{
    if (self.projectno>0) {
        [self editButtonPress:self.navigationItem.rightBarButtonItem];
    }
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
    [self initInputView];
    [acitivity stopAnimating];
}
/*
 上传失败
 */
-(void)requestFilad
{
    [acitivity stopAnimating];
}
-(PBFinanceLeaseData *)dataZhuanhuan:(NSMutableDictionary *)dic
{
    self.pbdata.no = [[dic objectForKey:@"no"] intValue];
    self.pbdata.type = [[dic objectForKey:@"type"] intValue];
    self.pbdata.projectamount = [[dic objectForKey:@"projectamount"] intValue];
    self.pbdata.receiptfund = [[dic objectForKey:@"receiptfund"] intValue];
    self.pbdata.leasedeviceinfo = [dic objectForKey:@"leasedeviceinfo"];
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
    [self changePostDataFromView];
    PBdataClass *pb = [[PBdataClass alloc]init];
    pb.delegate = self;
    NSString *modes = self.pbdata.no>0?@"mod":@"add";
    NSArray *a1 = [[NSArray alloc]initWithObjects:@"mode", @"no",@"productno",@"userno",@"companyno",@"type",@"projectamount",@"leasedeviceinfo",nil];
    NSArray *a2 = [[NSArray alloc]initWithObjects:modes,
                   [NSString stringWithFormat:@"%d",self.pbdata.no],
                   [NSString stringWithFormat:@"%d",self.productno],
                   [NSString stringWithFormat:@"%d", [PBUserModel getUserId]],
                   [NSString stringWithFormat:@"%d",[PBUserModel getCompanyno]],
                   [NSString stringWithFormat:@"%d",self.pbdata.type],
                   projectamount.text?projectamount.text:@"",
                   self.pbdata.leasedeviceinfo,
                   nil];
    [pb dataResponse:[NSURL URLWithString:SAVEURL] postDic:[[NSDictionary alloc]initWithObjects:a2 forKeys:a1] searchOrSave:NO];
    
}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    
    //上传到本地
    self.pbdata.no = [intvalue intValue];
    [self.pbdata saveRecord];
    [acitivity stopAnimating];
    if ([self.mode isEqualToString:@"add"]) {
        PBFinanceDataList* list = [[PBFinanceDataList alloc]initWithStyle:UITableViewStyleGrouped];
        list.count = 3;
        list.mode = @"add";
        list.projectno = [intvalue intValue];
        list.productno = self.productno;
        list.title = @"近三年财务信息";
        [self.navigationController pushViewController:list animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)changePostDataFromView{
    self.pbdata.projectamount = [projectamount.text intValue];
    self.pbdata.leasedeviceinfo = leasedeviceinfo.text?leasedeviceinfo.text:@"";
    
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
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]&&(section==3||section==4)) {
        return 0;
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]&&section == 2) {
        return [titleArr objectAtIndex:section];
    }else {
        return nil;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]&&section==2) {
        labletag = section;
        return [self TishiView];
    }else{
        return nil;
    }
}


#pragma mark - cell内容设置
-(void)addSubViewForCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section!=2) {
        cell.textLabel.text = [titleArr objectAtIndex:indexPath.section];
    }
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [[cell contentView] addSubview:typelabel];
    }
    if (indexPath.section == 1) {
        
        [[cell contentView] addSubview:projectamount];
        
    }
    if (indexPath.section == 2) {
        [[cell contentView] addSubview:leasedeviceinfo];
        leasedeviceinfo.editable = !isedit;
        
    }
    if (indexPath.section > 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    for (UITextField* textField in [[cell contentView] subviews]) {
        if ([textField isKindOfClass:[UITextField class]]) {
            [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [textField setEnabled:!isedit];
            if (isedit) {
                [textField setBorderStyle:UITextBorderStyleNone];
            }else{
                [textField setBorderStyle:UITextBorderStyleRoundedRect];
                textField.keyboardType = UIKeyboardTypeNumberPad;
                
            }
        }
    }
    
    
}


#pragma mark - IPAD 调试
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        return   [self textViewHeightWithView:leasedeviceinfo defaultHeight:44.0f];
    }
    return 44.0f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        if (indexPath.section == 3) {
            PBAssureCompanyInfo* company = [[PBAssureCompanyInfo alloc]initWithStyle:UITableViewStyleGrouped];
            company.ProjectStyle = ELSEPROJECTINFO;
            company.datadic = self.datadic;
            company.title = [titleArr objectAtIndex:3];
            company.type = 5;
            [self.navigationController pushViewController:company animated:YES];
        }
        if (indexPath.section == 4) {
            PBFinanceDataList *financeData = [[PBFinanceDataList alloc]initWithStyle:UITableViewStyleGrouped];
            financeData.ProjectStyle = ELSEPROJECTINFO;
            financeData.userinfo = self.datadic;
            financeData.count = 3;
            financeData.title = [titleArr objectAtIndex:4];
            [self.navigationController pushViewController:financeData animated:YES];
            [financeData release];
        }
    }else{
        if (indexPath.section == 0) {
            [pop.view removeFromSuperview];
            pop._arry = leasetype;
            pop.name = @"项目类型";
            pop.view.hidden = !pop.view.hidden;
            [pop popClickAction];
        }
    }
}
#pragma mark -POPview delegate
- (void)popView:(POPView *)popview didSelectIndexPath:(NSIndexPath *)indexPath{
    if ([pop._arry isEqualToArray:leasetype]) {
        typelabel.text = [popview._arry objectAtIndex:indexPath.row];
        self.pbdata.type = indexPath.row+1;
    }
}

@end
