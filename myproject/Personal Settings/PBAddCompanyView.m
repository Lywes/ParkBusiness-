//
//  PBAddCompanyView.m
//  ParkBusiness
//
//  Created by QDS on 13-5-15.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBAddCompanyView.h"
#import "PBCompanyData.h"
#import "PBUserModel.h"
#import "UIImageView+WebCache.h"
#import "PBSettings.h"
#import "PBCompanyChoose.h"
#import "PBpersonerInfo.h"
#define IMGURL [NSString stringWithFormat:@"%@/admin/index/uploadcompanyicon",HOST]
#define URL [NSString stringWithFormat:@"%@/admin/index/addcompanyinfo",HOST]
#define COMPANYURL [NSString stringWithFormat:@"%@/admin/index/searchcompanyinfo",HOST]
@interface PBAddCompanyView ()
-(void)initPopView;
-(void)postOtherData;
-(void)SearchOnServer;
-(PBCompanyData *)dataZhuanhuan:(NSMutableDictionary *)dic;
@end

@implementation PBAddCompanyView
@synthesize userinfos;
@synthesize projectno;
@synthesize mode;
@synthesize type;
@synthesize popController;
@synthesize companydata;
@synthesize choose;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        keyno = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    willAppear = NO;
	// Do any additional setup after loading the view.
}
-(void)backButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(7, 7, 25, 30);
    [btn addTarget:self action:@selector(backUpView) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barButton;
    [barButton release];
}
-(void)backUpView{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [acitivity release];
    [industry release];
    [LogImageAC=nil release];
    [picturelabel release];
    [projectjieshao_tishi=nil release];
    [userinfos release];
    [staff release];
    [staffnum release];
    [super dealloc];
}
- (void)viewLoding
{
    CGRect frame = self.view.frame;

    frame.size.height = frame.size.height-KTabBarHeight-KNavigationBarHeight;
    self.tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
    acitivity = [[PBActivityIndicatorView alloc]initWithFrame:frame];
    [acitivity retain];
    if (isPad()) {
        LogImageAC = [[UIImageView alloc]initWithFrame:CGRectMake(RATIO*130, 0, 80, 64)];
        
    }
    else {
        LogImageAC = [[UIImageView alloc]initWithFrame:CGRectMake(130, 0, 80, 80)];
        
    }
    //9
    titleArr = [[NSMutableArray alloc]initWithObjects:@"公司名称:",@"组织机构代码:",@"税务登记证号:",@"法人代表:", @"开户行:",@"公司账户:",@"账户名:",@"联系电话:",@"办公地点:",@"员工人数:",@"注册资本（万元）:",@"实收资本（万元）:",@"上年度销售额（万元）:",@"上年度盈利（万元）:",@"固定资产（万元）:",@"企业总负债（万元）:",@"主营产品、主营模式:",@"实际经营场地:",@"是否涉及特许经营:",@"行业情况(含自身所处行业地位):",@"下游客户情况:",nil];

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
    [self initPopView];

    [self backButton];
}
#pragma mark - 相册
-(void)logimgePicker
{
    if (imagepickerview) {
        [imagepickerview release];
    }
    imagepickerview = [[ImagePickerView alloc]initWithView:self];
    imagepickerview.delegate = self;
}

-(void)resultImage:(UIImage *)image
{
    LogImageAC.image = image;
    NewImage = image;
    [self.tableView reloadData];
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [organizingcode resignFirstResponder];
    [taxregistry resignFirstResponder];
    [representative resignFirstResponder];
    [bank resignFirstResponder];
    [companyaccount resignFirstResponder];
    [accountname resignFirstResponder];
    [telephone resignFirstResponder];
    [address resignFirstResponder];
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
//        self.pbprojectdata = [[PBProjectData alloc]init];
        [self SearchOnServer];
    }else{//本地取数据
        if (!willAppear) {
            self.companydata = [PBCompanyData searchData:[PBUserModel getUserId]];
            willAppear = !willAppear;
        }
    }
    PBCompanyData* titleData = [PBCompanyData searchImageData:[PBUserModel getUserId]];
    self.companydata.no = titleData.no;
    self.companydata.name = titleData.name;
    self.companydata.image = titleData.image;
    if(!LogImageAC.image)
    {
        LogImageAC.image = titleData.image;
    }
    [self.tableView reloadData];
    if ([self.mode isEqualToString:@"add"]) {
        isedit = NO;
    }
    if ([self.ProjectStyle isEqualToString:@"login"]) {
        [self navigatorRightButtonType:NEXT];
    }
    [self initInputView];
}
-(void)initInputView{
    for (int i = 1; i<=[titleArr count]; i++){
        CGSize textSize = [[titleArr objectAtIndex:i-1] sizeWithFont:[UIFont boldSystemFontOfSize:16]];
        CGRect frame = CGRectMake(textSize.width+20, 5, self.tableView.frame.size.width-textSize.width-(isPad()?120:50), 35);
        if (i == 1) {
            companyname = [[UILabel alloc]initWithFrame:frame];
            companyname.backgroundColor = [UIColor clearColor];
            companyname.text = self.companydata.name;
        }
        if (i == 2) {
            organizingcode = [[UITextField alloc]initWithFrame:frame];
            organizingcode.text = self.companydata.organizingcode;
        }
        if (i == 3) {
            taxregistry = [[UITextField alloc]initWithFrame:frame];
            taxregistry.text = self.companydata.taxregistry;
        }
        if (i == 4) {
            representative = [[UITextField alloc]initWithFrame:frame];
            representative.text = self.companydata.representative;
        }
        if (i == 5) {
            bank = [[UITextField alloc]initWithFrame:frame];
            bank.text = self.companydata.bank;
        }
        if (i == 6) {
            companyaccount = [[UITextField alloc]initWithFrame:frame];
            companyaccount.text = self.companydata.companyaccount;
        }
        if (i == 7) {
            accountname = [[UITextField alloc]initWithFrame:frame];
            accountname.text = self.companydata.accountname;
        }
        if (i == 8) {
            telephone = [[UITextField alloc]initWithFrame:frame];
            telephone.text = self.companydata.telephone;
        }
        if (i == 9) {
            address = [[UITextField alloc]initWithFrame:frame];
            address.text = self.companydata.address;
        }
        if (i == 10) {
            staffnum = [[UILabel alloc]initWithFrame:frame];
            staffnum.backgroundColor = [UIColor clearColor];
            staffnum.text = [PBKbnMasterModel getKbnNameById:self.companydata.staffnum withKind:@"staff"];
        }
        if (i == 11) {
            registerfund = [[UITextField alloc]initWithFrame:frame];
            registerfund.text = [NSString stringWithFormat:@"%d",self.companydata.registerfund];
            registerfund.keyboardType = UIKeyboardTypeNumberPad;
        }
        if (i == 12) {
            receiptfund = [[UITextField alloc]initWithFrame:frame];
            receiptfund.text = [NSString stringWithFormat:@"%d",self.companydata.receiptfund];
            receiptfund.keyboardType = UIKeyboardTypeNumberPad;
        }
        if (i == 13) {
            yearsale = [[UITextField alloc]initWithFrame:frame];
            yearsale.text = [NSString stringWithFormat:@"%d",self.companydata.yearsale];
            yearsale.keyboardType = UIKeyboardTypeNumberPad;
        }
        if (i == 14)
        {
            yearprofit = [[UITextField alloc]initWithFrame:frame];
            yearprofit.text = [NSString stringWithFormat:@"%d",self.companydata.yearprofit];
            yearprofit.keyboardType = UIKeyboardTypeNumberPad;
        }
        if (i == 15)
        {
            fixedassets = [[UITextField alloc]initWithFrame:frame];
            fixedassets.text = [NSString stringWithFormat:@"%d",self.companydata.fixedassets];
            fixedassets.keyboardType = UIKeyboardTypeNumberPad;
        }
        if (i == 16)
        {
            totaldebt = [[UITextField alloc]initWithFrame:frame];
            totaldebt.text = [NSString stringWithFormat:@"%d",self.companydata.totaldebt];
            totaldebt.keyboardType = UIKeyboardTypeNumberPad;
        }
        if (i == 17)
        {
            mainproducts = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-(isPad()?90:20), 120)];
            mainproducts.tag = 9;
            mainproducts.backgroundColor = [UIColor clearColor];
            mainproducts.textAlignment = UITextAlignmentLeft;
            mainproducts.delegate = self;
            mainproducts.text = self.companydata.mainproducts;
        }
        if (i == 18)
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
        if (i == 19)
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
        if (i == 20)
        {
            tradeinfo = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-(isPad()?90:20), 120)];
            tradeinfo.tag = 12;
            tradeinfo.backgroundColor = [UIColor clearColor];
            tradeinfo.textAlignment = UITextAlignmentLeft;
            tradeinfo.delegate = self;
            tradeinfo.text = self.companydata.tradeinfo;
        }
        if (i == 21)
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
    [pb dataResponse:[NSURL URLWithString:COMPANYURL] postDic:[NSDictionary dictionaryWithObjectsAndKeys:[self.datadic objectForKey:@"userno"],@"userno", nil]searchOrSave:YES];
    
}
/*
 获取失败
 */
-(void)searchFilad
{
    [self navigatorRightButtonType:BIANJI];
    [self editButtonPress:self.navigationItem.rightBarButtonItem];
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
    self.companydata.name = [dic objectForKey:@"name"];
    self.companydata.organizingcode = [dic objectForKey:@"organizingcode"];
    self.companydata.taxregistry = [dic objectForKey:@"taxregistry"];
    self.companydata.representative = [dic objectForKey:@"representative"];
    self.companydata.bank = [dic objectForKey:@"bank"];
    self.companydata.companyaccount = [dic objectForKey:@"companyaccount"];
    self.companydata.accountname = [dic objectForKey:@"accountname"];
    self.companydata.telephone = [dic objectForKey:@"telephone"];
    self.companydata.address = [dic objectForKey:@"address"];
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
        [acitivity startAnimating];
        if (NewImage) {
            //上传到服务器
            PBdataClass *pb = [[PBdataClass alloc]init];
            pb.delegate = self;
            [pb PostImageResponse:[NSURL URLWithString:IMGURL] postImage:NewImage Forkey:@"uploadedfile" postOtherDic:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", self.pbdata.no],@"no", nil] searchOrSave:NO];
        }
        else {
            [self postOtherData];
        }
}
-(void)imageIsSuccesePostOnServer:(int)intvalue
{
    keyno = intvalue;
    if (keyno > 0) {
        [self postOtherData];
    }
    else {
        UIAlertView *aletview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"上传失败" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) otherButtonTitles:nil, nil];
        [aletview show];
        [aletview release];
        [acitivity stopAnimating];
    }
}
-(void)nextDidPush//跳转下一步
{
    
}

-(void)postOtherData
{
    [self changePostDataFromView];
    PBdataClass *pb = [[PBdataClass alloc]init];
    pb.delegate = self;
    NSMutableDictionary* dic = [self.companydata postDataToServer:@"mod"];
    [pb dataResponse:[NSURL URLWithString:URL] postDic:dic searchOrSave:NO];
}
-(void)changePostDataFromView{
    self.companydata.name = companyname.text?companyname.text:@"";
    self.companydata.organizingcode = organizingcode.text?organizingcode.text:@"";
    self.companydata.taxregistry = taxregistry.text?taxregistry.text:@"";
    self.companydata.representative = representative.text?representative.text:@"";
    self.companydata.bank = bank.text?bank.text:@"";
    self.companydata.companyaccount = companyaccount.text?companyaccount.text:@"";
    self.companydata.accountname = accountname.text?accountname.text:@"";
    self.companydata.telephone = telephone.text?telephone.text:@"";
    self.companydata.address = address.text?address.text:@"";
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
    //上传到本地
    self.companydata.no = [intvalue intValue];
    [self.companydata saveRecord];
    [acitivity stopAnimating];
    [self viewTapped:nil];
    [self navigatorRightButtonType:BIANJI];
    [self.tableView reloadData];
    //将公司信息传递到父画面
    NSMutableDictionary* dic = self.popController.dic;
    [dic setObject:self.companydata.name forKey:@"公司:"];
    [dic setObject:intvalue forKey:@"companyno"];
    self.popController.dic = dic;
    

    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    height = 44.0f;
    if (indexPath.section == 0) {
        height = 80.0f;
    }
    if (indexPath.section == 17) {
        height =  [self textViewHeightWithView:mainproducts defaultHeight:44.0f];
    }
    if (indexPath.section == 20) {
        height =  [self textViewHeightWithView:tradeinfo defaultHeight:44.0f];
    }
    if (indexPath.section == 21) {
        height =  [self textViewHeightWithView:tradeinfo defaultHeight:44.0f];
    }
    return height;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return [titleArr count]+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    if (section==18&&self.companydata.actualoperatesite==1) {
        return 3;
    }
    if (section==19&&self.companydata.isfranchise==1) {
        return 2;
    }
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    if (section == 17||section == 20||section == 21) {
        return [titleArr objectAtIndex:section-1];
    }else {
        return nil;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]&&(section == 16||section == 19||section == 20)) {
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
    if (indexPath.section == 0) {
        CGRect frame = isPad()?CGRectMake(250, 0, 300, 80):CGRectMake(100, 0, 100, 80);
        picturelabel = [[UILabel alloc]initWithFrame:frame];
        picturelabel.text = @"上传Logo";
        picturelabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:picturelabel];
        if (NewImage) {
            cell.imageView.image = LogImageAC.image;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 1) {//企业名称
        [[cell contentView] addSubview:companyname];
    }
    if (indexPath.section == 2) {//组织机构代码
        [[cell contentView] addSubview:organizingcode];
    }
    if (indexPath.section == 3) {//税务登记证号
        [[cell contentView] addSubview:taxregistry];
    }
    if (indexPath.section == 4) {//法人代表
        [[cell contentView] addSubview:representative];
    }
    if (indexPath.section == 5) {//开户行
        [[cell contentView] addSubview:bank];
    }
    if (indexPath.section == 6) {//公司账户
        [[cell contentView] addSubview:companyaccount];
    }
    if (indexPath.section == 7) {//账户名
        [[cell contentView] addSubview:accountname];
    }
    if (indexPath.section == 8) {//联系电话
        [[cell contentView] addSubview:telephone];
    }
    if (indexPath.section == 9) {//办公地点
        [[cell contentView] addSubview:address];
    }
    if (indexPath.section == 10) {//员工人数
        [[cell contentView] addSubview:staffnum];
    }
    if (indexPath.section == 11) {//注册资本
        [[cell contentView] addSubview:registerfund];
    }
    if (indexPath.section == 12) {//实收资本
        [[cell contentView] addSubview:receiptfund];
    }
    if (indexPath.section == 13) {//上年度销售额
        [[cell contentView] addSubview:yearsale];
        
    }
    if (indexPath.section == 14)//上年度盈利
    {
        [[cell contentView] addSubview:yearprofit];
    }
    if (indexPath.section == 15)//固定资本
    {
        [[cell contentView] addSubview:fixedassets];
    }
    if (indexPath.section == 16)//企业总负债
    {
        [[cell contentView] addSubview:totaldebt];
    }
    if (indexPath.section == 17)//主营产品
    {
        cell.textLabel.text = @"";
        [[cell contentView] addSubview:mainproducts];
        mainproducts.editable = !isedit;
    }
    if (indexPath.section == 18) {//实际场地
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
    if (indexPath.section == 19) {//特许经营
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
    if (indexPath.section == 20)//行业情况
    {
        cell.textLabel.text = @"";
        [[cell contentView] addSubview:tradeinfo];
        tradeinfo.editable = !isedit;
    }
    if (indexPath.section == 21)//下游客户
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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self logimgePicker];
    }else{
        if (indexPath.section == 10) {
            [pop.view removeFromSuperview];
            pop._arry = staff;
            pop.name = @"员工人数";
            pop.view.hidden = !pop.view.hidden;
            [pop popClickAction];
        }
        if (indexPath.section == 18) {
            if (indexPath.row==0) {
                [pop.view removeFromSuperview];
                pop._arry = operatesite;
                pop.name = @"实际经营场地";
                pop.view.hidden = !pop.view.hidden;
                [pop popClickAction];
            }
        }
        if (indexPath.section == 19) {
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
