//
//  PBAddInsureInfo.m
//  ParkBusiness
//
//  Created by 上海 on 13-6-2.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBAddInsureInfo.h"
#define URL [NSString stringWithFormat:@"%@/admin/index/searchinsureinfo",HOST]
#define SAVEURL [NSString stringWithFormat:@"%@/admin/index/addinsureinfo",HOST]
@interface PBAddInsureInfo ()
-(void)postOtherData;
-(void)SearchOnServer;
//-(PBCompanyBondData *)dataZhuanhuan:(NSMutableDictionary *)dic;
@end

@implementation PBAddInsureInfo
@synthesize userinfos;
@synthesize projectno;
@synthesize mode;
@synthesize type;
-(void)dealloc
{
    [acitivity release];
    [userinfos release];
    [titleArr release];
    [insurelimit release];
    [insurename release];
    [paynum release];
    [unit release];
    [others release];
    [super dealloc];
}
- (void)viewLoding
{
    NSArray* arr = [[NSArray alloc]initWithObjects:@"insurename",@"insurelimit",@"unit",@"paynum",@"others", nil];
    self.userinfos = [[NSMutableDictionary alloc]init];
    for (NSString* key in arr) {
        [self.userinfos setObject:@"" forKey:key];
    }
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    acitivity = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    titleArr = [[NSMutableArray alloc]initWithObjects:@"保险产品名称:",@"保险期限(年):",@"产品单价（万元）:",@"购买份数:",@"其他事项:",nil];

}

-(void)backUpView
{
    if ([self.mode isEqualToString:@"add"]) {
        [self dismissModalViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [paynum resignFirstResponder];
    [others resignFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated{
    [acitivity removeFromSuperview];
    [self viewTapped:nil];
    [self initInputView];
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
        [self SearchOnServer];
    }else{//本地取数据
        if (!willAppear) {
            isedit = NO;
            [self.userinfos setObject:[self.datadic objectForKey:@"name"] forKey:@"insurename"];
            [self.userinfos setObject:[self.datadic objectForKey:@"insurelimit"] forKey:@"insurelimit"];
            [self.userinfos setObject:[self.datadic objectForKey:@"unit"] forKey:@"unit"];
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
            insurename = [[UILabel alloc]initWithFrame:frame];
            insurename.text = [self.userinfos objectForKey:@"insurename"];
        }
        if (i == 1) {
            insurelimit = [[UILabel alloc]initWithFrame:frame];
            insurelimit.text = [self.userinfos objectForKey:@"insurelimit"];
        }
        if (i == 2) {
            unit = [[UILabel alloc]initWithFrame:frame];
            unit.text = [self.userinfos objectForKey:@"unit"];
            
        }
        if (i == 3) {
            paynum = [[UITextField alloc]initWithFrame:frame];
            paynum.text = [self.userinfos objectForKey:@"paynum"];
        }
        if (i == 4) {
            others = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-(isPad()?90:20), 120)];
            others.tag = 5;
            others.backgroundColor = [UIColor clearColor];
            others.textAlignment = UITextAlignmentLeft;
            others.delegate = self;
            others.text = [self.userinfos objectForKey:@"others"];
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
    [acitivity stopAnimating];
}
/*
 上传成功
 */
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    if (datas.count > 0) {
        [self.userinfos removeAllObjects];
        [self.userinfos setDictionary:[datas objectAtIndex:0]];
    }
    [self initInputView];
    [acitivity stopAnimating];
    [self.tableView reloadData];
}
/*
 上传失败
 */
-(void)requestFilad
{
    [acitivity stopAnimating];
}
//-(PBCompanyBondData *)dataZhuanhuan:(NSMutableDictionary *)dic
//{
//    self.pbdata.bondtype = [[dic objectForKey:@"bondtype"] intValue];
//    self.pbdata.issueamount = [[dic objectForKey:@"issueamount"] intValue];
//    self.pbdata.bondamount = [[dic objectForKey:@"bondamount"] intValue];
//    self.pbdata.yearprofit = [[dic objectForKey:@"yearprofit"] intValue];
//    self.pbdata.debttoequity = [[dic objectForKey:@"debttoequity"] intValue];
//    self.pbdata.others = [dic objectForKey:@"others"];
//    [self.tableView reloadData];
//    return self.pbdata;
//}
#pragma mark - 数据上传到服务器
-(void)postDataOnserver
{
    [acitivity startAnimating];
    [self postOtherData];
    
}


-(void)postOtherData
{
//    [self changePostDataFromView];
    PBdataClass *pb = [[PBdataClass alloc]init];
    pb.delegate = self;
    NSArray *a1 = [[NSArray alloc]initWithObjects:@"mode", @"no",@"userno",@"insureno",@"paynum",@"others",nil];
    NSArray *a2 = [[NSArray alloc]initWithObjects:@"add",
                   @"-1",
                   [NSString stringWithFormat:@"%d", [PBUserModel getUserId]],
                   [self.datadic objectForKey:@"no"],
                   paynum.text?paynum.text:@"",
                   others.text?others.text:@"",
                   nil];
    [pb dataResponse:[NSURL URLWithString:SAVEURL] postDic:[[NSDictionary alloc]initWithObjects:a2 forKeys:a1] searchOrSave:NO];
    
}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    
    //上传到本地
//    self.pbdata.no = intvalue;
//    [self.pbdata saveRecord];
    [acitivity stopAnimating];
    [self dismissModalViewControllerAnimated:YES];
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的申请已成功提交！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    [alert release];
//    if ([self.mode isEqualToString:@"add"]) {
//        [self dismissModalViewControllerAnimated:YES];
//    }else{
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    
}

//-(void)changePostDataFromView{
//    self.pbdata.issueamount = [issueamount.text intValue];
//    self.pbdata.bondamount= [bondamount.text intValue];
//    self.pbdata.yearprofit =  [yearprofit.text intValue];
//    self.pbdata.others = others.text?others.text:@"";
//    
//}
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 4) {
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
    if (indexPath.section<4) {
        cell.textLabel.text = [titleArr objectAtIndex:indexPath.section];
    }
    if (indexPath.section == 0) {
        [[cell contentView] addSubview:insurename];
    }
    if (indexPath.section == 1) {
        [[cell contentView] addSubview:insurelimit];
    }
    if (indexPath.section == 2) {
        
        [[cell contentView] addSubview:unit];
        
    }
    if (indexPath.section == 3) {
        [[cell contentView] addSubview:paynum];
        
    }
    if (indexPath.section == 4) {
        [[cell contentView] addSubview:others];
        others.editable = !isedit;
        
    }
    for (UITextField* textField in [[cell contentView] subviews]) {
        if ([textField isKindOfClass:[UITextField class]]) {
            [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [textField setEnabled:!isedit];
            [textField setBorderStyle:UITextBorderStyleNone];
        }
    }
    if (!isedit) {
        [paynum setBorderStyle:UITextBorderStyleRoundedRect];
        paynum.keyboardType = UIKeyboardTypeNumberPad;
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
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
//        if (indexPath.section == 0) {
//            PBAssureCompanyInfo* company = [[PBAssureCompanyInfo alloc]initWithStyle:UITableViewStyleGrouped];
//            company.ProjectStyle = ELSEPROJECTINFO;
//            company.datadic = self.datadic;
//            company.title = [titleArr objectAtIndex:0];
//            company.type = 3;
//            [self.navigationController pushViewController:company animated:YES];
//        }
//    }else{
//        if (indexPath.section == 1) {
//            [pop.view removeFromSuperview];
//            pop._arry = bondtype;
//            pop.name = @"企业债券期限类型";
//            pop.view.hidden = !pop.view.hidden;
//            [pop popClickAction];
//        }
//        if (indexPath.section ==5) {
//            [pop.view removeFromSuperview];
//            pop.name = @"到期是否可债转股";
//            pop._arry = judgment;
//            pop.view.hidden = !pop.view.hidden;
//            [pop popClickAction];
//        }
//    }
}

@end
