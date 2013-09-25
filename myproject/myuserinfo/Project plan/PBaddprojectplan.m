//
//  PBaddprojectplan.m
//  ParkBusiness
//
//  Created by 新平 圣 on 13-3-4.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBaddprojectplan.h"
#import "PBUserModel.h"
@interface PBaddprojectplan()
-(void)didApperDatas;//将要出现时，数据写入
-(void)xianshikuang;
@end
@implementation PBaddprojectplan
@synthesize feiyong_arry = _feiyong_arry;
@synthesize textfield_arry = _textfield_arry;
@synthesize textview_arry = _textview_arry;
@synthesize datepicker;
@synthesize _datas,number,className;
@synthesize projectno;
-(void)dealloc
{
    [activity release];
    [self.feiyong_arry = nil release];
    [self.textfield_arry = nil release];
    [self.textview_arry=nil release];
    [self.datepicker = nil release];
    [self._datas release];
    [totalbudget release];
    [stdate release];
    [salestarget release];
    [teambiulding release];
    [self.className release];
    
    [super dealloc];
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    activity = nil;
    self._datas = nil;
    totalbudget = nil;
    stdate = nil;
    salestarget = nil;
    productdev = nil;
    teambiulding = nil;
    productdev = nil;
    self.className = nil;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.view addSubview:activity];
    self.title = self.className;
    [self didApperDatas];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self xianshikuang];
     [activity removeFromSuperview];
}
-(void)didApperDatas
{
    PBPlanData *pbplandata;
    if ([self._datas count]!=0) {
        if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
            pbplandata = [[[PBPlanData alloc]init]autorelease];
            NSMutableDictionary *dic = [self._datas objectAtIndex:self.number];
            pbplandata.totalbudget = [dic objectForKey:@"totalbudget"];
            pbplandata.salestarget = [dic objectForKey:@"salestarget"];
            pbplandata.profittarget= [dic objectForKey:@"profittarget"];
            stdate.text = [dic objectForKey:@"stdate"];
            number = pbplandata.no;
            //textview
            teambiulding.text = [dic objectForKey:@"teambiulding"];
            productdev.text = [dic objectForKey:@"productdev"];
        }
        else {
            [self navigatorRightButtonType:BIANJI];
            pbplandata = [self._datas objectAtIndex:self.number];
        }
        totalbudget.text = pbplandata.totalbudget;
        salestarget.text = pbplandata.salestarget;
        profittarget.text = pbplandata.profittarget;
        stdate.text = pbplandata.stdate;
        number = pbplandata.no;
        //textview
        teambiulding.text = pbplandata.teambiulding;
        productdev.text = pbplandata.productdev;
        [self xianshikuang];
    } 
    else {
        [self navigatorRightButtonType:ZUIJIA];
        totalbudget.text = nil;
        stdate.text = nil;
        salestarget.text = nil;
        productdev.text = nil;
        teambiulding.text = nil;
        productdev.text = nil;
        profittarget.text = nil;
        [self editState];
    }
    
    
}
#pragma mark - 编辑状态
-(void)editState
{
    isedit = NO;
    totalbudget.borderStyle = UITextBorderStyleRoundedRect;
    profittarget.borderStyle = UITextBorderStyleRoundedRect;
    salestarget.borderStyle = UITextBorderStyleRoundedRect;
    [teambiulding setEditable:YES];
     [productdev setEditable:YES];
}
-(void)xianshikuang
{
    isedit = YES;
    totalbudget.borderStyle = UITextBorderStyleNone;
    profittarget.borderStyle = UITextBorderStyleNone;
    salestarget.borderStyle = UITextBorderStyleNone;
    [teambiulding setEditable:NO];
    [productdev setEditable:NO];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
//        [self initData];
        [self backButton];
    }
    return self;
}

-(void)viewLoding
{
    activity = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    [activity retain];
    self.feiyong_arry = [[[NSMutableArray alloc]initWithObjects:@"支出费用总运算(万元):",@"销售收入目标(万元):",@"盈亏目标(万元):", nil]autorelease];
    
    //textfield
    totalbudget = [[UITextField alloc]initWithFrame:CGRectMake(180, 0, 121, 44)];
    totalbudget.delegate = self;
    totalbudget.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    salestarget  = [[UITextField alloc]initWithFrame:CGRectMake(180, 0, 121, 44)];
    salestarget.delegate = self;
    salestarget.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    profittarget = [[UITextField alloc]initWithFrame:CGRectMake(180, 0, 121, 44)];  
    profittarget.delegate = self;
    profittarget.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    stdate = [[UITextField alloc]initWithFrame:CGRectMake(150, 0, 150, 44)];  
    stdate.delegate = self;
    stdate.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textfield_arry = [[[NSMutableArray alloc]initWithObjects:totalbudget,salestarget,profittarget,stdate,nil]autorelease];
    //textview
    teambiulding = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 300, 44)];
    teambiulding.backgroundColor = [UIColor clearColor];
    teambiulding.delegate = self;
    teambiulding.tag = 2;
    productdev = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 300, 44)];
    productdev.backgroundColor = [UIColor clearColor];
    productdev.delegate = self;
    productdev.tag = 3;
    self.textview_arry = [[NSMutableArray alloc]initWithObjects:teambiulding,productdev, nil];
    self.datepicker = [[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 200, 320, 250)]autorelease];
    datepicker.datePickerMode = UIDatePickerModeDate;
    CGFloat size;
    if (isPad()) {
        size = PadContentFontSize;
        totalbudget.frame = CGRectMake(RATIO*95, 0, 490, 44);
        salestarget.frame = CGRectMake(RATIO*95, 0, 490, 44);
        profittarget.frame = CGRectMake(RATIO*95, 0, 490, 44);
        stdate.frame = CGRectMake(RATIO*65, 0, 546, 44);
        teambiulding.frame = CGRectMake(0, 0, 679, 44);
        productdev.frame = CGRectMake(0, 0, 679, 44);
 
    }
    else {
        size = ContentFontSize;
    }
    totalbudget.font = [UIFont systemFontOfSize:size];
    salestarget.font = [UIFont systemFontOfSize:size];
    profittarget.font = [UIFont systemFontOfSize:size];
    stdate.font = [UIFont systemFontOfSize:size];
    teambiulding.font = [UIFont systemFontOfSize:size];
    productdev.font = [UIFont systemFontOfSize:size];
    [datepicker addTarget:self action:@selector(datePickerSeclect:) forControlEvents:UIControlEventValueChanged];
    //数据初始化
    self._datas = [[[NSMutableArray alloc]init]autorelease];
    

}
-(void)datePickerSeclect:(id)sender
{
    UIDatePicker* control = (UIDatePicker*)sender;
    
    NSDate *date = control.date;
    NSDateFormatter *formatter = [[[NSDateFormatter alloc]init]autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [[[NSString alloc]initWithFormat:@"%@",[formatter stringFromDate:date]]autorelease];
    UITextField *txt = [self.textfield_arry objectAtIndex:3];
    txt.text = str;
}
//点击空白处键盘显示方法
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    for (UITextField * x in self.textfield_arry) {
        [x resignFirstResponder]; 
        
    }
    for(UITextView * y in self.textview_arry)
    {
        [y resignFirstResponder];
    }
}

#pragma mark - 编辑与datas

-(void)postDataOnserver
{  
    [activity startAnimating];
    [self xianshikuang];
    NSString *mode;
    //上传到本地
    if ([self._datas count]!=0) {
        mode = @"mod";
    }
    else{
        mode = @"add";
        
    }
    //上传到服务器
    NSMutableArray *a1 = [NSMutableArray arrayWithObjects:@"mode",
                   @"companyno",
                   @"projectno",
                   @"no",
                   @"productdev",
                   @"profittarget",
                   @"salestarget",
                   @"teambiulding",
                   @"totalbudget",
                   @"stdate",
                   @"enddate", 
                   nil];
    NSMutableArray *a2 = [NSMutableArray arrayWithObjects:mode,
                   USERNO,
                   [NSString stringWithFormat:@"%d",self.projectno],
                   [NSString stringWithFormat:@"%d",number],
                   ((productdev.text==NULL)?@"":productdev.text),
                   ((profittarget.text==NULL)?@"":profittarget.text),
                   ((salestarget.text==NULL)?@"":salestarget.text),
                   ((teambiulding.text==NULL)?@"":teambiulding.text),
                   (totalbudget.text==NULL)?@"":totalbudget.text,
                   (stdate.text==NULL)?@"":stdate.text,
                   (stdate.text==NULL)?@"":stdate.text, 
                   nil];
    PBdataClass *pbdataclass = [PBdataClass sharePBdataClass];    
    pbdataclass.delegate =self;
    [pbdataclass dataResponse:[NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/addprojectplan",HOST]] postDic:[NSDictionary dictionaryWithObjects:a2 forKeys:a1] searchOrSave:NO];

}
/*
 上传成功
 */
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    keyno = [intvalue intValue];
    PBPlanData *pbplandata = [[PBPlanData alloc]init];
    //上传到本地
        pbplandata.no = keyno;
        pbplandata.productdev = productdev.text;
        pbplandata.profittarget = profittarget.text;
        pbplandata.salestarget = salestarget.text;
        pbplandata.teambiulding = teambiulding.text;
        pbplandata.totalbudget = totalbudget.text;
        pbplandata.stdate = stdate.text;
        pbplandata.enddate = stdate.text;
        pbplandata.projectno = self.projectno;
        pbplandata.companyno = [PBUserModel getUserId];
    [activity stopAnimating];
    [pbplandata saveRecord];
    
    [self viewTapped:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
/*
 获取失败
 */
-(void)searchFilad
{
    if (number>0) {
        [self editButtonPress:self.navigationItem.rightBarButtonItem];
    }else{
        [self editState];
    }
    
    [activity stopAnimating];
}
/*
 上传失败
 */
-(void)requestFilad
{
    [activity stopAnimating];
}
#pragma mark - 表
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 1) {
        return 3;
    }
    else
        return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    switch (indexPath.section) {
        case 0:
            height = 44.0f;
            break;
        case 1:
            height = 44.0f;
            break;
        case 2:
            {
                height = teambiulding.contentSize.height;
                CGRect farm = teambiulding.frame;
                farm.size.height = height;
                teambiulding.frame = farm;
                if (teambiulding.contentSize.height > 44.0f) {
                    height = teambiulding.contentSize.height;
                    CGRect farm = teambiulding.frame;
                    farm.size.height = height;
                    teambiulding.frame = farm;
                }
                else {
                    height = 44.0f;
                    CGRect farm = teambiulding.frame;
                    farm.size.height = 44.0f;
                    teambiulding.frame = farm;
                } 
            }
            break;
        case 3:
            {
                height = productdev.contentSize.height;
                CGRect farm = productdev.frame;
                farm.size.height = height;
                productdev.frame = farm;
                if (productdev.contentSize.height > 44.0f) {
                    height = productdev.contentSize.height;
                    CGRect farm = productdev.frame;
                    farm.size.height = height;
                    productdev.frame = farm;
                }
                else {
                    height = 44.0f;
                    CGRect farm = productdev.frame;
                    farm.size.height = 44.0f;
                    productdev.frame = farm;
                } 
            }
            break;
        default:
            return FALSE;
            break;
    }
    return height;
}

-(void)addSubViewForCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        cell.textLabel.text = @"项目开始时间:";
        [cell.contentView addSubview:[self.textfield_arry objectAtIndex:3]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      
    }
    if (indexPath.section ==1) {
             cell.textLabel.text = [self.feiyong_arry objectAtIndex:indexPath.row];
        if (indexPath.row == 0) {
            [cell.contentView addSubview:[self.textfield_arry objectAtIndex:0]];
        }
        if (indexPath.row == 1) {
            [cell.contentView addSubview:[self.textfield_arry objectAtIndex:1]];
        }
        if (indexPath.row == 2) {
            [cell.contentView addSubview:[self.textfield_arry objectAtIndex:2]];
        }
      }
    if (indexPath.section == 2) {
        [cell.contentView addSubview:[self.textview_arry objectAtIndex:0]];
    }
    if (indexPath.section == 3) {
        [cell.contentView addSubview:[self.textview_arry objectAtIndex:1]];
        
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *str;
    switch (section) {
        case 2:
            str =  @"团队建设:";
            return str;
            break;
        case 3:
            str =  @"产品开发:";
            return str;
            break;       
        default:
            return nil;
            break;
    }
    [str release];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    labletag = section;
    if (section == 2) {
        return  [self TishiView];
    }
    if (section == 3) {
        return [self TishiView];
    }
    else {
        return nil;
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.keyboardType = UIKeyboardTypeNumberPad;
    if (textField == [self.textfield_arry objectAtIndex:3]) {
        textField.inputView = self.datepicker;
        UIToolbar* toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 460, 320, 44)];
    
        UIBarButtonItem* btn = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_wc", nil)
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(donePush:)];
        UIBarButtonItem* btn1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    toolBar.items = [NSArray arrayWithObjects:btn1,btn, nil];
        textField.inputAccessoryView = toolBar;
    }

}
-(void)donePush:(id)sender
{
    [stdate resignFirstResponder];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[NSString stringWithFormat:@"%d",textView.tag] forKey:@"tag"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"300" object:[NSNumber numberWithInt:textView.text.length -1]userInfo:dic];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
