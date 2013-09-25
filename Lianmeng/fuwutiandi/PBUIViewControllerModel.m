//
//  PBUIViewControllerModel.m
//  PBBank
//
//  Created by lywes lee on 13-5-13.
//  Copyright (c) 2013年 shanghai. All rights reserved.
//

#import "PBUIViewControllerModel.h"

@interface PBUIViewControllerModel ()

@end

@implementation PBUIViewControllerModel

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//返回按钮
-(void)backUpView
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topnavigation.png"] forBarMetrics:UIBarMetricsDefault];
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
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(UITextView *)addTextViewWithFrame:(CGRect)rect
{
    UITextView *textview = [[UITextView alloc]initWithFrame:rect];
//    textview sets
    textview.clipsToBounds = NO;
//    textview.layer.b
    
    textview.delegate = self;
//    textview.backgroundColor = [UIColor whiteColor];
    return textview;
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
