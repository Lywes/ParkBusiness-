//
//  PBCustonTextVC.m
//  ParkBusiness
//
//  Created by China on 13-9-4.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBCustonTextVC.h"
#import "NSObject+NAV.h"
@interface PBCustonTextVC ()

@end

@implementation PBCustonTextVC
@synthesize textfield,textview,show,keystr,text;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
-(void)popPreView{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    if (show) {
        textfield.hidden = YES;
        textview.hidden = NO;
        [self setTextFrame:textview];
        textview.text = text;
    }
    else{
        textfield.hidden = NO;
        textview.hidden = YES;
        [self setTextFrame:textfield];
        textfield.text = text;
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"nav_btn_wc", nil) style:UIBarButtonItemStylePlain target:self action:@selector(wancheng)];
    self.navigationItem.rightBarButtonItem = item;
}
-(void)setTextFrame:(UIView*)textView{
    CGRect frame = textView.frame;
    frame.size.width = isPad()?750:300;
    textView.frame = frame;
    [textView becomeFirstResponder];
}
-(void)wancheng{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:show?self.textview.text:textfield.text,self.keystr, nil];
    [self SaveTextDic:dic];
    [dic release];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
