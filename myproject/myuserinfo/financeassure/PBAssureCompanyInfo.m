//
//  PBAssureCompanyInfo.m
//  ParkBusiness
//
//  Created by 上海 on 13-5-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define BANKURL [NSString stringWithFormat:@"%@/admin/index/searchcompanyinfo",HOST]
#define SAVEURL [NSString stringWithFormat:@"%@/admin/index/addcompanyinfo",HOST]
#define PURCHASEURL [NSString stringWithFormat:@"%@/admin/index/purchasefinancingproduct",HOST]
#import "PBAssureCompanyInfo.h"
#import "PBIndustryData.h"
#import "PBUserModel.h"
#import "PBKbnMasterModel.h"
#import "UIImageView+WebCache.h"
#import "PBBankFinanceNeeds.h"
#import "PBCompanyData.h"
#import "PBCompanyChoose.h"
#import "PBAddCompanyBand.h"
#import "PBAddFinanceLease.h"
#import "PBFinancingVC.h"
@interface PBAssureCompanyInfo ()
-(void)initPopView;
-(void)postOtherData;
-(void)SearchOnServer;
-(PBCompanyData *)dataZhuanhuan:(NSMutableDictionary *)dic;
@end

@implementation PBAssureCompanyInfo
@synthesize companydata;
@synthesize projectno;
@synthesize mode;
@synthesize type;
@synthesize popController;
@synthesize GOFinacing;
-(void)dealloc
{
    [yearsale release];
    [fixedassets release];
    [yearprofit release];
    [staffnum release];
    [titleArr release];
    [acitivity release];
    [self.companydata = nil release];
    [staff release];
    [LogImageAC=nil release];
    [projectjieshao_tishi=nil release];
    [companyname release];
    [receiptfund release];//实收资本
    [registerfund release];//注册资本
    [totaldebt release];//企业总负债
    [mainproducts release];//主营产品
    [tradeinfo release];//行业情况
    [customerinfo release];//下游客户
    [actualsite release];//实际场地
    [leasedate release];//租约截止日期
    [averagerent release];//月平均租金
    [isfranchise release];//涉及特许经营
    [havefranchise release];//具有特许经营
    [operatesite release];//实际场地
    [judgment release];//涉及
    [check release];//具有
    [formatter release];
    [productData release];
    [super dealloc];
}
-(void)backUpViews
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)viewLoding
{
    companyname = @"";
    self.datadic = [[NSDictionary alloc]init];
    self.companydata = [[PBCompanyData alloc]init];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    acitivity = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    if (isPad()) {
        LogImageAC = [[UIImageView alloc]initWithFrame:CGRectMake(RATIO*130, 0, 80, 64)];
        
    }
    else {
        LogImageAC = [[UIImageView alloc]initWithFrame:CGRectMake(130, 0, 80, 80)];
        
    }
    formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    titleArr = [[NSMutableArray alloc]initWithObjects:@"企业名称:",@"员工人数:",@"注册资本（万元）:",@"实收资本（万元）:",@"上年度销售额（万元）:",@"上年度盈利（万元）:",@"固定资产（万元）:",@"企业总负债（万元）:",@"主营产品、主营模式:",@"实际经营场地:",@"是否涉及特许经营:",@"行业情况(含自身所处行业地位):",@"下游客户情况:", nil];
    [self initPopView];
    //本地取数据
    staff = [[NSMutableArray alloc]init];
    NSMutableArray *arry = [PBIndustryData search:@"staff"];
    for (PBIndustryData * industryData in arry ) {
        if (industryData.name != NULL) {
            [staff addObject:industryData.name];
        }
    }
    operatesite = [[NSMutableArray alloc]init];
    arry = [PBIndustryData search:@"operatesite"];
    for (PBIndustryData * industryData in arry ) {
        if (industryData.name != NULL) {
            [operatesite addObject:industryData.name];
        }
    }
    judgment = [[NSMutableArray alloc]init];
    arry = [PBIndustryData search:@"judgment"];
    for (PBIndustryData * industryData in arry ) {
        if (industryData.name != NULL) {
            [judgment addObject:industryData.name];
        }
    }
    check = [[NSMutableArray alloc]init];
    arry = [PBIndustryData search:@"check"];
    for (PBIndustryData * industryData in arry ) {
        if (industryData.name != NULL) {
            [check addObject:industryData.name];
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
    [yearsale resignFirstResponder];
    [yearprofit resignFirstResponder];
    [fixedassets resignFirstResponder];
    [receiptfund resignFirstResponder];//实收资本
    [registerfund resignFirstResponder];//注册资本
    [totaldebt resignFirstResponder];//企业总负债
    [mainproducts resignFirstResponder];//主营产品
    [tradeinfo resignFirstResponder];//行业情况
    [customerinfo resignFirstResponder];//下游客户
    [leasedate resignFirstResponder];//租约截止日期
    [averagerent resignFirstResponder];//月平均租金
}
-(void)viewWillDisappear:(BOOL)animated{
    [acitivity removeFromSuperview];
    [self viewTapped:nil];
    LogImageAC.image = nil;
    self.textViewAndtextFieldHidden = YES;
}
-(void)initPopView
{
    //弹出选择画面
    pop =[[POPView alloc]init];
    pop.delegate = self;
    pop.view.hidden = YES;
    [self.view addSubview:pop.view];
}

-(void)initDetaPicker:(UITextField*)textfield 
{
    //时间选择器
    UIDatePicker* datepicker = [[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 200, 320, 250)]autorelease];
    datepicker.datePickerMode = UIDatePickerModeDate;
    [datepicker addTarget:self action:@selector(datePickerSeclect:) forControlEvents:UIControlEventValueChanged];
    textfield.inputView = datepicker;
    UIToolbar* toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 460, 320, 44)];
    
    UIBarButtonItem* btn = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_wc", nil)
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(donePush:)];
    UIBarButtonItem* btn1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    toolBar.items = [NSArray arrayWithObjects:btn1,btn, nil];
    textfield.inputAccessoryView = toolBar;
}
-(void)datePickerSeclect:(id)sender
{
    UIDatePicker* control = (UIDatePicker*)sender;
    NSDate *date = control.date;
    NSString *str = [[[NSString alloc]initWithFormat:@"%@",[formatter stringFromDate:date]]autorelease];
    leasedate.text = str;
    
}
-(void)donePush:(id)sender
{
    [self viewTapped:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    willAppear = NO;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSubview:acitivity];
    if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        self.tableView.allowsSelection = NO;
        [self SearchOnServer];
    }else{//本地取数据
        if (!willAppear) {
            self.companydata = [PBCompanyData searchData:[PBUserModel getUserId]];
            willAppear = !willAppear;
        }
        PBCompanyData* titleData = [PBCompanyData searchImageData:[PBUserModel getUserId]];
        companyname = titleData.name;
        self.companydata.no = titleData.no;
        self.companydata.name = titleData.name;
        self.companydata.image = titleData.image;
        if(!LogImageAC.image)
        {
            LogImageAC.image = titleData.image;
        }
    }
    if ([self.mode isEqualToString:@"add"]) {
        isedit = NO;
    }
    [self initInputView];
    [self.tableView reloadData];
    
}
-(void)initInputView{
    for (int i = 1; i<=[titleArr count]; i++){
        CGSize textSize = [[titleArr objectAtIndex:i-1] sizeWithFont:[UIFont boldSystemFontOfSize:16]];
        CGRect frame = CGRectMake(textSize.width+20, 5, self.tableView.frame.size.width-textSize.width-(isPad()?120:50), 35);
        
        if (i == 2) {
            staffnum = [[UILabel alloc]initWithFrame:frame];
            staffnum.backgroundColor = [UIColor clearColor];
            staffnum.text = [PBKbnMasterModel getKbnNameById:self.companydata.staffnum withKind:@"staff"];
        }
        if (i == 3) {
            registerfund = [[UITextField alloc]initWithFrame:frame];
            registerfund.text = [NSString stringWithFormat:@"%d",self.companydata.registerfund];
            registerfund.keyboardType = UIKeyboardTypeNumberPad;
        }
        if (i == 4) {
            receiptfund = [[UITextField alloc]initWithFrame:frame];
            receiptfund.text = [NSString stringWithFormat:@"%d",self.companydata.receiptfund];
            receiptfund.keyboardType = UIKeyboardTypeNumberPad;
        }
        if (i == 5) {
            yearsale = [[UITextField alloc]initWithFrame:frame];
            yearsale.text = [NSString stringWithFormat:@"%d",self.companydata.yearsale];
            yearsale.keyboardType = UIKeyboardTypeNumberPad;
        }
        if (i == 6)
        {
            yearprofit = [[UITextField alloc]initWithFrame:frame];
            yearprofit.text = [NSString stringWithFormat:@"%d",self.companydata.yearprofit];
            yearprofit.keyboardType = UIKeyboardTypeNumberPad;
        }
        if (i == 7)
        {
            fixedassets = [[UITextField alloc]initWithFrame:frame];
            fixedassets.text = [NSString stringWithFormat:@"%d",self.companydata.fixedassets];
            fixedassets.keyboardType = UIKeyboardTypeNumberPad;
        }
        if (i == 8)
        {
            totaldebt = [[UITextField alloc]initWithFrame:frame];
            totaldebt.text = [NSString stringWithFormat:@"%d",self.companydata.totaldebt];
            totaldebt.keyboardType = UIKeyboardTypeNumberPad;
        }
        if (i == 9)
        {
            mainproducts = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-(isPad()?90:20), 120)];
            mainproducts.tag = 9;
            mainproducts.backgroundColor = [UIColor clearColor];
            mainproducts.textAlignment = UITextAlignmentLeft;
            mainproducts.delegate = self;
            mainproducts.text = self.companydata.mainproducts;
        }
        if (i == 10)
        {
            actualsite = [[UILabel alloc]initWithFrame:frame];
            actualsite.backgroundColor = [UIColor clearColor];
            actualsite.text = [PBKbnMasterModel getKbnNameById:self.companydata.actualoperatesite withKind:@"operatesite"];
            textSize = [@"租约截止日期:" sizeWithFont:[UIFont boldSystemFontOfSize:16]];
            frame = CGRectMake(textSize.width+20, 5, self.tableView.frame.size.width-textSize.width-(isPad()?120:50), 35);
            leasedate = [[UITextField alloc]initWithFrame:frame];
            leasedate.text = [formatter stringFromDate:self.companydata.leasedate];
            [self initDetaPicker:leasedate];
            textSize = [@"月平均租金(元):" sizeWithFont:[UIFont boldSystemFontOfSize:16]];
            frame = CGRectMake(textSize.width+20, 5, self.tableView.frame.size.width-textSize.width-(isPad()?120:50), 35);
            averagerent.keyboardType = UIKeyboardTypeNumberPad;
            averagerent = [[UITextField alloc]initWithFrame:frame];
            averagerent.text = [NSString stringWithFormat:@"%d",self.companydata.averagerent];
        }
        if (i == 11)
        {
            isfranchise = [[UILabel alloc]initWithFrame:frame];
            isfranchise.backgroundColor = [UIColor clearColor];
            isfranchise.text = [PBKbnMasterModel getKbnNameById:self.companydata.isfranchise withKind:@"judgment"];
            textSize = [@"是否具有特许经营资质:" sizeWithFont:[UIFont boldSystemFontOfSize:16]];
            frame = CGRectMake(textSize.width+20, 5, self.tableView.frame.size.width-textSize.width-(isPad()?120:50), 35);
            havefranchise = [[UILabel alloc]initWithFrame:frame];
            havefranchise.backgroundColor = [UIColor clearColor];
            havefranchise.text = [PBKbnMasterModel getKbnNameById:self.companydata.havefranchise withKind:@"check"];
        }
        if (i == 12)
        {
            tradeinfo = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-(isPad()?90:20), 120)];
            tradeinfo.tag = 12;
            tradeinfo.backgroundColor = [UIColor clearColor];
            tradeinfo.textAlignment = UITextAlignmentLeft;
            tradeinfo.delegate = self;
            tradeinfo.text = self.companydata.tradeinfo;
        }
        if (i == 13)
        {
            customerinfo = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-(isPad()?90:20), 120)];
            customerinfo.tag = 13;
            customerinfo.backgroundColor = [UIColor clearColor];
            customerinfo.textAlignment = UITextAlignmentLeft;
            customerinfo.delegate = self;
            customerinfo.text = self.companydata.customerinfo;
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
    [pb dataResponse:[NSURL URLWithString:BANKURL] postDic:[NSDictionary dictionaryWithObjectsAndKeys:[self.datadic objectForKey:@"userno"],@"userno", [self.datadic objectForKey:@"companyno"],@"companyno",nil]searchOrSave:YES];
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
-(PBCompanyData *)dataZhuanhuan:(NSMutableDictionary *)dic
{
    self.companydata.registerfund = [[dic objectForKey:@"registerfund"] intValue];
    self.companydata.receiptfund = [[dic objectForKey:@"receiptfund"] intValue];
    self.companydata.totaldebt = [[dic objectForKey:@"totaldebt"] intValue];
    self.companydata.staffnum = [[dic objectForKey:@"staffnum"] intValue];
    self.companydata.yearsale = [[dic objectForKey:@"yearsale"] intValue];
    self.companydata.fixedassets = [[dic objectForKey:@"fixedassets"] intValue];
    self.companydata.yearprofit = [[dic objectForKey:@"yearprofit"] intValue];
    self.companydata.mainproducts = [dic objectForKey:@"mainproducts"];
    self.companydata.tradeinfo = [dic objectForKey:@"tradeinfo"];
    self.companydata.customerinfo = [dic objectForKey:@"customerinfo"];
    self.companydata.actualoperatesite = [[dic objectForKey:@"actualoperatesite"] intValue];
    self.companydata.leasedate = [formatter dateFromString:(NSString*)[dic objectForKey:@"leasedate"]];
    self.companydata.averagerent = [[dic objectForKey:@"averagerent"] intValue];
    self.companydata.isfranchise = [[dic objectForKey:@"isfranchise"] intValue];
    self.companydata.havefranchise = [[dic objectForKey:@"havefranchise"] intValue];
    companyname = [dic objectForKey:@"name"];
    UIImageView *imageview = [[[UIImageView alloc]init]autorelease];
    [imageview setImageWithURL:[NSString stringWithFormat:@"%@%@",HOST,[dic objectForKey:@"imagepath"]]];
    LogImageAC.image = imageview.image;
    [self.tableView reloadData];
    return self.companydata;
}
#pragma mark - 数据上传到服务器
-(void)postDataOnserver
{
    if (self.companydata.no>0) {
        [acitivity startAnimating];
        [self postOtherData];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请先完善公司信息后再进行追加!"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        if (![self.mode isEqualToString:@"add"]) {
            [super editButtonPress:self.navigationItem.rightBarButtonItem];
        }
        
    }
    
}

-(void)nextDidPush//跳转下一步
{
    switch (self.type) {
        case 2:{
            if (GOFinacing) {
                PBFinancingVC *financingvc = [[PBFinancingVC alloc]initWithStyle:UITableViewStyleGrouped];
                [self.navigationController pushViewController:financingvc animated:YES];
                [financingvc release];
            }
            else
            {
                PBBankFinanceNeeds* needs = [[PBBankFinanceNeeds alloc]initWithStyle:UITableViewStyleGrouped];
                [needs navigatorRightButtonType:BIANJI];
                needs.mode = @"add";
                needs.projectno = self.projectno;
                needs.productno = self.productno;
                needs.title = NSLocalizedString(@"Left_mainTable_RZXQ", nil);
                [self.navigationController pushViewController:needs animated:YES];
            }
        }
            break;
        case 3:{
            PBAddCompanyBand* bond = [[PBAddCompanyBand alloc]initWithStyle:UITableViewStyleGrouped];
            [bond navigatorRightButtonType:BIANJI];
            bond.mode = @"add";
            bond.projectno = self.projectno;
            bond.productno = self.productno;
            bond.title = @"企业债券";
            [self.navigationController pushViewController:bond animated:YES];
        }
            break;
        case 4:{
            [self dismissModalViewControllerAnimated:YES];
            if (self.productno>0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"showalert" object:nil];
            }
        }
            break;
        case 5:{
            PBAddFinanceLease* lease = [[PBAddFinanceLease alloc]initWithStyle:UITableViewStyleGrouped];
            [lease navigatorRightButtonType:NEXT];
            lease.mode = @"add";
            lease.productno = self.productno;
            lease.projectno = self.projectno;
            lease.title = @"金融租赁";
            [self.navigationController pushViewController:lease animated:YES];
        }
            break;
        case 6:{
            productData = [[PBdataClass alloc]init];
            productData.delegate = self;
            NSArray* arr1 = [NSArray arrayWithObjects:[self.userinfos objectForKey:@"no"],USERNO,[NSString stringWithFormat:@"%d",[PBUserModel getCompanyno]],nil];
            NSArray* arr2 = [NSArray arrayWithObjects:@"productno",@"userno", @"companyno",nil];
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
            [productData dataResponse:[NSURL URLWithString:PURCHASEURL] postDic:dic searchOrSave:NO];
        }
            break;
        default:
            break;
    }
}
-(void)postOtherData
{
    [self changePostDataFromView];
    PBdataClass *pb = [[PBdataClass alloc]init];
    pb.delegate = self;
    NSMutableDictionary* dic = [self.companydata postDataToServer:@"mod"];
    pb.validate = NO;
    [pb dataResponse:[NSURL URLWithString:SAVEURL] postDic:dic searchOrSave:NO];
}
-(void)changePostDataFromView{
    self.companydata.registerfund = [registerfund.text intValue];
    self.companydata.receiptfund = [receiptfund.text intValue];
    self.companydata.yearsale = [yearsale.text intValue];
    self.companydata.fixedassets = [fixedassets.text intValue];
    self.companydata.yearprofit = [yearprofit.text intValue];
    self.companydata.totaldebt = [totaldebt.text intValue];
    self.companydata.mainproducts = mainproducts.text?mainproducts.text:@"";
    self.companydata.leasedate = [formatter dateFromString:leasedate.text];
    self.companydata.averagerent = [averagerent.text intValue];
    self.companydata.tradeinfo = tradeinfo.text?tradeinfo.text:@"";
    self.companydata.customerinfo = customerinfo.text?customerinfo.text:@"";

}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    if (dataclass == productData) {
        [acitivity stopAnimating];
        self.popController.hasBuy = @"1";
        [self.popController.tableView reloadData];
        [self dismissModalViewControllerAnimated:YES];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您已完成抢购，请尽快至网页进行付款！" delegate:self.popController cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        //上传到本地
        self.companydata.no = [intvalue intValue];
        [self.companydata saveRecord];
        if (self.type!=6) {
            [acitivity stopAnimating];
        }
        if ([self.mode isEqualToString:@"add"]) {
            [self nextDidPush];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
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
    return [titleArr count]+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        if (section==0||section==1||section==9||section==12||section==13) {
            return 0;
        }else if(self.type==2&&(section==3||section==4)){
            return 1;
        }
    }
    if (section<3) {
        return 1;
    }
    switch (self.type) {//不同项目类型显示不同数据
        case 2:
            if (section<=7) {
                return 1;
            }else{
                return 0;
            }
            break;
        case 3:
            if (section==12||section==13) {
                return 0;
            }else{
                if (section==10&&self.companydata.actualoperatesite==1) {
                    return 3;
                }
                if (section==11&&self.companydata.isfranchise==1) {
                    return 2;
                }
                return 1;
            }
            break;
        case 4:
            if (section==5||section==6||section==7||section==8||section==12||section==13) {
                return 0;
            }else{
                if (section==10&&self.companydata.actualoperatesite==1) {
                    return 3;
                }
                if (section==11&&self.companydata.isfranchise==1) {
                    return 2;
                }
                return 1;
            }
            break;
        case 5:
            if (section<5||section==9||section==12||section==13) {
                return 1;
            }else{
                return 0;
            }
            break;
        default:
            break;
    }
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        return nil;
    }
    if ((section == 9&&(self.type==3||self.type==4))||(self.type==5&&(section == 9||section == 12||section == 13))) {
        return [titleArr objectAtIndex:section-1];
    }else {
        return nil;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]&&((section == 9&&(self.type==3||self.type==4))||(self.type==5&&(section == 9||section == 12||section == 13)))) {
        labletag = section;
        return [self TishiView];
    }else{
        return nil;
    }
}

#pragma mark - cell内容设置
-(void)addSubViewForCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section>0) {
        cell.textLabel.text = [titleArr objectAtIndex:indexPath.section-1];
    }
    if (indexPath.section == 0) {//企业图片
        cell.imageView.image = LogImageAC.image;
        if (self.companydata.no<=0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"请先点击登记公司信息";
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.numberOfLines = 0;
        }
    }
    if (indexPath.section == 1) {//企业名称
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = [NSString stringWithFormat:@"%@  %@",cell.textLabel.text,companyname?companyname:@""];
        
    }
    if (indexPath.section == 2) {//员工人数
        [[cell contentView] addSubview:staffnum];
    }
    if (indexPath.section == 3) {//注册资本
        [[cell contentView] addSubview:registerfund];
    }
    if (indexPath.section == 4) {//实收资本
        [[cell contentView] addSubview:receiptfund];
    }
    if (indexPath.section == 5) {//上年度销售额
        [[cell contentView] addSubview:yearsale];
        
    }
    if (indexPath.section == 6)//上年度盈利
    {
        [[cell contentView] addSubview:yearprofit];
    }
    if (indexPath.section == 7)//固定资本
    {
        [[cell contentView] addSubview:fixedassets];
    }
    if (indexPath.section == 8)//企业总负债
    {
        [[cell contentView] addSubview:totaldebt];
    }
    if (indexPath.section == 9)//主营产品
    {
        cell.textLabel.text = @"";
        [[cell contentView] addSubview:mainproducts];
        mainproducts.editable = !isedit;
    }
    if (indexPath.section == 10) {//实际场地
        switch (indexPath.row) {
            case 0:
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [[cell contentView] addSubview:actualsite];
                break;
            case 1:
                cell.textLabel.text = @"租约截止日期:";
                [[cell contentView] addSubview:leasedate];
                break;
            case 2:
                cell.textLabel.text = @"月平均租金(元):";
                [[cell contentView] addSubview:averagerent];
                break;
            default:
                break;
        }
    }
    if (indexPath.section == 11) {//特许经营
        switch (indexPath.row) {
            case 0:
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [[cell contentView] addSubview:isfranchise];
                break;
            case 1:
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"是否具有特许经营资质:";
                [[cell contentView] addSubview:havefranchise];
                break;
            default:
                break;
        }
    }
    if (indexPath.section == 12)//行业情况
    {
        cell.textLabel.text = @"";
        [[cell contentView] addSubview:tradeinfo];
        tradeinfo.editable = !isedit;
    }
    if (indexPath.section == 13)//下游客户
    {
        cell.textLabel.text = @"";
        [[cell contentView] addSubview:customerinfo];
        customerinfo.editable = !isedit;
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
    height = 44.0f;
    if (indexPath.section == 0) {
        height = 80.0f;
    }
    if (indexPath.section == 9) {
        height =  [self textViewHeightWithView:mainproducts defaultHeight:44.0f];
    }
    if (indexPath.section == 12) {
        height =  [self textViewHeightWithView:tradeinfo defaultHeight:44.0f];
    }
    if (indexPath.section == 13) {
        height =  [self textViewHeightWithView:tradeinfo defaultHeight:44.0f];
    }
    return height;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&self.companydata.no<=0) {
        PBCompanyChoose* company = [[PBCompanyChoose alloc]init];
        company.title = @"选择公司";
        [self changePostDataFromView];
        [self.navigationController pushViewController:company animated:YES];
    }
    if (indexPath.section == 2) {
        [pop.view removeFromSuperview];
        pop._arry = staff;
        pop.name = @"员工人数";
        pop.view.hidden = !pop.view.hidden;
        [pop popClickAction];
    }
    if (indexPath.section == 10) {
        if (indexPath.row==0) {
            [pop.view removeFromSuperview];
            pop._arry = operatesite;
            pop.name = @"实际经营场地";
            pop.view.hidden = !pop.view.hidden;
            [pop popClickAction];
        }
    }
    if (indexPath.section == 11) {
        [pop.view removeFromSuperview];
        if (indexPath.row==0) {
            pop.name = @"是否涉及特许经营";
            pop._arry = judgment;
        }
        if (indexPath.row==1) {
            pop.name = @"是否具有特许经营资质";
            pop._arry = check;
        }
        pop.view.hidden = !pop.view.hidden;
        [pop popClickAction];
    }
    
}
#pragma mark -POPview delegate
- (void)popView:(POPView *)popview didSelectIndexPath:(NSIndexPath *)indexPath{
    if ([pop._arry isEqualToArray:staff]) {
        staffnum.text = [popview._arry objectAtIndex:indexPath.row];
        self.companydata.staffnum = indexPath.row+1;
    }
    if ([pop._arry isEqualToArray:operatesite]) {
        actualsite.text = [popview._arry objectAtIndex:indexPath.row];
        self.companydata.actualoperatesite = indexPath.row+1;
        [self.tableView reloadData];
    }
    if ([pop._arry isEqualToArray:judgment]) {
        isfranchise.text = [popview._arry objectAtIndex:indexPath.row];
        self.companydata.isfranchise = indexPath.row;
        [self.tableView reloadData];
    }
    if ([pop._arry isEqualToArray:check]) {
        havefranchise.text = [popview._arry objectAtIndex:indexPath.row];
        self.companydata.havefranchise = indexPath.row;
    }
}


@end