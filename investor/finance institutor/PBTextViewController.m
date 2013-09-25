//
//  PBTextViewController.m
//  ParkBusiness
//
//  Created by 上海 on 13-6-26.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBTextViewController.h"

@interface PBTextViewController ()

@end

@implementation PBTextViewController
@synthesize textview;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        textview = [[UITextView alloc]initWithFrame:CGRectMake(10, 5, self.view.frame.size.width-20, self.view.frame.size.height - 5)];
        textview.font = [UIFont systemFontOfSize:isPad()?16:14];
        [self.view addSubview:textview];
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(7, 7, 25, 30);
        [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(popPreView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = item;
        [item release];
    }
    return self;
}

- (void) popPreView
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
