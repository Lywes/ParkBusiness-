//
//  FAChatView.m
//  FASystemDemo
//
//  Created by Hot Hot Hot on 12-12-21.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import "FAChatView.h"
#import "FAPeopleChatView.h"
#import "FAFriendData.h"
#import "FAGroupData.h"
#import "UIImageView+WebCache.h"
@interface FAChatView ()
-(NSString *)dataStringToHans:(NSDate *)date;
@end

@implementation FAChatView
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    
    return self;
}
-(void)dealloc{
    [super dealloc];
    [key_ release];
    [dataSource_ release];
}
-(void)backDidPush{
    [self.parentViewController.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title=@"会话";
    [self getChatMessage];

    
}
-(void)getChatMessage{
    //获取系统时间
    NSMutableArray *unreadmessage = [FAMessageData getUnreadDialog];
    NSString *datestring = [self dataStringToHans:[NSDate date]];
    NSString *todayString = datestring;
    dataSource_ = [NSMutableDictionary dictionary];
    [dataSource_ retain];
    key_ = [NSMutableArray array];
    [key_ retain];
    NSMutableArray *messagearr = [[NSMutableArray alloc] init]; ;
    for (int i=0; i<[unreadmessage count]; i++) {
        FAMessageData *messagedata = [unreadmessage objectAtIndex:i];
        
        if ([todayString isEqualToString:[self dataStringToHans:messagedata.createtime]])
        {
            //            if ([datestring isEqualToString:todayString]) {
            //             [key_ addObject:datestring];
            //             }
        }else{
            if (![datestring isEqualToString:[self dataStringToHans:messagedata.createtime]]&&messagearr.count>0) {
                [dataSource_ setObject:messagearr forKey:datestring];
                [key_ addObject:datestring];
                messagearr = [[NSMutableArray alloc] init];
            }
            datestring = [self dataStringToHans:messagedata.createtime];
        }
        [messagearr addObject:messagedata];
    }
    if ([messagearr count]>0) {
        [dataSource_ setObject:messagearr forKey:datestring];
        
        [key_ addObject:datestring];
    }
    [self.tableView reloadData];
}
-(NSString *)dataStringToHans:(NSDate *)date{
    NSString *res;
    //格式
    NSDateFormatter* dateformat=[[[NSDateFormatter alloc]init]autorelease];
    [dateformat setDateFormat:@"yyy-MM-dd"];
    
    res = [dateformat stringFromDate:date];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0];
    
    NSString *todaystr = [dateformat stringFromDate:today];
    
    
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *yesterday = [cal dateByAddingComponents:components toDate: today options:0];
    NSString *yesterdaystr = [dateformat stringFromDate:yesterday];
    
    [components setHour:-48];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *nextday = [cal dateByAddingComponents:components toDate: today options:0];
    NSString *nextdaystr = [dateformat stringFromDate:nextday];
    
    if ([res isEqualToString:todaystr]) {
        res = @"今天";
    }else if ([res isEqualToString:yesterdaystr]) {
        res = @"昨天";
    }else if ([res isEqualToString:nextdaystr]) {
        res = @"前天";
    }
    return  res;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, isPad()?768:320, 30)];
    label.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:236.0/255.0 blue:247.0/255.0 alpha:0.6];
    UILabel* textlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 20)];
    textlabel.backgroundColor = [UIColor clearColor];
    textlabel.text = [key_ objectAtIndex:section];
    textlabel.textAlignment = UITextAlignmentLeft;
    textlabel.font = [UIFont systemFontOfSize:isPad()?16:14];
    [label addSubview:textlabel];
    return label;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [key_ count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id key=[key_ objectAtIndex:section];
    return [[dataSource_ objectForKey:key]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell...
    //获取单元格的段名
    id key=[key_ objectAtIndex:indexPath.section];
    //返回对应段及对应位置的数据，并设置到单元中
    FAMessageData* message=[[dataSource_ objectForKey:key]objectAtIndex:indexPath.row];
    if (message.groupid>0) {
        if (message.groupflg>0&&message.actionflg == 0) {
            cell.textLabel.text=message.friendname;
            [cell.imageView setImageWithURL:[NSURL URLWithString:message.imgpath] placeholderImage:[UIImage imageNamed:@"list_addfriend_icon.png"]];
        }else{
            FAGroupData *group = [FAGroupData getGroupDataById:message.groupid];
            cell.textLabel.text=group.groupname;
            [cell.imageView setImageWithURL:[NSURL URLWithString:group.imgpath] placeholderImage:[UIImage imageNamed:@"headpic.png"]];
        }
        cell.detailTextLabel.text=message.content;
        //在单元的imageView属性中设置图片
    }else{
        cell.detailTextLabel.text=message.content;
        // Configure the cell...
        //设置单元格的内容
        cell.textLabel.text=message.friendname;
        //在单元的imageView属性中设置图片
        [cell.imageView setImageWithURL:[NSURL URLWithString:message.imgpath] placeholderImage:[UIImage imageNamed:@"list_addfriend_icon.png"]];
    }
    for (UIView* subview in [[cell contentView] subviews]) {
        if (subview.tag==1||subview.tag == 2) {
            [subview removeFromSuperview];
        }
    }
    UILabel* timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(isPad()?668:240, 10, 80, 20)];
    timeLabel.tag = 1;
    timeLabel.font = [UIFont systemFontOfSize:isPad()?12:10];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd hh:mm"];
    timeLabel.text = [formatter stringFromDate:message.createtime];
    [cell.contentView addSubview:timeLabel];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:isPad()?16:14];
    if (message.count>0) {
        UIButton* messageIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        messageIcon.tag = 2;
//        CGSize textSize = [cell.textLabel.text sizeWithFont:cell.textLabel.font];
        messageIcon.frame = CGRectMake(30, -5, 22, 22);
//        UILabel* counts = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 18)];
        [messageIcon setBackgroundImage:[UIImage imageNamed:@"info_unread.png"] forState:UIControlStateDisabled];
        [messageIcon setTitle:message.count>10?@"10+":[NSString stringWithFormat:@"%d",message.count] forState:UIControlStateDisabled];
        messageIcon.enabled = NO;
        messageIcon.titleLabel.font = [UIFont systemFontOfSize:10];
        [[cell contentView] addSubview:messageIcon];
    }
    [timeLabel release];
    //追加附加
    
    return cell;
}
//返回对应段的段名
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [key_ objectAtIndex:section];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //NSString* className = [items_ objectAtIndex:indexPath.row];
    //NSLog(@"name=%@",className);
    FAPeopleChatView* view = [[[FAPeopleChatView alloc] initWithNibName:isPad()?@"FAPeopleChatView_ipad": @"FAPeopleChatView" bundle:nil] autorelease];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:view];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    id key=[key_ objectAtIndex:indexPath.section];
    FAMessageData* message=[[dataSource_ objectForKey:key]objectAtIndex:indexPath.row];
    view.friendid = message.friendid;
    view.friendname = message.friendname;
    view.imgpath = message.imgpath;
    if (message.groupid>0) {
        view.groupflg = message.groupflg;
        view.groupid = message.groupid;
    }
    view.actionflg = message.actionflg;
    view.readflg = 0;
    [self.navigationController presentViewController:nav animated:YES completion:NULL];
}
- (void)saveChatMessage:(NSDictionary *)aps{
    
    FAMessageData *messagedata = [[[FAMessageData alloc]init]autorelease];
    messagedata.friendid = [[aps objectForKey:@"id"] intValue];
    messagedata.groupid = ![[aps objectForKey:@"gid"] isKindOfClass:[NSNull class]]?[[aps objectForKey:@"gid"] intValue]:0;
    messagedata.friendname = [aps objectForKey:@"username"];
    messagedata.imgpath = ![[aps objectForKey:@"imgpath"] isKindOfClass:[NSNull class]]?[aps objectForKey:@"imgpath"]:@"";
    messagedata.content = [aps objectForKey:@"alert"];
    messagedata.isread = 0;
    messagedata.whosaid = 0;
    messagedata.createtime = [NSDate new];
    [messagedata saveRecord];
    [self getChatMessage];
    //notification to FAPeopleChatView
}
- (void)saveGroupChatMessage:(NSDictionary *)aps{
    FAMessageData *messagedata = [[[FAMessageData alloc]init]autorelease];
    messagedata.friendid = [[aps objectForKey:@"fromid"] intValue];
    messagedata.groupid = [[aps objectForKey:@"gid"] intValue];
    messagedata.friendname = [aps objectForKey:@"username"];
    messagedata.imgpath = ![[aps objectForKey:@"imgpath"] isKindOfClass:[NSNull class]]?[aps objectForKey:@"imgpath"]:@"";
    messagedata.content = [aps objectForKey:@"alert"];
    messagedata.isread = 0;
    messagedata.whosaid = 0;
    messagedata.createtime = [NSDate new];
    [messagedata saveRecord];
    [self getChatMessage];
    //notification to FAPeopleChatView
}
@end
