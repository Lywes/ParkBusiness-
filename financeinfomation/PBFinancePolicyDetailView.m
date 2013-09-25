//
//  PBFinancePolicyDetailView.m
//  ParkBusiness
//
//  Created by 上海 on 13-6-5.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//


#import "PBFinancePolicyDetailView.h"
#import "PBQuestionListController.h"
#import "PBRemarkListController.h"
#import "PBFinancInstitutDetailController.h"
#import "PBFinanceNewsListView.h"
@interface PBFinancePolicyDetailView ()
-(void)GetDAtaOnSever;
@end

@implementation PBFinancePolicyDetailView
@synthesize imageView;
@synthesize dataDic;
@synthesize name;
@synthesize financename;
@synthesize time;
@synthesize webView;
@synthesize image;
@synthesize remarktype;
@synthesize showFinance;
@synthesize shoucangbtn;
@synthesize no;
@synthesize SC_URL;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)GetDAtaOnSever
{
    PBdataClass *dataclass = [[PBdataClass alloc]init];
    dataclass.delegate = self;
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:self.no,@"no", nil];
    [dataclass dataResponse:self.SC_URL postDic:dic searchOrSave:YES];
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    if (datas.count>0) {
        self.dataDic = [datas objectAtIndex:0];
        [self viewRefresh];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //评论
    indicator = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:indicator];
//    UIButton *remarkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    remarkBtn.frame = isPad()?CGRectMake(6, 6, 42, 30):CGRectMake(6, 6, 33, 26);
//    [remarkBtn setBackgroundImage:[UIImage imageNamed:@"product_re.png"] forState:UIControlStateNormal];
//    [remarkBtn addTarget:self action:@selector(remark) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *remarkBtnItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"nav_btn_pl", nil) style:UIBarButtonItemStylePlain target:self action:@selector(remark)];
    if ([remarktype isEqualToString:@"1"]) {
//        UIButton *questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        questionBtn.frame = isPad()?CGRectMake(6, 6, 42, 30):CGRectMake(6, 6, 33, 26);
//        [questionBtn setBackgroundImage:[UIImage imageNamed:@"product_qa.png"] forState:UIControlStateNormal];
//        [questionBtn addTarget:self action:@selector(question) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *questionBtnItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"nav_btn_tw", nil) style:UIBarButtonItemStylePlain target:self action:@selector(question)];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:remarkBtnItem, questionBtnItem, nil];
        [questionBtnItem release];
    }else{
        self.navigationItem.rightBarButtonItem = remarkBtnItem;
    }
    [remarkBtnItem release];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(7, 7, 25, 30);
    [btn addTarget:self action:@selector(backHomeView) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barButton;
    if (isPhone5()) {
        CGRect frame = self.webView.frame;
        frame.size.height +=80;
        self.webView.frame = frame;
    }

    if (!self.no) {
        [self viewRefresh];
    }
    else{
        [self GetDAtaOnSever];
    }
    inputToolbar = [[UIInputToolbar alloc] initWithFrame:CGRectMake(0, isPad()?1024:(isPhone5()?568:480), isPad()?768:320, 40)];
    inputToolbar.delegate = self;
    inputToolbar.textView.placeholder = @"请输入提问";
    [self.navigationController.view addSubview:inputToolbar];
    [inputToolbar addObserverFromController:self];
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [indicator startAnimating];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [indicator stopAnimating];
}
-(void)viewDidUnload{
    [super viewDidUnload];
    [inputToolbar removeObserverFromController:self];
}

-(void)viewRefresh
{
    self.title = [dataDic objectForKey:@"name"];
    self.name.text =[dataDic objectForKey:@"name"];
    self.time.text =[dataDic objectForKey:@"cdate"];
    self.financename.text =[dataDic objectForKey:@"financename"];
    if ([remarktype isEqualToString:@"2"]) {
        self.showFinance.hidden = YES;
    }else{
        CGSize financesize = [self.financename.text sizeWithFont:self.financename.font];
        if (financesize.width<self.financename.frame.size.width) {
            CGRect frame = self.showFinance.frame;
            frame.origin.x = self.financename.frame.origin.x+financesize.width+5;
            self.showFinance.frame = frame;
        }
    }
    if (self.no) {
        shoucangbtn.hidden = YES;
    }
    if ([[dataDic objectForKey:@"flag"] isEqualToString:@"1"]) {
        shoucangbtn.enabled = NO;
        [shoucangbtn setTitle:@"已收藏" forState:UIControlStateNormal];
    }
    self.imageView.image = self.image;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[dataDic objectForKey:@"contenturl"]]]];
    // Do any additional setup after loading the view from its nib.
}
//评论
- (void) remark
{
    //    PBAllReviewController *controller = [[PBAllReviewController alloc] init];
    inputtype = @"remark";
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) destructiveButtonTitle:nil otherButtonTitles:@"我要评论",@"评论列表", nil];
    sheet.tag = 2;
    [sheet showInView:self.navigationController.view];
    
}

//提问，提问上传的参数是type,questionno,userno和question。。在这里提问获取的questionno是什么
- (void) question
{
    inputtype = @"question";
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) destructiveButtonTitle:nil otherButtonTitles:@"我要提问",@"提问列表", nil];
    sheet.tag = 1;
    [sheet showInView:self.navigationController.view];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==1) {
        switch (buttonIndex) {
            case 0:
                [inputToolbar.textView becomeFirstResponder];
                break;
            case 1:{
                PBQuestionListController *contrllor = [[PBQuestionListController alloc] init];
                contrllor.titleString = @"提问列表";
                contrllor.typeString = @"1";
                contrllor.qaNoString = [self.dataDic objectForKey:@"no"];
                [self.navigationController pushViewController:contrllor animated:YES];
                [contrllor release];
            }
                break;
            default:
                break;
        }
    }else{
        switch (buttonIndex) {
            case 0:
                [inputToolbar.textView becomeFirstResponder];
                break;
            case 1:{
                PBRemarkListController *controller = [[PBRemarkListController alloc] init];
                //需要传递一些参数过去
                NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:self.dataDic];
                [dic setObject:remarktype forKey:@"remarktype"];
                controller.infoDic = dic;
                [self.navigationController pushViewController: controller animated:YES];
                [controller release];
            }
                break;
            default:
                break;
        }
    }
}
-(void)inputButtonPressed:(NSString *)inputText
{
    [indicator startAnimating];
    sendmanager = [[PBWeiboDataConnect alloc] init];
    sendmanager.delegate= self;
    if ([inputtype isEqualToString:@"question"]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", @"type", [NSString stringWithFormat:@"%d", [PBUserModel getUserId]], @"userno", [self.dataDic objectForKey:@"no"], @"questionno",inputText, @"question", nil];
        [sendmanager submitDataFromUrl:QUESTIONINFO postValuesAndKeys:dic];
    }else{
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:remarktype, @"type", [NSString stringWithFormat:@"%d", [PBUserModel getUserId]], @"userno", [self.dataDic objectForKey:@"no"], @"commentno", inputText, @"content", nil];
        [sendmanager submitDataFromUrl:REMARKINFO postValuesAndKeys:dic];
    }
    
}

- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [inputToolbar keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [inputToolbar keyboardWillShowHide:notification];
    [inputToolbar keyboardWillHide];
}
//收藏
- (IBAction) collectProject:(id)sender
{
    shoucangbtn.enabled = NO;
    [indicator startAnimating];
    PBWeiboDataConnect  *collectData= [[PBWeiboDataConnect alloc] init];
    collectData.delegate = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[dataDic objectForKey:@"no"], @"projectno", [NSString stringWithFormat:@"%d", [PBUserModel getUserId]], @"personno", [remarktype isEqualToString:@"1"]?@"7":@"8",@"type",nil];
    [collectData submitDataFromUrl:FAVOURITES postValuesAndKeys:dic];
}

-(void)sucessSendPostData:(PBWeiboDataConnect *)weiboDatas{
    [indicator stopAnimating];
    if (sendmanager==weiboDatas) {
        [indicator stopAnimating];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[inputtype isEqualToString:@"question"]?@"提问信息已提交":@"评论信息已提交" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        if ([remarktype isEqualToString:@"1"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPolicyData" object:nil];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshNewsData" object:nil];
        }
        [shoucangbtn setTitle:@"已收藏" forState:UIControlStateNormal];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已成功收藏" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(IBAction)showFinanceInfo:(id)sender{
    PBFinancInstitutDetailController *controller = [[PBFinancInstitutDetailController alloc] init];
    controller.financeno = [dataDic objectForKey:@"financeno"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[dataDic objectForKey:@"financename"],@"name", nil];
    controller.dataDictionary = dic;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void) backHomeView {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
