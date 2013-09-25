//
//  FAFriendRemarkController.m
//  ParkBusiness
//
//  Created by QDS on 13-5-11.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "FAFriendRemarkController.h"
#import "FAFriendData.h"
@interface FAFriendRemarkController ()

@end

@implementation FAFriendRemarkController
@synthesize friendid,remark;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"修改备注";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem* rightButton=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"nav_btn_wc", nil) style:UIBarButtonItemStylePlain target:self action:@selector(btnDidPush)];
    self.navigationItem.rightBarButtonItem = rightButton;
    textfield = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 40)];
    [textfield setBorderStyle:UITextBorderStyleRoundedRect];
    [textfield setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.view addSubview:textfield];
    textfield.text = self.remark;
	// Do any additional setup after loading the view.
}

-(void)btnDidPush{
    [FAFriendData updateRemark:textfield.text withId:self.friendid];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [super dealloc];
    [textfield release];
}
@end
