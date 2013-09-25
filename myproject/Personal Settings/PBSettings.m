//
//  PBSettings.m
//  ParkBusiness
//
//  Created by lywes lee on 13-4-9.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBSettings.h"
#import "PBUserModel.h"
#import "PBInvestmentSettingViewController.h"
#import "PBKbnMasterModel.h"
#import "PBCompanyChoose.h"
#import "PBchooesjigou.h"
#import "PBAddCompanyView.h"
@interface PBSettings ()
-(void)initview;
-(void)showActionSheet;
-(void)postTextOnServer;
@end

@implementation PBSettings
@synthesize imageview;
@synthesize datas;
@synthesize dic;
@synthesize keys;
@synthesize touzianli;
-(void)dealloc
{
    [activity release];
    [pic=nil release];
    [self.datas=nil release];
    [self.imageview=nil release];
    [sc1=nil release];
    [sc2=nil release];
    [sc3=nil release];
    [sc4=nil release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewStyle)style withString:(NSString *)str
{
    self = [super initWithStyle:style];
    if (self) {
        self.touzianli = str;    
        [self initview];
        [self navigatorRightButtonType:WANCHEN];

    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [activity removeFromSuperview];

}
-(void)viewWillAppear:(BOOL)animated
{
    [self.view addSubview:activity];
    [self.tableView reloadData];
}
- (void)initview
{
    [super viewDidLoad];
    self.title = @"个人账户";
    self.tableView.allowsSelection = YES;
    activity = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    [activity retain];
    pic=[[UIImageView alloc]init];
    sc1 = [[NSArray alloc]initWithObjects:@"姓名:",@"性别:",@"ID:", nil];
    sc2 = [[NSArray alloc]initWithObjects:@"公司:",@"职务:",self.touzianli, nil];
    sc3 = [[NSArray alloc]initWithObjects:@"邮箱:",@"QQ:",@"所在城市:", nil];
    sc4 = [[NSArray alloc]initWithObjects:@"新浪微博:",@"Linkedln:",@"Facebook:",@"twitter:", nil];
    self.keys = [NSMutableArray arrayWithObjects:@"姓名:",@"性别:",@"ID:",@"个性签名:",@"公司:",@"职务:",self.touzianli,@"邮箱:",@"QQ:",@"所在城市:",@"新浪微博:",@"Linkedln:",@"Facebook:",@"twitter:",@"companyno",@"companyjob", nil];
    
    head = [[NSMutableDictionary alloc]init];//头像
    NSMutableArray *value = [[[NSMutableArray alloc]init]autorelease];
    NSMutableArray *arry1 = [PBShezhiData searchBy:[PBUserModel getUserId]];
    if([arry1 count]>0){
        for (PBShezhiData *shezhidata1 in arry1) {
            [head setValue:shezhidata1.imagepath forKey:@"imagepath"];
            [value addObject:shezhidata1.name == NULL?@"":shezhidata1.name];
            
            [value addObject:[PBKbnMasterModel getKbnNameById:shezhidata1.sex withKind:@"sex"] == NULL?@"":[PBKbnMasterModel getKbnNameById:shezhidata1.sex withKind:@"sex"]];
            
            [value addObject:[NSString stringWithFormat:@"%d",shezhidata1.no]];
            [value addObject:shezhidata1.signature == NULL?@"":shezhidata1.signature];
            
            [value addObject:shezhidata1.companyname == NULL?@"":shezhidata1.companyname];
            NSString* jobStr = [PBKbnMasterModel getKbnNameById:shezhidata1.companyjob withKind:@"job"];
            [value addObject:jobStr == NULL?@"":jobStr];
            if ([self.touzianli isEqualToString:@"投资相关设置"]) {
                [value addObject:@""];
            }
            else
            {
                [value addObject:[PBKbnMasterModel getKbnNameById:shezhidata1.trade withKind:@"industry"] == NULL?@"":[PBKbnMasterModel getKbnNameById:shezhidata1.trade withKind:@"industry"]];
            }
            [value addObject:shezhidata1.emailaddress == NULL?@"":shezhidata1.emailaddress];
            [value addObject:shezhidata1.qq == NULL?@"":shezhidata1.qq];
            
            [value addObject:[PBKbnMasterModel getKbnNameById:shezhidata1.city withKind:@"province"] == NULL?@"":[PBKbnMasterModel getKbnNameById:shezhidata1.city withKind:@"province"]];
            
            [value addObject:shezhidata1.sinablog == NULL?@"":shezhidata1.sinablog];
            [value addObject:shezhidata1.linkedin == NULL?@"":shezhidata1.linkedin];
            [value addObject:shezhidata1.skype == NULL?@"":shezhidata1.skype];
            [value addObject:shezhidata1.msn == NULL?@"":shezhidata1.msn];
            NSString* comapnyNo = [NSString stringWithFormat:@"%d",shezhidata1.companyno];
            [value addObject:comapnyNo == NULL?@"":comapnyNo];
            NSString* jobNo = [NSString stringWithFormat:@"%d",shezhidata1.companyjob];
            [value addObject:jobNo == NULL?@"":jobNo];
        }
        self.dic = [NSMutableDictionary dictionaryWithObjects:value forKeys:keys];
        
    }
    sex = [[NSMutableArray alloc]init]; 
    NSMutableArray *model = [PBIndustryData search:@"sex"];
    for (PBIndustryData *industrydata in model) {
        if (industrydata.name != NULL) {
            [sex addObject:industrydata.name];
        }
    }
    industry = [[NSMutableArray alloc]init];
    NSMutableArray *arry = [PBIndustryData search:@"industry"];
    for (PBIndustryData * industryData in arry ) {
        if (industryData.name != NULL) {
            [industry addObject:industryData.name];
        }
    }
    city = [[NSMutableArray alloc]init];
    NSMutableArray *cc = [PBIndustryData search:@"province"];
    for (PBIndustryData * industryData in cc) {
        if (industryData.name != NULL) {
            [city addObject:industryData.name];
        }
    }
    companyjob = [[NSMutableArray alloc]init];
    NSMutableArray *jobArr = [PBIndustryData search:@"job"];
    for (PBIndustryData * jobData in jobArr ) {
        if (jobData.name != NULL) {
            [companyjob addObject:jobData.name];
        }
    }
    sexpop  = [[POPView alloc]init];
    sexpop._arry = sex;
    sexpop.name = @"性别";
    sexpop.view.hidden = YES;
    sexpop.delegate = self;
    [self.view addSubview:sexpop.view];
    hangyepop  = [[POPView alloc]init];
    hangyepop._arry = industry;
    hangyepop.name = @"行业划分";
    hangyepop.view.hidden = YES;
    hangyepop.delegate = self;
    [self.view addSubview:hangyepop.view];   
    suozaichengshi  = [[POPView alloc]init];
    suozaichengshi._arry = city;
    suozaichengshi.name = @"城市";
    suozaichengshi.view.hidden = YES;
    suozaichengshi.delegate = self;
    [self.view addSubview:suozaichengshi.view];
    jobpop  = [[POPView alloc]init];
    jobpop._arry = companyjob;
    jobpop.name = @"职务";
    jobpop.view.hidden = YES;
    jobpop.delegate = self;
    [self.view addSubview:jobpop.view];

}
-(void)viewDidLoad
{

}
#pragma mark - cell内容设置
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int i;
    switch (section) {
        case 0:
             i= 1;
            break;
        case 1:
             i= 3;
            break;
        case 2:
             i= 1;
            break;
        case 3:{
            PBUserModel* user = [PBUserModel getPasswordAndKind];
            i= user.kind==3?2:3;
        }
            break;
        case 4:
            i= 3;
            break;
        case 5:
             i= 4;
            break;
        default:
            i = 0;
            break;
    }
    return i;
}

-(void)addSubViewForCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{   
    UILabel *lable = [[[UILabel alloc]initWithFrame:CGRectMake(100, 5, 180, 30)]autorelease];
    if (isPad()) {
        lable.frame = CGRectMake(RATIO*100, 5, RATIO*200, 30);
    }
    UIFont *font = [UIFont systemFontOfSize:isPad()?PadContentFontSmallSize:ContentFontSmallSize];
    lable.backgroundColor = [UIColor clearColor];
    lable.lineBreakMode = UILineBreakModeMiddleTruncation;
    lable.numberOfLines = 0;
    lable.font = font;
    if (indexPath.section == 0) {
        UIImage *image = [head objectForKey:@"imagepath"];
        if (image!=nil) {
            cell.imageView.image = image ;
        }
        [cell.contentView addSubview:lable];
        lable.text = @"上传头像";
        
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = [sc1 objectAtIndex:indexPath.row];
    }
    if (indexPath.section == 2) {
        cell.textLabel.text = @"个性签名:";
        cell.textLabel.hidden = YES;

    }
    if (indexPath.section == 3) {
        cell.textLabel.text = [sc2 objectAtIndex:indexPath.row];
    }
    if (indexPath.section == 4) {
        cell.textLabel.text = [sc3 objectAtIndex:indexPath.row];
    }
    if (indexPath.section == 5) {
        cell.textLabel.text = [sc4 objectAtIndex:indexPath.row];

    }
    if (indexPath.section!=0) {        
        [cell.contentView addSubview:lable];
        if (indexPath.section == 2) {
            if (isPad()) {
                lable.frame = CGRectMake(2, 0, 660, 44);
              
            }
            else {
                lable.frame = CGRectMake(4, 0, 279, 44);
            }
            CGFloat  contentWidth = 250;
            lable.text = [self.dic objectForKey:cell.textLabel.text];
            lable.numberOfLines = 0;
            lable.textAlignment = UITextAlignmentLeft;
            NSString *str = [self.dic objectForKey:@"个性签名:"];
            CGSize size = [str sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:UILineBreakModeWordWrap];
            CGFloat  height = MAX(size.height, 44.0f);
            CGSize rectf = lable.frame.size;
            rectf.height = height;
            lable.frame = CGRectMake(2,0,rectf.width,rectf.height);

        }
        else
        {
            lable.text = [self.dic objectForKey:cell.textLabel.text];
        }
    }


    if (indexPath.section == 1 && indexPath.row == 2) {
         cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        NSString *str = @"个性签名";
        return str;
    }
    else {
        return nil;   
    }
    
}
-(void)pushviewBy:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{

    pbtextfield = [[PBtextField alloc]initWithStyle:UITableViewStyleGrouped];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *lable = [cell.contentView.subviews objectAtIndex:0];
    pbtextfield.equstr = lable.text;
    pbtextfield.setting = self;
    pbtextfield.tableview1 = tableView;
    pbtextfield.indepath = indexPath;
    [pbtextfield.textfield becomeFirstResponder];
    [self.navigationController pushViewController:pbtextfield animated:YES];
    [pbtextfield release];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self showActionSheet];
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            [sexpop.view removeFromSuperview];
            sexpop.view.hidden = !sexpop.view.hidden;
            [sexpop popClickAction];
        }
        if (indexPath.row!=2 && indexPath.row!=1) {
            [self pushviewBy:tableView indexPath:indexPath];
        }
    }
    if (indexPath.section == 2) {
        [self pushviewBy:tableView indexPath:indexPath];
    }
    if (indexPath.section == 3) {
        if (indexPath.row==0) {
            //跳转公司
            if ([PBUserModel getPasswordAndKind].kind==2) {//企业家
                PBAddCompanyView* company = [[PBAddCompanyView alloc]init];
                company.title = @"公司详细";
                company.popController = self;
                [company navigatorRightButtonType:BIANJI];
                [self.navigationController pushViewController:company animated:YES];
             
            }
            
        }else if (indexPath.row==1){
            [jobpop.view removeFromSuperview];
            jobpop.view.hidden = !jobpop.view.hidden;
            [jobpop popClickAction];
        }else {
            if ([self.touzianli isEqualToString:@"行业划分:"]) {
                [hangyepop.view removeFromSuperview];
                hangyepop.view.hidden = !hangyepop.view.hidden;
                [hangyepop popClickAction];
            }
            else {
                PBInvestmentSettingViewController *set = [[[PBInvestmentSettingViewController alloc]init]autorelease];
                [self.navigationController pushViewController:set animated:YES];
            }
           
        }
    }
    if (indexPath.section == 4) {
        if (indexPath.row!=2) {
            [self pushviewBy:tableView indexPath:indexPath];
        }
        else {
            [suozaichengshi.view removeFromSuperview];
            suozaichengshi.view.hidden = !suozaichengshi.view.hidden;
            [suozaichengshi popClickAction];
        }
    }
    if (indexPath.section == 5) {	
        [self pushviewBy:tableView indexPath:indexPath];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if (indexPath.section == 2) {
        NSString *str = [self.dic objectForKey:@"个性签名:"];
        CGFloat  contentWidth = 250;
        UIFont *font = [UIFont systemFontOfSize:isPad()?PadContentFontSmallSize:ContentFontSmallSize];
        CGSize size = [str sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:UILineBreakModeWordWrap];
        height = MAX(size.height, 44.0f);
    }
    else {
        height = 44.0f;
    }
    return height;
}
#pragma - mark update sever
-(void)postDataOnserver
{
    //上传头像到服务器
    [activity startAnimating];
    if (NewImage) {
        PBdataClass *pbdataclass = [[PBdataClass alloc]init];
        pbdataclass.delegate = self;
        [pbdataclass PostImageResponse:[NSURL URLWithString:[NSString stringWithFormat:@"%@admin/index/uploaduserinfoicon",HOST]] postImage:pic.image Forkey:@"uploadedfile" postOtherDic:[NSDictionary dictionaryWithObjectsAndKeys:USERNO,@"id", nil] searchOrSave:NO];
    }
    else {
        [self postTextOnServer];
    }
}
-(void)imageIsSuccesePostOnServer:(int)intvalue
{
    keyno = intvalue;
    if (keyno != 0) {
        [self postTextOnServer];
    }
    else {
        UIAlertView *aletview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"上传失败" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) otherButtonTitles:nil, nil];
        [aletview show];
        [aletview release];
        [activity stopAnimating];
    }
}
-(void)postTextOnServer
{
    NSMutableArray * keys1 = [NSMutableArray arrayWithObjects:@"mod",@"no",
                              @"name",
                              @"sex",
                              @"signature",
                              @"companyno",
                              @"companyjob",
                              @"trade",
                              @"emailaddress",
                              @"qq",
                              @"city",
                              @"sinablog",
                              @"linkedin",
                              @"skype",
                              @"msn",
                              nil];
    NSMutableArray *value = [NSMutableArray arrayWithObjects:
                             @"mod",
                             [self.dic objectForKey:@"ID:"],
                             [self.dic objectForKey:@"姓名:"],
                             [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:[self.dic objectForKey:@"性别:"] withKind:@"sex"]]== NULL?@"":[NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:[self.dic objectForKey:@"性别:"] withKind:@"sex"]],
                             [self.dic objectForKey:@"个性签名:"],
                             [self.dic objectForKey:@"companyno"],
                             [self.dic objectForKey:@"companyjob"],
                             [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:[self.dic objectForKey:@"行业划分:"] withKind:@"industry"]] == NULL?@"":[NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:[self.dic objectForKey:@"行业划分:"] withKind:@"industry"]],
                             [self.dic objectForKey:@"邮箱:"],
                             [self.dic objectForKey:@"QQ:"],
                             [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:[self.dic objectForKey:@"所在城市:"] withKind:@"province"]] == NULL?@"":[NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:[self.dic objectForKey:@"所在城市:"] withKind:@"province"]],
                             [self.dic objectForKey:@"新浪微博:"],
                             [self.dic objectForKey:@"Linkedln:"],
                             [self.dic objectForKey:@"Facebook:"],
                             [self.dic objectForKey:@"twitter:"],
                             nil];
    NSMutableDictionary*postdic = [NSMutableDictionary dictionaryWithObjects:value forKeys:keys1];
    PBdataClass *dataclass = [[PBdataClass alloc]init];
    dataclass.delegate = self;
    dataclass.validate = NO;
    [dataclass dataResponse:[NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/updatesettinguser",HOST]] postDic:postdic searchOrSave:NO];
    UIAlertView *aletview = [[UIAlertView alloc]initWithTitle:nil message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [aletview show];
    [aletview release];
}
/*
 获取失败
 */
-(void)searchFilad
{
    [activity stopAnimating];
}
-(void)requestFilad
{
    [activity stopAnimating];
}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    if (NewImage) {
        [PBShezhiData SaveImage1:pic.image userid:[PBUserModel getUserId]];
    }
    NSMutableDictionary* dics = self.dic;
    [dics setObject:[self.dic objectForKey:@"companyno"] forKey:@"公司:"];
    [PBShezhiData saveRecord:dics];
    [activity stopAnimating];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - POPVIEW
- (void)popView:(POPView *)popview didSelectIndexPath:(NSIndexPath *)indexPath
{
    if (sexpop==popview) {
        [self.dic removeObjectForKey:@"性别:"];
        [self.dic setValue:[sexpop._arry objectAtIndex:indexPath.row] forKey:@"性别:"];
    }
    if (hangyepop==popview) {
        [self.dic removeObjectForKey:@"行业划分:"];
        [self.dic setValue:[hangyepop._arry objectAtIndex:indexPath.row] forKey:@"行业划分:"];

    }
    if (suozaichengshi == popview) {
        [self.dic removeObjectForKey:@"所在城市:"];
        [self.dic setValue:[suozaichengshi._arry objectAtIndex:indexPath.row] forKey:@"所在城市:"];
    }
    if (jobpop==popview) {
        [self.dic removeObjectForKey:@"职务:"];
        [self.dic setObject:[NSString stringWithFormat:@"%d",indexPath.row+1] forKey:@"companyjob"];
        [self.dic setValue:[jobpop._arry objectAtIndex:indexPath.row] forKey:@"职务:"];
        
    }
    [self.tableView reloadData];
}
#pragma mark - ImagePickerView delegate
-(void)resultImage:(UIImage *)image
{
    pic.image = image;
    [head removeObjectForKey:@"imagepath"];
    [head setValue:image forKey:@"imagepath"];
    NewImage = image;
    [self.tableView reloadData];
}
#pragma mark - 头像
-(void)showActionSheet
{
    if (imagepickerview) {
        [imagepickerview release];
    }
    imagepickerview = [[ImagePickerView alloc]initWithView:self];
    imagepickerview.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
