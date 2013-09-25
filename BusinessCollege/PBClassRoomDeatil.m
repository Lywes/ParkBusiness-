//
//  PBClassRoomDeatil.m
//  ParkBusiness
//
//  Created by China on 13-7-22.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBClassRoomDeatil.h"
#import "PBActivityIndicatorView.h"
#import "NSObject+NVBackBtn.h"
#import "PBRemarkListController.h"
#define ZHISHIKETANG_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/knowledgeclassdetail",HOST]]
@interface PBClassRoomDeatil ()

@end

@implementation PBClassRoomDeatil
@synthesize isURL_str;
@synthesize detailTitle_str;
@synthesize datadic;
-(void)dealloc{
    RB_SAFE_RELEASE(datadic);
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self customButtomItem:self];
    self.title = [self.datadic objectForKey:@"title"];
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    if ([urlTest evaluateWithObject:[self.datadic objectForKey:@"contenturl"]]) {
      UIWebView*  webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - KNavigationBarHeight)];
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.datadic objectForKey:@"contenturl"]]]];
        webview.delegate = self;
        [self.view addSubview:webview];
        [webview release];
    }
    else
    {
        [self initdata];
    }
    inputToolbar = [[UIInputToolbar alloc] initWithFrame:CGRectMake(0, isPad()?1024:(isPhone5()?568:480), isPad()?768:320, 40)];
    inputToolbar.delegate = self;
    inputToolbar.textView.placeholder = @"请输入提问";
    [self.navigationController.view addSubview:inputToolbar];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTap:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
   /*
    NSRegularExpression *regularexpressionURL = [[NSRegularExpression alloc]
                                                 
                                                 initWithPattern:@"http://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?"
                                                 
                                                 options:NSRegularExpressionCaseInsensitive
                                                 
                                                 error:nil];
    
    NSUInteger numberofMatchURL = [regularexpressionURL numberOfMatchesInString:self.isURL_str
                                   
                                                                        options:NSMatchingReportProgress
                                   
                                                                          range:NSMakeRange(0, self.isURL_str.length)];
    
 
    if (numberofMatchURL>0) {

    }
     */
    act = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:act];
    UIBarButtonItem *remarkbtn = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_pl", nil) style:UIBarButtonItemStylePlain target:self action:@selector(remark:)];
    if ([[self.datadic objectForKey:@"flag"] isEqualToString:@"0"]) {
        UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_sc", nil) style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemPress:)];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:remarkbtn,rightbtn, nil];
        [rightbtn release];
    }else{
        self.navigationItem.rightBarButtonItem = remarkbtn;
    }
    [remarkbtn release];
}
-(void)viewTap:(UITapGestureRecognizer*)tap{
    [inputToolbar resignFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [inputToolbar addObserverFromController:self];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [inputToolbar removeObserverFromController:self];
}
-(void)initdata
{
    [act startAnimating];
    PBdataClass *dataclass = [[PBdataClass alloc]init];
    dataclass.delegate = self;
    NSDictionary *dic= [[NSDictionary alloc]initWithObjectsAndKeys:[self.datadic objectForKey:@"no"],@"no", nil];
    [dataclass dataResponse:ZHISHIKETANG_URL postDic:dic searchOrSave:YES];
    [dic release];
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas{
    [act stopAnimating];
    if ([datas count]>0) {
        NSMutableDictionary* dic = [datas objectAtIndex:0];
        UITextView * textview  = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        textview.text = [dic objectForKey:@"content"];
        if (isPad()) {
            textview.font = [UIFont systemFontOfSize:17];
        }
        [textview setEditable:NO];
        [self.view addSubview:textview];
        [textview release];
    }
}
-(void)backHomeView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)rightBarButtonItemPress:(id)sender
{
    [act startAnimating];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                [self.datadic objectForKey:@"no"], @"projectno",
                                [NSString stringWithFormat:@"%d", [PBUserModel getUserId]], @"personno",
                                @"8",@"type",nil];
    PBdataClass *da = [[PBdataClass alloc]init];
    da.delegate = self;
    [da dataResponse:[NSURL URLWithString: FAVOURITES]postDic:dic searchOrSave:NO];
}
//评论
-(void)remark:(id)sender{
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) destructiveButtonTitle:nil otherButtonTitles:@"我要评论",@"评论列表", nil];
    [sheet showInView:self.navigationController.view];
    [sheet release];
}
//选择评论
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [inputToolbar.textView becomeFirstResponder];
            break;
        case 1:{
            PBRemarkListController *controller = [[PBRemarkListController alloc] init];
            //需要传递一些参数过去
            NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:self.datadic];
            [dic setObject:@"12" forKey:@"remarktype"];
            controller.infoDic = dic;
            [self.navigationController pushViewController: controller animated:YES];
            [controller release];
        }
            break;
        default:
            break;
    }
}
//我要评论
-(void)inputButtonPressed:(NSString *)inputText
{
    [act startAnimating];
    remarkData = [[PBdataClass alloc]init];
    remarkData.delegate= self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"12", @"type", [NSString stringWithFormat:@"%d", [PBUserModel getUserId]], @"userno", [self.datadic objectForKey:@"no"], @"commentno", inputText, @"content", nil];
    [remarkData dataResponse:[NSURL URLWithString:REMARKINFO] postDic:dic searchOrSave:NO];
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
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    if (dataclass==remarkData) {
        [act stopAnimating];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已成功评论" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else{
        [dataclass release];
        [act stopAnimating];
        [act release];
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"收藏成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alrt show];
        [alrt release];
        NSArray* arr = self.navigationItem.rightBarButtonItems;
        self.navigationItem.rightBarButtonItems = nil;
        self.navigationItem.rightBarButtonItem = [arr objectAtIndex:0];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"收藏" object:nil];
    }
    
    
}
-(void)searchFilad
{
    [act stopAnimating];
    [act release];
//      UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"由于网络环境不好,收藏失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alrt show];
//    [alrt release];
}
#pragma mark - web delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [act startAnimating];
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [act stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [act stopAnimating];
          UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络不流畅，获取数据失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alrt show];
        [alrt release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
