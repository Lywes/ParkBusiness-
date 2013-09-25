//
//  PBFinancing.m
//  ParkBusiness
//
//  Created by China on 13-7-10.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define BTN_TAG 100
#define VIEWCONTENTSIZE (sender.tag-100)
#import "PBFinancing.h"
#import "PBFinancingScroller.h"
#import "NSObject+NVBackBtn.h"
#import "PBIndustryOpportunityDetail.h"

@interface PBFinancing ()

@end

@implementation PBFinancing
@synthesize nameArray;
-(void)dealloc
{
    [self.nameArray=nil release];
    [shadowImageView=nil release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Left_mainTable_RZXQ", nil);
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[PBFinancingScroller shareInstance] scrollViewDidEndDecelerating:[PBFinancingScroller shareInstance]];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customButtomItem:self];
    PBFinancingScroller *_financing = [PBFinancingScroller shareInstance];
    [self.view addSubview:_financing];
    NSArray *btnNameArr = [[NSArray alloc]initWithObjects:NSLocalizedString(@"Left_mainTable_RZXQ", nil),NSLocalizedString(@"Left_mainTable_LCXQ", nil),NSLocalizedString(@"Left_mainTable_QYGQ", nil), nil];
    self.nameArray = btnNameArr;
    [btnNameArr release];
    
    [nameArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
         [btn setFrame:CGRectMake(self.view.bounds.size.width/3*idx, 0, self.view.bounds.size.width/3 - 2, 44)];
         [btn setTitle:obj forState:UIControlStateNormal];
         [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         btn.titleLabel.font = [UIFont systemFontOfSize:15];
         [btn addTarget:self action:@selector(BtnPress:) forControlEvents:UIControlEventTouchUpInside];
         btn.tag = BTN_TAG+idx;
         [self.view addSubview:btn];
         
     }];
    
    shadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 59, 44)];
    [shadowImageView setImage:[UIImage imageNamed:@"red_line_and_shadow.png"]];    
    [self.view addSubview:shadowImageView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectBtn:) name:nil object:nil];
    
}
//点击进入详细页面
-(void)selectBtn:(NSNotification *)notifion
{
    
    if ([notifion.name isEqualToString:@"selectBtn"]) {
        int a = [[notifion object] intValue];
        UIButton *sender = (UIButton *)[self.view viewWithTag:a];
        [shadowImageView setFrame:sender.frame];
    }
    if ([notifion.name isEqualToString:@"PUSHPBIndustryOpportunityDetail"]) {
        PBIndustryOpportunityDetail *controller = [[PBIndustryOpportunityDetail alloc] initWithStyle:UITableViewStyleGrouped];
        controller.dataDictionary = notifion.object;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}
-(void)backHomeView
{
   [self.navigationController.tabBarController.navigationController popViewControllerAnimated:YES];
}
-(void)BtnPress:(UIButton *)sender
{
    [UIView animateWithDuration:0.1f animations:^{
        [shadowImageView setFrame:sender.frame];
    }completion:^(BOOL finish)
     {
         if (finish) {
             [[PBFinancingScroller shareInstance] setContentOffset:CGPointMake(VIEWCONTENTSIZE*[[UIScreen mainScreen] bounds].size.width, 0) animated:NO];
             self.title = [self.nameArray objectAtIndex:VIEWCONTENTSIZE-0];
         }
     }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
