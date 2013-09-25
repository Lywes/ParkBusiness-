//
//  FAGroupListView.m
//  FASystemDemo
//
//  Created by wangzhigang on 13-2-15.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "FAGroupListView.h"
#import "FAGroupData.h"
#import "FAGroupMemberData.h"
#import "FAUserData.h"
#import "FAPeopleChatView.h"
#import "FAGroupMemberController.h"

@interface FAGroupListView ()
    -(void) searchGroupData;
@end

@implementation FAGroupListView

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        
        self.title = @"我的群组";
        // Custom initialization
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_zj", nil) style:UIBarButtonItemStylePlain target:self action:@selector(showGroupAddView:)];
        
        
    }
    return self;
}
-(void)backDidPush{
    
    [self.parentViewController.navigationController popViewControllerAnimated:YES];
}
-(void)showGroupAddView:(id)sender{
    [addGroupView addGroupViewWillShow];
}


-(BOOL)submitDidPushWithName:(NSString *)groupName{//点击确认按钮
    FAUserData *user = [FAUserData search];
    if (user.no>0) {
        FAChatManager *manager = [[[FAChatManager alloc]init]autorelease];
        manager.delegate = self;
        [manager addNewGroupWithName:groupName byId:user.no];
        return YES;
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"错误提示" message:@"设备成功注册后才能使用此功能。"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    return NO;
    
}
-(void)reloadData{
    [self.tableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self searchGroupData];
    [self.tableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [searchBar resignFirstResponder];
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    
    [searchBar resignFirstResponder];
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    groupdata = [FAGroupData search:-1 name:searchText limit:-1];
    [self.tableView reloadData];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchbar{//点击搜索按钮
    groupdata = [FAGroupData search:-1 name:searchbar.text limit:-1];
    [self.tableView reloadData];
    [searchbar resignFirstResponder];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
}
-(void)setAddGroupView{
    addGroupView = [[FAAddGroupView alloc]initWithFrame:self.view.frame];
    addGroupView.delegate = self;
    [self.view addSubview:addGroupView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    searchBar=[[UISearchBar alloc] init];
    searchBar.frame=CGRectMake(0, 0, (isPad()?768:320), 40);
    searchBar.delegate=self;
    //[searchBar sizeToFit];
    searchBar.backgroundColor=[UIColor clearColor];
    [[searchBar.subviews objectAtIndex:0]removeFromSuperview];
    for (UIView *subview in searchBar.subviews)
        
    {
        
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
            
        {
            
            [subview removeFromSuperview];
            
            break;
            
        }
        
    }
    UIView *tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 40)];
    //[tableHeadView setBackgroundColor:[UIColor grayColor]];
    
    //        UIImage *addImg = [UIImage imageNamed:@"discovery_icon.png"];
    //        addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        //[addBtn sizeToFit];
    //        [addBtn setImage:addImg forState:UIControlStateNormal];
    //        [addBtn setFrame:CGRectMake((isPad()?768:320)-45, 3, 38, 38)];
    //        [addBtn addTarget:self action:@selector(showGroupAddView:) forControlEvents:UIControlEventTouchUpInside];
    [tableHeadView addSubview:searchBar];
    self.tableView.tableHeaderView=tableHeadView;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshGroupList:) name:NEW_GROUP_ADD_NOTIFICATION object:nil];

    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
}

-(void)refreshGroupList:(NSNotification*)aNotification
{

    [self.tableView reloadData];
}
-(void) searchGroupData{
    groupdata = [FAGroupData search:-1 name:nil limit:0];
    //NSLog(@"select group count = %d",[groupdata count]);
    [groupdata retain];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [groupdata count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    FAGroupData *group = [groupdata objectAtIndex:indexPath.row];
    // Configure the cell...
    cell.imageView.image = [UIImage imageNamed:@"headpic.png"];
    cell.textLabel.text = group.groupname;
    
    return cell;
}
//详细按钮点击后的处理
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    FAGroupData *group = [groupdata objectAtIndex:indexPath.row];
    FAGroupMemberController *memberController = [[[FAGroupMemberController alloc] init] autorelease];
    memberController.groupid = group.groupid;
    
    [self.navigationController pushViewController:memberController animated:YES];
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
    [searchBar release];
    [groupdata release];
    [addGroupView release];
    
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
    FAPeopleChatView* view = [[[FAPeopleChatView alloc] initWithNibName:isPad()?@"FAPeopleChatView_ipad": @"FAPeopleChatView" bundle:nil] autorelease];
    FAGroupData *group = [groupdata objectAtIndex:indexPath.row];
    NSLog(@"talk groupid = %d",group.groupid);
    view.groupid = group.groupid;
    view.readflg =0;
    view.groupflg = 0;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:view];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //view.title = className;
    //[self presentModalViewController:nav animated:YES];
    [self.navigationController presentViewController:nav animated:YES completion:NULL];
}
- (void)addFreindToGroup:(NSDictionary *)aps{
    FAGroupMemberData *memberdata = [[[FAGroupMemberData alloc] init]autorelease];
    memberdata.groupid = [[aps objectForKey:@"gid"] intValue];
    memberdata.userid = [[aps objectForKey:@"id"] intValue];
    memberdata.username = [aps objectForKey:@"username"];
    memberdata.createtime = [NSDate new];
    [memberdata saveRecord];
    [self searchGroupData];
    [self.tableView reloadData];

}
- (void)addGroupAndFriendToList:(NSDictionary *)aps{
    FAGroupMemberData *memberdata = [[[FAGroupMemberData alloc] init]autorelease];
    memberdata.groupid = [[aps objectForKey:@"gid"] intValue];
    memberdata.userid = [[aps objectForKey:@"fromid"] intValue];
    memberdata.username = [aps objectForKey:@"username"];
    memberdata.createtime = [NSDate new];
    [memberdata saveRecord];
    
    FAUserData *user = [FAUserData search];
    memberdata.groupid = [[aps objectForKey:@"gid"] intValue];
    memberdata.userid = user.no;
    memberdata.username = user.name;
    memberdata.createtime = [NSDate new];
    [memberdata saveRecord];
    
    FAGroupData *group = [[[FAGroupData alloc]init]autorelease];
    group.groupid = [[aps objectForKey:@"gid"] intValue];
    group.groupname = [aps objectForKey:@"groupname"];
    group.flag = 0;
    group.createtime = [NSDate new];
    [group saveRecord];
    groupdata = [FAGroupData search:-1 name:nil limit:0];
    //NSLog(@"select group count = %d",[groupdata count]);
    [groupdata retain];
    [self.tableView reloadData];

}
- (void)saveGroup:(NSString *)name withGroupId:(int)gid{
    FAGroupData *group = [[[FAGroupData alloc]init]autorelease];
    group.groupname = name;
    group.groupid = gid;
    group.flag = 0;
    group.createtime = [NSDate new];
    [group saveRecord];
    FAUserData *user = [FAUserData search];
    FAGroupMemberData *memberdata = [[[FAGroupMemberData alloc] init]autorelease];
    memberdata.groupid = gid;
    memberdata.userid = user.no;
    memberdata.username = user.name;
    memberdata.createtime = [NSDate new];
    [memberdata saveRecord];
    NSString *message = [NSString stringWithFormat:@"您已经成功添加新群组：%@",name];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message: message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NEW_GROUP_ADD_NOTIFICATION object:nil];
    [self searchGroupData];
    [self.tableView reloadData];
    /*}else{
     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"错误提示" message: @"添加群组失败。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
     [alert show];
     }*/
    
}
@end
