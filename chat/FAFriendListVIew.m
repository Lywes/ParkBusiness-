//
//  FAFriendListVIew.m
//  FASystemDemo
//
//  Created by Hot Hot Hot on 12-12-7.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import "FAFriendListView.h"
#import "FAPeopleChatView.h"
#import "CustomCell1.h"
#import "FAGroupListView.h"
#import "FABusinessCardView.h"
#import "FATitleBusinessCardView.h"
#import "FAFriendData.h"
#import "FAFriendGroupData.h"
#import "FATitleBusinessCardView.h"
#import "FAFriendGroupEditView.h"
#import "UIImageView+WebCache.h"
#import "FAGroupData.h"
@interface FAFriendListView ()
-(void)setDataSourceForTable;
@end

@implementation FAFriendListView
@synthesize myTableView;
@synthesize dataSourceArry;
@synthesize dataSourceDict;
@synthesize flagArray;
-(void)dealloc
{
    [item_ release];
    [dataSource_ release];
    [key_ release];
    [images release];
    [myTableView release];
    [searchBar release];
    [addBtn release];
    [dataSourceDict release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        
        
        
    }
    return self;
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self searchFriendsWithName:searchText];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchbar{//点击搜索按钮
    [self searchFriendsWithName:searchbar.text];
    [searchbar resignFirstResponder];
}
-(void)searchFriendsWithName:(NSString*)name{
    dataSourceArry=[FAFriendGroupData search:-1 name:nil limit:-1];
    
    [dataSourceDict removeAllObjects];
    for(int i=0;i<[self.dataSourceArry count];i++){
        FAFriendGroupData *group = [dataSourceArry objectAtIndex:i];
        if(i==0){
            NSMutableArray* frienddata = [FAGroupData searchGroupDataWithFlag:1 withoutGid:[PBUserModel getPasswordAndKind].kind == 3?1:-1];
            [dataSourceDict setObject:frienddata forKey:group.name];
        }else if(i==1){
            NSMutableArray* frienddata = [FAGroupData searchGroupDataWithFlag:2 withoutGid:[PBUserModel getPasswordAndKind].kind == 1?1:-1];
            [dataSourceDict setObject:frienddata forKey:group.name];
        }else if(i==2){
            NSMutableArray* frienddata = [FAFriendData search:-1 friendgroupid:-1 name:nil limit:-1];
            [dataSourceDict setObject:frienddata forKey:group.name];
        }else{
            NSMutableArray* frienddata = [FAFriendData search:-1 friendgroupid:group.no name:name limit:-1];
            [dataSourceDict setObject:frienddata forKey:group.name];
        }
        
        
        
    }
    
    [flagArray removeAllObjects];
    for(int i=0;i<[self.dataSourceDict count];i++)
    {
        [flagArray addObject:[NSNumber numberWithInt:1]];
    }
    [self.tableView reloadData];
}
-(void)groupSetting{
    FAFriendGroupEditView* friendGroup = [[FAFriendGroupEditView alloc]init];
    [self.navigationController pushViewController:friendGroup animated:YES];
}
-(void)backDidPush{
    
    [self.parentViewController.navigationController popViewControllerAnimated:YES];
}
-(void)showFriendSearchView:(id)sender{
    FASearchFriendController *searchController = [[[FASearchFriendController alloc] init ] autorelease];
    
    [self.navigationController pushViewController:searchController animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.title=@"好友列表";
    [self setDataSourceForTable];
    [self.tableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [searchBar resignFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage* settingimage=[UIImage imageNamed:@"icon_group_setting.png"] ;
    UIButton *settingbtn = [ UIButton buttonWithType:UIButtonTypeCustom];
    [settingbtn setImage:settingimage forState:UIControlStateNormal];
    [settingbtn sizeToFit];
    [settingbtn addTarget:self action:@selector(groupSetting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightButton=[[UIBarButtonItem alloc] initWithCustomView:settingbtn];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.tabBarItem=[[UITabBarItem alloc] initWithTitle:@"我的好友" image:[UIImage imageNamed:@"friend_info_add.png"] tag:0];
    
    self.title = @"我的好友";
    
    searchBar=[[UISearchBar alloc] init];
    searchBar.frame=CGRectMake(55, 0, self.tableView.bounds.size.width-50, 40);
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
    UIView *tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 40)];
    //[tableHeadView setBackgroundColor:[UIColor grayColor]];
    
    UIImage *addImg = [UIImage imageNamed:@"custom_button.png"];
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //[addBtn sizeToFit];
    [addBtn setBackgroundImage:addImg forState:UIControlStateNormal];
    [addBtn setTitle:@"添加好友" forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [addBtn setFrame:CGRectMake(5, 7, 50, 25)];
    [addBtn addTarget:self action:@selector(showFriendSearchView:) forControlEvents:UIControlEventTouchUpInside];
    [tableHeadView addSubview:searchBar];
    [tableHeadView addSubview:addBtn];
    [self setDataSourceForTable];
    self.tableView.tableHeaderView=tableHeadView;
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    [tapGr release];
    
        
}
-(void)setDataSourceForTable{
    dataSourceArry=[FAFriendGroupData search:-1 name:nil limit:-1];
    dataSourceDict=[[NSMutableDictionary alloc] init];
    for(int i=0;i<[self.dataSourceArry count];i++){
        FAFriendGroupData *group = [dataSourceArry objectAtIndex:i];
        if(i==0){
            NSMutableArray* frienddata = [FAGroupData searchGroupDataWithFlag:1 withoutGid:[PBUserModel getPasswordAndKind].kind == 3?1:-1];
            [dataSourceDict setObject:frienddata forKey:group.name];
        }else if(i==1){
            NSMutableArray* frienddata = [FAGroupData searchGroupDataWithFlag:2 withoutGid:[PBUserModel getPasswordAndKind].kind == 1?1:-1];
            [dataSourceDict setObject:frienddata forKey:group.name];
        }else if(i==2){
            NSMutableArray* frienddata = [FAFriendData search:-1 friendgroupid:-1 name:nil limit:-1];
            [dataSourceDict setObject:frienddata forKey:group.name];
        }else{
            NSMutableArray* frienddata = [FAFriendData search:-1 friendgroupid:group.no name:nil limit:-1]; 
            [dataSourceDict setObject:frienddata forKey:group.name];
        }
        
       
        
    }
    
    /*[[NSDictionary dictionaryWithContentsOfFile:finalPath] retain];*/
    
    flagArray=[[NSMutableArray alloc] init];
    for(int i=0;i<[self.dataSourceDict count];i++)
    {
        [flagArray addObject:[NSNumber numberWithInt:1]];
    }

}
-(void)rightButtonDidPush
{
    FAPeopleChatView* peopleChat=[[[FAPeopleChatView alloc] init] autorelease];
    NSArray* tabs=[[NSArray alloc] initWithObjects:peopleChat, nil];
    rootController=[[UITabBarController alloc] init];
    [rootController setViewControllers:tabs animated:NO];
    [self.navigationController pushViewController:rootController animated:YES];
    
}

-(void)popToGroupView
{
    FAGroupListView* chatView=[[FAGroupListView alloc] init] ;
    [self.navigationController pushViewController:chatView animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSourceArry count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int num=[[flagArray objectAtIndex:section] intValue];
    //NSLog(@"numflg = %d",num);
    if(num==1)
    {
        return 0;
    }else
    {
       
        FAFriendGroupData *group = [dataSourceArry objectAtIndex:section];
      return [[dataSourceDict objectForKey:group.name] count];
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 51.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerViewBottom=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 51)] autorelease];
    
    UIImageView* backgroudImage=[[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 51)] autorelease];
    
    backgroudImage.image=[UIImage imageNamed:@"background_640X102.png"];
    [headerViewBottom addSubview:backgroudImage];
    
    
    UILabel* Label=[[[UILabel alloc] initWithFrame:CGRectMake(58, 14, 180, 21)] autorelease];
    FAFriendGroupData *group = [dataSourceArry objectAtIndex:section];
    NSString* Name=group.name;
    //NSLog(@"%@",Name);
    [Label setBackgroundColor:[UIColor clearColor]];
    [Label setFont:[UIFont systemFontOfSize:18.0f]];
    Label.text=Name;
    
    
    UIImageView* subCountLabel=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"count_background.png"]] autorelease];
    [subCountLabel setFrame:CGRectMake(self.view.frame.size.width-70, 14, 39, 21)];
    subCountLabel.backgroundColor=[UIColor clearColor];
    NSInteger subCount = [[dataSourceDict objectForKey:Name] count];
    UILabel* subCntLabel=[[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 19, 11)] autorelease];
    subCntLabel.text=[[NSString alloc] initWithFormat:@"%d",subCount];
    [subCntLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    subCntLabel.textColor=[UIColor whiteColor];
    //subCntLabel.textAlignment=UITextAlignmentCenter;
    subCntLabel.backgroundColor=[UIColor clearColor];
    [subCountLabel addSubview:subCntLabel];
    
    
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0,0, self.view.frame.size.width, 51)];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn addTarget:self action:@selector(sectionHeaderClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTag:[[NSString stringWithFormat:@"%d",section] intValue]];
    UIImageView* UDImg=[[[UIImageView alloc]initWithFrame:CGRectMake(20, 17, 16, 16)] autorelease];
    int flagNum=[[flagArray objectAtIndex:section] intValue];
    UDImg.image=(flagNum==1)?[UIImage imageNamed:@"arrow_right.png"]:[UIImage imageNamed:@"arrow_down.png"];
    [UDImg setTag:[[NSString stringWithFormat:@"%d",section]intValue]];
    UDImg.backgroundColor=[UIColor clearColor];
    
    
    [headerViewBottom addSubview:btn];
    [headerViewBottom addSubview:UDImg];
    [headerViewBottom addSubview:Label];
    [headerViewBottom addSubview:subCountLabel];
    
    return headerViewBottom;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CustomCellIdentifier = @"CustomCellIdentifier1";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CustomCellIdentifier] autorelease];
    }
    if (indexPath.section==0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        FAFriendGroupData *group = [dataSourceArry objectAtIndex:indexPath.section];
        NSMutableArray *friends = [dataSourceDict objectForKey:group.name];
        FAGroupData *friend = (FAGroupData *)[friends objectAtIndex:indexPath.row];
        cell.textLabel.text = friend.groupname;
//        cell.detailTextLabel.text=[NSString stringWithFormat:@"%d",friend.groupid];
        [cell.imageView setImageWithURL:[NSURL URLWithString:friend.imgpath] placeholderImage:[UIImage imageNamed:@"headpic.png"]];
        
    }else if (indexPath.section==1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        FAFriendGroupData *group = [dataSourceArry objectAtIndex:indexPath.section];
        NSMutableArray *friends = [dataSourceDict objectForKey:group.name];
        FAGroupData *friend = (FAGroupData *)[friends objectAtIndex:indexPath.row];
        cell.textLabel.text = friend.groupname;
//        cell.detailTextLabel.text=[NSString stringWithFormat:@"%d",friend.groupid];
        [cell.imageView setImageWithURL:[NSURL URLWithString:friend.imgpath] placeholderImage:[UIImage imageNamed:@"headpic.png"]];
        
    }else{
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        FAFriendGroupData *group = [dataSourceArry objectAtIndex:indexPath.section];
        NSMutableArray *friends = [dataSourceDict objectForKey:group.name];
        FAFriendData *friend = (FAFriendData *)[friends objectAtIndex:indexPath.row];
        cell.textLabel.text = friend.friendname;
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%d",friend.friendid];
        [cell.imageView setImageWithURL:[NSURL URLWithString:friend.imgpath] placeholderImage:friend.icon];
    }
    
    return cell;
}
//详细按钮点击后的处理
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    FATitleBusinessCardView *cardController = [[[FATitleBusinessCardView alloc] initWithStyle:UITableViewStyleGrouped ] autorelease];
    cardController.friendflg = YES;
    FAFriendGroupData *group = [dataSourceArry objectAtIndex:indexPath.section];
    NSMutableArray *friends = [dataSourceDict objectForKey:group.name];
    FAFriendData *friend = (FAFriendData *)[friends objectAtIndex:indexPath.row];
    cardController.friendid = friend.friendid;
    [self.navigationController pushViewController:cardController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

-(void)sectionHeaderClicked:(id)sender
{
    //NSLog(@"sectionHeaderClicked");
    UIButton* btn=(UIButton*)sender;
    int tag=(int)btn.tag;
    //NSLog(@"tag=%d",tag);
    int flagNum=[[flagArray objectAtIndex:tag] intValue];
    //NSLog(@"flagNum=%d",flagNum);
    if(flagNum==1)
    {
        [flagArray replaceObjectAtIndex:tag withObject:[NSNumber numberWithInt:0]];
        [self.tableView reloadData];
        //[self.myTableView reloadData];
    }else
    {
        [flagArray replaceObjectAtIndex:tag withObject:[NSNumber numberWithInt:1]];
        [self.tableView reloadData];
        //[self.myTableView reloadData];
    }
}

-(void)viewDidUnload
{
    [self setMyTableView:nil];
    [super viewDidUnload];
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FAPeopleChatView* view = [[[FAPeopleChatView alloc] initWithNibName:isPad()?@"FAPeopleChatView_ipad": @"FAPeopleChatView" bundle:nil] autorelease];
    FAFriendGroupData *group = [dataSourceArry objectAtIndex:indexPath.section];
    NSMutableArray *friends = [dataSourceDict objectForKey:group.name];
    
    if (indexPath.section==0) {
        FAGroupData *friend = (FAGroupData *)[friends objectAtIndex:indexPath.row];
        view.groupid = friend.groupid;
        view.groupflg = 1;
        view.actionflg = 1;
    }else if (indexPath.section==1) {
        FAGroupData *friend = (FAGroupData *)[friends objectAtIndex:indexPath.row];
        view.groupid = friend.groupid;
        view.groupflg = 1;
        view.actionflg = 1;
    }else{
        FAFriendData *friend = (FAFriendData *)[friends objectAtIndex:indexPath.row];
        view.friendid = friend.friendid;
        view.friendname = friend.friendname;
        view.imgpath = friend.imgpath;
        view.groupflg = 0;
    }
    view.readflg =0;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:view];
    
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //view.title = className;
    //[self presentModalViewController:nav animated:YES];
    [self.navigationController presentViewController:nav animated:YES completion:NULL];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touches End!");
    [searchBar resignFirstResponder];
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    
   [searchBar resignFirstResponder];
    
}

- (void)addFreindToList:(NSDictionary *)aps{
    FAFriendData *frienddata = [[[FAFriendData alloc] init]autorelease];
    NSLog(@"friendname = %@",[aps objectForKey:@"username"]);
    NSLog(@"friendid = %@",[aps objectForKey:@"fromid"]);
    frienddata.friendid = [[aps objectForKey:@"fromid"] intValue];
    frienddata.friendname = [aps objectForKey:@"username"];
    frienddata.imgpath = [aps objectForKey:@"imgpath"];
    frienddata.friendgroupid = 1;
    frienddata.icon = [UIImage imageNamed:@"list_addfriend_icon.png"];
    [frienddata saveRecord];
    [self setDataSourceForTable];
    [self.tableView reloadData];
}
@end
