//
//  PBImgIndustrialViewController.m
//  ParkBusiness
//
//  Created by  on 13-3-7.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBImgIndustrialViewController.h"
#define INSERT_QUESTION_URL [NSString stringWithFormat:@"%@admin/index/insertquestion",HOST]
#define POLICY_DETAIL_URL [NSString stringWithFormat:@"%@admin/index/searchpolicydetail",HOST]
@implementation PBImgIndustrialViewController

@synthesize data;
@synthesize dataTextView;
@synthesize parkNoString;
@synthesize inputToolbar;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(6, 6, 25, 30);
        [btn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(popBackgoView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = backBarBtn;
        [backBarBtn release];
        
    }
    return self;
}

-(void)popBackgoView
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated 
{
    self.title = [self.data objectForKey:@"mytitle"];
    policymanager = [[PBParkManager alloc] init];
    policymanager.delegate = self;
    [indicator startAnimating];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: [self.data objectForKey:@"no"],@"no",nil];
    [policymanager getRequestData:POLICY_DETAIL_URL forValueAndKey:dic];
    [dic release];

    

}
-(void)refreshData{
    [indicator stopAnimating];
    if ([policymanager.itemNodes count]>0) {
        NSMutableDictionary* dic = [policymanager.itemNodes objectAtIndex:0];
        self.dataTextView.text =  [dic objectForKey:@"mybody"];
        if (isPad()) {
            dataTextView.font = [UIFont systemFontOfSize:PadContentFontSize];
        }else{
            dataTextView.font = [UIFont systemFontOfSize:ContentFontSize];
        }
    }
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    indicator = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:indicator];
    [self rightBarButton];
        
}
-(void)rightBarButton
{
    
    UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc] initWithTitle:@"电话咨询" style:UIBarButtonItemStylePlain target:self action:@selector(questionView:)];
    self.navigationItem.rightBarButtonItem = rightbtn;
    [rightbtn release];
    inputToolbar = [[UIInputToolbar alloc] initWithFrame:CGRectMake(0, isPad()?1024:(isPhone5()?568:480), isPad()?768:320, 40)];
    inputToolbar.delegate = self;
    inputToolbar.textView.placeholder = @"请输入提问";
    [self.navigationController.view addSubview:self.inputToolbar];
    
}
//进入提问页面
- (void)questionView:(id)sender
{
//    [self.inputToolbar addObserverFromController:self];
//    [self.inputToolbar.textView becomeFirstResponder];
     UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:@"点击拨打电话" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) destructiveButtonTitle:@"021-65442341" otherButtonTitles: nil];
    [sheet showFromTabBar:self.tabBarController.tabBar];
    [sheet release];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        NSString* num = [NSString stringWithFormat:@"tel://%@",[actionSheet buttonTitleAtIndex:buttonIndex]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
    }
}
-(void)inputButtonPressed:(NSString *)inputText
{
    [indicator startAnimating];
    NSArray *arr1 = [NSArray arrayWithObjects:parkNoString,inputText,USERNO, nil];
    NSArray *arr2 = [NSArray arrayWithObjects:@"parkno",@"question", @"personno",nil];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
    PBParkManager* parkManager = [[PBParkManager alloc]init];
    parkManager.delegate = self;
    [parkManager submitDataFromUrl:INSERT_QUESTION_URL postValuesAndKeys:dic];
    [dic release];
}

-(void)sucessSendPostData:(NSObject *)Data{
    [indicator stopAnimating];
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"提问信息已提交" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alert show];
    [alert show];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [self.inputToolbar removeObserverFromController:self];
}
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [self.inputToolbar keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [self.inputToolbar keyboardWillShowHide:notification];
    [self.inputToolbar keyboardWillHide];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    [super dealloc];
    [indicator release];
    [dataTextView release];
}
@end
