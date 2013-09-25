//
//  PBMyFinanceNeedsFeedBack.m
//  ParkBusiness
//
//  Created by 上海 on 13-8-26.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBMyFinanceNeedsFeedBack.h"
#import "PBUnreadMessageData.h"
#define QIATAN_URL [NSString stringWithFormat:@"%@/admin/index/makearrangements",HOST]
#define URL [NSString stringWithFormat:@"%@admin/index/searchmyneedsfeedback", HOST]
@interface PBMyFinanceNeedsFeedBack ()

@end

@implementation PBMyFinanceNeedsFeedBack
@synthesize feedbackno;
@synthesize type;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"融资需求反馈列表";
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
    [PBUnreadMessageData updateOldNumWithNeedsNo:[feedbackno intValue] withType:[type intValue]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadMyNeedsData" object:nil];
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_background"]];
    [indicator = [PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:indicator];
    PBWeiboDataConnect* connect = [[PBWeiboDataConnect alloc]init];
    connect.delegate = self;
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:feedbackno,@"needsno",type,@"type" ,nil];
    [connect getXMLDataFromUrl:URL postValuesAndKeys:dic];
    [indicator startAnimating];
}
-(void)sucessParseXMLData:(PBWeiboDataConnect *)weiboDatas{
    [indicator stopAnimating];
    allData = weiboDatas.parseData;
    if (allData.count==0) {
        self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"needs_feedback"]];
    }
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [allData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(10, 2, self.view.frame.size.width, 20)];
        name.numberOfLines = 0;
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont boldSystemFontOfSize:15];
        name.tag = 11;
        UILabel *text = [[UILabel alloc]initWithFrame:CGRectZero];
        text.numberOfLines = 0;
        text.font = [UIFont systemFontOfSize:isPad()?16:14];
        text.tag = 12;
        text.textColor = [UIColor grayColor];
        text.backgroundColor = [UIColor clearColor];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"custom_button"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(INeedchat:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"我要洽谈" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:isPad()?12:10];
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
        a = [self HeightAStr:[[allData objectAtIndex:indexPath.section] objectForKey:@"answer"]];
        text.text = [[allData objectAtIndex:indexPath.section] objectForKey:@"answer"];
        text.frame = CGRectMake(10, 25, self.view.frame.size.width - 30, a);
        name.text = [[allData objectAtIndex:indexPath.section] objectForKey:@"financename"];
        btn.enabled = ![[[allData objectAtIndex:indexPath.section] objectForKey:@"flag"] boolValue];
        [btn setFrame:CGRectMake(self.view.frame.size.width-85,text.frame.origin.y+text.frame.size.height, 55, 25)];
    }
    
    // Configure the cell...
    
    return cell;
}
-(void)INeedchat:(UIButton *)sender
{
    checkButton = sender;
    NSIndexPath *index =  [self.tableView indexPathForCell:(UITableViewCell *)sender.superview.superview];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (allData.count>0) {
        return [self HeightAStr:[[allData objectAtIndex:indexPath.section] objectForKey:@"answer"]]+50;
    }
    return 44.0f;
}

-(CGFloat)HeightAStr:(NSString *)str
{
    UIFont *font = [UIFont systemFontOfSize:isPad()?16:14];
    CGFloat a = self.view.frame.size.width - 30;
    CGSize tag = [str sizeWithFont:font constrainedToSize:CGSizeMake(a, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    return MAX(20.0f, tag.height);
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
