//
//  FABusinessCardView.m
//  FASystemDemo
//
//  Created by Hot Hot Hot on 12-12-24.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import "FABusinessCardView.h"
#import "FATitleBusinessCardView.h"
#import "FAConentViewViewController.h"

@interface FABusinessCardView ()

@end

@implementation FABusinessCardView

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        
    }
    return self;
}


-(void)dealloc
{
    [titleView release];
    [conentView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    titleView=[[FATitleBusinessCardView alloc] init];
    UIImage* image_=[UIImage imageNamed:@"8.png"];
    UIImageView* imageView=[[UIImageView alloc] initWithImage:image_];
    imageView.frame=CGRectMake(10,30, 50, 50);
    
    UILabel* label=[[[UILabel alloc] init] autorelease];
    label.frame=CGRectMake(70, 50, 180, 30);
    
    UIButton* button=[[UIButton alloc] initWithFrame:CGRectMake(260, 50, 35, 30)];
    button.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:imageView];
    [self.view addSubview:label];
    [self.view addSubview:button];
    
    conentView=[[FAConentViewViewController alloc] init];
    navigation2=[[UINavigationController alloc] initWithRootViewController:conentView];
    [self.view addSubview:navigation2.view];
    
    navigation1=[[UINavigationController alloc] initWithRootViewController:titleView];
    [self.view addSubview:navigation1.view];
    
    
    sections_=[[NSArray alloc] initWithObjects:@"1",@"2",@"3", nil];
    NSArray* array1=[[NSArray alloc] initWithObjects:@"个性签名", nil];
    NSArray* array2=[[NSArray alloc] initWithObjects:@"查看资料",@"聊天纪录", nil];
    NSArray* array3=[[NSArray alloc] initWithObjects:@"删除好友", nil];
    
    dataSource_=[[NSArray alloc] initWithObjects:array1,array2,array3, nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    titleView.tableView.dataSource=self;
    titleView.tableView.delegate=self;
    
    titleView.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    navigation1.view.frame=CGRectMake(0, 90, 350, 40);
    [titleView.tableView reloadData];	
    
    conentView.tableView.dataSource=self;
    conentView.tableView.delegate=self;
    conentView.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    navigation2.view.frame=CGRectMake(0, 130,350, 40);
    [conentView.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return [sections_ count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[dataSource_ objectAtIndex:section] count];
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
    cell.textLabel.text=[[dataSource_ objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
