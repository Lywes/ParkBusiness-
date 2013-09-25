//
//  PBsuperviewVC.m
//  ParkBusiness
//
//  Created by oh yes on 13-8-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBsuperviewVC.h"

@interface PBsuperviewVC ()

@end
@implementation PBsuperviewVC
@synthesize topView,_arr;
-(void)dealloc{
    RB_SAFE_RELEASE(topView);
    RB_SAFE_RELEASE(_arr);
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
    self.navigationItem.rightBarButtonItem = nil;
}

-(void)initdata{}
-(void)initSearchBar{}
-(void)InvestTableview{}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]autorelease];
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return KNavigationBarHeight;    //default retun 44.0f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;                       //default retun 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;                       //default retun 0;
}
-(void)initTableView{
    //add topview
    self.topView = [[[UIView alloc]init]autorelease];
    self.topView.frame = CGRectMake(0, 0, VIEWSIZE.width,  isPad()?KNavigationBarHeight:KNavigationBarHeight - 5);
    [self.view addSubview:self.topView];
    
     //add refrsh tablview
    UITableView *__tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableview = __tableview;
    [__tableview release];
    if ([self TopViewHidden]) {
        self.tableview.frame = CGRectMake(0, 0, VIEWSIZE.width, VIEWSIZE.height- KNavigationBarHeight);
    }
    else{
        self.tableview.frame = CGRectMake(0, self.topView.frame.size.height, VIEWSIZE.width, VIEWSIZE.height -self.topView.frame.size.height - KNavigationBarHeight);
    }
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    activity  = [[PBActivityIndicatorView alloc]initWithFrame:self.tableview.frame];
    
    [self.view addSubview:activity];
    [activity retain];
}
-(BOOL)TopViewHidden{
    return YES; //default return YES
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initTopViewNumBtn:(NSInteger)num BtnNameArr:(NSArray *)nameAr{
    //button
    float x = VIEWSIZE.width/num;
    for (int i = 0; i<num; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*x, 0, x, self.topView.frame.size.height);
        [btn setTitle:[nameAr objectAtIndex:i] forState:UIControlStateNormal];
        if (i == 0) {
             [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        else {
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }

        btn.titleLabel.font = [UIFont fontWithName:@"Papyrus" size:15];
        NSLog(@"%@",[UIFont familyNames]);
        btn.tag = 20+i;
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:btn];
        
    }
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0,self.topView.frame.size.height - 2,self.topView.frame.size.width,2)];
    imageview.image = [UIImage imageNamed:@"userinfo_header_separator.png"];
    [self.topView addSubview:imageview];
    [imageview release];
}
-(void)BtnImageChange:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    for (int i = 20; i<23; i++) {
        if (i!=btn.tag) {
            UIButton *btn1 = (UIButton *)[self.view viewWithTag:i];
            [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}

@end
