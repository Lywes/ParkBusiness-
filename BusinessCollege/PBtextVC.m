//
//  PBtextVC.m
//  ParkBusiness
//
//  Created by China on 13-7-4.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBtextVC.h"
#import "NSObject+NVBackBtn.h"
@interface PBtextVC ()

@end

@implementation PBtextVC
@synthesize text;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customButtomItem:self];
    self.view.backgroundColor = [UIColor whiteColor];
    UITextView*textview = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 2*KNavigationBarHeight)];
    if (isPad()) {
        textview.font = [UIFont systemFontOfSize:17];
    }
    [textview setEditable:NO];
    textview.text = self.text;
    [self.view addSubview:textview];
    [textview release];
}
-(void)backHomeView
{
//    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
