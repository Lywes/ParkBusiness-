//
//  FAFriendGroupEditView.m
//  ParkBusiness
//
//  Created by lywes lee on 13-4-11.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "FAFriendGroupEditView.h"

@interface FAFriendGroupEditView ()

@end

@implementation FAFriendGroupEditView
@synthesize friendGroupArry;
@synthesize tableViews;
- (id)init{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"好友分组管理";
        UIBarButtonItem* rightbtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGroup)];
        self.navigationItem.rightBarButtonItem = rightbtn;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(7, 7, 25, 30);
        [btn addTarget:self action:@selector(backHomeView:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = barButton;
    }
    return self;
}
-(void)addGroup{//点击添加群组按钮
    [addGroupView addGroupViewWillShow];
}

-(BOOL)submitDidPushWithName:(NSString *)groupName{//点击确认按钮
    if (![FAFriendGroupData checkGroupNameExist:groupName]){
        FAFriendGroupData* group = [[FAFriendGroupData alloc]init];
        group.name = groupName;
        group.idx = [FAFriendGroupData searchMaxIdx]+1;
        [group saveRecord];
        friendGroupArry=[FAFriendGroupData searchGroupInfoWithFriendId:-1];
        [self.tableViews reloadData];
        return YES;
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该群组名字已存在 请重新命名！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    return NO;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTableViews];
    addGroupView = [[FAAddGroupView alloc]initWithFrame:self.navigationController.view.frame];
    addGroupView.delegate = self;
    [self.navigationController.view addSubview:addGroupView];
    friendGroupArry=[FAFriendGroupData searchGroupInfoWithFriendId:-1];
    [self.tableViews setEditing:YES animated:YES];
    
//    for(FAFriendGroupData *group in friendGroupArry){
//        
//    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)setTableViews{
    [self.tableViews = [UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-KTabBarHeight-KNavigationBarHeight)];
    self.tableViews.delegate = self;
    self.tableViews.dataSource = self;
    [self.view addSubview:self.tableViews];
}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (UITableViewCellEditingStyleDelete ==editingStyle) {
        FAFriendGroupData* group = [friendGroupArry objectAtIndex:indexPath.row];
        [group deleteRecord];
        [friendGroupArry removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    NSLog(@"sourceIndexPath=%d",sourceIndexPath.row);
    NSLog(@"destinationIndexPath=%d",destinationIndexPath.row);
    FAFriendGroupData* fromData = [friendGroupArry objectAtIndex:sourceIndexPath.row];
    FAFriendGroupData* toData = [friendGroupArry objectAtIndex:destinationIndexPath.row];
    [FAFriendGroupData exchangeFromNo:fromData.no toIdx:toData.idx];
    if (sourceIndexPath.row<destinationIndexPath.row) {
        for (int i=sourceIndexPath.row; i<destinationIndexPath.row; i++) {
            FAFriendGroupData* data = [friendGroupArry objectAtIndex:i+1];
             NSLog(@"data.idx=%d",data.idx);
            [FAFriendGroupData exchangeFromNo:data.no toIdx:data.idx-1];
        }
    }else if(sourceIndexPath.row>destinationIndexPath.row){
        for (int i=destinationIndexPath.row; i<sourceIndexPath.row; i++) {
            FAFriendGroupData* data = [friendGroupArry objectAtIndex:i];
            NSLog(@"data.idx=%d",data.idx);
            [FAFriendGroupData exchangeFromNo:data.no toIdx:data.idx+1];
        }
    }
    friendGroupArry=[FAFriendGroupData searchGroupInfoWithFriendId:-1];
}
- (void) backHomeView:(UIViewController*)viewController {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [friendGroupArry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    FAFriendGroupData *group  = [friendGroupArry objectAtIndex:indexPath.row];
    cell.textLabel.text = group.name;
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
