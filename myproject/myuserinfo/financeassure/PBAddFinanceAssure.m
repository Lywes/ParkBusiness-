//
//  PBAddFinanceAssure.m
//  ParkBusiness
//
//  Created by 上海 on 13-5-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBAddFinanceAssure.h"
#import "PBBankChooseView.h"
#import "PBAssureCompanyInfo.h"
#define URL [NSString stringWithFormat:@"%@/admin/index/searchfinancingassure",HOST]
#define SAVEURL [NSString stringWithFormat:@"%@/admin/index/addfinancingassure",HOST]
@interface PBAddFinanceAssure ()
-(void)initPopView;
-(void)postOtherData;
-(void)SearchOnServer;
-(PBFinanceAssureData *)dataZhuanhuan:(NSMutableDictionary *)dic;
@end

@implementation PBAddFinanceAssure
@synthesize userinfos;
@synthesize pbdata;
@synthesize projectno;
@synthesize mode;
@synthesize type;
-(void)dealloc
{
    [loanapply release];
    [enterprise release];
    [creditamount release];
    [creditlimit release];
    [assurerate release];
    [loanbankname release];
    [acitivity release];
    [applyproperty release];
    [applycredituse release];
    [userinfos release];
    [repaytypelabel release];
    [titleArr release];
    [property release];
    [repaytype release];
    [credituse release];
    [super dealloc];
}
- (void)viewLoding
{
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    acitivity = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    titleArr = [[NSMutableArray alloc]initWithObjects:NSLocalizedString(@"_tb_gsgk", nil),@"借款申请主体:",@"申请人性质:",@"用款企业:",@"授信金额(万元):", @"授信期限(月):",@"还款方式:",@"借款银行名称:",@"申请授信用途:",@"担保费率(%):",nil];
    
    [self initPopView];
    //本地取数据
    property = [[NSMutableArray alloc]init];
    NSMutableArray *arry1 = [PBIndustryData search:@"property"];
    for (PBIndustryData * industryData in arry1 ) {
        if (industryData.name != NULL) {
            [property addObject:industryData.name];
        }
    }
    repaytype = [[NSMutableArray alloc]init];
    NSMutableArray *arry2 = [PBIndustryData search:@"repaytype"];
    for (PBIndustryData * industryData in arry2 ) {
        if (industryData.name != NULL) {
            [repaytype addObject:industryData.name];
        }
    }
    credituse = [[NSMutableArray alloc]init];
    NSMutableArray *arry3 = [PBIndustryData search:@"credituse"];
    for (PBIndustryData * industryData in arry3 ) {
        if (industryData.name != NULL) {
            [credituse addObject:industryData.name];
        }
    }
    [self backButton];
}

-(void)backUpView
{
    if (self.productno>0) {
        [self dismissModalViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [loanapply resignFirstResponder];
    [enterprise resignFirstResponder];
    [creditamount resignFirstResponder];
    [creditlimit resignFirstResponder];
    [assurerate resignFirstResponder];
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
    [self.navigationController.view addSubview:acitivity];
    
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
    PBSendData *send = [[PBSendData alloc] init];
    self.collectData = send;
    self.collectData = send;
    [send release];
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
        self.pbdata = [[PBFinanceAssureData alloc]init];
        [self SearchOnServer];
    }else{//本地取数据
        if (!willAppear) {
            self.pbdata = [PBFinanceAssureData searchData:self.projectno];
            willAppear = !willAppear;
        }
    }
    [self initInputView];
    [self.tableView reloadData];
}

-(void)initInputView{
    for (int i = 0; i<[titleArr count]-1; i++){
        CGSize textSize = [[titleArr objectAtIndex:i+1] sizeWithFont:[UIFont boldSystemFontOfSize:16]];
        CGRect frame = CGRectMake(textSize.width+20, 5, self.tableView.frame.size.width-textSize.width-(isPad()?120:50), 35);
        if (i == 0) {
            loanapply = [[UITextField alloc]initWithFrame:frame];
            loanapply.text = self.pbdata.loanapply;
        }
        if (i == 1) {
            applyproperty = [[UILabel alloc]initWithFrame:frame];
            applyproperty.backgroundColor = [UIColor clearColor];
            applyproperty.text = [PBKbnMasterModel getKbnNameById:self.pbdata.applyproperty withKind:@"property"];
        }
        if (i == 2) {
            enterprise = [[UITextField alloc]initWithFrame:frame];
            enterprise.text = self.pbdata.enterprise;
            
        }
        if (i == 3) {
            creditamount = [[UITextField alloc]initWithFrame:frame];
            creditamount.keyboardType = UIKeyboardTypeNumberPad;
            creditamount.text = [NSString stringWithFormat:@"%d",self.pbdata.creditamount];
        }
        if (i == 4) {
            creditlimit = [[UITextField alloc]initWithFrame:frame];
            creditlimit.keyboardType = UIKeyboardTypeNumberPad;
            creditlimit.text = [NSString stringWithFormat:@"%d",self.pbdata.creditlimit];
        }
        if (i == 5) {
            repaytypelabel = [[UILabel alloc]initWithFrame:frame];
            repaytypelabel.backgroundColor = [UIColor clearColor];
            repaytypelabel.text = [PBKbnMasterModel getKbnNameById:self.pbdata.repaytype withKind:@"repaytype"];
        }
        if (i == 6) {
            loanbankname = [[UILabel alloc]initWithFrame:frame];
            loanbankname.backgroundColor = [UIColor clearColor];
            loanbankname.text = self.pbdata.loanbankname;
        }
        if (i == 7) {
            applycredituse = [[UILabel alloc]initWithFrame:frame];
            applycredituse.backgroundColor = [UIColor clearColor];
            applycredituse.text = [PBKbnMasterModel getKbnNameById:self.pbdata.applycredituse withKind:@"credituse"];
        }
        if (i == 8) {
            assurerate = [[UITextField alloc]initWithFrame:frame];
            assurerate.keyboardType = UIKeyboardTypeNumberPad;
            assurerate.text = [NSString stringWithFormat:@"%d",self.pbdata.assurerate];
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
-(PBFinanceAssureData *)dataZhuanhuan:(NSMutableDictionary *)dic
{
    self.pbdata.loanapply = [dic objectForKey:@"loanapply"];
    self.pbdata.applyproperty = [[dic objectForKey:@"applyproperty"] intValue];
    self.pbdata.enterprise = [dic objectForKey:@"enterprise"];
    self.pbdata.creditamount = [[dic objectForKey:@"creditamount"] intValue];
    self.pbdata.creditlimit = [[dic objectForKey:@"creditlimit"] intValue];
    self.pbdata.repaytype = [[dic objectForKey:@"repaytype"] intValue];
    self.pbdata.loanbankname = [dic objectForKey:@"loanbankname"];
    self.pbdata.assurerate = [[dic objectForKey:@"assurerate"] intValue];
    self.pbdata.applycredituse = [[dic objectForKey:@"applycredituse"] intValue];
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
    NSArray *a1 = [[NSArray alloc]initWithObjects:@"mode", @"no",@"productno",@"userno",@"companyno",@"loanapply",@"applyproperty",@"enterprise",@"creditamount",@"creditlimit",@"repaytype",@"loanbankname",@"applycredituse",@"assurerate",nil];
    NSArray *a2 = [[NSArray alloc]initWithObjects:modes,
                   [NSString stringWithFormat:@"%d",self.pbdata.no],
                   [NSString stringWithFormat:@"%d",self.productno],
                   [NSString stringWithFormat:@"%d", [PBUserModel getUserId]],
                   [NSString stringWithFormat:@"%d",[PBUserModel getCompanyno]],
                   self.pbdata.loanapply?self.pbdata.loanapply:@"",
                   [NSString stringWithFormat:@"%d",self.pbdata.applyproperty],
                   self.pbdata.enterprise?self.pbdata.enterprise:@"",
                   creditamount.text?creditamount.text:@"",
                   creditlimit.text?creditlimit.text:@"",
                   [NSString stringWithFormat:@"%d",self.pbdata.repaytype],
                   self.pbdata.loanbankname?self.pbdata.loanbankname:@"",
                   [NSString stringWithFormat:@"%d",self.pbdata.applycredituse],
                   [NSString stringWithFormat:@"%d",self.pbdata.assurerate],
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
        [self nextDidPush];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void)nextDidPush{
    PBAssureCompanyInfo* company = [[PBAssureCompanyInfo alloc]init];
    company.type = self.type;
    company.projectno = self.pbdata.no;
    company.productno = self.productno;
    company.title = @"企业基本信息";
    company.mode = @"add";
    [company navigatorRightButtonType:WANCHEN];
    [self .navigationController pushViewController:company animated:YES];
}
-(void)changePostDataFromView{
    self.pbdata.loanapply = loanapply.text;
    self.pbdata.enterprise = enterprise.text;
    self.pbdata.creditamount= [creditamount.text intValue];
    self.pbdata.creditlimit =  [creditlimit.text intValue];
    self.pbdata.assurerate = [assurerate.text intValue];

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
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]&&section==0) {
        return  0;
    }
    return 1;
}


#pragma mark - cell内容设置
-(void)addSubViewForCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    
    cell.textLabel.text = [titleArr objectAtIndex:indexPath.section];
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 1) {
        
        [[cell contentView] addSubview:loanapply];
    }
    if (indexPath.section == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [[cell contentView] addSubview:applyproperty];
        
    }
    if (indexPath.section == 3) {
        [[cell contentView] addSubview:enterprise];
        
    }
    if (indexPath.section == 4) {
        [[cell contentView] addSubview:creditamount];
    }
    if (indexPath.section == 5) {
        [[cell contentView] addSubview:creditlimit];
    }
    if (indexPath.section == 6) {
        [[cell contentView] addSubview:repaytypelabel];
        
    }
    if (indexPath.section == 7) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [[cell contentView] addSubview:loanbankname];
    }
    if (indexPath.section == 8) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [[cell contentView] addSubview:applycredituse];
    }
    if (indexPath.section == 9) {
        [[cell contentView] addSubview:assurerate];
        
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
    if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        if (indexPath.section == 0) {
            PBAssureCompanyInfo* company = [[PBAssureCompanyInfo alloc]initWithStyle:UITableViewStyleGrouped];
            company.ProjectStyle = ELSEPROJECTINFO;
            company.datadic = self.datadic;
            company.title = [titleArr objectAtIndex:0];
            company.type = 4;
            [self.navigationController pushViewController:company animated:YES];
        }
    }else{
        if (indexPath.section == 2) {
            [pop.view removeFromSuperview];
            pop._arry = property;
            pop.name = @"申请人性质";
            pop.view.hidden = !pop.view.hidden;
            [pop popClickAction];
        }
        if (indexPath.section ==6) {
            [pop.view removeFromSuperview];
            pop.name = @"还款方式";
            pop._arry = repaytype;
            pop.view.hidden = !pop.view.hidden;
            [pop popClickAction];
        }
        if (indexPath.section ==7) {
            PBBankChooseView* choose = [[PBBankChooseView alloc]init];
            choose.popController = self;
            choose.title = @"选择银行";
            [self changePostDataFromView];
            [self.navigationController pushViewController:choose animated:YES];
        }
        if (indexPath.section ==8) {
            [pop.view removeFromSuperview];
            pop.name = @"申请授信用途";
            pop._arry = credituse;
            pop.view.hidden = !pop.view.hidden;
            [pop popClickAction];
        }
    }
}
#pragma mark -POPview delegate
- (void)popView:(POPView *)popview didSelectIndexPath:(NSIndexPath *)indexPath{
    if ([pop._arry isEqualToArray:property]) {
        applyproperty.text = [popview._arry objectAtIndex:indexPath.row];
        self.pbdata.applyproperty = indexPath.row+1;
    }else if([pop._arry isEqualToArray:repaytype]){
        repaytypelabel.text = [popview._arry objectAtIndex:indexPath.row];
        self.pbdata.repaytype = indexPath.row+1;
    }else{
        applycredituse.text = [popview._arry objectAtIndex:indexPath.row];
        self.pbdata.applycredituse = indexPath.row+1;
    }
}

@end
