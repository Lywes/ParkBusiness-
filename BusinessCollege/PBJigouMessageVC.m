//
//  PBJigouMessageVC.m
//  ParkBusiness
//
//  Created by China on 13-8-28.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define ZHISHIKETANG_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/knowledgeclasslist",HOST]]
#import "PBJigouMessageVC.h"
#import "PBKnowledgeVC.h"
#import "NSObject+NAV.h"
@interface PBJigouMessageVC ()

@end

@implementation PBJigouMessageVC
@synthesize parentController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initdata
{
    [ac startAnimating];
    PBdataClass *dataclass = [[PBdataClass alloc]init];
    dataclass.delegate = self;
    self.dataclass = dataclass;
    [dataclass release];
    if (pageno == 1) {
        [self.dataArr removeAllObjects];
    }
    NSDictionary *dic= [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageno],@"pageno",USERNO,@"userno",@"3",@"kind", nil];
    [self.dataclass dataResponse:ZHISHIKETANG_URL postDic:dic searchOrSave:YES];
    [dic release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([PBUserModel getPasswordAndKind].kind != 2) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"jigou_fabu.png"];
        btn.frame = isPad()?CGRectMake(self.tableview.frame.size.width - 50, 5, image.size.width, image.size.height) :CGRectMake(self.tableview.frame.size.width - 30, 5, image.size.width/2, image.size.height/2);
        
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(rightBarButtonItemPress:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.zsfb_btn = btn;
        [self.view addSubview:self.zsfb_btn];
    }
	// Do any additional setup after loading the view.
}
-(void)rightBarButtonItemPress:(id)sender
{
    /*
     if ([PBUserModel getPasswordAndKind].kind==2) {
     UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您必须成为融商正式会员后才能使用此功能！" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) otherButtonTitles:@"申请正式加盟", nil];
     [alert show];
     [alert release];
     return;
     }
     */
    PBKnowledgeVC * knowladgevc = [[PBKnowledgeVC alloc]initWithStyle:UITableViewStyleGrouped];
//    PBNavigationController * nav = [[PBNavigationController alloc] initWithRootViewController:knowladgevc];
//    [self customButtom:knowladgevc];
//    [self customNav:nav];
//    [self.parentController presentModalViewController:nav animated:YES];
//    [nav release];
//    [knowladgevc release];
    [self.parentController.navigationController pushViewController:knowladgevc animated:YES];
    [knowladgevc release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"APPLYJOININ" object:nil];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
