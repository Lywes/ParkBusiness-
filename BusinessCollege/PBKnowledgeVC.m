//
//  PBKnowledgeVC.m
//  ParkBusiness
//
//  Created by QDS on 13-7-1.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define ADDZHISHIKETANG_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/addknowledgeclass",HOST]]

#import "PBKnowledgeVC.h"
@interface PBKnowledgeVC ()

@end

@implementation PBKnowledgeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"机构发布";
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.tableView.separatorColor = [UIColor clearColor];
//    self.tableView.backgroundView = nil;
//    self.tableView.backgroundColor = [UIColor clearColor];
//    self.tableView.tableFooterView = [self footView];//footview
//    [self navigatorRightButtonNme:NSLocalizedString(@"nav_btn_tj", nil) backimageName:nil];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_tj", nil) style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemPress:)]autorelease];
    self.KIT_arr = [[[NSMutableArray alloc]initWithCapacity:2]autorelease];
}
-(void)rightBarButtonItemPress:(id)sender
{
    NSLog(@"%@",self.KIT_arr);
    NSString *textfieldtext = [[self.KIT_arr objectAtIndex:0] text];
    NSString *textviewtext = [[self.KIT_arr objectAtIndex:1] text];
    if ([textfieldtext isEqualToString:@""] || textfieldtext == NULL || [textviewtext isEqualToString:@""] || textviewtext == NULL) {
        [self showAlertViewWithMessage:@"填写不完整,请填写完整"];
    }
    else
    {
        PBdataClass *dataclass = [[PBdataClass alloc]init];
        dataclass.delegate = self;
        self.dataclass = dataclass;
        [dataclass release];
        [self.dataclass dataResponse:ADDZHISHIKETANG_URL postDic:[NSDictionary dictionaryWithObjectsAndKeys:textviewtext,@"content",textfieldtext,@"title",USERNO,@"userno", nil] searchOrSave:NO];
    }

}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    [self showAlertViewWithMessage:@"发表成功"];
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)searchFilad
{
    [self showAlertViewWithMessage:@"网络有问题，提交失败"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 搜索栏代理
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

}
#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]autorelease];
//        cell.backgroundColor = [UIColor clearColor];
        if (indexPath.section == 0) {
            UITextField *textfield = [self addtextfield];
            CGRect rect = cell.frame;
            rect.origin.x += 10;
            textfield.frame = rect;
            [textfield becomeFirstResponder];
            if (self.KIT_arr.count<2) {
                [self.KIT_arr addObject:textfield];
            }
            [cell.contentView addSubview:textfield];
        }
        else
        {
            UITextView *textview = [self addtextview];
          
            textview.frame = CGRectMake(0, 0, isPad()?679:300, 80);
            [textview setEditable:YES];
            if (self.KIT_arr.count<2) {
                 [self.KIT_arr addObject:textview];
            }
            [cell.contentView addSubview:textview
             ];
        }
        
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *str = NULL;
    if (section == 0) {
        str = @"主题";
    }
    if (section == 1) {
        str = @"内容";
    }
    return  str;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 44.0f;
        case 1:
            return 80.0f;
        default:
            return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
-(UIView *)footView
{
    UITextView *footview = [[[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)]autorelease];
    footview.text = @"每提交一份有效的知识,系统会为您的诚信积分增加5分,恶意提交系统扣除5分诚信积分.";
    footview.scrollEnabled = NO;
    footview.textAlignment = UITextAlignmentLeft;
    footview.backgroundColor = [UIColor clearColor];
    return footview;
}
@end
