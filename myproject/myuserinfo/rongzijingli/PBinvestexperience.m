//
//  PBinvestexperience.m
//  ParkBusiness
//
//  Created by lywes lee on 13-4-19.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBinvestexperience.h"
#import "PBIndustryData.h"
#import "PBKbnMasterModel.h"
@interface PBinvestexperience ()
-(void)kbmaster;//本地kbmaster表
-(void)POPViewForKbmaster:(POPView *)popview;//本地kbmaster表视图
-(void)viewApperData;
-(void)xianshikuang;
-(void)DataZhuanHuan;
@end

@implementation PBinvestexperience
@synthesize namearry;
@synthesize stage,unit;
@synthesize unitview,stageview;
@synthesize data;
@synthesize projectno;
-(void)dealloc
{
    [activity release];
    [self.data release];
    [lablearry release];
    [textfieldarry release];
    [self.unitview release];
    [self.stageview release];
    [self.unit release];
    [self.stage release];
    [self.namearry release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.title = @"";
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    activity = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    [activity retain];
    self.namearry = [NSMutableArray arrayWithObjects:@"融资时间:",@"阶段:",@"额度:",@"单位:",@"投资机构/投资人:", nil];
    textfieldarry = [[NSMutableArray alloc]init];
    lablearry = [[NSMutableArray alloc]init];
    [lablearry retain];
    [self kbmaster];
    _stage = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, 200, 30)];
    _stage.backgroundColor = [UIColor clearColor];
    _unit = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, 200, 30)];
    _unit.backgroundColor = [UIColor clearColor];

    if (isPad()) {
        _stage.frame = CGRectMake(RATIO*100, 5, RATIO*200, 30);
        _unit.frame = CGRectMake(RATIO*100, 5, RATIO*200, 30);
    }
    
    if (isPad()) {
        _anmout = [[UITextField alloc]initWithFrame:CGRectMake(RATIO*45, 0, 586, 44)];
        _stadate = [[UITextField alloc]initWithFrame:CGRectMake(RATIO*45, 0, 586, 44)];
        _touziren = [[UITextField alloc]initWithFrame:CGRectMake(RATIO*85, 0, 506, 44)];
    }
    else {
        _anmout = [[UITextField alloc]initWithFrame:CGRectMake(85, 0, 215, 44)];
        _stadate = [[UITextField alloc]initWithFrame:CGRectMake(85, 0, 215, 44)];
        _touziren = [[UITextField alloc]initWithFrame:CGRectMake(140, 0, 160, 44)];
    }
    _anmout.delegate = self;
    _anmout.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _stadate.delegate = self;
    _stadate.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _touziren.delegate = self;
    _touziren.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [textfieldarry addObject:_anmout];
    [textfieldarry addObject:_stadate];
    [textfieldarry addObject:_touziren];
    [self initDetaPicker];

}
-(void)kbmaster
{
    //本地kbmaster表
    self.stage = [[[NSMutableArray alloc]init]autorelease];
    NSMutableArray *arry1 = [PBIndustryData search:@"projectstage"];
    for (PBIndustryData * industryData in arry1 ) {
        if (industryData.name != NULL) {
            [self.stage addObject:industryData.name];
        }
    }
    self.unit = [[[NSMutableArray alloc]init]autorelease];
    NSMutableArray *a1 = [PBIndustryData search:@"unit"];
    for(PBIndustryData *industrydata in a1)
    {
        if (industrydata.name!=NULL) {
            [self.unit addObject:industrydata.name];
        }
    }
    self.stageview =[[POPView alloc]init];
    self.stageview.delegate = self;
    self.stageview._arry = self.stage;
    self.stageview.view.hidden = YES;
    [self.view addSubview:self.stageview.view];
    
    self.unitview =[[POPView alloc]init];
    self.unitview.delegate = self;
    self.unitview._arry = self.unit;
    self.unitview.view.hidden = YES;
    [self.view addSubview:self.unitview.view];
    [self.stageview release];
    [self.unitview release];
}
-(void)POPViewForKbmaster:(POPView *)popview
{
    [popview.view removeFromSuperview];
    popview.view.hidden = !popview.view.hidden;
    [popview popClickAction];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.view addSubview:activity];
    if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
         self.tableView.allowsSelection = NO;
        [self DataZhuanHuan];
    }
    else {
         [self viewApperData];
    }
}
-(void)DataZhuanHuan
{
    self.data = [[PBrongzijingliData alloc]init];
    NSString *amouStr = [self.datadic objectForKey:@"amountunit"];
    data.amountunit = amouStr.intValue;
    data.investors = [self.datadic objectForKey:@"investors"];
    data.invsetamount = [self.datadic objectForKey:@"invsetamount"];
    NSString *stageStr = [self.datadic objectForKey:@"invsetstage"];
    data.invsetstage = stageStr.intValue;
    data.financetime = [self.datadic objectForKey:@"financetime"];
    [self viewApperData];
}
-(void)viewApperData
{
    NSString *invsetstage_ = [PBKbnMasterModel getKbnNameById:self.data.invsetstage withKind:@"projectstage"];
    _stage.text = invsetstage_;
    
    NSString *amountunit_ = [PBKbnMasterModel getKbnNameById:self.data.amountunit withKind:@"unit"];
    _unit.text = amountunit_;
    _stadate.text = self.data.financetime;
    _anmout.text = self.data.invsetamount;
    _touziren.text = self.data.investors;
    if (!self.data) {
        [self editState];
    }
    [self.tableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self xianshikuang];
    [activity removeFromSuperview];

}
-(void)xianshikuang
{
    isedit = YES;
    [_touziren setBorderStyle:UITextBorderStyleNone];
    [_anmout setBorderStyle:UITextBorderStyleNone];
}
-(void)editState
{
    isedit = NO;
    [_touziren setBorderStyle:UITextBorderStyleRoundedRect];
    [_anmout setBorderStyle:UITextBorderStyleRoundedRect];
}
-(void)postDataOnserver
{
    [activity startAnimating];
    [self xianshikuang];
    PBdataClass *pbdataclass = [[PBdataClass alloc]init];   
    pbdataclass.delegate =self;
    NSString *str;
    if (self.data.no) {
        str = @"mod";
    }
    else {
        str = @"add";
    }
    NSArray *a1 = [NSArray arrayWithObjects:@"mode",
                   @"projectno",
                   @"no",
                   @"invsetstage",
                   @"invsetamount",
                   @"financetime",
                   @"amountunit", 
                   @"investors",
                   nil];
    NSArray *a2 = [NSArray arrayWithObjects:str,
                   [NSString stringWithFormat:@"%d",self.projectno],
                   [NSString stringWithFormat:@"%d",self.data.no],
                   [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:_stadate.text withKind:@"projectstage"]]==NULL?@"":[NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:_stadate.text withKind:@"projectstage"]],
                   _anmout.text==NULL?@"":_anmout.text,
                   _stadate.text==NULL?@"":_stadate.text,
                   [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:_unit.text withKind:@"unit"]]==NULL?@"":[NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:_unit.text withKind:@"unit"]],
                   _touziren.text == NULL?@"":_touziren.text,
                   nil];
    [pbdataclass dataResponse:[NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/addinvestexperience",HOST]]
                      postDic:[NSDictionary dictionaryWithObjects:a2 forKeys:a1] searchOrSave:NO];
}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    if (intvalue >0) {
        PBrongzijingliData *db = [[[PBrongzijingliData alloc]init]autorelease];
        db.no = [intvalue intValue];
        db.projectno = self.projectno;
        int stage_ = [PBKbnMasterModel getKbnIdByName:_stage.text withKind:@"projectstage"];
        db.invsetstage = stage_;
        db.invsetamount = _anmout.text;
        db.investors = _touziren.text;
        db.financetime = _stadate.text;
        
        int unit_ = [PBKbnMasterModel getKbnIdByName:_unit.text withKind:@"unit"];
        db.amountunit = unit_;
        [db saveRecord];
        [activity stopAnimating];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [activity stopAnimating];
        UIAlertView *aletview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"上传失败" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) otherButtonTitles:nil, nil];
        [aletview show];
        [aletview release];
    }
   
}
/*
 上传失败
 */
-(void)requestFilad
{
    [activity stopAnimating];
}
-(void)searchFilad{
    if (self.data.no) {
        [self editButtonPress:self.navigationItem.rightBarButtonItem];
    }else{
        [self editState];
    }
    
    [activity stopAnimating];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        cell.textLabel.text = [self.namearry objectAtIndex:indexPath.section];
        if (indexPath.section == 1) {
            [cell.contentView addSubview:_stage];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.section == 2) {
             [cell.contentView addSubview:_anmout];
        }
        if (indexPath.section == 3) {
            [cell.contentView addSubview:_unit];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.section == 0) {
             [cell.contentView addSubview:_stadate];
             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.section == 4) {
             [cell.contentView addSubview:_touziren];
        }
    } 
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    for (UITextField *text in textfieldarry) {
        [text resignFirstResponder];
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    UITableViewCell *cell = (UITableViewCell *)[[textField superview]superview];
    
    CGRect frame = cell.frame;
    
    int offset = frame.origin.y  - (self.view.frame.size.height - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    float width = self.view.frame.size.width;
    
    float height = self.view.frame.size.height;
    
    if(offset > 0)
        
    {
        
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        
        self.view.frame = rect;
        
    }
    
    [UIView commitAnimations];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
    
    [textField resignFirstResponder];
    
    
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        [self POPViewForKbmaster:self.stageview];
    }
    if (indexPath.section == 3) {
        [self POPViewForKbmaster:self.unitview];
    }
}
-(void)popView:(POPView *)popview didSelectIndexPath:(NSIndexPath *)indexPath
{
    if (stageview == popview) {
        _stage.text = [popview._arry objectAtIndex:indexPath.row];
    }
    if (unitview == popview) {
        _unit.text = [popview._arry objectAtIndex:indexPath.row];
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
-(void)initDetaPicker
{
    //时间选择器
    UIDatePicker* datepicker = [[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 200, 320, 250)]autorelease];
    datepicker.datePickerMode = UIDatePickerModeDate;
    [datepicker addTarget:self action:@selector(datePickerSeclect:) forControlEvents:UIControlEventValueChanged];
    _stadate.inputView = datepicker;
    UIToolbar* toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 460, 320, 44)];
    
    UIBarButtonItem* btn = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_wc", nil)
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(donePush:)];
    UIBarButtonItem* btn1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    toolBar.items = [NSArray arrayWithObjects:btn1,btn, nil];
    _stadate.inputAccessoryView = toolBar;
}
-(void)datePickerSeclect:(id)sender
{
    UIDatePicker* control = (UIDatePicker*)sender;
    
    NSDate *date = control.date;
    NSDateFormatter *formatter = [[[NSDateFormatter alloc]init]autorelease];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString *str = [[[NSString alloc]initWithFormat:@"%@",[formatter stringFromDate:date]]autorelease];
    _stadate.text = str;
}
-(void)donePush:(id)sender
{
    [_stadate resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
