//
//  PBhuodongVC1.m
//  ParkBusiness
//
//  Created by lywes lee on 13-5-5.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBhuodongVC1.h"
#import "NSObject+NVBackBtn.h"
@interface PBhuodongVC1 ()

@end

@implementation PBhuodongVC1
@synthesize content = _content;
@synthesize huodong = _huodong;
-(void)dealloc
{
    [self.content release];
    [self.huodong release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.content.text = [self.huodong objectForKey:@"content"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customButtomItem:self];
    self.title = @"活动详情";
    CGRect rectt = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height);
//    rectt.origin.y += 10.0f;
//    if (isPad()) {
//         rectt.size.height -= 90.0f;
//    }
//    if (isPhone5()) {
//        rectt.size.height -= 70.0f;
//    }
//    else {
//         rectt.size.height -= 60.0f;
//    }
    self.content = [[[UITextView alloc]initWithFrame:rectt]autorelease];
//    self.content.backgroundColor = [UIColor clearColor];
    [self.content setEditable:NO];
    [self.view addSubview:self.content];
}
-(void)backHomeView
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.content = nil;
    self.huodong = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
