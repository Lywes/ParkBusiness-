//
//  PBAboutUsView.m
//  ParkBusiness
//
//  Created by 上海 on 13-7-3.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBAboutUsView.h"

@interface PBAboutUsView ()

@end

@implementation PBAboutUsView

@synthesize webview;
-(void)dealloc
{
    [self.webview release];
    [indicator release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"关于我们";
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(7, 7, 25, 30);
        [btn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = barButton;
    }
    return self;
}

-(void)dismissView{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect frame = self.view.frame;
    frame.size.height -=KNavigationBarHeight;
    self.webview = [[UIWebView alloc]initWithFrame:frame];
    self.webview.delegate =self;
    [self.view addSubview:webview];
    //关于我们网页URL
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.ifdz.net/about.html"]]];
    indicator = [[PBActivityIndicatorView alloc]initWithFrame:frame];
    indicator.center = self.view.center;
    [self.view addSubview:indicator];

}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [indicator startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [indicator stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"加载失败" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) otherButtonTitles:nil, nil];
//    [alertview show];
//    [alertview release];
    PBAlertView* alert = [[PBAlertView alloc]initWithMessage:@"网络不给力 请稍后再试"];
    [alert show];
    [alert release];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.webview = nil;
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
