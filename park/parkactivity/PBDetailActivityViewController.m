//
//  PBDetailActivityViewController.m
//  ParkBusiness
//
//  Created by  on 13-3-8.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBDetailActivityViewController.h"
#import "PBUserModel.h"
#import "PBActivityReceipt.h"
@implementation PBDetailActivityViewController

@synthesize titleName;
@synthesize contentTextView;
@synthesize data;
@synthesize parkManager;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(6, 6, 25, 30);
        [btn1 setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(popBackgoView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn1];
        self.navigationItem.leftBarButtonItem = backBarBtn;
        [backBarBtn release];
        
    }
    return self;
}

-(void)popBackgoView
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.title = [self.data objectForKey:@"name"];
    contentTextView.text = [self.data objectForKey:@"content"];
     int type = [[self.data objectForKey:@"type"] intValue];
    if (type==2||type==3) {//判断是否为可参加活动
        NSDateFormatter* fommatter = [[NSDateFormatter alloc]init];
        [fommatter setDateFormat:@"yyyy-MM-dd hh:mm"];
        NSDate *enddate = [fommatter dateFromString:[self.data objectForKey:@"enddate"]];
        if ( enddate!=[enddate earlierDate:[NSDate date]]) {
            NSString* title = [[self.data objectForKey:@"attendflg"] isEqualToString:@"1"]?@"已参加":@"我要参加";
            UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(joinBtn)];
            self.navigationItem.rightBarButtonItem = rightButton;
            [rightButton release];
            self.navigationItem.rightBarButtonItem.enabled = [[self.data objectForKey:@"attendflg"] isEqualToString:@"1"]?NO:YES;
            
        }
    }
    
    
    if (isPad()) {
        contentTextView.font = [UIFont systemFontOfSize:PadContentFontSize];
    }else{
        contentTextView.font = [UIFont systemFontOfSize:ContentFontSize];
    }
   
}
- (void)didReceiveMemoryWarning
{

    [super didReceiveMemoryWarning];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)joinBtn
{
    PBActivityReceipt* receipt = [[PBActivityReceipt alloc]init];
    receipt.datadic = self.data;
    [receipt navigatorRightButtonType:WANCHEN];
    [self.navigationController pushViewController:receipt animated:YES];
}


-(void)sucessSendPostData:(NSObject *)Data{

    NSLog(@"Pressed button with text");
}

- (void)refreshData
{
     nodesMutableArr = [[NSArray arrayWithArray:parkManager.itemNodes] retain];
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
