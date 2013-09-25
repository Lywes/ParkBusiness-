//
//  FAConentViewViewController.m
//  FASystemDemo
//
//  Created by lywes lee on 12-12-28.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import "FAConentViewViewController.h"

@interface FAConentViewViewController ()

@end

@implementation FAConentViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title=@"用户名片";
    
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad]; 
//    sections_=[[NSArray alloc] initWithObjects:@"1",@"2",@"3", nil];
//    NSArray* array1=[[NSArray alloc] initWithObjects:@"个性签名", nil];
//    NSArray* array2=[[NSArray alloc] initWithObjects:@"查看资料",@"聊天纪录", nil];
//    NSArray* array3=[[NSArray alloc] initWithObjects:@"删除好友", nil];
//    
//    dataSource_=[[NSArray alloc] initWithObjects:array1,array2,array3, nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier=@"basis-cell";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(nil==cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell autorelease];
    }
    //cell.textLabel.text=[[dataSource_ objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
