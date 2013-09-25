//
//  PBtextField.m
//  ParkBusiness
//
//  Created by lywes lee on 13-4-9.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBtextField.h"
#import "PBSettings.h"
#import "PBAddCompanyView.h"
#import "PBScienceProperty.h"
#import "PBProjectData.h"
@interface PBtextField ()

@end

@implementation PBtextField
@synthesize textfield;
@synthesize addCompany;
@synthesize tableview1;
@synthesize indepath;
@synthesize setting;
@synthesize equstr;
@synthesize detailStr;
-(void)dealloc
{
    [lable release];
    [self.equstr=nil release];
    [self.tableview1=nil release];
    [self.indepath =nil release];
    [self.textfield = nil release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.detailStr = @"";
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    lable.text = self.detailStr;
    
    if ([self.equstr isEqualToString:@"姓名:"]) {
        lable.text = @"最多输入10个字";
        self.title = @"编辑姓名";
    }
    if ([self.equstr isEqualToString:@"公司:"]) {
        lable.text = @"最多输入30个字";
        self.title = @"编辑公司名称";
    }
    if ([self.equstr isEqualToString:@"QQ:"]) {
        lable.text = @"例如:5164555";
         self.title = @"编辑QQ";
        self.textfield.keyboardType = UIKeyboardTypeNumberPad;
    }
    if ([self.equstr isEqualToString:@"新浪微博:"]) {
        lable.text = @"例如:http://blog.sina.com.cn/sina";
        self.title = @"编辑新浪微博";
    }
    if ([self.equstr isEqualToString:@"邮箱:"]) {
        lable.text = @"例如:anlas@sina.com";
        self.title = @"编辑新浪邮箱:";
         self.textfield.keyboardType = UIKeyboardTypeEmailAddress;
    }
    self.textfield.text = [self.setting.dic objectForKey:self.equstr];
    if (self.science) {
//        whattext = YES;
//        [self.projectjieshao becomeFirstResponder];
        self.textfield.text = self.equstr;
    }
    [self.textfield becomeFirstResponder];
    if ([self.equstr isEqualToString:@"个性签名:"]) {
        self.title = @"编辑个性签名:";
        whattext = YES;
        [self.projectjieshao becomeFirstResponder];
        self.projectjieshao.text = [self.setting.dic objectForKey:self.equstr];
    }
    [self.tableView reloadData];

}
-(void)viewDidDisappear:(BOOL)animated
{
    lable.text=nil;
    self.textfield.text = nil;
    self.projectjieshao.text = nil;
    whattext = NO;

}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
     return YES;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigatorRightButtonType:WANCHEN];
    if (isPad()) {
        self.textfield = [[[UITextField alloc]initWithFrame:CGRectMake(5, 5, 675, 30)]autorelease];
    }
    else {
        self.textfield = [[[UITextField alloc]initWithFrame:CGRectMake(5, 5, 290, 30)]autorelease];
    }    
    textfield.delegate = self;
    self.textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.textfield setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    isedit = NO;
    whattext= NO;
    //footview
    lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 250, 20)];
    if (isPad()) {
        lable.frame = CGRectMake(RATIO*10+30, 0, RATIO*250, 20);
    }
    lable.backgroundColor = [UIColor clearColor];
    lable.textAlignment = UITextAlignmentLeft;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    NSLog(string);
    if ([self.equstr isEqualToString:@"姓名:"]) {
      return  [self rang:range location:10];
    }
    else if([self.equstr isEqualToString:@"公司:"])
    {
       return [self rang:range location:30];
    }
    else
        return YES;

}
-(BOOL)rang:(NSRange)rang location:(NSInteger)num
{
    if (rang.location>=num) {
        return NO;
    }
    else
        return YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(void)addSubViewForCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (!whattext) {
        [cell.contentView addSubview:textfield];
    }
    else {
        [self addTextViewForCell:cell];

    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)]autorelease];
    if (isPad()) {
        view.frame = CGRectMake(0, 0, RATIO*320, 20);
    }
    if (whattext) {
        view = [self TishiView];
    }
    
    [view addSubview:lable];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat i;
    if (whattext) {
        i = 120;
    }
    else {
        i = 44;
    }
    return i;
}
-(void)postDataOnserver
{
    
    [setting.dic removeObjectForKey:self.equstr];
    if (!whattext) {
        [setting.dic setObject:self.textfield.text forKey:self.equstr];
    }
    else {

        [setting.dic setObject:self.projectjieshao.text forKey:self.equstr];
        
    }
    if (self.science) {
        [self.science.textDic setObject:self.textfield.text forKey:self.title];
    }
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
