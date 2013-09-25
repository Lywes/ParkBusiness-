//
//  PBFinancingVC.m
//  ParkBusiness
//
//  Created by QDS on 13-6-28.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define RONGZIXUQIU_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/addcompanyfinancingneeds",HOST]]
#import "PBFinancingVC.h"
@interface PBFinancingVC ()

@end

@implementation PBFinancingVC
@synthesize textview_arr;
@synthesize actity;
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
    self.title = NSLocalizedString(@"Left_mainTable_RZXQ", nil);
    [self backUpView];
    [self navigatorRightButtonType:WANCHENG];
    self.textview_arr = [[[NSMutableArray alloc]initWithCapacity:4]autorelease];
    self.actity = [[[PBActivityIndicatorView alloc]initWithFrame:self.navigationController.view.frame]autorelease];
    [self.view addSubview:self.actity];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)NvBtnPress:(id)sender
{
    NSMutableArray *value = [[NSMutableArray alloc]init];
    NSMutableArray *key = [[NSMutableArray alloc]initWithObjects:@"fundneed",@"fundused",@"propertyinfo",@"companydevelopment",@"userno", nil];
    for (UITableViewCell *cell in textview_arr ) {
       UITextView *textview = [cell.contentView.subviews objectAtIndex:0];
        [value addObject:textview.text];
    }
    [value addObject:USERNO];
    PBdataClass *dataclass = [[PBdataClass alloc]init];
    dataclass.delegate = self;
    [self.actity  startAnimating];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:value forKeys:key];
    [dataclass dataResponse:RONGZIXUQIU_URL postDic:dic searchOrSave:NO];
    [value release];
    [key release];
}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    [self.actity  stopAnimating];
    [dataclass release];
    [self.navigationController popToRootViewControllerAnimated:YES];
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发送成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertview show];
    [alertview release];
}
#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
      cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UITextView *textview = [self addtextview];
    [textview setEditable:YES];
    if (indexPath.section == 0) {
        textview.keyboardType = UIKeyboardTypeNumberPad;
    }
    if (self.textview_arr.count<4) {
        [self.textview_arr addObject:cell];
    }
    [cell.contentView addSubview:textview];
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"资金需求";
            break;
        case 1:
            return @"资金用途";
            break;
        case 2:
            return @"企业知识产权情况";
            break;
        case 3:
            return @"企业发展状况（行业整体状况、市场占有率、技术先进性、所获奖项等）";
            break;
            
        default:
            return nil;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
@end
