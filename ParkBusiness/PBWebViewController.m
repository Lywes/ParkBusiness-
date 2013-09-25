//
//  PBWebViewController.m
//  ParkBusiness
//
//  Created by China on 13-9-4.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBWebViewController.h"

@interface PBWebViewController ()

@end

@implementation PBWebViewController
@synthesize url;
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
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
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
