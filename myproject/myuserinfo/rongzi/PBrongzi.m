//
//  PBrongzi.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-5.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define SEARCHRONGZI [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchprojectneed",HOST]]
#import "PBrongzi.h"
#import "PBIndustryData.h"
#import "PBUserModel.h"
#import "PBKbnMasterModel.h"
@interface PBrongzi ()
-(void)searchInserver;
-(void)viewApperData;
@end

@implementation PBrongzi
@synthesize textfield_arry = _textfield_arry,stringbili_arry = _stringbili_arry,stringdanwei_arry = _stringdanwei_arry;
@synthesize pbprojectdata;
@synthesize projectno;
-(void)dealloc
{
    [activity release];
    [self.textfield_arry=nil release];
    [self.stringdanwei_arry=nil release];
    [self.stringbili_arry = nil  release];
    [amountunit release];
    [financingamount release];
    [rate release];
    [amountunitview release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    amountunit = nil;
    financingamount = nil;
    rate = nil;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"项目融资需求";        
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [activity removeFromSuperview];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSubview:activity];
    if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        self.tableView.allowsSelection = NO;
        [self searchInserver];
    }
    else {
        [self navigatorRightButtonType:BIANJI];
        self.pbprojectdata = [PBProjectData searchImagePath:self.projectno];
        [self viewApperData];
    }
  
}
-(void)viewApperData
{
    financingamount.text = self.pbprojectdata.financingamount;
    NSString *text_ = [PBKbnMasterModel getKbnNameById:self.pbprojectdata.amountunit withKind:@"unit"];
    amountunit.text = text_;    
    NSString *rate_ = [PBKbnMasterModel getKbnNameById:self.pbprojectdata.rate withKind:@"rate"];
    rate.text = rate_;
    self.projectjieshao.text = self.pbprojectdata.others;
}
#pragma mark - 服务器取数据
-(void)searchInserver
{
    [activity startAnimating]; 
    PBdataClass *dataclass = [[PBdataClass alloc]init];
    dataclass.delegate = self;
    [dataclass dataResponse:SEARCHRONGZI postDic:[NSDictionary dictionaryWithObjectsAndKeys:[self.datadic objectForKey:@"companyno"],@"companyno",[self.datadic objectForKey:@"no"],@"projectno", nil] searchOrSave:YES];
}
/*
 获取失败
 */
-(void)searchFilad
{
    [self editButtonPress:self.navigationItem.rightBarButtonItem];
    [activity stopAnimating]; 
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    if ([datas count]>0) {
        NSDictionary *dic = [datas objectAtIndex:0];
        self.pbprojectdata = [[PBProjectData alloc]init]; 
        NSString *amountunitStr = [dic objectForKey:@"amountunit"];
        NSString *financingamountStr = [dic objectForKey:@"financingamount"];
        NSString *rateStr = [dic objectForKey:@"rate"];
        self.pbprojectdata.amountunit = amountunitStr.intValue;
        self.pbprojectdata.financingamount = financingamountStr;
        self.pbprojectdata.others = [dic objectForKey:@"others"];
        self.pbprojectdata.rate = rateStr.intValue;
        [self viewApperData];
        [self.pbprojectdata release];
    }
    [activity stopAnimating]; 
}
#pragma mark - 编辑与上传服务器
-(void)postDataOnserver
{
    [activity startAnimating];
    financingamount.borderStyle = UITextBorderStyleNone;
    self.projectjieshao_tishi.hidden = YES;
    //上传到服务器
    PBdataClass *pbdataclass = [[PBdataClass alloc]init];    
    pbdataclass.delegate = self;
    NSArray *a1 = [NSArray arrayWithObjects:@"mode",
                   @"companyno",
                   @"no",
                   @"amountunit",
                   @"financingamount",
                   @"others",
                   @"rate", 
                   nil];
    NSArray *a2 = [NSArray arrayWithObjects:@"mod",
                   USERNO,
                   [NSString stringWithFormat:@"%d",self.pbprojectdata.no],
                   [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:amountunit.text withKind:@"unit"]]==NULL?@"":[NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:amountunit.text withKind:@"unit"]],                   
                   financingamount.text==NULL?@"":financingamount.text,
                   self.projectjieshao.text==NULL?@"":self.projectjieshao.text,
                   [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:rate.text withKind:@"rate"]]==NULL?@"":[NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:rate.text withKind:@"rate"]],
                   nil];
    [pbdataclass dataResponse:[NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/addprojectneed",HOST]]
 postDic:[NSDictionary dictionaryWithObjects:a2 forKeys:a1] searchOrSave:NO];
}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    //上传到本地
//    PBProjectData *data = [[[PBProjectData alloc]init]autorelease];
    self.pbprojectdata.companyno = [PBUserModel getUserId];
    self.pbprojectdata.no = self.pbprojectdata.no;
    self.pbprojectdata.proname =self.pbprojectdata.proname;
    self.pbprojectdata.trade = self.pbprojectdata.trade;
    self.pbprojectdata.introduce = self.pbprojectdata.introduce;
    self.pbprojectdata.stdate =self.pbprojectdata.stdate;
    self.pbprojectdata.stage = self.pbprojectdata.stage;
    self.pbprojectdata.financingamount = financingamount.text;
    
    int unit_ = [PBKbnMasterModel getKbnIdByName:amountunit.text withKind:@"unit"];
    self.pbprojectdata.amountunit = unit_;
    
    int rate_ = [PBKbnMasterModel getKbnIdByName:rate.text withKind:@"rate"];
    self.pbprojectdata.rate = rate_;
    self.pbprojectdata.others = self.projectjieshao.text;
    self.pbprojectdata.businessmode = self.pbprojectdata.businessmode;
    self.pbprojectdata.modetype = self.pbprojectdata.modetype;
    self.pbprojectdata.imagepath = self.pbprojectdata.imagepath;
    [self.pbprojectdata saveRecord];
    [activity stopAnimating];
    [self.navigationController popViewControllerAnimated:YES];

}
/*
 上传失败
 */
-(void)requestFilad
{
    [activity stopAnimating];
}
-(void)editButtonPress:(id)sender
{
    financingamount.borderStyle = UITextBorderStyleRoundedRect;
    isedit = !isedit;
    if (isedit == NO) {
        self.tableView.allowsSelection = YES;
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"nav_btn_wc", nil);
        self.projectjieshao_tishi.hidden = NO;
    }
    else
    {
        self.tableView.allowsSelection = NO;
        self.navigationItem.rightBarButtonItem.title = @"编辑";
        [financingamount resignFirstResponder];
        [self postDataOnserver];
        [self.projectjieshao resignFirstResponder];


    }
}

#pragma mark - 表
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 4;
}
-(void)addSubViewForCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        cell.textLabel.text = @"融资额度:";
        [cell addSubview:[self.textfield_arry objectAtIndex:0]];
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = @"融资单位:";
        [cell addSubview:[self.textfield_arry objectAtIndex:1]];
    }
    if (indexPath.section == 2) {
        cell.textLabel.text = @"出让股权比例:";
        [cell addSubview:[self.textfield_arry objectAtIndex:2]];
    }
    if (indexPath.section == 3) {
        [self addTextViewForCell:cell];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        NSString *str = @"其他需求:";
        return str;
    }
    else {
        return nil;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
            return nil;
        }
        else {
             return [self TishiView];
        }
    }
    else {
        return nil;
    }
}
#pragma mark - txtfield协议
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (isedit) {
        return NO;
    }
    else
        return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    for (UITextField * x in self.textfield_arry) {
        [x resignFirstResponder]; 
        
    }
    return YES; 
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [financingamount resignFirstResponder];
    [self.projectjieshao resignFirstResponder];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        [amountunitview.view removeFromSuperview];
        amountunitview.view.hidden = !amountunitview.view.hidden;
        [amountunitview popClickAction];
    }
    if (indexPath.section == 2) {
        [rateview.view removeFromSuperview];
        rateview.view.hidden = !rateview.view.hidden;
        [rateview popClickAction];
    }
}
- (void)popView:(POPView *)popview didSelectIndexPath:(NSIndexPath *)indexPath{
    if (popview == amountunitview) {
        amountunit.text = [self.stringdanwei_arry objectAtIndex:indexPath.row];

    }
    if (popview == rateview) {
        rate.text = [self.stringbili_arry objectAtIndex:indexPath.row];
        
    }
}
-(void)donePush:(id)sender
{
    UITextField *xx = (UITextField *)sender;
    [self textFieldShouldReturn:xx];
}
- (void)viewLoding
{
    activity = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    [activity retain];
    //textfield 初始化
    financingamount = [[[UITextField alloc]initWithFrame:CGRectMake(120, 0, 190, 44)]autorelease];
    financingamount.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    financingamount.delegate = self;
    financingamount.keyboardType = UIKeyboardTypeNumberPad;
    amountunit = [[[UILabel alloc]initWithFrame:CGRectMake(150, 7, 150, 30)]autorelease];
    amountunit.backgroundColor = [UIColor clearColor];
    rate = [[[UILabel alloc]initWithFrame:CGRectMake(150, 7, 150, 30)]autorelease];  
    /* Pad适配
     */
    CGFloat textsize;
    if (isPad()) {
        textsize = PadContentFontSize;
        financingamount.frame = CGRectMake(RATIO*68, 0, 585, 44);
        amountunit.frame = CGRectMake(RATIO *200, 10, RATIO *150, 45);
        rate.frame = CGRectMake(RATIO *200, 10, RATIO *150, 45);
    }
    else {
        textsize = ContentFontSize;
    }
    financingamount.font = [UIFont systemFontOfSize:textsize];
    amountunit.font = [UIFont systemFontOfSize:textsize];
    rate.font = [UIFont systemFontOfSize:textsize];
    rate.backgroundColor = [UIColor clearColor];
    
    
   self.textfield_arry = [[[NSMutableArray alloc]initWithObjects:financingamount,amountunit,rate,nil]autorelease];
    //界面数据
    self.stringdanwei_arry = [[[NSMutableArray alloc]init]autorelease];
    self.stringbili_arry = [[[NSMutableArray alloc]init]autorelease];
    //POPView与本地表
    NSMutableArray *a1 = [PBIndustryData search:@"unit"];
    for(PBIndustryData *industrydata in a1)
    {
        if (industrydata.name!=NULL) {
            [self.stringdanwei_arry addObject:industrydata.name];
        }
    }
    amountunitview = [[POPView alloc]init];
    amountunitview._arry = self.stringdanwei_arry;
    amountunitview.delegate = self;
    amountunitview.view.hidden = YES;
    [self.view addSubview:amountunitview.view];
    
    NSMutableArray *a2 = [PBIndustryData search:@"rate"];
    for(PBIndustryData *industrydata in a2)
    {
        if (industrydata.name!=NULL) {
            [self.stringbili_arry addObject:industrydata.name];
        }
    }
    rateview = [[POPView alloc]init];
    rateview._arry = self.stringbili_arry;
    rateview.delegate = self;
    rateview.view.hidden = YES;
    [self.view addSubview:rateview.view];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if (indexPath.section == 3) {
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
    else
    {
        height = 44.0f;
    }
    return height;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
