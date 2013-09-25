//
//  PBAddCompanyBand.m
//  ParkBusiness
//
//  Created by 上海 on 13-5-29.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBAddCompanyBand.h"
#import "PBAssureCompanyInfo.h"
//收藏的URL
#define URL [NSString stringWithFormat:@"%@/admin/index/searchcompanybondinfo",HOST]
#define SAVEURL [NSString stringWithFormat:@"%@/admin/index/addcompanybondinfo",HOST]
@interface PBAddCompanyBand ()
-(void)initPopView;
-(void)postOtherData;
-(void)SearchOnServer;
-(PBCompanyBondData *)dataZhuanhuan:(NSMutableDictionary *)dic;
@end

@implementation PBAddCompanyBand
@synthesize userinfos;
@synthesize pbdata;
@synthesize projectno;
@synthesize mode;
@synthesize type;
@synthesize productno;
-(void)dealloc
{
    [acitivity release];
    [userinfos release];
    [titleArr release];
    [issueamount release];
    [bondamount release];
    [yearprofit release];
    [others release];
    [bondtypelabel release];
    [debttoequity release];
    [bondtype release];
    [judgment release];
    [super dealloc];
}
- (void)viewLoding
{
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    acitivity = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    titleArr = [[NSMutableArray alloc]initWithObjects:@"企业概况:",@"企业债券期限类型:",@"发行总金额（万元）:",@"债券面额（万元）:",@"年收益率(%):", @"到期是否可债转股:",@"其他事项:",nil];
    
    [self initPopView];
    //本地取数据
    bondtype = [[NSMutableArray alloc]init];
    NSMutableArray *arry1 = [PBIndustryData search:@"bondtype"];
    for (PBIndustryData * industryData in arry1 ) {
        if (industryData.name != NULL) {
            [bondtype addObject:industryData.name];
        }
    }
    judgment = [[NSMutableArray alloc]init];
    NSMutableArray *arry2 = [PBIndustryData search:@"judgment"];
    for (PBIndustryData * industryData in arry2 ) {
        if (industryData.name != NULL) {
            [judgment addObject:industryData.name];
        }
    }
    [self backButton];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [issueamount resignFirstResponder];
    [bondamount resignFirstResponder];
    [yearprofit resignFirstResponder];
    [others resignFirstResponder];
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
    //设置收藏
    
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
        self.pbdata = [[PBCompanyBondData alloc]init];
        [self SearchOnServer];
    }else{//本地取数据
        if (!willAppear) {
            self.pbdata = [PBCompanyBondData searchData:self.projectno];
            willAppear = !willAppear;
        }
    }
    if ([self.mode isEqualToString:@"add"]) {
        [super editButtonPress:self.navigationItem.rightBarButtonItem];
    }
    [self initInputView];
    [self.tableView reloadData];
}

-(void)initInputView{
    for (int i = 0; i<[titleArr count]-1; i++){
        CGSize textSize = [[titleArr objectAtIndex:i+1] sizeWithFont:[UIFont boldSystemFontOfSize:16]];
        CGRect frame = CGRectMake(textSize.width+20, 5, self.tableView.frame.size.width-textSize.width-(isPad()?120:50), 35);
        if (i == 0) {
            bondtypelabel = [[UILabel alloc]initWithFrame:frame];
            bondtypelabel.backgroundColor = [UIColor clearColor];
            bondtypelabel.text = [PBKbnMasterModel getKbnNameById:self.pbdata.bondtype withKind:@"bondtype"];
        }
        if (i == 1) {
            issueamount = [[UITextField alloc]initWithFrame:frame];
            issueamount.text = [NSString stringWithFormat:@"%d",self.pbdata.issueamount];
        }
        if (i == 2) {
            bondamount = [[UITextField alloc]initWithFrame:frame];
            bondamount.text = [NSString stringWithFormat:@"%d",self.pbdata.bondamount];
            
        }
        if (i == 3) {
            yearprofit = [[UITextField alloc]initWithFrame:frame];
            yearprofit.text = [NSString stringWithFormat:@"%d",self.pbdata.yearprofit];
        }
        if (i == 4) {
            debttoequity = [[UILabel alloc]initWithFrame:frame];
            debttoequity.backgroundColor = [UIColor clearColor];
            debttoequity.text = [PBKbnMasterModel getKbnNameById:self.pbdata.debttoequity withKind:@"judgment"];
        }
        if (i == 5) {
            others = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-(isPad()?90:20), 120)];
            others.tag = 5;
            others.backgroundColor = [UIColor clearColor];
            others.textAlignment = UITextAlignmentLeft;
            others.delegate = self;
            others.text = self.pbdata.others;
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
-(PBCompanyBondData *)dataZhuanhuan:(NSMutableDictionary *)dic
{
    self.pbdata.bondtype = [[dic objectForKey:@"bondtype"] intValue];
    self.pbdata.issueamount = [[dic objectForKey:@"issueamount"] intValue];
    self.pbdata.bondamount = [[dic objectForKey:@"bondamount"] intValue];
    self.pbdata.yearprofit = [[dic objectForKey:@"yearprofit"] intValue];
    self.pbdata.debttoequity = [[dic objectForKey:@"debttoequity"] intValue];
    self.pbdata.others = [dic objectForKey:@"others"];
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
    NSArray *a1 = [[NSArray alloc]initWithObjects:@"mode", @"no",@"productno",@"userno",@"companyno",@"bondtype",@"issueamount",@"bondamount",@"yearprofit",@"debttoequity",@"others",nil];
    NSArray *a2 = [[NSArray alloc]initWithObjects:modes,
                   [NSString stringWithFormat:@"%d",self.pbdata.no],
                   [NSString stringWithFormat:@"%d",self.productno],
                   [NSString stringWithFormat:@"%d", [PBUserModel getUserId]],
                   [NSString stringWithFormat:@"%d",[PBUserModel getCompanyno]],
                   [NSString stringWithFormat:@"%d",self.pbdata.bondtype],
                   issueamount.text?issueamount.text:@"",
                   bondamount.text?bondamount.text:@"",
                   yearprofit.text?yearprofit.text:@"",
                   [NSString stringWithFormat:@"%d",self.pbdata.debttoequity],
                   self.pbdata.others,
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
        [self dismissModalViewControllerAnimated:YES];
        if (self.productno>0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showalert" object:nil];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)changePostDataFromView{
    self.pbdata.issueamount = [issueamount.text intValue];
    self.pbdata.bondamount= [bondamount.text intValue];
    self.pbdata.yearprofit =  [yearprofit.text intValue];
    self.pbdata.others = others.text?others.text:@"";
    
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
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]&&section==0) {
        return 0;
    }
    // Return the number of rows in the section.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 5) {
        return [titleArr objectAtIndex:section];
    }else {
        return nil;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]&&section==5) {
        labletag = section;
        return [self TishiView];
    }else{
        return nil;
    }
}


#pragma mark - cell内容设置
-(void)addSubViewForCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section<6) {
        cell.textLabel.text = [titleArr objectAtIndex:indexPath.section];
    }
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [[cell contentView] addSubview:bondtypelabel];
    }
    if (indexPath.section == 2) {
        
        [[cell contentView] addSubview:issueamount];
        
    }
    if (indexPath.section == 3) {
        [[cell contentView] addSubview:bondamount];
        
    }
    if (indexPath.section == 4) {
        [[cell contentView] addSubview:yearprofit];
    }
    if (indexPath.section == 5) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [[cell contentView] addSubview:debttoequity];
    }
    if (indexPath.section == 6) {
        [[cell contentView] addSubview:others];
        others.editable = !isedit;
        
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
    if (indexPath.section == 6) {
        return   [self textViewHeightWithView:others defaultHeight:44.0f];
    }
    return 44.0f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        if (indexPath.section == 0) {
            PBAssureCompanyInfo* company = [[PBAssureCompanyInfo alloc]initWithStyle:UITableViewStyleGrouped];
            company.ProjectStyle = ELSEPROJECTINFO;
            company.datadic = self.datadic;
            company.title = [titleArr objectAtIndex:0];
            company.type = 3;
            [self.navigationController pushViewController:company animated:YES];
        }
    }else{
        if (indexPath.section == 1) {
            [pop.view removeFromSuperview];
            pop._arry = bondtype;
            pop.name = @"企业债券期限类型";
            pop.view.hidden = !pop.view.hidden;
            [pop popClickAction];
        }
        if (indexPath.section ==5) {
            [pop.view removeFromSuperview];
            pop.name = @"到期是否可债转股";
            pop._arry = judgment;
            pop.view.hidden = !pop.view.hidden;
            [pop popClickAction];
        }
    }
}
#pragma mark -POPview delegate
- (void)popView:(POPView *)popview didSelectIndexPath:(NSIndexPath *)indexPath{
    if ([pop._arry isEqualToArray:bondtype]) {
        bondtypelabel.text = [popview._arry objectAtIndex:indexPath.row];
        self.pbdata.bondtype = indexPath.row+1;
    }else{
        debttoequity.text = [popview._arry objectAtIndex:indexPath.row];
        self.pbdata.debttoequity = indexPath.row;
    }
}
@end
