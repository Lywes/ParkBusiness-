//
//  FASearchFriendController.m
//  FASystemDemo
//
//  Created by wangzhigang on 13-2-15.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "FASearchFriendController.h"

@interface FASearchFriendController ()

@end

@implementation FASearchFriendController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"添加好友";
        searchBar_ = [[UISearchBar alloc] init];
        searchBar_.frame = CGRectMake( 0, 4, (isPad()?768:320)-50, 25);
        searchBar_.delegate = self;
        //[searchBar_ sizeToFit];
        searchBar_.keyboardType = UIKeyboardTypeNumberPad;
        searchBar_.backgroundColor=[UIColor clearColor];
        [[searchBar_.subviews objectAtIndex:0]removeFromSuperview];
        for (UIView *subview in searchBar_.subviews)
            
        {
            
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
                
            {
                
                [subview removeFromSuperview];
                
                break;
                
            }
            
        }
        UIView *tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 30)];
        
        searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //[addBtn sizeToFit];
        [searchBtn setBackgroundImage:[UIImage imageNamed:@"custom_button.png"] forState:UIControlStateNormal];
        searchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [searchBtn setFrame:CGRectMake((isPad()?768:320)-47, 4, 45, 25)];
        [searchBtn addTarget:self action:@selector(searchFriend:) forControlEvents:UIControlEventTouchUpInside];
        [tableHeadView addSubview:searchBar_];
        [tableHeadView addSubview:searchBtn];
        
        self.tableView.tableHeaderView = tableHeadView;
    }
    return self;
}
- (void)searchFriend:(id)sender{
    FAChatManager *manager = [[[FAChatManager alloc] init] autorelease];
    //NSLog(@"id = %d",[searchBar_.text intValue]);
    manager.delegate = self;
    [manager searchGroupMemberByName:@"" doById:[searchBar_.text intValue]];
    
}
-(void)getGroupMemberResultByName:(NSArray *)res{
    //首先删除数据资源中的内容
    [dataSource_ removeAllObjects];
    [dataSource_ addObjectsFromArray:res] ;
    //表格更新
    [self.tableView reloadData];
    //隐藏键盘
    [searchBar_ resignFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    dataSource_ = [[NSMutableArray alloc] initWithCapacity:1];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    
    [searchBar_ resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source




//dataBase_为保持全部数据的NSArray类型变量
- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar {
    //首先删除数据资源中的内容
    [dataSource_ removeAllObjects];
    
    //表格更新
    [self.tableView reloadData];
    //隐藏键盘
    [searchBar resignFirstResponder];
}

#pragma mark UITableView methods

- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [dataSource_ count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    NSDictionary *userDict = (NSDictionary *)[dataSource_ objectAtIndex:indexPath.row];
    cell.textLabel.text = [userDict objectForKey:@"alias" ];
    
    cell.detailTextLabel.text = [userDict objectForKey:@"id" ];
    cell.imageView.image = [UIImage imageNamed:@"list_addfriend_icon.png"];
    UIButton *addFriend = [UIButton buttonWithType:UIButtonTypeCustom];
    [addFriend setBackgroundImage:[UIImage imageNamed:@"custom_button.png"] forState:UIControlStateNormal];
    [addFriend setTitle:@"邀请" forState:UIControlStateNormal];
    addFriend.titleLabel.font = [UIFont systemFontOfSize:12];
    [addFriend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addFriend.frame = CGRectMake(0, 0, 35, 25);
    [addFriend addTarget:self action:@selector(sendFriendInvite:) forControlEvents:UIControlEventTouchUpInside];
    addFriend.tag = indexPath.row;
    cell.accessoryView = addFriend;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)sendFriendInvite:(id)sender{
    UIButton *btn = (UIButton*)sender;
    //int i= btn.tag;
    FAChatManager *manager = [[[FAChatManager alloc] init] autorelease];
    FAUserData *userdata = [FAUserData search];
    NSDictionary *userDict = (NSDictionary *)[dataSource_ objectAtIndex:btn.tag];
    [manager inviteToBeFreindTo:[[userDict objectForKey:@"id" ] intValue] fromId:userdata.no];
}
#pragma mark - Table view delegate



@end
