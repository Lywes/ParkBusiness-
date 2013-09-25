//
//  FAAcountManagementView.m
//  FASystemDemo
//
//  Created by Hot Hot Hot on 12-12-3.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import "FAAcountManagementView.h"

@interface FAAcountManagementView ()

@end

@implementation FAAcountManagementView
-(void)dealloc
{
    [key_ release];
    [dataSource_ release];
    [images_ release];
    [item_ release];
    [userdata release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.title=@"帐号管理";
        UIBarButtonItem *rightbtn = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAccountInfo:)]autorelease];
        self.navigationItem.rightBarButtonItem=rightbtn;
    }
    return self;
}
-(void)editAccountInfo:(id)sender{

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    userdata = [FAUserData search];
    [userdata retain];

    //NSArray* array=[[NSArray alloc] initWithObjects:@"国产007", nil];
    key_=[[NSArray alloc] initWithObjects:@"个人设置", @"个性签名", nil];
    
    
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    return 1;
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    if ( 0 == indexPath.section ) {
        return 100.0;
    } else {
        return 44.0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    switch(indexPath.section)
    {
        case 0:
            
            if(userdata.no>0){
                if(userdata.icon){
                    cell.imageView.image=userdata.icon;
                }
                cell.textLabel.text=userdata.name;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",userdata.no];
            }else{
                cell.textLabel.text=@"模拟器环境";
                cell.detailTextLabel.text = @"测试";
            }
            
            //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 1:
            if(userdata.no>0){
                cell.textLabel.text=userdata.signature;
            }else{
                cell.textLabel.text=@"模拟器环境";
            }
            break;
        default:
            break;
    }
    
    return cell;
}
- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
    return [key_ objectAtIndex:section];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
