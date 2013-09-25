//
//  PBEDITViewController.m
//  ParkBusiness
//
//  Created by  on 13-4-23.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBEDITViewController.h"

@implementation PBEDITViewController

@synthesize popupTextView;

@synthesize popStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(6, 6, 25, 30);
        [btn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(popBackView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = backBarBtn;
        [backBarBtn release];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)popBackView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)finish
{    
    self.popStr = self.popupTextView.text;
    [self.navigationController popViewControllerAnimated:YES];
}

    //控制字数
-(void)popupTextView:(YIPopupTextView *)textView didChangeWithText:(NSString *)text{
    if([text length]>0){
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{    
    
    if (range.location>=300
        ) {    
        
        if ([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder]; 
        }
        return NO;    
    }
    
    return YES;    
    
}

-(void)viewWillAppear:(BOOL)animated
{

    UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"nav_btn_wc", nil) style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    self.navigationItem.rightBarButtonItem = rightbtn;
    [rightbtn release];
    
    
    popupTextView = [[YIPopupTextView alloc] initWithPlaceHolder:@"请输入内容..." maxCount:300];
    popupTextView._closeButton.hidden = YES;
    popupTextView.delegate = self;
    popupTextView.text = self.popStr;
    popupTextView.keyboardAppearance = UIKeyboardAppearanceDefault;
    popupTextView.superview.backgroundColor = [UIColor grayColor];
    [popupTextView showInView:self.view];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
   
   
       
   
}

- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
