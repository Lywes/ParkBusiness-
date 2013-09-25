//
//  PBtableViewEdit.m
//  ParkBusiness
//
//  Created by 新平 圣 on 13-3-1.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define  SWTAG 400
#import "PBzuijia.h"
#import "PBIndustryData.h"
#import "PBUserModel.h"
#import "PBKbnMasterModel.h"
#import "UIImageView+WebCache.h"
@interface PBzuijia()
-(void)logimgePicker;
-(void)fromOherPlace;
-(void)postOtherData;
@end
@implementation PBzuijia
@synthesize swith1,swith2;
@synthesize textlable_arry;
@synthesize memberinfos;
@synthesize number;
@synthesize projectno;
@synthesize ProjectStyle;
-(void)dealloc
{
    [picturelable release];
    [activity release];
    [swith1=nil release];
    [swith2=nil release];
    [self.memberinfos release];
    [self.textlable_arry release];
    [pop release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        
    }
    return self;
}
-(void)viewLoding
{
    activity = [[PBActivityIndicatorView alloc]initWithFrame:self.tableView.frame];
    [activity retain];
    self.memberinfos = [[[NSMutableArray alloc]init]autorelease];
    self.swith1 = [[[UISwitch alloc]init]autorelease];
    self.swith2 = [[[UISwitch alloc]init]autorelease];
    swith1.tag = SWTAG;
    swith2.tag = SWTAG+1;
    [swith1 addTarget:self action:@selector(swithPress:) forControlEvents:UIControlEventValueChanged];
     [swith2 addTarget:self action:@selector(swithPress:) forControlEvents:UIControlEventValueChanged];
    self.textlable_arry = [NSArray arrayWithObjects:@"姓名:",@"团队角色:",@"背景介绍:",@"工作年数:",@"结婚:",@"项目经历:", nil];
    if (isPad()) {
        teamjob = [[UILabel alloc]initWithFrame:CGRectMake(RATIO*140, 15, RATIO*140, 15)];
        years = [[UITextField alloc]initWithFrame:CGRectMake(RATIO*140, 7, RATIO*140, 30)]; 
        LogImageAC = [[UIImageView alloc]initWithFrame:CGRectMake(RATIO*130, 0, 64, 64)];
         picturelable = [[UILabel alloc]initWithFrame:CGRectMake(250, 0, 300, 80)];
    }
    else {
        teamjob = [[UILabel alloc]initWithFrame:CGRectMake(140, 15, 140, 15)];
        years = [[UITextField alloc]initWithFrame:CGRectMake(140, 7, 140, 30)];
        LogImageAC = [[UIImageView alloc]initWithFrame:CGRectMake(130, 0, 64, 64)];
         picturelable = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, 100, 80)];
    }
    picturelable.text = @"上传头像";
    picturelable.backgroundColor = [UIColor clearColor];
    picturelable.hidden = YES;
    [picturelable retain];
    teamjob.backgroundColor = [UIColor clearColor];
    years.keyboardType = UIKeyboardTypeNumberPad;
    years.delegate = self;
    //本地表   
    NSMutableArray *job = [[[NSMutableArray alloc]init]autorelease];
    NSMutableArray *job1 =  [PBIndustryData search:@"job"];
    for(PBIndustryData *industrydata in job1)
    {
        if (industrydata.name != NULL) {
            [job addObject:industrydata.name];
        }
    }
    pop = [[POPView alloc]init];
    pop.delegate = self;
    pop.view.hidden = YES;
    pop._arry = job;
    [self.view addSubview:pop.view];


}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     [activity removeFromSuperview];
    keyno = 0;
}
-(void)viewWillAppear:(BOOL)animated
{
   
    [self.view addSubview:activity];
    if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        [self fromOherPlace];
    }  
    else {
        if ([self.memberinfos count]!=0) {
            self.title = @"信息";
            isedit = YES;
            [swith1 setEnabled:NO];
            [swith2 setEnabled:NO];
            PBteamData *teamdata = [self.memberinfos objectAtIndex:self.number];
            if ([teamdata.married isEqualToString:@"1"]) {
                swith1.on = YES;            
            }
            else {
                swith1.on = NO;
            }
            if ([teamdata.experience isEqualToString:@"1"]) {
                swith2.on = YES;
            }
            else {
                swith2.on = NO;
            }
            self.projectname.text  = teamdata.name;
            self.projectjieshao.text = teamdata.introduce;       
            NSString *job = [PBKbnMasterModel getKbnNameById:teamdata.teamjob withKind:@"job"];
             teamjob.text = job;
            years.text = teamdata.years;
            no = teamdata.no;
            if (!LogImageAC.image) {
                LogImageAC.image = teamdata.imagepath;
            }
        }
        else
        {
            self.title = @"追加新成员";
            isedit = NO;
            self.textViewAndtextFieldHidden = NO;
            picturelable.hidden = NO;
            [years setBorderStyle:UITextBorderStyleRoundedRect];
            self.projectjieshao_tishi.hidden = NO;
            self.projectname.text  = nil;
            self.projectjieshao.text = nil;
            teamjob.text = nil;
            years.text = nil;
        }
    }
    [self.tableView reloadData];
    
    
}
-(void)fromOherPlace
{
    if ([self.memberinfos count]>0) {
        self.title = @"信息";
        isedit = YES;
        self.tableView.allowsSelection = NO;
        [swith1 setEnabled:NO];
        [swith2 setEnabled:NO];
        NSDictionary *dic = [self.memberinfos objectAtIndex:self.number];
        if ([[dic objectForKey:@"married"] isEqualToString:@"1"]) {
            swith1.on = YES;            
        }
        else {
            swith1.on = NO;
        }
        if ([[dic objectForKey:@"experience"] isEqualToString:@"1"]) {
            swith2.on = YES;
        }
        else {
            swith2.on = NO;
        }
        self.projectname.text  = [dic objectForKey:@"name"];
        self.projectjieshao.text = [dic objectForKey:@"introduce"];
        NSString *str = [dic objectForKey:@"teamjob"];
        int job = str.intValue;
        teamjob.text = [PBKbnMasterModel getKbnNameById:job withKind:@"job"];        
        years.text = [dic objectForKey:@"years"];
         no = (int)[dic objectForKey:@"no"];
        NSString *imagepath = [NSString stringWithFormat:@"%@%@",HOST,[dic objectForKey:@"imagepath"]];
        [LogImageAC setImageWithURL:[NSURL URLWithString:imagepath]];
//        LogImageAC.image =[dic objectForKey:@"imagepath"];
        
    }
}
-(void)addSubViewForCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [cell.contentView addSubview:picturelable];
        cell.imageView.image  = LogImageAC.image;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = [self.textlable_arry objectAtIndex:0];
        [self addTextfiledForCell:cell];
    }
    if (indexPath.section == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [self.textlable_arry objectAtIndex:1];
        [cell.contentView addSubview:teamjob];
    }
    if (indexPath.section == 3) {
        [self addTextViewForCell:cell];
        
    }
    if (indexPath.section == 4)
    {
        cell.textLabel.text = [self.textlable_arry objectAtIndex:3];
        [cell.contentView  addSubview:years];
    }
    if (indexPath.section == 5)
    {
        cell.textLabel.text = [self.textlable_arry objectAtIndex:4];
        self.swith1.center = CGPointMake(250, 25);
        if (isPad()) {
            self.swith1.center = CGPointMake(RATIO*250, 25);
        }
        [cell.contentView  addSubview:self.swith1];

    }
    if (indexPath.section == 6) {
        cell.textLabel.text = [self.textlable_arry objectAtIndex:5];
        self.swith2.center = CGPointMake(250, 25);
        if (isPad()) {
            self.swith2.center = CGPointMake(RATIO*250, 25);
        }
        [cell.contentView  addSubview:self.swith2];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if (indexPath.section == 0) {
        height = 80.0f;
    }
   else if (indexPath.section == 3) {
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
   else {
        height = 44.0f;
   }
    return height;  
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(void)swithPress:(id)sender
{
    UISwitch *sw = (UISwitch *)sender;
    if (sw == swith1) {
        [sw setOn:sw.on animated:YES];
    }
    if (sw == swith2) {
        [sw setOn:sw.on animated:YES];
    }
}
#pragma mark - 编辑状态
-(void)editState
{
    picturelable.hidden = NO;
    [years setBorderStyle:UITextBorderStyleRoundedRect];
    self.projectjieshao_tishi.hidden = NO;
    [swith1 setEnabled:YES];
    [swith2 setEnabled:YES];
}
-(void)postDataOnserver
{
     picturelable.hidden = YES;
    [activity startAnimating];
    [swith1 setEnabled:NO];
    [swith2 setEnabled:NO];
    [years setBorderStyle:UITextBorderStyleNone];
    self.projectjieshao_tishi.hidden = YES;
    if (NewImage) {
        //上传到服务器
        NSString *userid = USERNO;
        PBdataClass *pb = [[PBdataClass alloc]init];
        pb.delegate = self;
        [pb PostImageResponse:[NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/uploadgroupmembericon",HOST]] postImage:LogImageAC.image Forkey:@"uploadedfile" postOtherDic:[NSDictionary dictionaryWithObjectsAndKeys:userid,@"id",[NSString stringWithFormat:@"%d", self.projectno],@"no",[NSString stringWithFormat:@"%d",no],@"memberno", nil] searchOrSave:NO];
    }
    else {
        [self postOtherData];
    }

   
}
-(void)postOtherData
{
    NSString *str;
    if (keyno > 0) {
        str = @"mod";
    }
    else
    {
        if (no > 0) {
            str = @"mod";
        }else{
            str = @"add";
        }
    }
    //上传服务器
    PBdataClass *datas = [[PBdataClass alloc]init];
    datas.delegate = self;
    NSArray *a1 =[NSArray arrayWithObjects:@"mode",
                  @"companyno",
                  @"projectno",
                  @"no",
                  @"name",
                  @"introduce",
                  @"experience",
                  @"married",
                  @"teamjob",
                  @"years", nil];
    NSArray *a2 = [NSArray arrayWithObjects:str,
                  [NSString stringWithFormat:@"%d", [PBUserModel getUserId]],
                  [NSString stringWithFormat:@"%d",self.projectno],
                  [NSString stringWithFormat:@"%d",keyno<=0?no:keyno],
                  (self.projectname.text==NULL)?@"":self.projectname.text,
                  (self.projectjieshao.text==NULL)?@"":self.projectjieshao.text,
                  [swith1.on?@"YES":@"NO"isEqualToString: @"YES"]?@"1":@"0",
                  [swith2.on?@"YES":@"NO"isEqualToString: @"YES"]?@"1":@"0",
                  [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:teamjob.text withKind:@"job"]] == NULL?@"":[NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:teamjob.text withKind:@"job"]],
                   years.text == NULL?[NSString stringWithFormat:@"%d",0]:years.text, nil];
    [datas dataResponse:[NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/addgroup",HOST]] postDic:[NSDictionary dictionaryWithObjects:a2 forKeys:a1] searchOrSave:NO];
    
}
-(void)imageIsSuccesePostOnServer:(int)intvalue
{
    keyno = intvalue;
    if (intvalue != 0) {
        [self postOtherData];
    }
    else {
        UIAlertView *aletview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"上传失败" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) otherButtonTitles:nil, nil];
        [aletview show];
        [aletview release];
        [activity stopAnimating];
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
    if(no>0){
        [self editButtonPress:self.navigationItem.rightBarButtonItem];
    }
    [activity stopAnimating];
}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    keyno = [intvalue intValue];
    PBteamData *pbteamdata = [[PBteamData alloc]init];
        pbteamdata.no = keyno;
    if (NewImage) {
        pbteamdata.imagepath = LogImageAC.image;

    }
    else
    {
        if(LogImageAC.image == nil)
        {
            pbteamdata.imagepath = [UIImage imageNamed:@"name.png"]; 
        }
        else {
           
            pbteamdata.imagepath = LogImageAC.image;
        }
    }

        pbteamdata.companyno = [PBUserModel getUserId];
        pbteamdata.projectno = self.projectno;
        pbteamdata.name = self.projectname.text;
        int jobid = [PBKbnMasterModel getKbnIdByName:teamjob.text withKind:@"job"];
        pbteamdata.teamjob = jobid;
        pbteamdata.introduce = self.projectjieshao.text;
        pbteamdata.years = years.text;
        pbteamdata.experience = [swith2.on?@"YES":@"NO"isEqualToString: @"YES"]?@"1":@"0";
        pbteamdata.married = [swith1.on?@"YES":@"NO"isEqualToString: @"YES"]?@"1":@"0";
    [pbteamdata saveRecord];
     [activity stopAnimating];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view delegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        NSString *str = @"背景介绍";
        return str;
    }
    else {
        return nil;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
             return [self TishiView];
        }
        else {
            return nil;
        }
    }
    else {
        return nil;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self logimgePicker];
    }
    if (indexPath.section == 1) {
        [self.projectname becomeFirstResponder];
    }
    if (indexPath.section == 2) {
        [pop.view removeFromSuperview];
        pop.view.hidden = !pop.view.hidden;
        [pop popClickAction];
    }
    if (indexPath.section == 3) {
        [self.projectjieshao becomeFirstResponder];
    }
    if (indexPath.section == 4) {
        [years becomeFirstResponder];
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
#pragma mark -POPview delegate
- (void)popView:(POPView *)popview didSelectIndexPath:(NSIndexPath *)indexPath{
    teamjob.text = [popview._arry objectAtIndex:indexPath.row];
}
#pragma mark - View lifecycle

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 7;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.projectname resignFirstResponder]; 
    [years resignFirstResponder];
    return YES; 
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
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [self.projectname resignFirstResponder];
    [years resignFirstResponder];
    [self.projectjieshao resignFirstResponder];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.textlable_arry = nil;
//    self.memberinfos = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
