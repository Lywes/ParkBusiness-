//
//  PBFinancingNews.m
//  ParkBusiness
//
//  Created by oh yes on 13-8-25.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define KBTNheight 30
#define KBTNheight_iPad 40
#import "PBFinancingNews.h"
#import "PBClassroomVC.h"
#import "PBClassRoomDeatil.h"
#import "PBIndustryOpportunityList.h"
#import "NSObject+NAV.h"
#import "PBBusinessCollegeMainNV.h"
#import "PBLIcaiMessageVCViewController.h"
#import "PBJigouMessageVC.h"
#import "PBFinancingCaseController.h"
@interface PBFinancingNews ()
{
    UIView *mainview;
    UIViewController *_currentMainController;
}
@end

@implementation PBFinancingNews
@synthesize btnScr;
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    RB_SAFE_RELEASE(mainview);
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //scrollerview
    UIScrollView *scr = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, VIEWSIZE.width,isPad()? KBTNheight_iPad:KBTNheight)];
    UIImageView *iamgeview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_btnBg.png"]];
    iamgeview.frame = scr.frame;
    [scr addSubview:iamgeview];
    [iamgeview release];
    self.btnScr = scr;
    [scr release];
    
    self.btnScr.pagingEnabled = NO;
    self.btnScr.userInteractionEnabled = YES;
    self.btnScr.bounces = YES;
    
    self.btnScr.showsHorizontalScrollIndicator = NO;
    self.btnScr.showsVerticalScrollIndicator = NO;
    CGFloat weidth = scr.frame.size.width/5;
    
    //button
    NSArray *btnName_arr = [NSArray arrayWithObjects:NSLocalizedString(@"Left_mainTable_JR", nil),NSLocalizedString(@"Left_mainTable_LC", nil),NSLocalizedString(@"Left_mainTable_JGFB", nil),NSLocalizedString(@"Left_mainTable_JRAL", nil),NSLocalizedString(@"Left_mainTable_SXY", nil), nil];
    for (int i = 0; i<5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(weidth*i, 0, weidth, self.btnScr.frame.size.height);
        [btn setTitle:[btnName_arr objectAtIndex:i] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btnBg.png"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:isPad()?18:15];
        btn.tag = 10+i;
        [self.btnScr addSubview:btn];
        [btn addTarget:self action:@selector(_target:) forControlEvents:UIControlEventTouchUpInside];

    }
    self.btnScr.contentSize = CGSizeMake(weidth*5, KBTNheight);
    [self.view addSubview:self.btnScr];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, scr.frame.size.height-2 , VIEWSIZE.width,2)];
    imageview.image = [UIImage imageNamed:@"userinfo_header_separator.png"];
    [self.view addSubview:imageview];
    [imageview release];
    //prentview
    mainview = [[UIView alloc] initWithFrame:CGRectMake(0, isPad()? KBTNheight_iPad:KBTNheight, self.view.frame.size.width, self.view.frame.size.height - scr.frame.size.height)];
    [self.view addSubview:mainview];
    [mainview release];
    
    
    //prentview notifition
    [[NSNotificationCenter defaultCenter]addObserverForName:@"SHOWMAINVIEW" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        PBClassRoomDeatil *pbClassRoomDeatil = [[PBClassRoomDeatil alloc]init];
        pbClassRoomDeatil.datadic = note.object;
        [self.navigationController pushViewController:pbClassRoomDeatil animated:YES];
        [pbClassRoomDeatil release];
    }];
    //defaultview
    UIButton *btn = (UIButton *)[self.view viewWithTag:10];
    [self _target:btn];
}
-(void)_target:(UIButton *)seder{
  void (^removeSubview)(void) = ^{
      if (mainview.subviews.count > 0) { //删除之前的view
          [mainview.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
              [obj removeFromSuperview];
          }];
      }
      
      [seder setBackgroundImage:[UIImage imageNamed:@"btnselect.png"] forState:UIControlStateNormal];
      [self.btnScr.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
          if ([obj isKindOfClass:[UIButton class]]) {
              if ([(UIButton *)obj tag] != seder.tag) {
                  [obj setBackgroundImage:[UIImage imageNamed:@"btnBg.png"] forState:UIControlStateNormal];
              }
          }
          
      }];
  };
       switch (seder.tag) {
        case 10:                //融商资讯
        {
            removeSubview();
            PBClassroomVC *class = [[PBClassroomVC alloc] init];
            [mainview addSubview:class.view];
            Block_release(removeSubview);
        }
            break;
       case 11:                 //理财
       {
           removeSubview();
           PBLIcaiMessageVCViewController *class = [[PBLIcaiMessageVCViewController alloc] init];
           [mainview addSubview:class.view];
           Block_release(removeSubview);
       }
           break;
       case 12:                 //机构发布
       {
           removeSubview();
           PBJigouMessageVC *class = [[PBJigouMessageVC alloc] init];
           class.parentController = self;
           [mainview addSubview:class.view];
           Block_release(removeSubview);
       }
           break;
        case 13:                //金融案例
        {
            PBFinancingCaseController *class = [[PBFinancingCaseController alloc] init];
            class.flag = 1;
            class.title = NSLocalizedString(@"Left_mainTable_JRAL", nil);
            PBNavigationController *nav = [[PBNavigationController alloc] initWithRootViewController:class];
            [nav.navigationBar setBarStyle:UIBarStyleBlack];
            [class release];
            [self customNav:nav];
            [self customButtom:class];
            [self presentModalViewController:nav animated:YES];
            [nav release];
            
        }
            break;
           case 14:              //商学院
           {
               
               PBBusinessCollegeMainNV *class = [[PBBusinessCollegeMainNV alloc] init];
               [self customButtom:class];
               [self presentModalViewController:class animated:YES];
               [class release];
           }
               break;
        default:
            break;
    }


    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
