//
//  PBUserProtocolVIew.m
//  ParkBusiness
//
//  Created by 上海 on 13-8-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBUserProtocolView.h"

@interface PBUserProtocolView ()

@end

@implementation PBUserProtocolView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_qx", nil) style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)]];
    }
    return self;
}
-(void)dismiss{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    indicator = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:indicator];
    UIWebView* webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    webView.delegate = self;
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.ifdz.net/policy.html"]];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    [webView release];
	// Do any additional setup after loading the view.
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [indicator startAnimating];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [indicator stopAnimating];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
