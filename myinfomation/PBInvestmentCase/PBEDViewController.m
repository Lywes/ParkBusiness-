//
//  PBEDViewController.m
//  ParkBusiness
//
//  Created by  on 13-4-23.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBEDViewController.h"

@implementation PBEDViewController

@synthesize textField;
@synthesize contentStr;


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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];

    UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"nav_btn_wc", nil) style:UIBarButtonItemStylePlain target:self action:@selector(chuanzhi)];
    self.navigationItem.rightBarButtonItem = rightbtn;
    [rightbtn release];  
    if (isPad()) {
        textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 60, 748, 40)];
        textField.font = [UIFont systemFontOfSize:20];
    }else{
        textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, 300, 30)];
    }
    
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:textField];
}

-(void)viewTapped{
    [textField resignFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.textField.text = @"";
}

-(void)chuanzhi
{
    self.contentStr = self.textField.text;
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
