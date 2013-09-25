//
//  FAAddCompanyFriendView.m
//  FASystemDemo
//
//  Created by Hot Hot Hot on 12-11-30.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import "FAAddCompanyFriendView.h"

@interface FAAddCompanyFriendView ()

@end

@implementation FAAddCompanyFriendView

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title=@"添加企业好友";
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    UISearchBar* search=[[UISearchBar alloc] init];
    search.frame=CGRectMake(0, 0, self.tableView.bounds.size.width, 0);
    [search sizeToFit];
    self.tableView.tableHeaderView=search;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method imlementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
