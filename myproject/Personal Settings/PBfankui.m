//
//  PBfankui.m
//  ParkBusiness
//
//  Created by lywes lee on 13-4-21.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define FANKUI_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/addfeedback",HOST]]
#import "PBfankui.h"

@interface PBfankui ()

@end

@implementation PBfankui
@synthesize flag;
-(void)dealloc
{
    [textview release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    
    }
    return self;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [textview becomeFirstResponder];


}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"反馈信息";

//    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn1.tag = 101;
//    btn1.frame = CGRectMake(3, 1.5, 40, 40);
//    [btn1 addTarget:self action:@selector(backHomeView:) forControlEvents:UIControlEventTouchUpInside];
//    [btn1 setBackgroundImage:[UIImage imageNamed:@"right_back.png"] forState:UIControlStateNormal];
//    UIBarButtonItem *barButton1 = [[UIBarButtonItem alloc] initWithCustomView:btn1];
//    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:barButton1,rightbtn1, nil];

    UIBarButtonItem *rightbtn1 = [[UIBarButtonItem alloc]initWithTitle:@"反馈" style:UIBarButtonItemStylePlain target:self action:@selector(showTitleView)];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    self.navigationItem.rightBarButtonItem = rightbtn1;
    [rightbtn1 release];
    
    if (isPad()) {
        textview = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 679, 120)];
        textview.font = [UIFont systemFontOfSize:14];
    }
    else {
        textview = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 300, 120)];
        textview.font = [UIFont systemFontOfSize:13];
    }
    isedit = NO;
    textview.backgroundColor = [UIColor clearColor];
    textview.delegate = self;
    self.tableView.tableHeaderView = [self headerView];
}
-(void)showTitleView{
    
    if ([textview.text isEqualToString: @""]) {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"填写不完整,请填写完整" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alrt show];
        [alrt release];
    }
    else
    {
        PBdataClass *dataclass = [[PBdataClass alloc]init];
        dataclass.delegate =self;
        [dataclass dataResponse:FANKUI_URL postDic:[NSDictionary dictionaryWithObjectsAndKeys:textview.text,@"content",USERNO,@"userno", nil] searchOrSave:NO];
        
    }
    
    
}
-(UIView *)headerView
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    UITextView *fheaderView = [[[UITextView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-10, 70)]autorelease];
    fheaderView.font = [UIFont systemFontOfSize:isPad()?16:14];
    fheaderView.text = @"我们热忱欢迎您在此提出针对我们APP的改进意见，以及针对平台上各金融机构的服务、产品的反馈意见。";
    fheaderView.editable = NO;
    fheaderView.scrollEnabled = NO;
    fheaderView.backgroundColor = [UIColor clearColor];
    [view addSubview:fheaderView];
    return view;
}
-(void)viewTapped:(UITapGestureRecognizer *)tapGr
{
    [textview resignFirstResponder];
}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"谢谢你的反馈意见" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alrt show];
    [alrt release];
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
-(void)addSubViewForCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    [cell.contentView addSubview:textview];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *str;
    str = @"内容";
    return str;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    [self navigatorRightButtonType:FANKUI];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
