//
//  PBLoginController.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-29.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#import "PBwelcomeVC.h"
#import "PBLoginController.h"
#import "PBChooseJobController.h"
#import "PBUserModel.h"
#import "PBInsertDataModel.h"
#import "PBKbnMasterModel.h"
#import "FAGroupData.h"
#import "FAFriendGroupData.h"
#import "PBSidebarVC.h"
#define NUMBERS @"0123456789\n"
#define SENDURL [NSString stringWithFormat:@"%@/admin/index/sendsms",HOST]
#define CHECKURL [NSString stringWithFormat:@"%@/admin/index/checksms",HOST]
#define INSERTURL [NSString stringWithFormat:@"%@/admin/index/insertuserdata",HOST]
#define FRIENDURL @"http://www.5asys.com/load"
#define KBNURL [NSString stringWithFormat:@"%@/admin/index/upkbnmaster",HOST]
#define INSTITUTEURL @"http://www.5asys.com/admin/index/grouplist"
#define LOADURL [NSString stringWithFormat:@"%@/admin/index/loaduserinfo",HOST]
//#define INSTITUTEURL [NSString stringWithFormat:@"%@/admin/index/searchfinancinginstitution",HOST]
@interface PBLoginController ()

@end

@implementation PBLoginController
@synthesize mobileText,passwordText,submitbtns,sendbtns;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
    [sendData release];
    [checkData release];
    [indicator release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    customView.backgroundColor = [customView.backgroundColor colorWithAlphaComponent:0.3];
    sendData = [[PBWeiboDataConnect alloc]init];
    sendData.delegate = self;
    checkData = [[PBWeiboDataConnect alloc]init];
    checkData.delegate = self;
    institudeData = [[PBWeiboDataConnect alloc]init];
    institudeData.delegate = self;
    insertData = [[PBInsertDataConnect alloc]init];
    insertData.delegate = self;
    indicator = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    insertData.indicator = indicator;
    sendData.indicator = indicator;
    checkData.indicator = indicator;
    institudeData.indicator = indicator;
    originframe = customView.frame;
    changeframe = originframe;
    changeframe.origin.y -= 50.0f;
    mobileText.delegate =self;
    passwordText.delegate = self;
    passwordText.returnKeyType = UIReturnKeyJoin;
    [self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view from its nib.
    
    PBwelcomeVC *we = [[PBwelcomeVC alloc] init];
    [self presentModalViewController:we animated:NO];
    [we release];
}

-(IBAction)getPasswordText:(id)sender{//获取验证码
    [mobileText resignFirstResponder];
    [passwordText resignFirstResponder];
    if ([mobileText.text length]!=11) {//手机格式不正确
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号码输入格式不正确 请重新输入" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else {//正确
        [indicator startAnimating];
        sendbtns.enabled = NO;
        NSArray* arr1 = [NSArray arrayWithObjects:mobileText.text, nil];
        NSArray* arr2 = [NSArray arrayWithObjects:@"user", nil];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
        [sendData submitDataFromUrl:SENDURL postValuesAndKeys:dic];
        [dic release];
    }
    
}
-(void)sucessSendPostData:(PBWeiboDataConnect *)weiboDatas{//成功提交数据返回函数
    [indicator stopAnimating];
    if(weiboDatas==sendData){//成功获取验证码
        sendbtns.enabled = YES;
        if([sendData.receiveStr isEqualToString:@"success"]){
            [self alertMessage:@"信息已发送成功！！请接收"];
        }else{
            [self alertMessage:@"信息发送失败！！请重新获取验证码"];
        }
    }else if(weiboDatas==checkData){//验证码校验成功
        submitbtns.enabled = YES;
        if([checkData.receiveStr isEqualToString:@"0"]){//验证码错误
            [self alertMessage:@"验证码输入错误 请重新输入"];
            
        }else{//验证码正确
            if([checkData.receiveStr isEqualToString:@"1"]){//手机号已存在
                alerts = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该手机号码已注册 您的用户信息将导入到当前设备中" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alerts show];
            }else if([checkData.receiveStr isEqualToString:@"2"]){//验证码正确且手机号未注册
                [indicator startAnimating];
                [insertData getFriendDataFromUrl:LOADURL postValuesAndKeys:[NSMutableDictionary dictionaryWithObjectsAndKeys:USERNO,@"no",@"2",@"type", nil]];
            }
        }
    }
}
#pragma mark 获取失败
-(void)requestFilad:(PBWeiboDataConnect *)weiboDatas{
    sendbtns.enabled = YES;
    submitbtns.enabled = YES;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alerts == alertView ){
        [indicator setTitle:@"正在导入⋯⋯"];
        [indicator startAnimating];
        [insertData getFriendDataFromUrl:LOADURL postValuesAndKeys:[NSMutableDictionary dictionaryWithObjectsAndKeys:USERNO,@"no",@"1",@"type", nil]];
    }
    if (alertView.tag == 2) {
        [[UIApplication sharedApplication] performSelector:@selector(terminateWithSuccess)];
    }
}
//成功获取后台表数据进行导入
-(void)sucessReceiveData:(NSMutableDictionary*)parseData withInfo:(NSMutableArray*)tableInfo{
    for (int i = 0; i<[tableInfo count]; i++) {
        NSMutableArray* data =  [parseData objectForKey:[tableInfo objectAtIndex:i]];
        for(NSMutableDictionary* dic in data){
            switch (i) {
                case 0://保存USER表信息
                    [PBInsertDataModel saveUserRecords:dic];
                    NSUserDefaults* userData = [NSUserDefaults standardUserDefaults];
                    int kind = [[dic objectForKey:@"kind"] intValue];
                    [userData setInteger:kind== 0?0:-1 forKey:@"kind"];
                    FAFriendGroupData* group = [[FAFriendGroupData alloc]init];
                    group.name = @"金融机构";
                    group.idx = 0;
                    group.no = 2;
                    [group saveRecord];
                    group.name = @"政府机关";
                    group.idx = 1;
                    group.no = 3;
                    [group saveRecord];
                    [group release];
                    break;
                case 1://保存PROJECT表信息
                    [PBInsertDataModel saveProjectRecord:dic];
                    break;
                case 2://保存PROJECTINFO表信息
                    [PBInsertDataModel saveProjectInfoRecord:dic];
                    break;
                case 3://保存PROJECTGROUP表信息
                    [PBInsertDataModel saveProjectGroupRecord:dic];
                    break;
                case 4://保存PROJECTPLAN表信息
                    [PBInsertDataModel saveProjectPlanRecord:dic];
                    break;
                case 5://保存PROJECTCONDITION表信息
                    [PBInsertDataModel saveProjectConditionRecord:dic];
                    break;
                case 6://保存INVESTEXPERIENCE表信息
                    [PBInsertDataModel saveInvestExperienceRecord:dic];
                    break;
                case 7://保存companyinfo表信息
                    [PBInsertDataModel saveCompanyInfoRecord:dic];
                    break;
                case 8://保存bankloaninfo表信息
                    [PBInsertDataModel saveBankLoanRecord:dic];
                    break;
                case 9://保存companybondinfo表信息
                    [PBInsertDataModel saveCompanyBondRecord:dic];
                    break;
                case 10://保存financingassure表信息
                    [PBInsertDataModel saveFinancingAssureRecord:dic];
                    break;
                case 11://保存financinglease表信息
                    [PBInsertDataModel saveFinancingLeaseRecord:dic];
                    break;
                case 12://保存patentinfo表信息
                    [PBInsertDataModel savePatentInfoRecord:dic];
                    break;
                case 13://保存financingleaseaccount表信息
                    [PBInsertDataModel saveFinancingAccountRecord:dic];
                    break;
                case 14://保存bankfinancingcase表信息
                    [PBInsertDataModel saveBankFinancingCaseRecord:dic];
                    break;
                default:
                    break;
            }
        }
    }
}
//成功获取朋友信息
-(void)sucessGetFriendData:(NSMutableDictionary *)parseData withInfo:(NSMutableArray *)tableInfo{
    for (int i = 0; i<[tableInfo count]; i++) {
        NSMutableArray* data =  [parseData objectForKey:[tableInfo objectAtIndex:i]];
        for(NSMutableDictionary* dic in data){
            switch (i) {
                case 0://保存FRIEND表信息
                    [PBInsertDataModel saveFriendRecord:dic];
                    break;
                case 1://保存GROUPMASTER表信息
                    [PBInsertDataModel saveGroupRecord:dic];
                    break;
                default:
                    break;
            }
        }
    }
}
-(IBAction)checkPasswordText:(id)sender{//验证码校验
    int userId = [PBUserModel getUserId];
    if(userId>0){
        if([mobileText.text length]== 11){
            if ([passwordText.text length]>0) {//输入正确
                submitbtns.enabled = NO;
                [mobileText resignFirstResponder];
                [passwordText resignFirstResponder];
                [indicator startAnimating];
                NSArray* arr1 = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",userId],mobileText.text,passwordText.text, nil];
                NSArray* arr2 = [NSArray arrayWithObjects:@"no",@"user", @"password",nil];
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
                [checkData submitDataFromUrl:CHECKURL postValuesAndKeys:dic];
            }else{
                [self alertMessage:@"请输入验证码"];
            }
        }else if([mobileText.text length]>0){
            [self alertMessage:@"手机号格式不正确"];
        }else{
            [self alertMessage:@"请输入手机号"];
        }
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户初始化失败 请关闭应用重新启动" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 2;
        [alert show];
        [alert release];
//        [self alertMessage:@"用户数据正在初始化 请稍候再试"];
    }
}

-(void)sucessLoadRegisterDataWithType:(int)type{
    if (type==1) {
        //完成数据保存跳转页面
        PBSidebarVC* home = [[PBSidebarVC alloc] init];
        [self.navigationController pushViewController:home animated:YES];
        [home release];
    }else if(type == 2){
        PBUserModel *userModel = [[PBUserModel alloc]init];
        userModel.userId = [PBUserModel getUserId];
        userModel.password = passwordText.text;
        userModel.tel = mobileText.text;
        [userModel saveRecord];
        PBChooseJobController* choose = [[[PBChooseJobController alloc]initWithStyle:UITableViewStyleGrouped]autorelease];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topnavigation.png"] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        choose.title = @"欢迎使用";
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController pushViewController:choose animated:YES];
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [mobileText resignFirstResponder];
    [passwordText resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField==mobileText){
        //判断是否为数字
        NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicText = [string isEqualToString:filtered];
        if(!basicText){
            return NO;
        }
        if([textField.text length]>10){
            textField.text = [textField.text substringToIndex:10];
            return NO;
        }
    }
    return YES;
}
//-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    if(textField==passwordText&&!isPad()){
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:.3];
//        customView.frame = changeframe;
//        [UIView commitAnimations];
//    }
//}
//-(void)textFieldDidEndEditing:(UITextField *)textField{
//    if(textField==passwordText){
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:.3];
//        customView.frame = originframe;
//        [UIView commitAnimations];
//    }
//}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self checkPasswordText:nil];
    return YES;
}
-(void)alertMessage:(NSString*)message{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



@end
