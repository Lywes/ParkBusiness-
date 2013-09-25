//
//  FAFriendGroupSelectController.m
//  FASystemDemo
//
//  Created by wangzhigang on 13-4-2.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "FAFriendGroupSelectController.h"
#import "FAFriendGroupData.h"
#import "UIImage+Scale.h"
@interface FAFriendGroupSelectController ()

@end

@implementation FAFriendGroupSelectController
@synthesize no;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(saveGroupChange)];
        self.navigationItem.rightBarButtonItem=rightButton;
        [rightButton release];
        self.title = @"选择分组";
    }
    return self;
}
- (void)saveGroupChange{//保存群组信息
    [FAFriendGroupData deleteFriendGroupMemberWithFid:self.no];
    for (int i=0;i<[checkGroupArr count];i++) {
        BOOL check = [[checkGroupArr objectAtIndex:i] boolValue];
        if (check) {
            FAFriendGroupData *data = [allFriendGroup objectAtIndex:i];
            [FAFriendGroupData saveFriendGroupMemberInfo:-1 fid:self.no fgid:data.no];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc
{
    [super dealloc];
    
    [allFriendGroup release];
    [checkGroupArr release];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    addGroupView = [[FAAddGroupView alloc]initWithFrame:self.navigationController.view.frame];
    addGroupView.delegate = self;
    [self.navigationController.view addSubview:addGroupView];
    checkGroupArr = [[NSMutableArray alloc]init];
    allFriendGroup = [FAFriendGroupData searchGroupInfoWithFriendId:self.no];
    for (FAFriendGroupData *data in allFriendGroup) {
        BOOL check = ![data.flag isEqualToString:@"0"]?TRUE:FALSE;
        [checkGroupArr addObject:[NSNumber numberWithBool:check]];
    }
    
    [allFriendGroup retain];
    [checkGroupArr retain];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    }



-(BOOL)submitDidPushWithName:(NSString *)groupName{//点击确认按钮
    if (![FAFriendGroupData checkGroupNameExist:groupName]){
        FAFriendGroupData* group = [[FAFriendGroupData alloc]init];
        group.name = groupName;
        group.idx = [FAFriendGroupData searchMaxIdx]+1;
        [group saveRecord];
        [group release];
        allFriendGroup = [FAFriendGroupData searchGroupInfoWithFriendId:self.no];
        [checkGroupArr removeAllObjects];
        for (FAFriendGroupData *data in allFriendGroup) {
            BOOL check = ![data.flag isEqualToString:@"0"]?TRUE:FALSE;
            [checkGroupArr addObject:[NSNumber numberWithBool:check]];
        }
        [self.tableView reloadData];
        return YES;
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该群组名字已存在 请重新命名！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    return NO;
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
    return [allFriendGroup count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    if (indexPath.row==0) {
        cell.imageView.image = [UIImage imageNamed:@"list_addfriend.png"] ;
        cell.textLabel.text = @"新分组";
        //cell.textLabel.backgroundColor = [UIColor redColor];
    }else{
        NSString *checkImage = [[checkGroupArr objectAtIndex:indexPath.row-1] boolValue]?@"plugin_open":@"like_headbg";
        cell.imageView.image = [[UIImage imageNamed:checkImage] scaleToSize:CGSizeMake(27.0f, 27.0f)];
        FAFriendGroupData *data = (FAFriendGroupData *)[allFriendGroup objectAtIndex:(indexPath.row-1)];
        cell.textLabel.text = data.name;
    }
    
    // Configure the cell...
    
    return cell;
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.row==0){
        [addGroupView addGroupViewWillShow];
    }else{
        BOOL check = ![[checkGroupArr objectAtIndex:indexPath.row-1] boolValue];
        [checkGroupArr replaceObjectAtIndex:indexPath.row-1 withObject:[NSNumber numberWithBool:check]];
        NSString *checkImage = check?@"plugin_open":@"like_headbg";
        cell.imageView.image = [[UIImage imageNamed:checkImage] scaleToSize:CGSizeMake(27.0f, 27.0f)];
    }
}

@end
