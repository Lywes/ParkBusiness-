//
//  PBhuodong.m
//  PBBank
//
//  Created by lywes lee on 13-5-7.
//  Copyright (c) 2013年 shanghai. All rights reserved.
//
#define SEARCHACTIVITYXIANGXI [NSURL URLWithString:[NSString stringWithFormat:@"%@admin/index/activitydetail",UNION]]
#define BAOMINGACTIVITY [NSURL URLWithString:[NSString stringWithFormat:@"%@admin/index/applyactivity",UNION]]

#import "PBhuodongyugao.h"
@interface PBhuodongyugao ()
-(void)initPresentView;
-(void)initPresentData;
-(void)NvButtonNotEdit;

@end

@implementation PBhuodongyugao
@synthesize no;
-(void)dealloc
{
    [self.dataclass release];
    [self.DataArr release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"活动详情";
         [self backUpView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initPresentView];
    [self initPresentData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"编号：%@",self.no);
    self.dataclass.delegate = self;
    [self.dataclass dataResponse:SEARCHACTIVITYXIANGXI postDic:[NSDictionary dictionaryWithObjectsAndKeys:self.no,@"no",[NSString stringWithFormat:@"%d",1],@"userno" ,nil] searchOrSave:YES]; 
}
-(void)initPresentView
{
    //加载动画
    self.activity = [[PBActivityIndicatorView alloc]initWithFrame:self.navigationController.view.frame];
    [self.view addSubview:self.activity];
}
-(void)initPresentData
{
    NSMutableArray *a1 = [NSMutableArray arrayWithObjects:@"举办单位",@"承办单位",@"协助单位", nil];
    NSMutableArray *a2 = [NSMutableArray arrayWithObjects:@"活动地点",@"举办时间",@"参加人数",@"收费标准", nil];
    NSMutableArray *a3 = [NSMutableArray arrayWithObjects:@"姓名",@"电话",@"邮件",@"FAX", nil];
    NSMutableArray *a4 = [NSMutableArray arrayWithObjects:@"活动现场图片",@"活动现场视频", nil];
    self.headArr = [[[NSMutableArray alloc]initWithObjects:@"活动背景",a1,@"主要嘉宾",@"活动议程",a2,a3,a4, nil]autorelease];
    self.DataArr = [NSMutableArray arrayWithCapacity:100];
    self.dataclass = [[PBdataClass alloc]init];

}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
      NSLog(@"活动详情:%@",datas);
    NSDictionary *dic = [datas objectAtIndex:0];
    if ([[dic objectForKey:@"applyflag"] isEqual:@"1"]) {
        [self NvButtonNotEdit];
    }
    NSArray *a1 = [NSArray arrayWithObject:[dic objectForKey:@"activitybackground"]];
    NSArray *a2 = [NSArray arrayWithObjects:[dic objectForKey:@"company"],[dic objectForKey:@"cocompany"],@"",nil];
    NSArray *a3 = [NSArray array];
    if (![[dic objectForKey:@"attendees"] isEqualToString:@""]) {
        a3 = [NSArray arrayWithArray:[dic objectForKey:@"attendees"]];
    }
//    NSArray *a3 = [NSArray arrayWithArray:[dic objectForKey:@"attendees"]];
    NSArray *a4 = [NSArray arrayWithObjects:@"",nil];
    NSArray *a5 = [NSArray arrayWithObjects:[dic objectForKey:@"address"],[dic objectForKey:@"stdate"],[dic objectForKey:@"personamount"],[dic objectForKey:@"charge"],nil];
    NSString *linkmanname = [[dic objectForKey:@"linkmanname"] isEqualToString:@""]?@"":[NSString stringWithFormat:@"姓名                    %@",[dic objectForKey:@"linkmanname"]];
    
    NSString *tel = [[dic objectForKey:@"tel"] isEqualToString:@""]?@"":[NSString stringWithFormat:@"电话                   %@",[dic objectForKey:@"tel"]];
    
    NSString *email = [[dic objectForKey:@"email"] isEqualToString:@""]?@"":[NSString stringWithFormat:@"email                %@",[dic objectForKey:@"email"]];
    
//     NSString *FAX = [dic objectForKey:@"FAX"] == @""?@"":[dic objectForKey:@"FAX"];
    NSMutableArray *a6 = [[[NSMutableArray alloc]init]autorelease];
    if (![linkmanname isEqualToString:@""]) {
        [a6 addObject:linkmanname];
    }
    if (![tel isEqualToString:@""]) {
         [a6 addObject:tel];
    }
    if (![email isEqualToString:@""]) {
        [a6 addObject:email];
    }
//    if (![FAX isEqualToString:@""]) {
//        [a6 addObject:FAX];
//    }

     self.DataArr = [NSMutableArray arrayWithObjects:a1,a2,a3,a4,a5,a6, nil];
  
    [self.tableView reloadData];
}
//右导航按钮
-(void)NvBtnPress:(id)sender
{
    UIAlertView *aletview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否要报名此活动" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) otherButtonTitles:@"确定", nil];
    [aletview show];
    [aletview release];
}
//报名成功
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    if ([intvalue integerValue] == 1) {
        [self.activity stopAnimating];
        [self NvButtonNotEdit];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.activity startAnimating];
        [self.dataclass dataResponse:BAOMINGACTIVITY postDic:[NSDictionary dictionaryWithObjectsAndKeys:self.no,@"no",[NSString stringWithFormat:@"%d",1],@"userno", nil] searchOrSave:NO];
        [self showAlertViewWithMessage:@"成功报名"];
    }

}
//导航栏右键失效与名字变换
-(void)NvButtonNotEdit
{
    self.navigationItem.rightBarButtonItem.title = @"已报名";
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
}
//报名失败
-(void)searchFilad
{
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if ([self.stylename isEqualToString:@"huigu"]) {
        return 7;
    }
    else {
         return 6;
    }
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            return 1;   
        case 1:
            return 3;  
        case 2:
        {
            if (self.DataArr.count>0) {
                NSInteger a = [[self.DataArr objectAtIndex:section] count];
                if (a>0) {
                    return a;
                }
                else {
                    return 1;
                }
            }
        }
        case 3:
            return 1;  
        case 4:
            return 4;  
        case 5:
        {
            if (self.DataArr.count>0) {
                NSInteger a = [[self.DataArr objectAtIndex:section] count];
                if (a>0) {
                    return a;
                }
                else {
                    return 1;
                }
            }
        }  
        case 6:
            return 2; 
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier]autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:ContentFontSize];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:ContentFontSize];
    if (indexPath.section == 0) {
        UITextView *textview = [self addtextview];
        [cell.contentView addSubview:textview];
        if (self.DataArr.count>0) {
            textview.text = [[self.DataArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        }
        
    }
    if (indexPath.section != 0 && indexPath.section != 2 && indexPath.section != 5) {
        id Aclass = [self.headArr objectAtIndex:indexPath.section];
        if ([Aclass isKindOfClass:[NSMutableArray class]]) {
            cell.textLabel.text = [Aclass objectAtIndex:indexPath.row];
        }
        else {
            cell.textLabel.text = Aclass;
        }
        if (indexPath.section == 3) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    if (indexPath.section ==1 || indexPath.section == 4) {
        UILabel *lable = [self addshortLable];
        [cell.contentView addSubview:lable];
        if ([self.DataArr count]>0) {
            lable.text = [[self.DataArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        }
    }
    if (indexPath.section == 2) {
        if (self.DataArr.count>0) {
            NSArray *arr = [self.DataArr objectAtIndex:indexPath.section];
            if (arr.count>0) {
                id dic = [arr objectAtIndex:indexPath.row];
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    cell.textLabel.text = [dic objectForKey:@"job"];
                    cell.detailTextLabel.text = [dic objectForKey:@"name"];
                }
            }
            else {
                cell.hidden = YES;
            }

        }
        else {
            cell.hidden = YES;
        }
    }
    if (indexPath.section == 5) {
        UILabel *lable = [self addshortLable];
        [cell.contentView addSubview:lable];
        if ([self.DataArr count]>0) {
//            cell.textLabel.text = [[self.headArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            NSArray *arr =  [self.DataArr objectAtIndex:indexPath.section];
            if (arr.count >0) {
                cell.textLabel.text = [arr objectAtIndex:indexPath.row]; 
            }
            else {
                cell.hidden = YES;
            }
        }
        else {
            cell.hidden = YES;
        }
        
    }
    if ([self.stylename isEqualToString:@"huigu"]) {
        if (indexPath.section == 6) {
            cell.textLabel.text = [[self.headArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text  = @"点击下载";
        }
    }
    return cell;
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 120.0f;
    }
    else {
        return 44;
    }
}
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.headArr objectAtIndex:section];
    }
    if (section == 2) {
        if (![self.DataArr count]>0) {
            return nil;
        }
        else {
            if ([[self.DataArr objectAtIndex:section] count]>0) {
                NSString *str = @"重要嘉宾";
                return str;
            }

        }

    }
    if (section == 5) {
        if (![self.DataArr count]>0) {
            return nil;
        }
        else {
            if ([[self.DataArr objectAtIndex:section] count]>0) {
                NSString *str = @"咨询热线";
                return str;
            }
            else {
                return nil;
            }
        }
        
    }
    else {
        return nil;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
