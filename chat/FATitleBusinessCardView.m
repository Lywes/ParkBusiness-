//
//  FATitleBusinessCardView.m
//  FASystemDemo
//
//  Created by wangzhigang on 12-12-26.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import "FATitleBusinessCardView.h"
#import "FAGroupSelectController.h"
#import "FAPeopleChatView.h"
#import "FAUserData.h"
#import "FAFriendGroupSelectController.h"
#import "FAFriendGroupData.h"
#import "FAFriendRemarkController.h"
#import "UIImageView+WebCache.h"
@interface FATitleBusinessCardView ()

@end

@implementation FATitleBusinessCardView
@synthesize  friendid;
@synthesize friendflg;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
            self.title = @"名片";
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
    
    [dataSource_ release];
    [frienddata release];
    [label release];
    
    [signature release];
   
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
        
    FAChatManager *manager = [[[FAChatManager alloc] init] autorelease];
    manager.delegate = self;
    [manager searchGroupMemberByName:@"" doById:self.friendid];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSMutableArray *res=[FAFriendData search:self.friendid friendgroupid:-1 name:nil limit:-1];
    if ([res isKindOfClass:[NSNull class]]||([res count] ==0)) {
        
    }else{
        frienddata = [res objectAtIndex:0];
    }
    
    
    
    groupArr =  [FAFriendGroupData searchGroupInfoWithFriendId:self.friendid];
    [self.tableView reloadData];
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==0){
        UIView* titleView = [[UIView alloc]init];
        UIImage* image_=[UIImage imageNamed:@"8.png"];
        UIImageView* imageView_=[[UIImageView alloc] initWithImage:image_];
        imageView_.frame=CGRectMake(10,15, 50, 50);
        
        
        UILabel* label_=[[[UILabel alloc] init] autorelease];
        label_.frame=CGRectMake(70, 20, 100, 30);
        label_.backgroundColor = [UIColor clearColor];
        
        
        
        UIButton* button_=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        UIButton* button_1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        UIButton* button_grp=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        button_.frame = CGRectMake(self.view.frame.size.width-220, 50, 65, 30);
        button_1.frame = CGRectMake(self.view.frame.size.width-195, 50, 65, 30);
        button_grp.frame = CGRectMake(self.view.frame.size.width-130, 50, 65, 30);
        [button_ setTitle:@"发起会话" forState:UIControlStateNormal];
        [button_ sizeToFit];
        [button_ addTarget:self action:@selector(launchChat:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [button_1 setTitle:@"加为好友" forState:UIControlStateNormal];
        [button_1 sizeToFit];
        [button_1 addTarget:self action:@selector(sendFriendInvite:) forControlEvents:UIControlEventTouchUpInside];
        
       
        [button_grp setTitle:@"群组邀请" forState:UIControlStateNormal];
        [button_grp sizeToFit];
        [button_grp addTarget:self action:@selector(inviteToGroup:) forControlEvents:UIControlEventTouchUpInside];
        
        [titleView addSubview:imageView_];
        [titleView addSubview:label_];
        
        if ([frienddata isKindOfClass:[NSNull class]]) {
            [titleView addSubview:button_1];
            imageView_.image = [UIImage imageNamed:@"list_addfriend_icon.png"];
        }else{
            [titleView addSubview:button_];
            [titleView addSubview:button_grp];
            if (frienddata.imgpath) {
                [imageView_ setImageWithURL:[NSURL URLWithString:frienddata.imgpath]];
            }else{
                imageView_.image = frienddata.icon;
            }
            label_.text = frienddata.friendname;
        }
        
        return titleView;
    }
    return NULL;
}
-(void)launchChat:(id)sender{
    FAPeopleChatView* view = [[[FAPeopleChatView alloc] initWithNibName:isPad()?@"FAPeopleChatView_ipad": @"FAPeopleChatView" bundle:nil] autorelease];
    
    
    
    view.friendid = self.friendid;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:view];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //view.title = className;
    //[self presentModalViewController:nav animated:YES];
    [self.navigationController presentViewController:nav animated:YES completion:NULL];
}
    
-(void)sendFriendInvite:(id)sender{
    UIButton *btn = (UIButton*)sender;
    [btn setEnabled:YES];
    FAChatManager *manager = [[[FAChatManager alloc] init] autorelease];
    FAUserData *userdata = [FAUserData search];
    
    [manager inviteToBeFreindTo:self.friendid fromId:userdata.no];
}
-(void)inviteToGroup:(id)sender{
    FAGroupSelectController *groupSelectController = [[[FAGroupSelectController alloc] init] autorelease];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:groupSelectController];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    groupSelectController.friendid = self.friendid;
    //view.title = className;
    //[self presentModalViewController:nav animated:YES];
    [self.navigationController presentViewController:nav animated:YES completion:NULL];

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        return 100.0;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    if ( 0 == indexPath.section ) {
        return 100.0;
    } else {
        return 44.0;
    }
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
    if (self.friendflg) {
        return 4;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    switch (section) {
        case 1:
        case 2:
            return 2;
            break;
        
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    // Configure the cell...
    switch (indexPath.section) {
        case 0:
             //cell.textLabel.text= @"个性签名:";
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *signaturetitle = [[[UILabel alloc] init] autorelease];
            signaturetitle.text = @"个性签名:";
            signaturetitle.frame = CGRectMake(5, 5, 50, 30);
            [signaturetitle sizeToFit];
            signaturetitle.font = [UIFont systemFontOfSize:16.0f];
            
            signature = [[[UILabel alloc] init] autorelease];
            if ([frienddata isKindOfClass:[NSNull class]]) {
                signature.text = @"";
            }else{
                signature.text = frienddata.signature;
            }
           
            signature.frame = CGRectMake(5, 35, 50, 30);
            [signature sizeToFit];
            signature.font = [UIFont systemFontOfSize:14.0f];
            [cell.contentView addSubview:signaturetitle];
            [cell.contentView addSubview:signature];
            
            break;
        case 1:
            if (indexPath.row == 0){
                NSString* text = @"分组    ";
                if([groupArr count]>0){
                    for (FAFriendGroupData* data in groupArr) {
                        if(![data.flag isEqualToString:@"0"]){
                             text = [NSString stringWithFormat:@"%@%@,",text,data.name];
                        }
                    }
                    text = [text substringToIndex:[text length]-1];
                }
                cell.textLabel.text= text;
                
            }else{
                cell.textLabel.text= [NSString stringWithFormat:@"备注    %@",frienddata.remark?frienddata.remark:@""];
            }
            break;
        case 2:
            if (indexPath.row == 0)cell.textLabel.text= @"查看资料";
             else cell.textLabel.text= @"聊天记录";
            break;
        case 3:
             cell.textLabel.text= @"删除好友";
            break;
        default:
            break;
    }
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
    if (indexPath.section ==1) {
        if (indexPath.row==0) {
            //进入朋友分组选择画面
            FAFriendGroupSelectController *group = [[[FAFriendGroupSelectController alloc] init] autorelease];
            group.no = self.friendid;
            [self.navigationController pushViewController:group animated:YES];
        }else{
            //进入备注编辑画面
            FAFriendRemarkController* remark = [[FAFriendRemarkController alloc]init];
            remark.friendid = self.friendid;
            remark.remark = frienddata.remark?frienddata.remark:@"";
            [self.navigationController pushViewController:remark animated:YES];
            [remark release];
        }
    }else if (indexPath.section ==2) {
        if (indexPath.row==0) {
            //查看资料画面FAUserInfoController
            
        }else{
            FAPeopleChatView* view = [[[FAPeopleChatView alloc] initWithNibName:isPad()?@"FAPeopleChatView_ipad": @"FAPeopleChatView" bundle:nil] autorelease];
            
            
            
            view.friendid = self.friendid;
            view.readflg =1;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:view];
            nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            //view.title = className;
            //[self presentModalViewController:nav animated:YES];
            [self.navigationController presentViewController:nav animated:YES completion:NULL];

        }
    }else if(indexPath.section==3){
        UIAlertView *alert = [[UIAlertView alloc] init] ;
        alert.delegate = self;
        alert.title = @"确认";
        alert.message = @"您确定要从好友中删除吗？";
        [alert addButtonWithTitle:NSLocalizedString(@"nav_btn_qx", nil)];
        [alert addButtonWithTitle:@"同意"];
        alert.cancelButtonIndex = 0;
        
        [alert show];
    }
}
-(void)getGroupMemberResultByName:(NSArray *)res{
    //首先删除数据资源中的内容
    if ([res count]>0) {
        NSDictionary *friendDict = [res objectAtIndex:0];
        
        if ([frienddata isKindOfClass:[NSNull class]]) {
            frienddata = [[FAFriendData alloc] init];
            
        }else{
            
        }
        frienddata.friendid = self.friendid;
        frienddata.signature = [friendDict objectForKey:@"signature" ];
        frienddata.friendname = [friendDict objectForKey:@"alias" ];
        frienddata.imgpath = [friendDict objectForKey:@"imgpath" ];
        if ([[friendDict objectForKey:@"imgpath" ] isEqual:@""]) {
            frienddata.icon = [UIImage imageNamed:@"list_addfriend_icon.png"];
        }else{
            //下载远程图片
            //frienddata.icon =
        }
        if (frienddata.no >0) {
            [frienddata saveRecord];
        }
        //表格更新
        [self.tableView reloadData];
        //隐藏键盘

    }
    
}
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
        
    
    // 判断点击哪个按钮
    if ( buttonIndex != alertView.cancelButtonIndex ) {
        [frienddata deleteRecord];
        [self.navigationController popToRootViewControllerAnimated:YES];

        
    }
    
    
}

@end
