//
//  PBliuyan.m
//  ParkBusiness
//
//  Created by 上海 on 13-5-15.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define LIUYAN_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@admin/index/addfeedback",UNION]]
#import "PBliuyan.h"

@interface PBliuyan ()

@end

@implementation PBliuyan
@synthesize liuyantext;
-(void)dealloc
{
    [self.dataclass release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"留言";
        [self backUpView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigatorRightButtonType:FASONG];
    self.liuyantext = [self addtextview];
    [self.liuyantext setEditable:YES];
    self.dataclass = [[PBdataClass alloc]init];
    self.dataclass.delegate = self;
    [self.liuyantext becomeFirstResponder];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];

        [cell.contentView addSubview:self.liuyantext];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  isPad()?120:44;
}
-(void)NvBtnPress:(id)sender
{
    [self.dataclass dataResponse:LIUYAN_URL postDic:[NSDictionary dictionaryWithObjectsAndKeys: USERNO,@"userno",self.liuyantext.text,@"content", nil] searchOrSave:NO];
}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    [self showAlertViewWithMessage:@"发送成功"];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)searchFilad
{
//    [self showAlertViewWithMessage:@"发送失败"];
    PBAlertView* alert = [[PBAlertView alloc]initWithMessage:@"网络不给力 请稍后再试"];
    [alert show];
    [alert release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
