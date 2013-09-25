//
//  PBMyManageMoneyNeedsDetail_ipad.m
//  ParkBusiness
//
//  Created by 上海 on 13-8-26.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBMyManageMoneyNeedsDetail_ipad.h"
#import "PBUnreadMessageData.h"
#define QIATAN_URL [NSString stringWithFormat:@"%@/admin/index/makearrangements",HOST]
#define URL [NSString stringWithFormat:@"%@admin/index/searchmyneedsfeedback", HOST]
@interface PBMyManageMoneyNeedsDetail_ipad ()

@end

@implementation PBMyManageMoneyNeedsDetail_ipad
@synthesize dicData;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(7, 7, 25, 30);
        [btn addTarget:self action:@selector(backHomeView) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = barButton;
    }
    return self;
}
-(void)backHomeView{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect frame = self.view.frame;
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width/3, frame.size.height) style:UITableViewStyleGrouped];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    titleArr = [[NSArray alloc]initWithObjects:NSLocalizedString(@"_tb_lclx", nil),NSLocalizedString(@"_tb_kyzj", nil),NSLocalizedString(@"_tb_qwnhbl", nil),NSLocalizedString(@"_tb_sjzq", nil), nil];
    subTableView = [[UITableView alloc]initWithFrame:CGRectMake(frame.size.width/3, 0, frame.size.width*2/3, frame.size.height) style:UITableViewStyleGrouped];
    subTableView.delegate = self;
    subTableView.dataSource = self;
    mainTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_background"]];
    subTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_background"]];
    [self.view addSubview:mainTableView];
    [self.view addSubview:subTableView];
    [self initTitleView];
    [indicator = [PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:indicator];
    PBWeiboDataConnect* connect = [[PBWeiboDataConnect alloc]init];
    connect.delegate = self;
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[self.dicData objectForKey:@"no"],@"needsno",@"2",@"type" ,nil];
    [connect getXMLDataFromUrl:URL postValuesAndKeys:dic];
    [indicator startAnimating];
    [PBUnreadMessageData updateOldNumWithNeedsNo:[[self.dicData objectForKey:@"no"] intValue] withType:2];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadMyNeedsData" object:nil];
	// Do any additional setup after loading the view.
}
-(void)initTitleView{
    labelArr = [NSMutableArray new];
    for (int i = 0; i<[titleArr count]; i++) {
        UILabel* label = [[UILabel alloc]init];
        label.text = [titleArr objectAtIndex:i];
        label.backgroundColor = [UIColor clearColor];
        UIFont* font = [UIFont systemFontOfSize:14];
        label.font = font;
//        label.textColor = [UIColor blueColor];
        CGSize textSize = [[titleArr objectAtIndex:i] sizeWithFont:[UIFont boldSystemFontOfSize:16]];
        label.frame = CGRectMake(130, 5, mainTableView.frame.size.width-textSize.width-50, 35);
        switch (i) {
            case 0:
                label.text = [dicData objectForKey:@"type"];
                break;
            case 1:
                label.text = [NSString stringWithFormat:@"%@ 万元",[dicData objectForKey:@"availablefund"]];
                break;
            case 2:
            {
                label.text = [dicData objectForKey:@"expectreturn"];
                label.numberOfLines = 0;
            }
                break;
            case 3:
            {
                label.text = [dicData objectForKey:@"timeperiod"];
            }
                break;
            default:
                break;
        }
        [labelArr addObject:label];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==subTableView) {
        return [self HeightAStr:[[allData objectAtIndex:indexPath.section] objectForKey:@"answer"]withTableView:subTableView]+30;
    }
    return 44.0f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (tableView == mainTableView) {
        return [titleArr count];
    }
    return [allData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if (_tableView == mainTableView) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [titleArr objectAtIndex:indexPath.section];
        UILabel* label = (UILabel*)[labelArr objectAtIndex:indexPath.section];
        [cell.contentView addSubview:label];
    }
    if (_tableView==subTableView) {
        cell = [subTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(10, 2, subTableView.frame.size.width, 20)];
            name.numberOfLines = 0;
            name.backgroundColor = [UIColor clearColor];
            name.font = [UIFont boldSystemFontOfSize:14];
            name.tag = 11;
            UILabel *text = [[UILabel alloc]initWithFrame:CGRectZero];
            text.numberOfLines = 0;
            text.font = [UIFont systemFontOfSize:14];
            text.tag = 12;
            text.textColor = [UIColor grayColor];
            text.backgroundColor = [UIColor clearColor];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundImage:[UIImage imageNamed:@"custom_button"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(INeedchat:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:@"我要洽谈" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:10];
            btn.tag = 13;
            [cell.contentView addSubview:btn];
            [cell.contentView addSubview:name];
            [cell.contentView addSubview:text];
            [name release];
            [text release];
        }
        UIButton *btn = (UIButton *)[cell.contentView viewWithTag:13];
        UILabel *text = (UILabel *)[cell.contentView viewWithTag:12];
        UILabel *name = (UILabel *)[cell.contentView viewWithTag:11];
        CGFloat a = 0.0f;
        if (allData.count>0) {
            a = [self HeightAStr:[[allData objectAtIndex:indexPath.section] objectForKey:@"answer"]withTableView:subTableView]-20;
            text.text = [[allData objectAtIndex:indexPath.section] objectForKey:@"answer"];
            text.frame = CGRectMake(10, 25, subTableView.frame.size.width - 70, a);
            name.text = [[allData objectAtIndex:indexPath.section] objectForKey:@"financename"];
            btn.enabled = ![[[allData objectAtIndex:indexPath.section] objectForKey:@"flag"] boolValue];
            [btn setFrame:CGRectMake(subTableView.frame.size.width-125,text.frame.origin.y+text.frame.size.height, 55, 25)];
        }
    }
    // Configure the cell...
    
    return cell;
}
-(void)INeedchat:(UIButton *)sender
{
    checkButton = sender;
    NSIndexPath *index =  [subTableView indexPathForCell:(UITableViewCell *)sender.superview.superview];
    indexno = index.section;
    UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"信息" message:@"思考好了再做决定" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) otherButtonTitles:@"确定", nil];
    [view show];
    [view release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [indicator startAnimating];
        PBWeiboDataConnect* submit = [[PBWeiboDataConnect alloc]init];
        submit.delegate = self;
        NSMutableDictionary *dic= [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                   [[allData objectAtIndex:indexno] objectForKey:@"no"],@"no",nil];
        [submit submitDataFromUrl:QIATAN_URL postValuesAndKeys:dic];
        [dic release];
    }
}
-(void)sucessSendPostData:(PBWeiboDataConnect *)weiboDatas{
    [indicator stopAnimating];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"谢谢您选中我们提供的融资方案，我们会在24小时内与您取得联系，您可以直接通过APP或网站提交您的融资申请。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    checkButton.enabled = NO;
    [alert show];
    [alert release];
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(tableView==subTableView){
        if (section==0) {
            return @"理财需求反馈列表";
        }
    }
    return nil;
}

-(CGFloat)HeightAStr:(NSString *)str withTableView:(UITableView*)tableView
{
    UIFont *font = [UIFont systemFontOfSize:14];
    CGFloat a = tableView.frame.size.width - 30;
    CGSize tag = [str sizeWithFont:font constrainedToSize:CGSizeMake(a, 800) lineBreakMode:NSLineBreakByWordWrapping];
    return MAX(44.0f, tag.height+20);
}
-(void)sucessParseXMLData:(PBWeiboDataConnect *)weiboDatas{
    [indicator stopAnimating];
    allData = weiboDatas.parseData;
    if (allData.count==0) {
        subTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"needs_feedback_ipad"]];
    }
    [subTableView reloadData];
}

@end
