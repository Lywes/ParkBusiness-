//
//  PBWebVC.m
//  PBBank
//
//  Created by lywes lee on 13-5-10.
//  Copyright (c) 2013年 shanghai. All rights reserved.
//
#define JIARULIANMENG [NSURL URLWithString:@"HTTP://www.baidu.com"]
#import "PBWebVC.h"

@interface PBWebVC ()
-(void)initPreantView;
@end

@implementation PBWebVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"关于我们";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initPreantView];
}
-(void)initPreantView
{
    CGRect frame = self.view.frame;
    frame.size.height -= 50;
    UIWebView *webview = [[[UIWebView alloc]initWithFrame:frame]autorelease];
    webview.delegate = self;
    [webview loadRequest:[NSURLRequest requestWithURL:JIARULIANMENG]];
    [self.view addSubview:webview];
    activity = [[PBActivityIndicatorView alloc]initWithFrame:self.navigationController.view.frame];
    [self.view addSubview:activity];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(7, 7, 25, 30);
        [btn addTarget:self action:@selector(backHomeView) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = barButton;
}

- (void) backHomeView {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [activity startAnimating];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
     [activity stopAnimating];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *aletview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [aletview show];
    [aletview release];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
