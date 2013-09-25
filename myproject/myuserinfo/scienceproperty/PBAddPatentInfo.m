//
//  PBAddPatentInfo.m
//  ParkBusiness
//
//  Created by 上海 on 13-5-25.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBAddPatentInfo.h"
#import "PBIndustryData.h"
#import "PBUserModel.h"
#import "PBKbnMasterModel.h"
#define SEARCHONSERVER [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchpatentinfo",HOST]]
#define SAVEURL [NSString stringWithFormat:@"%@/admin/index/addpatentinfo",HOST]
@interface PBAddPatentInfo ()
-(void)initDetaPicker:(UITextField*)textfield withTag:(int)tag;
-(void)initPopView;
-(void)postOtherData;
-(void)SearchOnServer;
-(void)dataZhuanhuan:(NSMutableDictionary *)dic;
@end

@implementation PBAddPatentInfo

@synthesize userinfos;
@synthesize pbdata;
@synthesize projectno;
@synthesize mode;
@synthesize type;
-(void)dealloc
{
    [acitivity release];
    [name release];
    [patentno release];
    [acceptdate release];
    [authorizedate release];
    [datestring release];
    [pbdatepicker release];
    [pop release];
    [patentStr release];
    [patenttype release];
    [formatter release];
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
    self.pbdata = [[PBPatantData alloc]init];
    CGRect frame = CGRectMake(0, 0, isPad()?768:320, isPad()?1024:isPhone5()?568:480);
    self.view.frame = frame;
    self.navigationController.view.frame = frame;
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    acitivity = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    
    titleArr = [[NSMutableArray alloc]initWithObjects:@"专利名称:",@"专利类型:",@"专利号码:",@"受理时间:",@"授权时间:", nil];
    [self initPopView];
    //本地取下拉列表数据
    patenttype = [[NSMutableArray alloc]init];
    NSMutableArray *arry = [PBIndustryData search:@"patent"];
    for (PBIndustryData * industryData in arry ) {
        if (industryData.name != NULL) {
            [patenttype addObject:industryData.name];
        }
    }
    formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [self backButton];
    
}


-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [name resignFirstResponder];
    [patentno resignFirstResponder];
    [acceptdate resignFirstResponder];
    [authorizedate resignFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated{
    [acitivity removeFromSuperview];
    [self viewTapped:nil];
}
-(void)initPopView
{
    //弹出选择画面
    pop =[[POPView alloc]init];
    pop.delegate = self;
    pop.name = @"专利类型";
    pop.view.hidden = YES;
    [self.view addSubview:pop.view];
}
-(void)initDetaPicker:(UITextField*)textfield withTag:(int)tag
{
    //时间选择器
    UIDatePicker* datepicker = [[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 200, 320, 250)]autorelease];
    datepicker.datePickerMode = UIDatePickerModeDate;
    datepicker.tag =tag;
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
    if (control.tag == 1) {
        acceptdate.text = str;
    }else{
        authorizedate.text = str;
    }
    
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
        [self SearchOnServer];
    }
    if ([self.mode isEqualToString:@"add"]) {
        isedit = NO;
    }
    [self initInputView];
    [self.tableView reloadData];
    
    
}

-(void)initInputView{
    for (int i = 0; i<[titleArr count]; i++) {
        CGSize textSize = [[titleArr objectAtIndex:i] sizeWithFont:[UIFont boldSystemFontOfSize:16]];
        CGRect frame = CGRectMake(textSize.width+20, 5, self.tableView.frame.size.width-textSize.width-(isPad()?120:50), 35);
        if (i == 0) {
            name = [[UITextField alloc]initWithFrame:frame];
            name.text = self.pbdata.name;
        }
        if (i == 1) {
            if (!patentStr) {
                patentStr = [[UILabel alloc]initWithFrame:frame];
                patentStr.backgroundColor = [UIColor clearColor];
                patentStr.text = [PBKbnMasterModel getKbnNameById:self.pbdata.type withKind:@"patent"];
            }
            
        }
        if (i == 2) {
            patentno = [[UITextField alloc]initWithFrame:frame];
            patentno.text = self.pbdata.patentno;
        }
        if (i == 3) {
            acceptdate = [[UITextField alloc]initWithFrame:frame];
            acceptdate.text = [formatter stringFromDate:self.pbdata.acceptdate];
            acceptdate.textAlignment = UITextAlignmentCenter;
            [self initDetaPicker:acceptdate withTag:1];
            acceptdate.tag = 9;
            }
        if (i == 4)
        {
            authorizedate = [[UITextField alloc]initWithFrame:frame];
            authorizedate.text = [formatter stringFromDate:self.pbdata.authorizedate] ;
            authorizedate.textAlignment = UITextAlignmentCenter;
            [self initDetaPicker:authorizedate withTag:2];
            authorizedate.tag = 9;
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
    [pb dataResponse:SEARCHONSERVER postDic:[NSDictionary dictionaryWithObjectsAndKeys:[self.userinfos objectForKey:@"projectno"],@"no",[self.userinfos objectForKey:@"companyno"],@"companyno", nil]searchOrSave:YES];
    
}
/*
 获取失败
 */
-(void)searchFilad
{
    if (![self.mode isEqualToString:@"add"]) {
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
    [acitivity stopAnimating];
}
/*
 上传失败
 */
-(void)requestFilad
{
    [acitivity stopAnimating];
}
-(void)dataZhuanhuan:(NSMutableDictionary *)dic
{
    self.pbdata.name = [dic objectForKey:@"name"];
    self.pbdata.patentno = [dic objectForKey:@"patentno"];
    self.pbdata.type = [[dic objectForKey:@"type"] intValue];
    self.pbdata.acceptdate =[formatter dateFromString:(NSString*)[dic objectForKey:@"acceptdate"]] ;
    self.pbdata.authorizedate =[formatter dateFromString:(NSString*)[dic objectForKey:@"authorizedate"]] ;
    [self initInputView];
}
#pragma mark - 数据上传到服务器
-(void)postDataOnserver
{
    [acitivity startAnimating];
    [self postOtherData];
}
-(void)imageIsSuccesePostOnServer:(int)intvalue
{
    
}

-(void)postOtherData
{
    [self changePostDataFromView];
    PBdataClass *pb = [[PBdataClass alloc]init];
    pb.delegate = self;
    NSArray *a1 = [[NSArray alloc]initWithObjects:@"mode",@"no",@"projectno",@"name",@"type",@"patentno",@"acceptdate",@"authorizedate", nil];
    NSArray *a2 = [[NSArray alloc]initWithObjects:self.mode,
                   [NSString stringWithFormat:@"%d",self.pbdata.no],
                   [NSString stringWithFormat:@"%d",self.pbdata.projectno],
                   self.pbdata.name,
                   [NSString stringWithFormat:@"%d",self.pbdata.type],
                   self.pbdata.patentno,
                   acceptdate.text?acceptdate.text:@"",
                   authorizedate.text?authorizedate.text:@"",
                   nil];
    [pb dataResponse:[NSURL URLWithString:SAVEURL] postDic:[[NSDictionary alloc]initWithObjects:a2 forKeys:a1] searchOrSave:NO];
}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    
    //上传到本地
    self.pbdata.no = [intvalue intValue];
    [self.pbdata saveRecord];
    [acitivity stopAnimating];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)changePostDataFromView{
    if ([self.mode isEqualToString:@"add"]) {
        self.pbdata.projectno = self.projectno;
        self.pbdata.name = name.text?name.text:@"";
    }
    self.pbdata.patentno = patentno.text?patentno.text:@"";
    self.pbdata.acceptdate = [formatter dateFromString:acceptdate.text];
    self.pbdata.authorizedate = [formatter dateFromString:authorizedate.text];
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
    if ([self.mode isEqualToString:@"mod"]&&section==0) {
        return 0;
    }
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
        [[cell contentView] addSubview:patentStr];
        
    }
    if (indexPath.section == 2) {
        [[cell contentView] addSubview:patentno];
    }
    if (indexPath.section == 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [[cell contentView] addSubview:acceptdate];
    }
    if (indexPath.section == 4)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [[cell contentView] addSubview:authorizedate];
    }
    for (UITextField* textField in [[cell contentView] subviews]) {
        if ([textField isKindOfClass:[UITextField class]]) {
            [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [textField setEnabled:!isedit];
            if (isedit) {
                [textField setBorderStyle:UITextBorderStyleNone];
            }else if (textField.tag!=9){
                [textField setBorderStyle:UITextBorderStyleRoundedRect];
            }
        }
    }
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section==3) {
//        return lbtxt_projectjieshao;
//    }
//    else {
//        return NULL;
//    }
//}


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
        pop._arry = patenttype;
        pop.view.hidden = !pop.view.hidden;
        [pop popClickAction];
    }
    
}
#pragma mark -POPview delegate
- (void)popView:(POPView *)popview didSelectIndexPath:(NSIndexPath *)indexPath{
    
    patentStr.text = [popview._arry objectAtIndex:indexPath.row];
    self.pbdata.type = indexPath.row+1;
}

@end
