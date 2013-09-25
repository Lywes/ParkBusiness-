//
//  PBuserinfo.m
//  ParkBusiness
//
//  Created by 新平 圣 on 13-2-28.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define SEARCHONSERVER [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchproject",HOST]]
#import "PBuserinfo.h"
#import "PBIndustryData.h"
#import "PBUserModel.h"
#import "PBKbnMasterModel.h"
#import "UIImageView+WebCache.h"
#import "MyProject.h"
#import "PBAssureCompanyInfo.h"
#import "PBCompanyData.h"
#define BANKURL [NSString stringWithFormat:@"%@/admin/index/addproject",HOST]
@interface PBuserinfo ()
-(void)initDetaPicker;
-(void)initPopView;
-(void)postOtherData;
-(void)SearchOnServer;
-(PBProjectData *)dataZhuanhuan:(NSMutableDictionary *)dic;
@end
@implementation PBuserinfo
@synthesize projectstartime;
@synthesize datestring,pbdatepicker;
@synthesize lbtxt_projectname,lbtxt_projectjieshao,lbtxt_hangyehuafen,lbtxt_projectstartime,lbtex_projectjieduan,lbtex_chuanyejingli;
@synthesize userinfos;
@synthesize pbprojectdata;
@synthesize projectno;
@synthesize mode;
@synthesize type;
@synthesize popController;
-(void)dealloc
{
    [acitivity release];
    [picturelabel release];
    [self.pbprojectdata = nil release];
    [industry release];
    [stage release];
    [LogImageAC=nil release];
    [lbtxt_projectjieshao=nil release];
    [lbtxt_projectjieshao=nil release];
    [lbtxt_hangyehuafen=nil release];
    [lbtxt_hangyehuafen=nil release];
    [lbtex_projectjieduan = nil release];
    [lbtex_chuanyejingli  = nil release];
    [projectjieshao_tishi=nil release];
    [datestring=nil release];
    [projectstartime=nil release];
    [hangyehuafen=nil release];
    [_projectjieduan=nil release];
    [userinfos release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewLoding
{
    CGRect frame = CGRectMake(0, 0, isPad()?768:320, isPad()?1024:isPhone5()?568:480);
    self.view.frame = frame;
    self.navigationController.view.frame = frame;
    self.title = @"项目基本信息";
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    acitivity = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    if (isPad()) {
        self.projectstartime = [[[UITextField alloc]initWithFrame:CGRectMake(RATIO*130, 12, RATIO*130, 29)]autorelease];//项目开始时间
        hangyehuafen = [[UILabel alloc]initWithFrame:CGRectMake(RATIO*130, 10, RATIO*100, 20)];//行业划分显示在此lable上;
        companyname = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 300, 20)];//公司名称显示在此lable上;
        _projectjieduan = [[UILabel alloc]initWithFrame:CGRectMake(RATIO*130, 15, RATIO*100, 15)];
        LogImageAC = [[UIImageView alloc]initWithFrame:CGRectMake(RATIO*130, 0, 80, 64)];
        picturelabel = [[UILabel alloc]initWithFrame:CGRectMake(250, 0, 300, 80)];

    }
    else {
        self.projectstartime = [[[UITextField alloc]initWithFrame:CGRectMake(130, 12, 130, 29)]autorelease];//项目开始时间
        hangyehuafen = [[UILabel alloc]initWithFrame:CGRectMake(130, 10, 100, 20)];//行业划分显示在此lable上;
        companyname = [[UILabel alloc]initWithFrame:CGRectMake(90, 5, 200, 30)];//公司名称显示在此lable上;
        companyname.font = [UIFont systemFontOfSize:14];
        _projectjieduan = [[UILabel alloc]initWithFrame:CGRectMake(130, 15, 100, 15)];
        LogImageAC = [[UIImageView alloc]initWithFrame:CGRectMake(130, 0, 80, 80)];
        picturelabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, 100, 80)];

    }
    companyname.numberOfLines = 0;
    picturelabel.text = @"企业Logo";
    picturelabel.backgroundColor = [UIColor clearColor];
    picturelabel.hidden = YES;
    [picturelabel retain];
    [self.projectstartime setEnabled:NO];
    [self.projectstartime setBorderStyle:UITextBorderStyleNone];
    hangyehuafen.backgroundColor = [UIColor clearColor];
    //项目阶段显示在此lable上
    _projectjieduan.backgroundColor = [UIColor clearColor];
    lbtxt_projectname = @"项目名称:";
    lbtxt_hangyehuafen = @"行业划分:";
    lbtxt_projectjieshao  = @"项目介绍:";
    lbtxt_projectstartime = @"开始时间:";
    lbtex_projectjieduan = @"项目阶段:";
    
    [self initPopView];
    [self initDetaPicker];
    //本地取数据
    industry = [[NSMutableArray alloc]init];
    NSMutableArray *arry = [PBIndustryData search:@"industry"];
    for (PBIndustryData * industryData in arry ) {
        if (industryData.name != NULL) {
            [industry addObject:industryData.name];
        }
    }
    stage = [[NSMutableArray alloc]init];
    NSMutableArray *arry1 = [PBIndustryData search:@"stage"];
    for (PBIndustryData * industryData in arry1 ) {
        if (industryData.name != NULL) {
            [stage addObject:industryData.name];
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
    [self.projectjieshao resignFirstResponder];
    [self.projectname resignFirstResponder];
    [self.projectstartime resignFirstResponder];
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
    pop.name = @"项目阶段";
    pop.view.hidden = YES;
    [self.view addSubview:pop.view];
    pop_arry = [[NSMutableArray alloc]initWithObjects:@"1",@"2", nil];
}
-(void)initDetaPicker
{
    //时间选择器
    UIDatePicker* datepicker = [[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 200, 320, 250)]autorelease];
    datepicker.datePickerMode = UIDatePickerModeDate;
    [datepicker addTarget:self action:@selector(datePickerSeclect:) forControlEvents:UIControlEventValueChanged];
    self.projectstartime.inputView = datepicker;
    UIToolbar* toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 460, 320, 44)];
    
    UIBarButtonItem* btn = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_wc", nil)
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(donePush:)];
    UIBarButtonItem* btn1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    toolBar.items = [NSArray arrayWithObjects:btn1,btn, nil];
    self.projectstartime.inputAccessoryView = toolBar;
}
-(void)datePickerSeclect:(id)sender
{
    UIDatePicker* control = (UIDatePicker*)sender;
    
    NSDate *date = control.date;
    NSDateFormatter *formatter = [[[NSDateFormatter alloc]init]autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [[[NSString alloc]initWithFormat:@"%@",[formatter stringFromDate:date]]autorelease];
    projectstartime.text = str;
}
-(void)donePush:(id)sender
{
    [self.projectstartime resignFirstResponder];
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
        self.pbprojectdata = [[PBProjectData alloc]init];
        [self SearchOnServer];
    }
    //本地取数据
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        self.pbprojectdata = [PBProjectData searchImagePath:self.projectno];
    }
    [self viewApperdata];
    if ([self.mode isEqualToString:@"add"]&&self.type==1&&isedit) {
        [super editButtonPress:self.navigationItem.rightBarButtonItem];
    }

}
-(void)viewApperdata
{
    self.projectname.text = self.pbprojectdata.proname;
    NSString *trade = [PBKbnMasterModel getKbnNameById:self.pbprojectdata.trade withKind:@"industry"];//行业划分；
    hangyehuafen.text = trade;
    self.projectjieshao.text = self.pbprojectdata.introduce;
    projectstartime.text = self.pbprojectdata.stdate;
    if(!LogImageAC.image)
    {
        PBCompanyData* titleData = [PBCompanyData searchImageData:[PBUserModel getUserId]];
        companyname.text = titleData.name;
        LogImageAC.image = titleData.image;
//        if (self.pbprojectdata.imagepath) {
//            LogImageAC.image = self.pbprojectdata.imagepath;
//        }else{
//            LogImageAC.image = type==1?[UIImage imageNamed:@"project_icon_1"]:[UIImage imageNamed:@"project_icon_2"];
//            NewImage = LogImageAC.image;
//        }
    }
    NSString *stage1 = [PBKbnMasterModel getKbnNameById:self.pbprojectdata.stage withKind:@"stage"];
    _projectjieduan.text = stage1;
    [self.tableView reloadData];
}
#pragma mark -编辑状态
-(void)editState
{
    picturelabel.hidden = NO;
    [self.projectstartime setEnabled:YES];
    self.projectjieshao_tishi.hidden = NO;
}
#pragma mark - 从服务器服务器取数据
-(void)SearchOnServer
{
    [acitivity startAnimating];
    PBdataClass *pb = [[PBdataClass alloc]init];
    pb.delegate = self;
    [pb dataResponse:SEARCHONSERVER postDic:[NSDictionary dictionaryWithObjectsAndKeys:[self.userinfos objectForKey:@"projectno"],@"no",[self.userinfos objectForKey:@"companyno"],@"companyno", nil]searchOrSave:YES];

}
/*
 获取失败
 */
-(void)searchFilad
{
    if (type==1) {
        [self editButtonPress:self.navigationItem.rightBarButtonItem];
    }else{
        if (self.pbprojectdata.no>0) {
            [self editButtonPress:self.navigationItem.rightBarButtonItem];
        }else{
            [self editState];
        }
    }
    [acitivity stopAnimating]; 
}
/*
    上传成功
*/
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    NSLog(@"项目基本信息:%@",datas);
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
    self.pbprojectdata.proname = [dic objectForKey:@"proname"];
    NSString *stage1 = [dic objectForKey:@"stage"];
     pbprojectdata.stage = stage1.intValue;
    self.pbprojectdata.stdate = [dic objectForKey:@"stdate"];
    NSString *trade1 = [dic objectForKey:@"trade"];
    self.pbprojectdata.stage = trade1.intValue;
    self.pbprojectdata.introduce = [dic objectForKey:@"introduce"];
    UIImageView *imageview = [[[UIImageView alloc]init]autorelease];
    [imageview setImageWithURL:[NSString stringWithFormat:@"%@%@",HOST,[dic objectForKey:@"imagepath"]]];
    self.pbprojectdata.imagepath = imageview.image;
    [self viewApperdata];
    return self.pbprojectdata;
}
#pragma mark - 数据上传到服务器
-(void)postDataOnserver
{
    [acitivity startAnimating];
    picturelabel.hidden = YES;
    [self.projectstartime setEnabled:NO];
    self.projectjieshao_tishi.hidden = YES;
    if (NewImage) {
        //上传到服务器
        NSString *userid = USERNO;
        PBdataClass *pb = [[PBdataClass alloc]init];
        pb.delegate = self;
        [pb PostImageResponse:[NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/uploadprojecticon",HOST]] postImage:type==1?[UIImage imageNamed:@"project_icon_1"]:[UIImage imageNamed:@"project_icon_2"] Forkey:@"uploadedfile" postOtherDic:[NSDictionary dictionaryWithObjectsAndKeys:userid,@"id",[NSString stringWithFormat:@"%d", self.pbprojectdata.no],@"no", nil] searchOrSave:NO];
    }
    else {
        [self postOtherData];
    }
        
}
-(void)imageIsSuccesePostOnServer:(int)intvalue
{
    keyno = intvalue;
    if (keyno > 0) {
        self.pbprojectdata.no = keyno;
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
    PBAssureCompanyInfo* apply = [[PBAssureCompanyInfo alloc]initWithStyle:UITableViewStyleGrouped];
    [apply navigatorRightButtonType:NEXT];
    apply.mode = @"add";
    apply.type = self.type;
    apply.projectno = keyno;
    apply.productno = self.productno;
    apply.title = @"企业现状";
    [self.navigationController pushViewController:apply animated:YES];
}
-(void)postOtherData
{
    PBdataClass *pb = [[PBdataClass alloc]init];
    pb.delegate = self;
    NSString *userid = USERNO;
    NSString* modes = self.pbprojectdata.no>0?@"mod":@"add";
    NSArray *a1 = [[NSArray alloc]initWithObjects:@"mode",@"no",@"type",@"productno",@"companyno",@"proname",@"stage",@"stdate",@"trade",@"introduce", nil];
    NSArray *a2 = [[NSArray alloc]initWithObjects:modes,
                   [NSString stringWithFormat:@"%d",self.pbprojectdata.no],
                   [NSString stringWithFormat:@"%d",self.type],
                   [NSString stringWithFormat:@"%d",self.productno],userid,
                   (self.projectname.text==NULL)?@"":self.projectname.text,
                   [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:_projectjieduan.text withKind:@"stage"]]==NULL?@"":[NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:_projectjieduan.text withKind:@"stage"]],
                   (projectstartime.text==NULL)?@"":projectstartime.text,
                   [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:hangyehuafen.text withKind:@"industry"]]==NULL?@"":[NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:hangyehuafen.text withKind:@"industry"]],
                   (self.projectjieshao.text==NULL)?@"":self.projectjieshao.text, 
                   nil];
    [pb dataResponse:[NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/addproject",HOST]] postDic:[[NSDictionary alloc]initWithObjects:a2 forKeys:a1] searchOrSave:NO]; 
}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    //上传到本地
    keyno = [intvalue intValue];
    PBProjectData *pbprojectdata1 = [[PBProjectData alloc]init];
    pbprojectdata1.companyno = [PBUserModel getUserId];
    pbprojectdata1.type = self.type;
    pbprojectdata1.no = keyno;
    pbprojectdata1.imagepath = type==1?[UIImage imageNamed:@"project_icon_1"]:[UIImage imageNamed:@"project_icon_2"];
    pbprojectdata1.proname =self.projectname.text;
    int trade = [PBKbnMasterModel getKbnIdByName:hangyehuafen.text withKind:@"industry"];
    pbprojectdata1.trade = trade;
    pbprojectdata1.introduce = self.projectjieshao.text;
    pbprojectdata1.stdate = self.projectstartime.text;
    int stage1 = [PBKbnMasterModel getKbnIdByName:_projectjieduan.text withKind:@"stage"];
    pbprojectdata1.stage = stage1;
    pbprojectdata1.modetype = pbprojectdata.modetype;
    pbprojectdata1.businessmode = pbprojectdata.businessmode;
    pbprojectdata1.financingamount = pbprojectdata.financingamount;
    pbprojectdata1.amountunit = pbprojectdata.amountunit;
    pbprojectdata1.rate = pbprojectdata.rate;
    pbprojectdata1.others = pbprojectdata.others;
    [pbprojectdata1 saveRecord];
    [acitivity stopAnimating];
    if ([self.mode isEqualToString:@"add"]) {
        if (self.type==2) {
            [self nextDidPush];
        }else{
            [self dismissModalViewControllerAnimated:YES];
            if (self.productno>0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"showalert" object:nil];
            }
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    [pbprojectdata1 release];
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
    return self.type==2?6:7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return 1;
}
#pragma mark - cell内容设置
-(void)addSubViewForCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [cell.contentView addSubview:picturelabel];
        cell.imageView.image = LogImageAC.image;
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = @"公司名称";
        [cell.contentView addSubview:companyname];
        
    }
    if (indexPath.section == 2) {
        cell.textLabel.text = lbtxt_projectname;
        [self addTextfiledForCell:cell];
        
    }
    if (indexPath.section == 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = lbtxt_hangyehuafen;
        [cell.contentView addSubview:hangyehuafen];
    }
    if (indexPath.section == 4) {
        [self addTextViewForCell:cell];
        
    }
    if (indexPath.section == 5)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = lbtxt_projectstartime;
        [cell.contentView addSubview:self.projectstartime];
    }
    if (indexPath.section == 6)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = lbtex_projectjieduan;
        [cell.contentView addSubview:_projectjieduan];
    }
    if (indexPath.section == 7) {
        cell.textLabel.text = lbtex_chuanyejingli;
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==4) {
        return lbtxt_projectjieshao;
    }
    else {
        return NULL;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
            return nil;
        }
        else
        {
            return [self TishiView];
        }
    }
    else {
        return nil;
    }
}

#pragma mark - IPAD 调试
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        height = 80.0f;
    }
    else if (indexPath.section == 4) {
        height = self.projectjieshao.contentSize.height;
        CGRect farm = self.projectjieshao.frame;
        farm.size.height = height;
        self.projectjieshao.frame = farm;
        if (self.projectjieshao.contentSize.height > 44.0f) {
            height = self.projectjieshao.contentSize.height;
            CGRect farm = self.projectjieshao.frame;
            farm.size.height = height;
            self.projectjieshao.frame = farm;
        }
        else {
            height = 44.0f;
            CGRect farm = self.projectjieshao.frame;
            farm.size.height = 44.0f;
            self.projectjieshao.frame = farm;
        }    
    }
    else if (indexPath.section != 0 && indexPath.section != 4) {
        height = 44.0f;
    }
    return height;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        [self logimgePicker];
//    }
    if (indexPath.section == 2) {
        [self.projectname becomeFirstResponder];
    }
    if (indexPath.section == 3) {
        [pop.view removeFromSuperview];
        pop._arry = industry;
        pop.view.hidden = !pop.view.hidden;
        [pop popClickAction];
    }
    if (indexPath.section ==4) {
        [self.projectjieshao becomeFirstResponder];
    }
    if (indexPath.section == 5) {
        [projectstartime becomeFirstResponder];
    }
    if (indexPath.section == 6) {
        [pop.view removeFromSuperview];       
        pop._arry = stage;
        pop.view.hidden = !pop.view.hidden;
        [pop popClickAction];
    }
    
}
#pragma mark -POPview delegate
- (void)popView:(POPView *)popview didSelectIndexPath:(NSIndexPath *)indexPath{
    if ([pop._arry isEqualToArray:industry]) {
        hangyehuafen.text = [popview._arry objectAtIndex:indexPath.row];
    }
    if ([pop._arry isEqualToArray:stage]) {
        _projectjieduan.text = [popview._arry objectAtIndex:indexPath.row];
    }
}

@end
