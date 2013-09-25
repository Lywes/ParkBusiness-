//
//  FAChatSettingView.m
//  FASystemDemo
//
//  Created by Hot Hot Hot on 12-11-23.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import "FAChatSettingView.h"
#import "FAAcountManagementView.h"
#import "UIImage+Scale.h"
@interface FAChatSettingView ()

@end

@implementation FAChatSettingView
-(void)dealloc
{
    [items_ release];
    [dataSouce_ release];
    [key_ release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        self.tabBarItem =[[[UITabBarItem alloc]initWithTitle:@"设置" image:[[UIImage imageNamed:@"qzone_icon_set_up.png"] scaleToSize:CGSizeMake(30.0f, 30.0f)] tag:0]autorelease];
        UIImage* image=[[UIImage imageNamed:@"btn_loan.png"] scaleToSize:CGSizeMake(40.0f, 40.0f)];
        UIButton *btnView = [ UIButton buttonWithType:UIButtonTypeCustom];
        [btnView setImage:image forState:UIControlStateNormal];
        [btnView sizeToFit];
        [btnView addTarget:self action:@selector(backDidPush) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* leftButton=[[UIBarButtonItem alloc] initWithCustomView:btnView];
        self.navigationItem.leftBarButtonItem=leftButton;
        [leftButton release];
    }
    return self;
}
-(void)backDidPush{
    
    [self.parentViewController.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"设置";
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    
    key_=[[NSArray alloc] initWithObjects:@"帐号",@"推送消息",@"在线状态", nil];
    
 
    NSArray* array1=[[NSArray alloc]initWithObjects:@"帐号设置", nil];
    NSArray* array2=[[NSArray alloc]initWithObjects:@"消息",@"电脑在线时推送消息", nil];
    NSArray* array3=[[NSArray alloc] initWithObjects:@"iPhone在线",@"手机在线", nil];
    NSArray* arrays=[[NSArray alloc] initWithObjects:array1,array2,array3, nil];
    
    dataSouce_=[[NSDictionary alloc] initWithObjects:arrays forKeys:key_];
    
    
    items_=[[NSArray alloc] initWithObjects:@"帐号设置",@"消息",@"电脑在线时推送消息",@"iPhone在线",@"手机在线", nil];
    [array1 release];
    [array2 release];
    [array3 release];
    [arrays release];
    
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
    return [[dataSouce_ objectForKey:key] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    //获取单元格的段名
    id key=[key_ objectAtIndex:indexPath.section];
    //返回对应段及对应位置的数据，并设置到单元中
    NSString* text=[[dataSouce_ objectForKey:key]objectAtIndex:indexPath.row];
    cell.textLabel.text=text;
    //判断是第几列，并在相应的列中添加列的属性
    switch(indexPath.section)
    {
        case 0:
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 1:
        [cell.contentView addSubview:[self switchForCell:cell]];
            break;
        default:
            break;
    }
    
    return cell;
}

//创建包含UISwitch实例的单元
- (UISwitch*)switchForCell:(const UITableViewCell*)cell {
    UISwitch* theSwitch = [[[UISwitch alloc] init] autorelease];
    theSwitch.on = YES;
    CGPoint newCenter = cell.contentView.center;
    newCenter.x += 80;
    theSwitch.center = newCenter;
    theSwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    return theSwitch;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [key_ objectAtIndex:section];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FAAcountManagementView* acountManageMent=[[[FAAcountManagementView alloc] init] autorelease];
    /*NSString* className = [items_ objectAtIndex:indexPath.row];
    acountManageMent.title = className;*/
    if (indexPath.section==0&& indexPath.row==0) {
        [self.navigationController pushViewController:acountManageMent animated:YES];
    }

}

@end
