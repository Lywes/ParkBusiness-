//
//  FAGroupMemberController.m
//  FASystemDemo
//
//  Created by wangzhigang on 13-2-15.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "FAGroupMemberController.h"
#import "FATitleBusinessCardView.h"
#import "FAGroupMemberData.h"
#import "FAUserData.h"
#import "FAFriendData.h"
#import "FAPeopleChatView.h"
#import "PBUserModel.h"
#import "PBWeiboCell.h"
#define MEMBERURL @"http://www.5asys.com/searchmember"
//#define URL [NSString stringWithFormat:@"%@/admin/index/searchtweibo",HOST]
@interface FAGroupMemberController ()

@end

@implementation FAGroupMemberController
@synthesize groupid;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"群组成员";
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    indicator = [[PBActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, isPad()?768:320, isPad()?1024:(isPhone5()?568:460))];
    [self.view addSubview:indicator];
    [indicator startAnimating];
    memberData = [[PBWeiboDataConnect alloc]init];
    memberData.delegate = self;
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.groupid],@"gid",USERNO,@"uid", nil];
    [memberData getXMLDataFromUrl:MEMBERURL postValuesAndKeys:dic];
//    NSArray* arr1 = [NSArray arrayWithObjects:@"1",@"",@"",nil];
//    NSArray* arr2 = [NSArray arrayWithObjects:@"pageno",@"trade",@"sort", nil];
//    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
//    [memberData getXMLDataFromUrl:URL postValuesAndKeys:dic];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)sucessParseXMLData:(PBWeiboDataConnect *)weiboDatas{
    [indicator stopAnimating];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [memberData.parseData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    PBWeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [tableView registerNib:[UINib nibWithNibName:isPad()?@"PBWeiboCell_ipad":@"PBWeiboCell" bundle:nil]forCellReuseIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }else {
        [cell.imageViews removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIView* view in [[cell contentView] subviews]) {
        view.frame = CGRectZero;
    }
    if([memberData.parseData count]>0){
        NSMutableDictionary* dic = [memberData.parseData objectAtIndex:indexPath.row];
        //设置cell位置及大小
        cell.customlabel1.font = [UIFont boldSystemFontOfSize:isPad()?16:14];//设置姓名大小
        cell.customlabel1.frame = CGRectMake(85, 15, 100, 30);
        cell.customlabel2.font = [UIFont systemFontOfSize:isPad()?PadContentFontSize:ContentFontSize];//设置ID大小
        cell.customlabel2.textColor = [UIColor grayColor];
        cell.customlabel2.frame = CGRectMake(85, 45, 100, 30);
        cell.customlabel3.font = [UIFont systemFontOfSize:isPad()?PadContentFontSmallSize:ContentFontSmallSize];//设置签名大小
        cell.customlabel3.frame = CGRectMake(isPad()?300:185, 10, isPad()?350:130, 70);
        cell.customlabel3.textColor = [UIColor grayColor];
        cell.customlabel3.numberOfLines = 0;
        cell.customlabel1.text = [dic objectForKey:@"username"];//姓名
        cell.customlabel2.text = [dic objectForKey:@"uid"];//ID
        cell.customlabel3.text = [dic objectForKey:@"signature"];//个性签名
        //加载boss头像应该用异步方式
        NSString *tutorURLStr = [dic objectForKey:@"imgpath"];
        cell.imageViews = [[CustomImageView alloc]initWithFrame:CGRectMake(5, 5, 65 , 65)];
        [[cell contentView] addSubview:cell.imageViews];
        [cell.imageViews.imageView loadImage:tutorURLStr withPlaceholdImage:[UIImage imageNamed:@"list_addfriend_icon.png"]];
    }
    return cell;
}
//详细按钮点击后的处理
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    FATitleBusinessCardView *cardController = [[[FATitleBusinessCardView alloc] initWithStyle:UITableViewStyleGrouped ] autorelease];
    FAGroupMemberData *member = [groupmember objectAtIndex:indexPath.row];
    
    
    cardController.friendflg = [FAFriendData isFriend:member.userid];
    
    cardController.friendid = member.userid;
    [self.navigationController pushViewController:cardController animated:YES];

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
- (void)dealloc
{
    [super dealloc];
    [memberData release];
    [indicator release];
    [groupmember release];
    
}
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
    FAGroupMemberData *member = [groupmember objectAtIndex:indexPath.row];
    if ([FAFriendData isFriend:member.userid]) {
        FAPeopleChatView* view = [[[FAPeopleChatView alloc] initWithNibName:isPad()?@"FAPeopleChatView_ipad": @"FAPeopleChatView" bundle:nil] autorelease];
        
        
        
        view.friendid = member.userid;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:view];
        nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        //view.title = className;
        //[self presentModalViewController:nav animated:YES];
        [self.navigationController presentViewController:nav animated:YES completion:NULL];
    }else{
        UIActionSheet *sheet = [[[ UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) destructiveButtonTitle:nil otherButtonTitles:@"加为好友", nil] autorelease];
        sheet.tag = indexPath.row;
        [sheet showInView:self.view];
        
    }
}
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    int row = actionSheet.tag;
    FAGroupMemberData *member = [groupmember objectAtIndex:row];
    if ( buttonIndex != actionSheet.cancelButtonIndex ) {
        FAChatManager *manager = [[[FAChatManager alloc] init] autorelease];
        FAUserData *userdata = [FAUserData search];
        
        [manager inviteToBeFreindTo:member.userid fromId:userdata.no];
    }
}
@end
